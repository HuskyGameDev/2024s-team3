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
		if potion.effects.get_strength(effect) < minEffects.get_strength(effect) \
		or potion.effects.get_strength(effect) >= maxEffects.get_strength(effect):
			return false
	return true
