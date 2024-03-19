extends Node

# spawnCustomers 
# If a customer is needed it will spawn one in and then assign it attributes. 
# this class governs the customer.gd class by creating instances, it can create different combinations of customers you will encounter 
# the customers can be created with different attributes in this script like walking speed, lore, order, ect. or default values 
# more customers with different looks are made seperatly by creating a scence, the object itself is a scene that will be instatiated when it is needed later to save reasources

var tempCust
var customerStartLocation = (Vector2(1200,50))
var customerEndLocation = (Vector2(800,50)) # changing y value could create a walking bobbing effect
#var customerWalkFlip = true

#var custspawned = false;
var sizeOfCustomers = 3
var t = 0.0 # interpolation t walk value for the x direction
#var y = 0.0 # interpolation t up and down walk value for the y direction

var customerScene = preload("res://Scenes/Customers/customer1.tscn")

var rng = RandomNumberGenerator.new() # just for a random speed

# Called when the node enters the scene tree for the first time.
func _ready(): 
	
	# create a customer array to spawn in unique sprites, order details will be random but seperated from customer (for now, will change) 
	var custArray = PlayerData.save.currentLocation.get_customer_requests(sizeOfCustomers)
	
	print("\nuninstantiated customers in array:")
	for n in sizeOfCustomers:
		print(custArray[n])
	print("")
	custArray.shuffle() # will randomize the array, sweet
	
	# instatiate number 1 test
	tempCust = customerScene.instantiate()
	tempCust.position = customerStartLocation
	add_child(tempCust) # add new customer to the main scene so you can see it
	#custspawned = true
	
	# generate customer data example
	#todo 
	tempCust.setCustomerName("customerOne")
	tempCust.setCustomerOrder(custArray[0])
	
	# generate customers one after another 
	# how many per area?
	#todo
	
	var my_random_number = rng.randf_range(.4, 1.4) # walking speed range
	tempCust.setCustomerSpeed(my_random_number) # reference the current instance of a customer and modify it, AFTER they are instatiated 
	
	print(tempCust.customerName, " has entered with a speed of: ", my_random_number, "\n") # name of object or the actual name
	print(tempCust.customerName, " wants a ", tempCust.foodOrder)
	
func _physics_process(delta): # testing a small movement without animating it, godot makes this strange idk
	# x
	return
	if(t < 1.7):
		t += (delta * (tempCust.walkSpeed) )
		#print(t) 
		tempCust.position = customerStartLocation.lerp(customerEndLocation, t) 
	
	# y slow down walk at the end, and move in y direction
	else:
		customerEndLocation.y += 1
		if(tempCust.walkSpeed > 1 ):
			tempCust.walkSpeed -= .1
		
		t += (delta * (tempCust.walkSpeed) )
		#print(t) 
		tempCust.position = customerStartLocation.lerp(customerEndLocation, t) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (t >= 2 || t < 0):
		set_physics_process(false)
		#t = 0.0
		
#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout
	

