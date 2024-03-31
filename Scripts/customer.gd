extends Sprite2D
# creates generic customers 

var potionsRecieved: Array[String] = [] # Add potion recieved to an array for storage, can combine or add to one main array in the future to keep track of all potions
var data:Customer 

func _setup(customerData: Customer):
	self.data = customerData
	

func set_sprite(sprite:Texture2D):
	self.texture = sprite


func _on_area_2d_body_entered(body):
	if body.get("object_type") == "Potion":
		var recievedPotion = body.get("object_data")
		
		if (recievedPotion.id == self.data.order.id): # check if they got the right one
			print(self.data.customerName, " recieved a ",  self.data.order.name)
		else: print(self.data.customerName, " wanted a: ",  self.data.order.name, " but got a ", recievedPotion.name, " instead.")
		
		## Add potion recieved to an array 
		potionsRecieved.push_back(recievedPotion.id) # add
