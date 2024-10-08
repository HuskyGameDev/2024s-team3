@tool
extends "res://addons/resource_manager/ingredient_manager/ingredient_row.gd"


## Disables checkbox for the current change
func _ready():
	super()
	if not self.ingredient: return
	
	var action = self.ingredient.id.get_slice("_", 0)
	match action:
		"chopped": $ChoppableCheck.disabled = true
		"crushed": $CrushableCheck.disabled = true
		"melted": $MeltableCheck.disabled = true
		"concentrated": $ConcentratableCheck.disabled = true
