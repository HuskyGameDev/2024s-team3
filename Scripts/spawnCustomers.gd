extends Node
# spawnCustomers 
# If a customer is needed it will spawn one in and then assign it attributes. 
# this class governs the customer.gd class by creating instances, it can create different combinations of customers you will encounter 
# the customers can be created with different attributes in this script like walking speed, lore, order, ect. or default values 
# the object itself is a scene that will be instatiated when it is needed later to save reasources

const NAMES_DATA_PATH = "res://Assets/Data/CustomerNames.txt"
const SPRITES_DIR_PATH = "res://Assets/Sprites/Customers"
const customerScene = preload("res://Scenes/Customer.tscn")

var txtBox = preload("res://Scenes/UI/textBox.tscn") # general textbox

var custArray:Array[Customer] = []
var customerNames:Array[String] = []
var customerSprites:Array[Texture2D] = []
var currentCustomer
var dupWalkSpeed
var order

var customerStartLocation = (Vector2(1200,50))
var customerEndLocation = (Vector2(800,50)) 
var customerWalkOutLocation = (Vector2(-700,50))

var sizeOfCustomers = 3
var t = 0.0 # interpolation t walk value for the x direction
#var y = 0.0 # interpolation t up and down walk value for the y direction

signal orderToBell
var walkOut

# Called when the node enters the scene tree for the first time.
func _ready(): 
	# create a customer array with all of the orders for the day
	custArray = PlayerData.save.currentLocation.get_customer_requests(sizeOfCustomers)
	
	# set up the array of customer names
	var namesFile = FileAccess.open(NAMES_DATA_PATH, FileAccess.READ)
	if namesFile: 
		while not namesFile.eof_reached():
			var nextLine = namesFile.get_line()
			if(nextLine != ""): customerNames.append(nextLine)
		namesFile.close()
		
	# set up the array of customer sprites
	var spritesDir = DirAccess.open(SPRITES_DIR_PATH)
	if spritesDir:
		for fileName:String in spritesDir.get_files():
			if fileName.get_extension() == "import": continue
			customerSprites.append(ResourceLoader.load(SPRITES_DIR_PATH+"/"+fileName, "Texture2D"))
	
	spawn_customer()
	
	
func spawn_customer():
	# instatiate a customer scene
	walkOut = false
	currentCustomer = customerScene.instantiate()
	currentCustomer.set_sprite(customerSprites[randi() % customerSprites.size()]) # set customer's sprite randomly
	currentCustomer.position = customerStartLocation
	add_child(currentCustomer) # add new customer to the main scene so you can see it
	
	# set up the customer's data
	custArray[0].customerName = customerNames[randi() % customerNames.size()] # set customer's name randomly
	currentCustomer._setup(custArray[0])
	
	# display what the customer wants
	var currentTxtBox = txtBox.instantiate() # ready current textbox
	var formatString = "%s wants a %s"
	var actualString = formatString % [str(currentCustomer.data.customerName), str(currentCustomer.data.order.name)]
	currentTxtBox.order = actualString
	add_child(currentTxtBox) # show 
	
	# send data to Bell 
	order = currentCustomer.data.order.name
	orderToBell.emit(order)
	
	dupWalkSpeed = currentCustomer.data.walkSpeed/2
	
	
func _physics_process(delta): # testing a small movement without animating it, copium
	# x
	if(t < 1.7 && !walkOut):
		t += (delta * (currentCustomer.data.walkSpeed) )
		#print(t) 
		currentCustomer.position = customerStartLocation.lerp(customerEndLocation, t) 
	
	# y slow down walk at the end, and move in y direction
	elif !walkOut:
		customerEndLocation.y += 1
		if(currentCustomer.data.walkSpeed > 1 ):
			currentCustomer.data.walkSpeed -= .1
		
		t += (delta * (currentCustomer.data.walkSpeed) )
		#print(t) 
		currentCustomer.position = customerStartLocation.lerp(customerEndLocation, t) 
		
	if (t >= 2 || t < 0 && !walkOut):
		set_physics_process(false)
		currentCustomer.data.walkSpeed = currentCustomer.data.walkSpeed / 60
		t = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):# this didnt work in _physics_process? so here for now
	# x
	if(walkOut): 
		if(t < 1.7):
			t += (delta * (currentCustomer.data.walkSpeed+.05) )
			#print(t) 
			currentCustomer.position = currentCustomer.position.lerp(customerWalkOutLocation, t) 
			
	if(currentCustomer.position.x <= customerWalkOutLocation.x && walkOut):
		walkOut = false
		t = 0
		print("stop")
		nextCust()

func _on_ring_bell_correct_go_to_cust_spawner(): # code gets here when there is a correct order
	print(currentCustomer.data.customerName, " recieved a ",  order)
	walkOut = true
	
#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout

func nextCust():
	currentCustomer.queue_free()
	spawn_customer()
