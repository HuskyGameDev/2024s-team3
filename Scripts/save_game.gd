extends Node

const SAVE_LOCATION = "user://savegame.save"
@export var saveFile:SaveGameFile

func _ready():
	saveFile = load_game()
	

func save_game():
	## Set up save object
	var save = SaveGameFile.new()
	
	## Save to file
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	save_file.store_var(var_to_str(save))


func load_game() -> SaveGameFile:
	## Load from file
	if not FileAccess.file_exists(SAVE_LOCATION):
		print("No save found")
		return SaveGameFile.new()
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var save = str_to_var(save_file.get_var())
	if save is SaveGameFile:
		return save
	else:
		print("error reading save file")
		return SaveGameFile.new()


func clear_save():
	DirAccess.remove_absolute(SAVE_LOCATION)


