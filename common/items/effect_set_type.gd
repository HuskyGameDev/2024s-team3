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

## key is Effect, value is int
static var ALL_EFFECTS = {
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
}

## Get effect resource by id
static func get_effect_by_id(id: String):
	for effect in ALL_EFFECTS:
		if effect.id == id: 
			return effect
	return null

## 0-4 does nothing, 5-9 is weak, 10-19 is regular, and 20+ is strong
const NOTHING_RANGE = 5
const WEAK_RANGE = 10
const REGULAR_RANGE = 20

const EFFECTLESS_COLOR = Color(200, 200, 200)


@export var effects:Dictionary = ALL_EFFECTS.duplicate()


## Gets the strength of an effect
func get_strength(e: Effect):
	return effects[e]


## Sets the strength of an effect
func set_strength(e: Effect, strength: int):
	effects[e] = strength


## Adds another effects set to this one
func add(e: EffectSet) -> void:
	for effect in self.effects:
		self.effects[effect] += e.get_strength(effect)


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
func get_color() -> Color:
	if all_null(): return EFFECTLESS_COLOR
	
	## Sort effects by strength
	var strongest_effects = self.effects.keys()
	strongest_effects = strongest_effects.filter(func(e): return true if self.effects[e] != 0 else false)
	strongest_effects.sort_custom(func(a, b): return true if abs(self.effects[a]) > abs(self.effects[b]) else false)
	
	if strongest_effects.size() == 0: return EFFECTLESS_COLOR
	
	var strongest_effect = strongest_effects[0]
	
	return strongest_effect.pos_color if self.effects[strongest_effect] >= 0 else strongest_effect.neg_color
