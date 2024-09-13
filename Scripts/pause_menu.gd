extends Control
signal pause_timer # signals timer to pause

func _input(e): # when a user presses the "escape" key pause screen appears and game is paused, or if paused, unpaused
	if Input.is_action_just_pressed("escape"): # escpe is defined project input map
		if self.visible == false: # if not visible
			self.visible = true # make visible
			GameTime.emit_signal("pause")
		else:
			self.visible = false # make not visible
			GameTime.emit_signal("pause")

# exit game 
func _on_quit_button_button_down():
	get_tree().quit()
	
 #change scene to main meny
func _on_menu_button_button_down():
	get_tree().change_scene_to_file("res://Scenes/UI/Title.tscn")

# resume game
func _on_resume_button_button_down():
	self.visible = false # make not visible
	GameTime.emit_signal("pause")
