extends Resource
class_name EffectSet

const MAX_EFFECT = 100
const MIN_EFFECT = -MAX_EFFECT

@export var healing_poison: int = 0
@export var warm_cold: int = 0
@export var calming_agitation: int = 0
@export var strength_weakness: int = 0
@export var energy_fatigue: int = 0
@export var light_dark: int = 0
@export var luck_misfortune: int = 0
@export var mana_stamina: int = 0
@export var clarity_confusion: int = 0
@export var defense_vulnerability: int = 0
@export var swiftness_slowness: int = 0

func as_list() -> Array[int]:
	return [
		healing_poison,
		warm_cold,
		calming_agitation,
		strength_weakness,
		energy_fatigue,
		light_dark,
		luck_misfortune,
		mana_stamina,
		clarity_confusion,
		defense_vulnerability,
		swiftness_slowness
	]


## Adds another effects set to this one
func add(e: EffectSet) -> void:
	healing_poison += e.healing_poison
	warm_cold += e.warm_cold
	calming_agitation += e.calming_agitation
	strength_weakness += e.strength_weakness
	energy_fatigue += e.energy_fatigue
	light_dark += e.light_dark
	luck_misfortune += e.luck_misfortune
	mana_stamina += e.mana_stamina
	clarity_confusion += e.clarity_confusion
	defense_vulnerability += e.defense_vulnerability
	swiftness_slowness += e.swiftness_slowness


## Checks if all effects are 0
func all_null() -> bool:
	if healing_poison != 0: return false
	if warm_cold != 0: return false
	if calming_agitation != 0: return false
	if strength_weakness != 0: return false
	if energy_fatigue != 0: return false
	if light_dark != 0: return false
	if luck_misfortune != 0: return false
	if mana_stamina != 0: return false
	if clarity_confusion != 0: return false
	if defense_vulnerability != 0: return false
	if swiftness_slowness != 0: return false
	return true
