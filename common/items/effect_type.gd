@tool
extends Resource
class_name EffectSet


## 0-4 does nothing, 5-9 is weak, 10-19 is regular, and 20+ is strong
const NOTHING_RANGE = 5
const WEAK_RANGE = 10
const REGULAR_RANGE = 20

const EFFECTLESS_COLOR = Vector3(0.75, 0.75, 0.75)
const EFFECT_COLORS = {
	"healing": Vector3(0.99, 0.18, 0.31),
	"poison": Vector3(0.03, 0.93, 0.09),
	"warm": Vector3(1, 0.86, 0.2),
	"cold": Vector3(0.74, 0.93, 0.95),
	"calming": Vector3(0.52, 0.86, 0.96),
	"agitation": Vector3(1, 0.4, 0),
	"strength": Vector3(0.96, 0.09, 0.03),
	"weakness": Vector3(0.99, 0.94, 0.87),
	"energy": Vector3(0.93, 0.41, 0.69),
	"fatigue": Vector3(0.08, 0.18, 0.79),
	"light": Vector3(1, 0.98, 0.24),
	"dark": Vector3(0.17, 0.04, 0.27),
	"luck": Vector3(0, 0.64, 0.02),
	"misfortune": Vector3(0.71, 0.33, 0.72),
	"clarity": Vector3(0.33, 0.14, 0.6),
	"confusion": Vector3(0.59, 0.66, 0.26),
	"defense": Vector3(0.45, 0.29, 0.21),
	"vulnerability": Vector3(0.94, 0.74, 0.69),
	"swiftness": Vector3(0, 0.76, 1),
	"slowness": Vector3(0.29, 0.41, 0.27)
}

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
	"swiftness_slowness": "Swift"
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
	"swiftness_slowness": "Slow"
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


func as_nested_list() -> Array:
	return [
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
	## Sort effects by strength
	var nested_list = as_nested_list()
	nested_list = nested_list.filter(func(e): return true if e[1] != 0 else false)
	nested_list.sort_custom(func(a, b): return true if abs(a[1]) > abs(b[1]) else false)
		
	## Get effect labels
	var labels: Array[String] = []
	for effect in nested_list:
		var effect_name = effect[0]
		var effect_strength = effect[1]
		var label = ""
		
		if abs(effect_strength) < NOTHING_RANGE:
			label += "Slight "
		elif abs(effect_strength) < WEAK_RANGE:
			label += "Weak "
		elif abs(effect_strength) >= REGULAR_RANGE:
			label += "Strong "
		
		if effect_strength > 0:
			label += positive_labels[ effect_name ]
		else:
			label += negative_labels[ effect_name ]
	
		labels.push_back(label)
	return labels


## Set effect value by string key
func set_effect_by_key(key:String, value:int):
	# The downside of using strings to determine which effect is being changed
	if key == "healing_poison": 			self.healing_poison = value
	elif key == "warm_cold": 				self.warm_cold = value
	elif key == "calming_agitation": 		self.calming_agitation = value
	elif key == "strength_weakness": 		self.strength_weakness = value
	elif key == "energy_fatigue": 			self.energy_fatigue = value
	elif key == "light_dark": 				self.light_dark = value
	elif key == "luck_misfortune": 			self.luck_misfortune = value
	elif key == "clarity_confusion": 		self.clarity_confusion = value
	elif key == "defense_vulnerability": 	self.defense_vulnerability = value
	elif key == "swiftness_slowness": 		self.swiftness_slowness = value
	else: push_error("%s is not a valid effect key" % key)


## Set all values to input value
func set_all(value:int):
	healing_poison = value
	warm_cold = value
	calming_agitation = value
	strength_weakness = value
	energy_fatigue = value
	light_dark = value
	luck_misfortune = value
	clarity_confusion = value
	defense_vulnerability = value
	swiftness_slowness = value


## Get vec3 representing the effect's color
func get_color() -> Vector3:
	if all_null(): return EFFECTLESS_COLOR
	
	var nested_list = as_nested_list()
	nested_list = nested_list.filter(func(e): return true if abs(e[1]) >= NOTHING_RANGE else false)
	nested_list.sort_custom(func(a, b): return true if abs(a[1]) > abs(b[1]) else false)
	if nested_list.size() == 0: return EFFECTLESS_COLOR
	
	var strongest_effect = nested_list[0][0].split("_")
	strongest_effect = strongest_effect[0] if nested_list[0][1] > 0 else strongest_effect[1]
	
	return EFFECT_COLORS[strongest_effect]
