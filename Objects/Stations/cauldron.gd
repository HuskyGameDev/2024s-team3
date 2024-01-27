extends Node2D

var currentIngredients: Array[int] = []


func _on_body_enter_cauldron(body):
	if body.has_meta("ingredient"):
		var addedIngredient = body.get_meta("ingredient").data
		body.queue_free()
		currentIngredients.push_back(addedIngredient.id)


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		check_potion_made()


func check_potion_made():
	print(currentIngredients)
