@tool
extends Resource
class_name CustomerOrder

## Min effects will be inclusive,
## Max effects will be exclusive
@export var minEffects: EffectSet
@export var maxEffects: EffectSet
@export var dialogueOptions: PackedStringArray

func check(potion: Potion) -> bool:	
	for effect in EffectSet.ALL_EFFECTS:
		var min_strength = minEffects.get_strength(effect)
		var max_strength = maxEffects.get_strength(effect)
		var actual_strength = potion.effects.get_strength(effect)
		
		if min_strength == 0 and max_strength == 0: continue
		
		if actual_strength < min_strength \
		or actual_strength > max_strength:
			return false
		
	return true

func calculate(potion: Potion) -> Vector2:	
	print("Calculating potion")
	var output: Vector2 = Vector2(0,0) ## x = money gain, y = reputation gain
	var numCorrect: int = 0 # increases by 1 for each correct effect
	var strongest = potion.effects.get_strongest(3).filter(func(e): return true if potion.effects.get_strength(e) >= EffectSet.NOTHING_RANGE else false)
	for effect in EffectSet.ALL_EFFECTS:
		if effect not in strongest: continue
		var min_strength = minEffects.get_strength(effect)
		var max_strength = maxEffects.get_strength(effect)
		if min_strength == -50 and max_strength == 50:
			min_strength = 0
			max_strength = 0
		var actual_strength = potion.effects.get_strength(effect)
		var strength_factor = 1
		if (abs(actual_strength) < EffectSet.WEAK_RANGE):
			strength_factor = 0.5
		elif (abs(actual_strength) >= EffectSet.REGULAR_RANGE):
			strength_factor = 1.5
		print("Strengths: " + str(min_strength) + ", " + str(actual_strength) + ", " + str(max_strength))
		if actual_strength < min_strength \
		or actual_strength > max_strength:
			# if an unwanted effect is in the potion, lower the reputation a bit
			output.y = output.y - 0.5*effect.reputation_factor
			print("New reputation: " + str(output.y))
		if min_strength == 0 and max_strength == 0: continue
		print("Passed effect")
		
		if actual_strength >= min_strength and actual_strength <= max_strength:
			## add to both money and reputation
			output.x = output.x + effect.money_factor*strength_factor
			output.y = output.y + effect.reputation_factor*strength_factor
			numCorrect = numCorrect + 1
		else:
			# if the effect was specifically not asked for, lower reputation further
			output.y = output.y - 2*effect.reputation_factor 
	if (numCorrect > 0):
		output.x = pow(output.x, 1.2*numCorrect)
	return output
