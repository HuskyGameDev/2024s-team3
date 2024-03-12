extends Node
# creates generic customers 

var potionsRecieved: Array[String] = [] # Add potion recieved to an array for storage, can combine or add to one main array in the future to keep track of all potions

var customerName = "joe" # default, can also look at the acutal object name too
var walkSpeed = .25 # default
var foodOrder = "(notSet)"
	
func setCustomerSpeed(speed):
	self.walkSpeed = speed # same as "this. in java"
	
func setCustomerName(name):
	self.customerName = name 
	
func setCustomerOrder(order):
	self.foodOrder = order 

func _on_area_2d_input_event(viewport, event, shape_idx): # Godot signal I might use later
	#if event is Potion: 
		#print("customer got a : ", Potion) 
		pass

func _on_area_2d_body_entered(body):
	if body.get("object_type") == "Potion":
		var recievedPotion = body.get("object_data")
		
		if (recievedPotion.id == foodOrder): # check if they got the right one
			print(customerName, "recieved a ", foodOrder)
		else: print(customerName, " wanted a: ", foodOrder, " but got a " ,recievedPotion.id, " instead.")
		
		## Add potion recieved to an array 
		var addedPotion = body.get("object_data")
		potionsRecieved.push_back(recievedPotion.id) # add
