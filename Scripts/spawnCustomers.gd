extends Node

#var this = preload("res://Scenes/customers/customer1.tscn") # testing, reference the object to instantiate as a scene 

var sizeOfCustomers = 3

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
	var customerLocation = (Vector2(400,50))
	
	var custArray = [customer1, customer2, customer3] 
	
	print("uninstantiated objects in array:")
	for n in sizeOfCustomers:
		print(custArray[n])
	
	custArray.shuffle() # will randomize the array
	
	# instatiate number 1 test
	var tempCust = custArray[0].instantiate()
	tempCust.position = customerLocation
	add_child(tempCust) # add new custer to the main scene so you can see it
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
