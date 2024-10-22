extends Control
#Signal for skipping customer
signal skipCustomerPressed
#Shows the pop up panel
func _on_end_day_pressed():
	$Confirmation.show()

func _on_confirm_pressed():
	GameTime.end_of_day.emit() # When pressed it emits the end_of_day signal.
	$Confirmation.hide()
#Hides the pop up panel.
func _on_cancel_pressed():
	$Confirmation.hide()
	
	
func _on_skip_customer_pressed():
	skipCustomerPressed.emit()
	
	
