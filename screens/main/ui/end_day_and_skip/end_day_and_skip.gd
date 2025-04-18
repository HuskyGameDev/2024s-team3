extends Control
#Signal for skipping customer
signal skipCustomerPressed
signal end_day_pressed
signal confirm_pressed
#Shows the pop up panel
func _on_end_day_pressed():
	end_day_pressed.emit()
	$Confirmation.show()
func _on_confirm_pressed():
	confirm_pressed.emit()
	GameTime.hour = GameTime.STORE_CLOSE_TIME # set game time to closing time
	GameTime.end_of_day.emit() # When pressed it emits the end_of_day signal.
	PlayerData.change_reputation(-5) # Lower player's rep for closing early.
	$Confirmation.hide()
#Hides the pop up panel.
func _on_cancel_pressed():
	$Confirmation.hide()
	
	
func _on_skip_customer_pressed():
	skipCustomerPressed.emit()
	
	
