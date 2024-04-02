extends Button

signal potionData
signal CorrectGoToCustSpawner
var custOrder 
var potionOnPedestal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		if (custOrder == potionOnPedestal):
			print("correct order!")
			CorrectGoToCustSpawner.emit() # send another one, get ride of this guy 
			

func _on_pedestal_send_to_bell(item):
	potionOnPedestal = item.name


func _on_customer_spawner_order_to_bell(data:String):
	custOrder = data
