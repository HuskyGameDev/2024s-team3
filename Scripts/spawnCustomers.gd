extends Node

# spawnCustomers 
# If a customer is needed it will spawn one in and then assign it attributes. 
# this class governs the customer.gd class by creating instances, it can create different combinations of customers you will encounter 
# the customers can be created with different attributes in this script like walking speed, lore, order, ect. or default values 
# more customers with different looks are made seperatly by creating a scence, the object itself is a scene that will be instatiated when it is needed later to save reasources

var tempCust
var customerStartLocation = (Vector2(750,50))
var customerEndLocation = (Vector2(400,50))
#var custspawned = false;
var sizeOfCustomers = 3
var t = 0.0 # time

var customer1 = preload("res://Scenes/customers/customer1.tscn")
var customer2 = preload("res://Scenes/customers/customer2.tscn")
var customer3 = preload("res://Scenes/customers/customer3.tscn")

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
	
	var my_random_number = rng.randf_range(.1, 2.5) # walking speed range
	tempCust.setCustomerSpeed(my_random_number) # reference the current instance of a customer and modify it, AFTER they are instatiated 
	
	print(tempCust.name, " has entered with a speed of: ", my_random_number, "\n")
	
func _physics_process(delta): # testing a small movement without animating it
	t += (delta * (tempCust.walkSpeed * 2) )
	#print(t) 
	tempCust.position = customerStartLocation.lerp(customerEndLocation, t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (t > 2 && t != 0.0):
		set_physics_process(false)
		t = 0.0
		
#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout
