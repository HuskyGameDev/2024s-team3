extends Node

#var this = preload("res://Scenes/customers/customer1.tscn") # testing, reference the object to instantiate as a scene 
var tempCust
var stop = false
var customerStartLocation = (Vector2(500,50))
var customerEndLocation = (Vector2(450,50))
#var custspawned = false;
var sizeOfCustomers = 3
var t = 0.0

var customer1 = preload("res://Scenes/customers/customer1.tscn")
var customer2 = preload("res://Scenes/customers/customer2.tscn")
var customer3 = preload("res://Scenes/customers/customer3.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# instatiating testing
	#var instance = this.instantiate() # godot moment
	#instance.hide()
	#add_child(instance) 
	#print("instantiated customer 1")
	
	# array testing
	#var customerArray = [instance]
	#print("printing Array ",customerArray[0].name)
	
	
	# create a customer array to spawn in unique sprites, order details will be random but seperated from customer (for now, will change) 
	var custArray = [customer1, customer2, customer3] 
	
	print("uninstantiated objects in array:")
	for n in sizeOfCustomers:
		print(custArray[n])
	
	custArray.shuffle() # will randomize the array
	
	# instatiate number 1 test
	tempCust = custArray[0].instantiate()
	tempCust.position = customerStartLocation
	add_child(tempCust) # add new custer to the main scene so you can see it
	#custspawned = true


func _physics_process(delta): # testing a small movement without animating it
	t += delta * 0.4
	#print(t)
	tempCust.position = customerStartLocation.lerp(customerEndLocation, t)


#func endPhysics():
	#wait(15)
	#set_physics_process(false)


#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if t > 2:
		set_physics_process(false)
