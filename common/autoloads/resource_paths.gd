extends Node

var resource_file_paths: Dictionary = {}

func _ready():
	## Get all resource files
	var resource_paths = get_all_resource_paths("res://common/locations") + get_all_resource_paths("res://common/items")
	
	## Add the paths to the dictionary
	var regex = RegEx.new()
	regex.compile("^res:\\/\\/.+\\/(?'id'[0-9_[:lower:]]+)\\.tres.*$")
	for path in resource_paths:
		var result = regex.search(path)
		if result:
			resource_file_paths[result.get_string("id")] = path


func get_all_resource_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():
			file_paths += get_all_resource_paths(file_path)  
		elif ".tres" in file_name:
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	dir.list_dir_end()
	return file_paths


func get_resource_path(id: String):
	if id in resource_file_paths:
		return resource_file_paths[id]
	else: return null
