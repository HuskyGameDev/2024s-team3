extends Node2D

var currentIngredients: Array[int] = []


func _on_body_enter_cauldron(body):
	if body.has_meta("ingredient"):
		var addedIngredient = body.get_meta("ingredient")
		body.queue_free()
		currentIngredients.push_back(addedIngredient.id)


func check_potion_made():
	pass
