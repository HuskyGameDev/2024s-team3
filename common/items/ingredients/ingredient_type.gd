@tool
extends Item
class_name Ingredient

@export var effects: EffectSet
@export var average_color: Color

enum Actions {
	CHOP = 2,
	CRUSH = 4,
	MELT = 8,
	CONCENTRATE = 16
}

# we use "_" just as a placeholder because bitwise 0 & 0 returns 0 (false)
@export_flags("_", "CHOP", "CRUSH", "MELT", "CONCENTRATE") var available_actions = 0

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
