extends Control

func _ready():
	GameTime.stop()
	if PlayerData.save.money == 0 and PlayerData.save.reputation == 0 and PlayerData.save.madePotions.size() == 0:
		$"VBoxContainer/Continue".visible = false


func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	PlayerData.clear_save()
	_on_continue_pressed()


func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Main.tscn")
