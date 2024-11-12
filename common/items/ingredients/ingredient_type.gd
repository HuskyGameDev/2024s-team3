@tool
extends Item
class_name Ingredient

@export var effects: EffectSet

enum Actions {
	CHOP = 2,
	CRUSH = 4,
	MELT = 8,
	CONCENTRATE = 16
}

enum Types {
	MINERAL = 0,
	PLANT = 1,
	MAGIC_PLANT = 2,
	ANIMAL = 3,
	MAGIC_ANIMAL = 4
}

# we use "_" just as a placeholder because bitwise 0 & 0 returns 0 (false)
@export_flags("_", "CHOP", "CRUSH", "MELT", "CONCENTRATE") var available_actions = 0

@export var type : Types :
	set(t):
		type = t
		match type:
			Types.MINERAL:
				grab_sounds = [
					load("res://common/audio/ingredients/Mineral_Pickup_1.wav"),
					load("res://common/audio/ingredients/Mineral_Pickup_2.wav")
				]
				drop_sounds = [
					load("res://common/audio/ingredients/Mineral_Drop_1.wav"),
					load("res://common/audio/ingredients/Mineral_Drop_2.wav"),
				]
			Types.PLANT:
				grab_sounds = [
					load("res://common/audio/ingredients/Foliage_Pickup_1.wav"),
					load("res://common/audio/ingredients/Foliage_Pickup_2.wav")
				]
				drop_sounds = [
					load("res://common/audio/ingredients/Foliage_Drop_1.wav"),
					load("res://common/audio/ingredients/Foliage_Drop_2.wav"),
				]
			Types.MAGIC_PLANT:
				grab_sounds = [
					load("res://common/audio/ingredients/Magic_Plant_Pickup_1.wav"),
					load("res://common/audio/ingredients/Magic_Plant_Pickup_2.wav")
				]
				drop_sounds = [
					load("res://common/audio/ingredients/Magic_Plant_Drop_1.wav"),
					load("res://common/audio/ingredients/Magic_Plant_Drop_2.wav"),
				]
			##TODO: update these sound effects
			Types.ANIMAL:
				grab_sounds = [load("res://common/audio/ingredients/Magic_Plant_Drop_1.wav"),]
				drop_sounds = [load("res://common/audio/ingredients/Mineral_Pickup_2.wav")]
			Types.MAGIC_ANIMAL:
				grab_sounds = [load("res://common/audio/ingredients/Magic_Plant_Drop_1.wav"),]
				drop_sounds = [load("res://common/audio/ingredients/Mineral_Pickup_2.wav")]

var grab_sounds = []
var drop_sounds = []

## Returns true if the selected action is valid
func can(action:Actions):
	return available_actions & action

## Converts action to a string
static func action_to_string(action:Actions) -> String:
	match action:
		Actions.CHOP: return "chopped"
		Actions.CRUSH: return "crushed"
		Actions.MELT: return "melted"
		Actions.CONCENTRATE: return "concentrated"
	return ""


## Gets the base id (minus the action) of the ingredient
func get_base_id():
	var trimmed_id = self.id
	for action in Actions.values():
		var action_string = "%s_" % action_to_string(action)
		trimmed_id = trimmed_id.trim_prefix(action_string)
	return trimmed_id


## Gets the sound the ingredient should make when being picked up
func get_grab_sound():
	return grab_sounds.pick_random()


## Gets the sound the ingredient should make when being dropped
func get_drop_sound():
	return drop_sounds.pick_random()
