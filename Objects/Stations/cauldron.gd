extends Node2D

var currentIngredients: Array[String] = []
var recipes = {}
var potion = preload("res://Objects/Potions/Potion.tscn")

signal potion_made(potion)

func _on_recipes_recipes_loaded(recipe_dict):
	recipes = recipe_dict
	

func _on_body_enter_cauldron(body):
	if body.get("object_type") == "Ingredient":
		var addedIngredient = body.get("object_data")
		body.queue_free()
		currentIngredients.push_back(addedIngredient.id)


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		check_potion_made()


func check_potion_made():
	currentIngredients.sort()
	var made_potion = recipes.get(currentIngredients.hash())
	currentIngredients.clear()
	if made_potion:
		var newPotion = potion.instantiate()
		newPotion.data = made_potion
		newPotion.position = self.position
		# we subtract 100 to move the potion up
		newPotion.position -= Vector2(0, 100)
		potion_made.emit(newPotion)
	else:
		print("Did not make potion")


