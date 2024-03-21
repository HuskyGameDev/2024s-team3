extends Node
# creates generic customers 

var potionsRecieved: Array[String] = [] # Add potion recieved to an array for storage, can combine or add to one main array in the future to keep track of all potions
var data:Customer 
	
func setCustomerSpeed(speed):
	self.data.walkSpeed = speed # same as "this. in java"
	
func setCustomerName(name):
	self.data.customerName = name 

func _setup(customerData: Customer):
	self.data = customerData

func _on_area_2d_input_event(viewport, event, shape_idx): # Godot signal I might use later
	#if event is Potion: 
		#print("customer got a : ", Potion) 
		pass

func _on_area_2d_body_entered(body):
	if body.get("object_type") == "Potion":
		var recievedPotion = body.get("object_data")
		
		if (recievedPotion.id == self.data.order.id): # check if they got the right one
			print(self.data.customerName, " recieved a ",  self.data.order.name)
		else: print(self.data.customerName, " wanted a: ",  self.data.order.name, " but got a ", recievedPotion.name, " instead.")
		
		## Add potion recieved to an array 
		var addedPotion = body.get("object_data")
		potionsRecieved.push_back(recievedPotion.id) # add
