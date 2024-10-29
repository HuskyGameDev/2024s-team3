@tool
extends Node

var location_file_paths: Dictionary = {}
var ingredient_file_paths: Dictionary = {}
var customer_sprites: Array[Texture2D] = []
var potion_sprites: Array[Texture2D] = []

@onready var regex = RegEx.new()

####################### SETUP #######################
func _ready():
	regex.compile("^res:\\/\\/.+\\/(?'id'[0-9_[:lower:]]+)\\.tres.*$")
	## Find all resources
	update_ingredient_paths()
	update_location_paths()
	
	## Get all customer sprite files
	var customer_sprite_paths = _get_all_paths_with_extension("res://screens/main/customers/generic_sprites", ".png")
	## Add the images to the array
	for path in customer_sprite_paths:
		customer_sprites.push_back(load(path))
	
	
	## Get all potion sprite files
	var potion_sprite_paths = _get_all_paths_with_extension("res://common/items/potions", ".png")
	## Add the images to the array
	for path in potion_sprite_paths:
		potion_sprites.push_back(load(path))


func update_ingredient_paths():
	## Clear old paths
	ingredient_file_paths = {}
	## Get all resource files
	var ingredient_paths = _get_all_paths_with_extension("res://common/items/ingredients", ".tres")
	## Add the paths to the dictionary
	for path in ingredient_paths:
		var result = regex.search(path)
		if result: ingredient_file_paths[result.get_string("id")] = path

func update_location_paths():
	## Clear old paths
	location_file_paths = {}
	## Get all resource files
	var location_paths = _get_all_paths_with_extension("res://common/locations", ".tres")
	## Add the paths to the dictionary
	for path in location_paths:
		var result = regex.search(path)
		if result: location_file_paths[result.get_string("id")] = path


func _get_all_paths_with_extension(path: String, extension: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():
			file_paths += _get_all_paths_with_extension(file_path, extension)  
		elif extension in file_name:
			if OS.has_feature("editor"):
				if ".import" not in file_name: #Only include .import files if not in the editor
					file_paths.append(file_path)
			else:
				file_path = file_path.trim_suffix(".import")
				file_path = file_path.trim_suffix(".remap")
				file_paths.append(file_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	return file_paths

####################### GETTERS #######################
func get_resource_path(id: String):
	if id in location_file_paths:
		return location_file_paths[id]
	elif id in ingredient_file_paths:
		return ingredient_file_paths[id]
	else: return null

func get_location_path(id: String):
	if id in location_file_paths:
		return location_file_paths[id]
	else: return null

func get_ingredient_path(id: String):
	if id in ingredient_file_paths:
		return ingredient_file_paths[id]
	else: return null


func get_all_location_paths() -> Array:
	return location_file_paths.values()

func get_all_ingredient_paths() -> Array:
	return ingredient_file_paths.values()


## for example: nightshade_petals returns chopped_nightshade_petals, crushed_nightshade_petals
func get_all_ingredient_variant_paths(id: String) -> Array:
	var ingredient_path = get_ingredient_path(id)
	var ingredient_dir = ingredient_path.get_base_dir()
	var paths = _get_all_paths_with_extension(ingredient_dir, ".tres")
	paths.erase(ingredient_path)
	return paths


func get_all_non_variant_ingredient_paths() -> Array:
	var paths = get_all_ingredient_paths()
	for action in Ingredient.Actions.values():
		var action_string = Ingredient.action_to_string(action)
		paths = paths.filter(func(p): return not p.contains(action_string))
	return paths


func get_random_customer_sprite() -> Texture2D:
	randomize()
	return customer_sprites[randi() % customer_sprites.size()]

func get_random_potion_sprite() -> Texture2D:
	randomize()
	return potion_sprites[randi() % potion_sprites.size()]
