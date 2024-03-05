extends Node

signal recipes_loaded(recipe_dict)

var recipes = {}

# Load all potion recipes
func _ready():
	var path = "res://Assets/Potions/Resources/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			add_recipe_to_dictionary(load(path + file_name))
			file_name = dir.get_next()
		recipes_loaded.emit(recipes)
	else:
		print("An error occurred when trying to access the path.")


func add_recipe_to_dictionary(recipe_data):
	recipe_data.recipe.sort()
	var recipe_hash = recipe_data.recipe.hash()
	var found_hash = recipes.get(recipe_hash)
	if found_hash != null:
		# If the hashes aren't unique it quits (because the game will not work without unique hashes)
		print("Hash for recipes " + recipe_data.potion_name + " and " + found_hash.potion_name + " are the same")
		get_tree().quit(-1)
	else:
		recipes[recipe_hash] = recipe_data
