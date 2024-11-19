extends Control

@onready var fader:AnimationPlayer = $Fader

func _ready():
	GameTime.stop()
	$ColorRect2.hide()
	$ColorRect2.top_level = false
	if not FileAccess.file_exists("res://screens/main/packed_main.tscn"):
		$"VBoxContainer/Continue".visible = false

func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	PlayerData.clear_save_files()
	PlayerData.change_money(-PlayerData.money)
	PlayerData.change_reputation(-PlayerData.reputation)
	await fadeout()
	get_tree().change_scene_to_file("res://screens/tutorial/tutorial.tscn")


func _on_continue_pressed():
	await fadeout()
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
	
func fadeout():
	print("Fading out")
	$ColorRect2.show()
	$ColorRect2.top_level = true
	print(db_to_linear($MainPlayer.volume_db))
	print(linear_to_db(0))
	var tween:Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($ColorRect2, "color", Color(0,0,0,1), 1.5)
	tween.tween_property($MainPlayer, "volume_db", linear_to_db(0.04), 1.5)
	await tween.finished
	return true
