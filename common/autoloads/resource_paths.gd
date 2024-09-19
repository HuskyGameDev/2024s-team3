extends Node

var location_file_paths: Dictionary = {}
var potion_file_paths: Dictionary = {}
var ingredient_file_paths: Dictionary = {}
var customer_sprites: Array[Texture2D] = []

####################### SETUP #######################
func _ready():
	## Get all resource files
	var location_paths = _get_all_paths_with_extension("res://common/locations", ".tres")
	var potion_paths = _get_all_paths_with_extension("res://common/items/potions", ".tres")
	var ingredient_paths = _get_all_paths_with_extension("res://common/items/ingredients", ".tres")
	
	## Add the paths to the dictionary
	var regex = RegEx.new()
	regex.compile("^res:\\/\\/.+\\/(?'id'[0-9_[:lower:]]+)\\.tres.*$")
	for path in location_paths:
		var result = regex.search(path)
		if result: location_file_paths[result.get_string("id")] = path
	for path in potion_paths:
		var result = regex.search(path)
		if result: potion_file_paths[result.get_string("id")] = path
	for path in ingredient_paths:
		var result = regex.search(path)
		if result: ingredient_file_paths[result.get_string("id")] = path
	
	## Get all customer sprite files
	var customer_sprite_paths = _get_all_paths_with_extension("res://screens/main/customers/generic_sprites", ".png")
	## Add the images to the array
	for path in customer_sprite_paths:
		customer_sprites.push_back(load(path))


func _get_all_paths_with_extension(path: String, extension: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():
			file_paths += _get_all_paths_with_extension(file_path, extension)  
		elif extension in file_name and ".import" not in file_name:
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	dir.list_dir_end()
	return file_paths

####################### GETTERS #######################
func get_resource_path(id: String):
	if id in location_file_paths:
		return location_file_paths[id]
	elif id in potion_file_paths:
		return potion_file_paths[id]
	elif id in ingredient_file_paths:
		return ingredient_file_paths[id]
	else: return null

func get_location_path(id: String):
	if id in location_file_paths:
		return location_file_paths[id]
	else: return null

func get_potion_path(id: String):
	if id in potion_file_paths:
		return potion_file_paths[id]
	else: return null

func get_ingredient_path(id: String):
	if id in ingredient_file_paths:
		return ingredient_file_paths[id]
	else: return null


func get_all_location_paths() -> Array:
	return location_file_paths.values()

func get_all_potion_paths() -> Array:
	return potion_file_paths.values()

func get_all_ingredient_paths() -> Array:
	return ingredient_file_paths.values()


func get_random_customer_sprite() -> Texture2D:
	randomize()
	return customer_sprites[randi() % customer_sprites.size()]
