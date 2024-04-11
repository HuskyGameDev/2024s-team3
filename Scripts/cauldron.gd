extends Node2D

var currentIngredients: Array[String] = []

signal potion_made(potion:Potion)
signal ingredient_added(id)

func _on_body_enter_cauldron(body):
	if body.get("object_type") == "Ingredient":
		## Animate object movement to top of cauldron
		body.gravity_scale = 0
		var top_of_cauldron = self.position - Vector2(0, 80)
		var ingredient_position = body.global_position
		var time_to_animate = (top_of_cauldron.distance_to(ingredient_position)) / 1000
		var tween = create_tween().bind_node(body)
		tween.tween_property(body, "global_position", top_of_cauldron, time_to_animate).from(ingredient_position)
		await tween.finished
		## Add to cauldron array
		var addedIngredient = body.get("object_data")
		ingredient_added.emit(addedIngredient.id)
		body.queue_free()
		currentIngredients.push_back(addedIngredient.id)

func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if currentIngredients.size() > 0:
			check_potion_made()


func check_potion_made():
	currentIngredients.sort() # Sorts the array of ingredients
	
	var made_potion = RecipeData.recipes.get(currentIngredients.hash()) # Hashes the array of ingredients and finds the corresponding recipe
	
	"""
	If the recipe made by the ingredients in the cauldron matches a working recipe, make the corresponding potion.
	Otherwise, run a script to find out what failed potion was made.
	Either way, clear out the ingredient array after checking.
	"""
	if made_potion:
		potion_made.emit(made_potion)
	else:
		pass
		# TODO: Actually find what failed potion was made
	currentIngredients.clear()
	
