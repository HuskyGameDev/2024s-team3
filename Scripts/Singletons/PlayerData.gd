extends Node

################# Game Saving ###################
const SAVE_LOCATION = "user://savegame.save"
@export var save:SaveGameFile

func _ready():
	save = load_game()
	GameTime.connect("end_of_day", _on_end_of_day);
	

func save_game():
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


func clear_save():
	DirAccess.remove_absolute(SAVE_LOCATION)


################ Event Triggers #################

func _on_end_of_day():
	save_game();
	
func _on_potion_made(potion:Potion):
	if not save.madePotions.has(potion.id):
		save.madePotions.append(potion.id)
