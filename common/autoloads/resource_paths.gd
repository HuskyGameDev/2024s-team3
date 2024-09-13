extends Node

var location_file_paths: Dictionary = {}
var potion_file_paths: Dictionary = {}
var ingredient_file_paths: Dictionary = {}

func _ready():
	## Get all resource files
	var location_paths = _get_all_resource_paths("res://common/locations")
	var potion_paths = _get_all_resource_paths("res://common/items/potions")
	var ingredient_paths = _get_all_resource_paths("res://common/items/ingredients")
	
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


func _get_all_resource_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():
			file_paths += _get_all_resource_paths(file_path)  
		elif ".tres" in file_name:
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	dir.list_dir_end()
	return file_paths


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
