extends Control

@onready var fader:AnimationPlayer = $Fader

func _ready():
	GameTime.stop()
	$ColorRect2.hide()
	$ColorRect2.top_level = false
	if not FileAccess.file_exists("res://screens/main/packed_main.tscn") or (PlayerData.day <= 1):
		$"VBoxContainer/Continue".visible = false

func _on_exit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	PlayerData.clear_save_files()
	PlayerData.change_money(-PlayerData.money)
	PlayerData.change_reputation(-PlayerData.reputation)
	PlayerData.day = 1 # reset day counter
	GameTime.day = PlayerData.day # ensure day matches save
	await fadeout()
	get_tree().change_scene_to_file("res://screens/tutorial/tutorial.tscn")


func _on_continue_pressed():
	GameTime.day = PlayerData.day # ensure day matches save
	GameTime.hour = GameTime.STORE_OPEN_TIME # ensure day stats at beginning 
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
	tween.tween_property($MainPlayer, "volume_db", -40, 1.5)
	await tween.finished
	return true
