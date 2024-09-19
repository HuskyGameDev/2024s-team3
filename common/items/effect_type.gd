extends Resource
class_name EffectSet


## 0-4 does nothing, 5-9 is weak, 10-19 is regular, and 20+ is strong
const NOTHING_RANGE = 5
const WEAK_RANGE = 10
const REGULAR_RANGE = 20

@export var healing_poison: int = 0
@export var warm_cold: int = 0
@export var calming_agitation: int = 0
@export var strength_weakness: int = 0
@export var energy_fatigue: int = 0
@export var light_dark: int = 0
@export var luck_misfortune: int = 0
@export var clarity_confusion: int = 0
@export var defense_vulnerability: int = 0
@export var swiftness_slowness: int = 0

## Potion labels
const positive_labels = {
	"healing_poison": "Healing",
	"warm_cold": "Warming",
	"calming_agitation": "Calming",
	"strength_weakness": "Strengthening",
	"energy_fatigue": "Energizing",
	"light_dark": "Light",
	"luck_misfortune": "Lucky",
	"clarity_confusion": "Clarifying",
	"defense_vulnerability": "Defensive",
	"swiftness_slownes": "Swift"
}

const negative_labels = {
	"healing_poison": "Poison",
	"warm_cold": "Cooling",
	"calming_agitation": "Agitating",
	"strength_weakness": "Weakening",
	"energy_fatigue": "Tiring",
	"light_dark": "Dark",
	"luck_misfortune": "Unlucky",
	"clarity_confusion": "Confusing",
	"defense_vulnerability": "Vulnerable",
	"swiftness_slownes": "Slow"
}



func as_list() -> Array[int]:
	return [
		healing_poison,
		warm_cold,
		calming_agitation,
		strength_weakness,
		energy_fatigue,
		light_dark,
		luck_misfortune,
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
	clarity_confusion += e.clarity_confusion
	defense_vulnerability += e.defense_vulnerability
	swiftness_slowness += e.swiftness_slowness


## Checks if all effects are 0
func all_null() -> bool:
	return self.as_list().all(func(num): return true if num == 0 else false)


## Clears all effects in the neutral range
func clear_neutrals():
	if abs(healing_poison) < NOTHING_RANGE: healing_poison = 0
	if abs(warm_cold) < NOTHING_RANGE: warm_cold = 0
	if abs(calming_agitation) < NOTHING_RANGE: calming_agitation = 0
	if abs(strength_weakness) < NOTHING_RANGE: strength_weakness = 0
	if abs(energy_fatigue) < NOTHING_RANGE: energy_fatigue = 0
	if abs(light_dark) < NOTHING_RANGE: light_dark = 0
	if abs(luck_misfortune) < NOTHING_RANGE: luck_misfortune = 0
	if abs(clarity_confusion) < NOTHING_RANGE: clarity_confusion = 0
	if abs(defense_vulnerability) < NOTHING_RANGE: defense_vulnerability = 0
	if abs(swiftness_slowness) < NOTHING_RANGE: swiftness_slowness = 0


## Returns an array with the names of the effects (in order)
func get_strongest() -> Array[String]:
	var nested_list = [
		[ "healing_poison", healing_poison ],
		[ "warm_cold", warm_cold ],
		[ "calming_agitation", calming_agitation ],
		[ "strength_weakness", strength_weakness ],
		[ "energy_fatigue", energy_fatigue ],
		[ "light_dark", light_dark ],
		[ "luck_misfortune", luck_misfortune ],
		[ "clarity_confusion", clarity_confusion ],
		[ "defense_vulnerability", defense_vulnerability ],
		[ "swiftness_slowness", swiftness_slowness ],
	]
	
	## Sort effects by strength
	nested_list = nested_list.filter(func(e): return true if e[1] >= NOTHING_RANGE else false)
	nested_list.sort_custom(func(a, b): return true if a[1] > b[1] else false)
		
	## Get effect labels
	var labels: Array[String] = []
	for effect in nested_list:
		var effect_name = effect[0]
		var effect_strength = effect[1]
		var label = ""
		
		if abs(effect_strength) < WEAK_RANGE:
			label += "Weak "
		elif abs(effect_strength) >= REGULAR_RANGE:
			label += "Strong "
		
		if effect_strength > 0:
			label += positive_labels[ effect_name ]
		else:
			label += negative_labels[ effect_name ]
	
		labels.push_back(label)
	return labels
