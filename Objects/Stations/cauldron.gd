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
		print(addedIngredient.ingredient_name + " entered cauldron")


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		check_potion_made()


func check_potion_made():
	currentIngredients.sort() # Sorts the array of ingredients
	print("Current Ingredients: ")
	for ingredient in currentIngredients:
		print(ingredient)
	if currentIngredients.size() == 0:
		print("None")
	
	var made_potion = recipes.get(currentIngredients.hash()) # Hashes the array of ingredients and finds the corresponding recipe
	
	"""
	If the recipe made by the ingredients in the cauldron matches a working recipe, make the corresponding potion.
	Otherwise, run a script to find out what failed potion was made.
	Either way, clear out the ingredient array after checking.
	"""
	if made_potion:
		var newPotion = potion.instantiate()
		newPotion.data = made_potion
		newPotion.position = self.position
		# we subtract 100 to move the potion up
		newPotion.position -= Vector2(0, 100)
		potion_made.emit(newPotion)
	else:
		print("Did not make potion")
		# TODO: Actually find what failed potion was made
	currentIngredients.clear()
	


