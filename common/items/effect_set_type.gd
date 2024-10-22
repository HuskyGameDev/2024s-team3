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
static var NOTHING_RANGE = 5
static var WEAK_RANGE = 10
static var REGULAR_RANGE = 20

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


## Returns an array of the strongest n effects
func get_strongest(n:int = 10) -> Array:
	## Sort effects by strength
	var all_effects = self.effects.keys()
	all_effects = all_effects.filter(func(e): return true if self.effects[e] != 0 else false)
	all_effects.sort_custom(func(a, b): return true if abs(self.effects[a]) > abs(self.effects[b]) else false)
	if n > all_effects.size():
		return all_effects.slice(0, n)
	else: return all_effects


## Returns an array of the weakest n effects
func get_weakest(n:int = 10) -> Array:
	## Sort effects by strength
	var all_effects = self.effects.keys()
	all_effects = all_effects.filter(func(e): return true if self.effects[e] != 0 else false)
	all_effects.sort_custom(func(a, b): return false if abs(self.effects[a]) > abs(self.effects[b]) else true)
	if n > all_effects.size():
		return all_effects.slice(0, n)
	else: return all_effects


## Returns an array with the names of the effects (in order)
func get_strongest_as_strings() -> Array[String]:
	var strongest_effects = get_strongest()
		
	## Get effect labels
	var labels: Array[String] = []
	for effect in strongest_effects:
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


## Perform a function on every effect
func modify_each(f:Callable):
	for effect in effects:
		effects[effect] = f.call(effects[effect])


## Perform a function on the largest effect
func modify_largest(f:Callable):
	var strongest = get_strongest(1)[0]
	if not strongest: return
	effects[strongest] = f.call(effects[strongest])


## Perform a function on the smallest effect
func modify_smallest(f:Callable):
	var weakest = get_weakest(1)[0]
	if not weakest: return
	effects[weakest] = f.call(effects[weakest])
