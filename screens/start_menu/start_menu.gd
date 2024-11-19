extends Control

func _ready():
	GameTime.stop()
	if not FileAccess.file_exists("res://screens/main/packed_main.tscn"):
		$"VBoxContainer/Continue".visible = false

func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	PlayerData.clear_save_files()
	get_tree().change_scene_to_file("res://screens/tutorial/tutorial.tscn")


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
