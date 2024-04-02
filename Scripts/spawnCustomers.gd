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
var order

var outWalkSpeed # start walking out from a standstill but not with constant acceleration, change speed when walking out 
const customerStartLocation = (Vector2(1200,200))
var customerEndLocation = (Vector2(400,60)) 
var customerWalkOutLocation = (Vector2(-650, 150))

var sizeOfCustomers = 3
var t = 0.0 # interpolation t walk value for the x direction
var o = 0.0

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
	#print("start location is: ", customerStartLocation, " end is: ", customerEndLocation, " Walk out is: ", customerWalkOutLocation)
	
	walkOut = false
	currentCustomer = customerScene.instantiate()
	currentCustomer.set_sprite(customerSprites[randi() % customerSprites.size()]) # set customer's sprite randomly
	currentCustomer.position = customerStartLocation
	add_child(currentCustomer) # add new customer to the main scene so you can see it
	
	print("valid cust? ",is_instance_valid(currentCustomer))
	
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
	
	outWalkSpeed = currentCustomer.data.walkSpeed / 80
	print("outwalkspeed is: ", outWalkSpeed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	# x
	if(!walkOut): # walk in
		if(t < 1):
			t += (delta * (currentCustomer.data.walkSpeed))
			#print(t) 
			currentCustomer.position = customerStartLocation.lerp(customerEndLocation, t) 
		
		#=================================================# w / o
	# x
	if(walkOut): 
		#print("o at walkouit is: ", o)
		if(o < 1 ): 
			o += (delta * (outWalkSpeed) ) 
			if(outWalkSpeed < 2): # slower, interpole was too fast
				outWalkSpeed += .005
			#print(t) 
			currentCustomer.position = customerEndLocation.lerp(customerWalkOutLocation, o) # careful child and parent coordinate issues
			
		if(o >= 1):
			nextCust()


func _on_ring_bell_correct_go_to_cust_spawner(): # code gets here when there is a correct order
	print(currentCustomer.data.customerName, " recieved a ",  order)
	walkOut = true
	o = 0 # need a reset
	
#func wait(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout

func nextCust():
	currentCustomer.queue_free()
	t = 0
	o = 0
	spawn_customer()
	
