extends Node
# creates generic customers 

var potionsRecieved: Array[String] = [] # Add potion recieved to an array for storage, can combine or add to one main array in the future to keep track of all potions

var customerName:String = "joe" # default, can also look at the acutal object name too
var walkSpeed:float = .25 # default
var foodOrder:Potion = null
var orderCost:int = 0
var orderReputation:int = 0
	
func setCustomerSpeed(speed):
	self.walkSpeed = speed # same as "this. in java"
	
func setCustomerName(name):
	self.customerName = name 
	
func setCustomerOrder(order:Dictionary):
	self.foodOrder = order.get("request")
	self.orderCost = order.get("moneyChange")
	self.orderReputation = order.get("repChange")

func _on_area_2d_input_event(viewport, event, shape_idx): # Godot signal I might use later
	#if event is Potion: 
		#print("customer got a : ", Potion) 
		pass

func _on_area_2d_body_entered(body):
	if body.get("object_type") == "Potion":
		var recievedPotion = body.get("object_data")
		
		if (recievedPotion.id == foodOrder.id): # check if they got the right one
			print(customerName, " recieved a ", foodOrder.name)
		else: print(customerName, " wanted a: ", foodOrder.name, " but got a " ,recievedPotion.name, " instead.")
		
		## Add potion recieved to an array 
		var addedPotion = body.get("object_data")
		potionsRecieved.push_back(recievedPotion.id) # add
