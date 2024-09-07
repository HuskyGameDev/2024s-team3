extends Node2D

var hasSalt:bool = false

signal salt_made(salt:Ingredient)

func _on_body_enter_crucible(body):
	if body.get("object_type") == "Ingredient":
		if body.get("object_data").id == "peppermint_leaves" && !hasSalt:
			#Set as current ingredient
			body.queue_free()
			hasSalt = true;


func _on_crucible_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click") && hasSalt:
		salt_made.emit("pine_resin")
		hasSalt=false
