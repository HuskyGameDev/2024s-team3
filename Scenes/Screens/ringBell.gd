extends Button

signal potionData
signal CorrectGoToCustSpawner
var custOrder 
var potionOnPedestal


func _on_pedestal_send_to_bell(item):
	potionOnPedestal = item.name


func _on_customer_spawner_order_to_bell(data:String):
	custOrder = data

func _pressed():
	if (custOrder == potionOnPedestal):
		print("correct order!")
		CorrectGoToCustSpawner.emit() # send another one, get ride of this guy 
		potionOnPedestal = null
