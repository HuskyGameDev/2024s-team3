@tool
extends Resource
class_name EffectSet

## Preload effect resources
static var CALMING_AGITATION     = preload("res://common/items/effects/calming_agitation.tres")
static var CLARITY_CONFUSION     = preload("res://common/items/effects/clarity_confusion.tres")
static var DEFENSE_VULNERABILITY = preload("res://common/items/effects/defense_vulnerability.tres")
static var ENERGY_FATIGUE        = preload("res://common/items/effects/energy_fatigue.tres")
static var HEALING_POISON        = preload("res://common/items/effects/healing_poison.tres")
static var LIGHT_DARK            = preload("res://common/items/effects/light_dark.tres")
static var LUCK_MISFORTUNE       = preload("res://common/items/effects/luck_misfortune.tres")
static var STRENGTH_WEAKNESS     = preload("res://common/items/effects/strength_weakness.tres")
static var SWIFTNESS_SLOWNESS    = preload("res://common/items/effects/swiftness_slowness.tres")
static var WARM_COLD             = preload("res://common/items/effects/warm_cold.tres")

static var ZERO_EFFECT_SET = {
	CALMING_AGITATION: 0,
	CLARITY_CONFUSION: 0,
	DEFENSE_VULNERABILITY: 0,
	ENERGY_FATIGUE: 0,
	HEALING_POISON: 0,
	LIGHT_DARK: 0,
	LUCK_MISFORTUNE: 0,
	STRENGTH_WEAKNESS: 0,
	SWIFTNESS_SLOWNESS: 0,
	WARM_COLD: 0,
} ## key is Effect, value is int

## Get effect resource by id
static func get_effect_by_id(id: String):
	for effect in ZERO_EFFECT_SET:
		if effect.id == id: 
			return effect
	return null

## 0-4 does nothing, 5-9 is weak, 10-19 is regular, and 20+ is strong
const NOTHING_RANGE = 5
const WEAK_RANGE = 10
const REGULAR_RANGE = 20

const EFFECTLESS_COLOR = Vector3(0.75, 0.75, 0.75)

@export var effects:Dictionary = ZERO_EFFECT_SET.duplicate()

#const EFFECT_COLORS = {
	#"healing": Vector3(0.99, 0.18, 0.31),
	#"poison": Vector3(0.03, 0.93, 0.09),
	#"warm": Vector3(1, 0.86, 0.2),
	#"cold": Vector3(0.74, 0.93, 0.95),
	#"calming": Vector3(0.52, 0.86, 0.96),
	#"agitation": Vector3(1, 0.4, 0),
	#"strength": Vector3(0.96, 0.09, 0.03),
	#"weakness": Vector3(0.99, 0.94, 0.87),
	#"energy": Vector3(0.93, 0.41, 0.69),
	#"fatigue": Vector3(0.08, 0.18, 0.79),
	#"light": Vector3(1, 0.98, 0.24),
	#"dark": Vector3(0.17, 0.04, 0.27),
	#"luck": Vector3(0, 0.64, 0.02),
	#"misfortune": Vector3(0.71, 0.33, 0.72),
	#"clarity": Vector3(0.33, 0.14, 0.6),
	#"confusion": Vector3(0.59, 0.66, 0.26),
	#"defense": Vector3(0.45, 0.29, 0.21),
	#"vulnerability": Vector3(0.94, 0.74, 0.69),
	#"swiftness": Vector3(0, 0.76, 1),
	#"slowness": Vector3(0.29, 0.41, 0.27)
#}

## Gets the strength of an effect
func get_strength(e: Effect):
	return effects[e]


## Sets the strength of an effect
func set_strength(e: Effect, strength: int):
	effects[e] = strength


## Adds another effects set to this one
func add(e: EffectSet) -> void:
	for effect in self.effects:
		self.effects[effect] += e[effect]


## Checks if all effects are 0
func all_null() -> bool:
	for effect in self.effects:
		if self.effects[effect] != 0: return false
	return true


## Clears all effects in the neutral range
func clear_neutrals():
	for effect in self.effects:
		if abs(self.effects[effect]) < NOTHING_RANGE: 
			self.effects[effect] = 0


## Returns an array with the names of the effects (in order)
func get_strongest() -> Array[String]:
	## Sort effects by strength
	var all_effects = self.effects.keys()
	all_effects = all_effects.filter(func(e): return true if self.effects[e] != 0 else false)
	all_effects.sort_custom(func(a, b): return true if abs(self.effects[a]) > abs(self.effects[b]) else false)
		
	## Get effect labels
	var labels: Array[String] = []
	for effect in all_effects:
		var effect_strength = self.effects[effect]
		
		var label = ""
		
		if abs(effect_strength) < NOTHING_RANGE:
			label += "Slight "
		elif abs(effect_strength) < WEAK_RANGE:
			label += "Weak "
		elif abs(effect_strength) >= REGULAR_RANGE:
			label += "Strong "
		
		if effect_strength > 0:
			label += effect.pos_label
		else:
			label += effect.neg_label
	
		labels.push_back(label)
	return labels


## Set all values to input value
func set_all(value:int):
	for effect in self.effects:
		self.effects[effect] = value


## Get vec3 representing the effect's color
func get_color() -> Vector3:
	if all_null(): return EFFECTLESS_COLOR
	
	## Sort effects by strength
	var strongest_effects = self.effects.keys()
	strongest_effects = strongest_effects.filter(func(e): return true if self.effects[e] != 0 else false)
	strongest_effects.sort_custom(func(a, b): return true if abs(self.effects[a]) > abs(self.effects[b]) else false)
	
	if strongest_effects.size() == 0: return EFFECTLESS_COLOR
	
	var strongest_effect = strongest_effects[0]
	
	return strongest_effects.pos_color if self.effects[strongest_effect] >= 0 else strongest_effects.neg_color
