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
