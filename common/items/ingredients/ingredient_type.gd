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
