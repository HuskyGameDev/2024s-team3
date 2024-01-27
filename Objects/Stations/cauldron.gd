extends Node2D

var currentIngredients: Array[int] = []
var recipes = {}


func _on_recipes_recipes_loaded(recipe_dict):
	recipes = recipe_dict
	

func _on_body_enter_cauldron(body):
	if body.has_meta("ingredient"):
		var addedIngredient = body.get_meta("ingredient").data
		body.queue_free()
		currentIngredients.push_back(addedIngredient.id)


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		check_potion_made()


func check_potion_made():
	currentIngredients.sort()
	var made_potion = recipes.get(currentIngredients.hash())
	if made_potion:
		print("Made " + made_potion.potion_name)
	else:
		print("Did not make potion")


