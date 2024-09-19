extends Node

const LOCATION_PATH = "res://common/locations"

func _ready():
	## get locations
	for path in ResourcePaths.get_all_location_paths():
		var location = load(path)
		## add buttons
		var button = Button.new()
		button.text = location.name
		button.add_theme_font_size_override("font_size", 64)
		button.pressed.connect(_button_pressed.bind(location))
		$"CenterContainer/VBoxContainer".add_child(button)

func _button_pressed(location:Location):
	PlayerData.location = location
	get_tree().change_scene_to_file("res://screens/main/main.tscn")
