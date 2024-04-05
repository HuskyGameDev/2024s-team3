extends Button

signal potionData
signal CorrectGoToCustSpawner
var custOrder:String
var orderPrice:int
var orderRep:int
var potionOnPedestal:String


func _on_pedestal_send_to_bell(item):
	potionOnPedestal = item.name


func _on_customer_spawner_order_to_bell(data):
	custOrder = data.order.name
	orderPrice = data.orderPrice
	orderRep = data.reputationChange

func _pressed():
	if !potionOnPedestal: return
	if custOrder == potionOnPedestal:
		print("correct order!")
		CorrectGoToCustSpawner.emit() # send another one, get ride of this guy 
		potionOnPedestal = ""
		PlayerData.changeMoney(orderPrice)
		PlayerData.changeReputation(orderRep)
	else:
		PlayerData.changeReputation(orderRep * -1)
