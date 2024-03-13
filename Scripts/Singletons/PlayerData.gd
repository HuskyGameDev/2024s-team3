extends Node

################# Game Saving ###################
const SAVE_LOCATION = "user://savegame.save"
var INV_LOCATION = "user://inv_data_file.json"
var data = {}
@export var save:SaveGameFile

func _ready():
	create_new_inv()
	save = load_game()
	GameTime.connect("end_of_day", _on_end_of_day);

func save_game(content):	
	if content != null:
		var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
		file.store_string(JSON.stringify(content))
		file.close
		file = null
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	save_file.store_var(var_to_str(save))

func load_game() -> SaveGameFile:
	## Load from file
	if not FileAccess.file_exists(SAVE_LOCATION):
		print("No save found")
		return SaveGameFile.new()
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var loaded_save = str_to_var(save_file.get_var())
	if loaded_save is SaveGameFile:
		return loaded_save
	else:
		print("error reading save file")
		return SaveGameFile.new()

func read_inv():
	var file = FileAccess.open(INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	file.close()
	return content
	
func write_inv(content):
	var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	return 
	
func create_new_inv():
	var file = FileAccess.open("res://Assets/Data/inv_data_file.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	data =  content
	save_game(content)

func clear_save():
	DirAccess.remove_absolute(SAVE_LOCATION)


################ Event Triggers #################

func _on_end_of_day():
	save_game(null)

func _on_potion_made(potion:Potion):
	if not save.madePotions.has(potion.id):
		save.madePotions.append(potion.id)
