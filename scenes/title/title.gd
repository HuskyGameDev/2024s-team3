extends Control

func _ready():
	GameTime.stop()
	if not PlayerData.tutorial_complete:
		$"VBoxContainer/Continue".visible = false


func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	PlayerData.clear_save_files()
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
