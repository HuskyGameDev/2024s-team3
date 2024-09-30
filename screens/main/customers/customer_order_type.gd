@tool
extends Resource
class_name CustomerOrder

## Min effects will be inclusive,
## Max effects will be exclusive
@export var minEffects: EffectSet
@export var maxEffects: EffectSet
@export var dialogueOptions: Array[String]

func check(potion: Potion) -> bool:
	var min_arr = minEffects.as_list()
	var max_arr = maxEffects.as_list()
	var effect_arr = potion.effects.as_list()
	
	for i in effect_arr.size():
		if effect_arr[i] < min_arr[i] \
		or effect_arr[i] >= max_arr[i]:
			return false
	return true
