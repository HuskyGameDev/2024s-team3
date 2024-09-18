extends Node

const LOCATION_PATH = "res://common/locations"

func _ready():
	## get locations
	var locations = []
	var dir = DirAccess.open(LOCATION_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			locations.push_back(load(LOCATION_PATH + file_name))
			file_name = dir.get_next()
	## add buttons
	for location in locations:
		var button = Button.new()
		button.text = location.name
		button.add_theme_font_size_override("font_size", 64)
		button.pressed.connect(_button_pressed.bind(location))
		$"CenterContainer/VBoxContainer".add_child(button)

func _button_pressed(location:Location):
	PlayerData.save.currentLocation = location
	PlayerData.save_game()
	get_tree().change_scene_to_file("res://screens/main/main.tscn")
