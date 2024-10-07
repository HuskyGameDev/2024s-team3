extends Item
class_name Ingredient

@export var effects: EffectSet

enum Actions {
	CHOP = 1 << 1,
	CRUSH = 1 << 2,
	MELT = 1 << 3,
	CONCENTRATE = 1 << 4
}

# we use "_" just as a placeholder because bitwise 0 & 0 returns 0 (false)
@export_flags("_", "CHOP", "CRUSH", "MELT", "CONCENTRATE") var available_actions = 0

## Returns true if the selected action is valid
func can(action:Actions):
	return available_actions & action
