extends Node

# spawnCustomers 
# If a customer is needed it will spawn one in and then assign it attributes. 
# this class governs the customer.gd class by creating instances, it can create different combinations of customers you will encounter 
# the customers can be created with different attributes in this script like walking speed, lore, order, ect. or default values 
# more customers with different looks are made seperatly by creating a scence, the object itself is a scene that will be instatiated when it is needed later to save reasources

var areaOnePotionNames = ["healing_potion", "potion2", "potion3", "potion4"] # what they might order

var tempCust
var customerStartLocation = (Vector2(1200,50))
var customerEndLocation = (Vector2(800,50)) # changing y value could create a walking bobbing effect
#var customerWalkFlip = true

#var custspawned = false;
var sizeOfCustomers = 3
var t = 0.0 # interpolation t walk value for the x direction
#var y = 0.0 # interpolation t up and down walk value for the y direction

var customer1 = preload("res://Scenes/Customers/customer1.tscn")
var customer2 = preload("res://Scenes/Customers/customer2.tscn")
var customer3 = preload("res://Scenes/Customers/customer3.tscn")

var rng = RandomNumberGenerator.new() # just for a random speed

# Called when the node enters the scene tree for the first time.
func _ready(): 
	
	# create a customer array to spawn in unique sprites, order details will be random but seperated from customer (for now, will change) 
	var custArray = [customer1, customer2, customer3] 
	
	print("\nuninstantiated customers in array:")
	for n in sizeOfCustomers:
		print(custArray[n])
	print("")
	
	custArray.shuffle() # will randomize the array, sweet
	
	# instatiate number 1 test
	tempCust = custArray[0].instantiate()
	tempCust.position = customerStartLocation
	add_child(tempCust) # add new customer to the main scene so you can see it
	#custspawned = true
	
	# generate customer data example
	#todo 
	tempCust.setCustomerName("customerOne")
	tempCust.setCustomerOrder(areaOnePotionNames.pick_random()) # area specific lists? like the one above
	
	# generate customers one after another 
	# how many per area?
	#todo
	
	var my_random_number = rng.randf_range(.4, 1.4) # walking speed range
	tempCust.setCustomerSpeed(my_random_number) # reference the current instance of a customer and modify it, AFTER they are instatiated 
	
	print(tempCust.name, " has entered with a speed of: ", my_random_number, "\n")
	print(tempCust.name, " wants a ", tempCust.foodOrder)
	
func _physics_process(delta): # testing a small movement without animating it, godot makes this strange idk
	# x
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
	

