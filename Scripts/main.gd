extends Node2D

var PotionScene = preload("res://Scenes/Potion.tscn")
var IngredientScene = preload("res://Scenes/Ingredient.tscn")

const NAMES_DATA_PATH = "res://Assets/Data/CustomerNames.txt"
const customerScene = preload("res://Scenes/Customer.tscn")

var txtBox = preload("res://Scenes/UI/textBox.tscn") # general textbox

var custArray:Array[Customer] = []
var customerNames:Array[String] = []
var currentCustomer

var outWalkSpeed # start walking out from a standstill but not with constant acceleration, change speed when walking out 
const customerStartLocation = (Vector2(1800,500))
var customerEndLocation = (Vector2(1200,500)) 
var customerWalkOutLocation = (Vector2(-650, 500))

var sizeOfCustomers = 3
var t = 0.0 # interpolation t walk value for the x direction
var o = 0.0

signal potionData
signal CorrectGoToCustSpawner
var custOrder:String
var orderPrice:int
var orderRep:int
var potionOnPedestal:String
var tutorial


var walkOut

func _ready():
	GameTime.start_day()
	GameTime.end_of_day.connect(func(): get_tree().change_scene_to_file("res://Scenes/Screens/NightMenu.tscn"));
	var drawer = get_node("Drawer-inventory")
	var pedestal = get_node("Pedestal")
	var cauldron = $"Cauldron"
	var bell = $"ringBell"
	bell.CorrectGoToCustSpawner.connect(next_step)
	cauldron.ingredient_added.connect(next_step)
	drawer.make_inv_object.connect(_on_inv_dragged) #moving object out of inventory
	pedestal.make_ped_object.connect(_on_ped_pressed) #moving object out of pedestal
	pedestal.sendToBell.connect(_on_pedestal_send_to_bell)
	
	# create a customer array with all of the orders for the day
	custArray = PlayerData.save.currentLocation.get_customer_requests(sizeOfCustomers)
	
	if GameTime.day == 1:
		tutorial = get_node("Tutorial")
		tutorial.visible = true
	
	# set up the array of customer names
	var namesFile = FileAccess.open(NAMES_DATA_PATH, FileAccess.READ)
	if namesFile: 
		while not namesFile.eof_reached():
			var nextLine = namesFile.get_line()
			if(nextLine != ""): customerNames.append(nextLine)
		namesFile.close()
	spawn_customer()

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

func next_step(id): #tutorial progression
	var nightShadeText = get_node("Tutorial/NightShadeText")
	var thistleRootText = get_node("Tutorial/ThistlerootText")
	var cauldromText = get_node("Tutorial/CauldronText")
	var potionText = get_node("Tutorial/PotionText")
	var finishText = get_node("Tutorial/FinishText")
	if id == "nightshade_petals" && nightShadeText.visible == true:
		nightShadeText.visible = false
		thistleRootText.visible = true
	elif id == "thistle_root" && thistleRootText.visible == true:
		thistleRootText.visible = false
		cauldromText.visible = true
	elif id == "healing_potion" && (potionText.visible == false):
		nightShadeText.visible = false
		thistleRootText.visible = false
		cauldromText.visible = false
		potionText.visible = true
	elif id == "healing_potion" && potionText.visible == true:
		potionText.visible = false
		finishText.visible = true
		await get_tree().create_timer(8).timeout 
		tutorial.visible = false

func _on_cauldron_potion_made(potion:Potion):
	next_step(potion.id)
	var newPotionObj = PotionScene.instantiate()
	newPotionObj.setType(potion)
	newPotionObj.global_position = $"Cauldron".global_position - Vector2(0, 100)
	add_child(newPotionObj)
	## "throws" potion
	## angle options: +/- 250, 350, 450, and 550
	var throwAngle = (randi_range(2, 5) * 100 + 50)
	if(bool(randi_range(0, 1))):
		throwAngle *= -1
	newPotionObj.rigidbody.apply_central_impulse(Vector2(throwAngle, -2000))

func _on_crucible_salt_made(salt:String):
	var newSalt = IngredientScene.instantiate()
	newSalt.data = ResourceLoader.load("res://Assets/Resources/Ingredients/" + salt + ".tres")
	newSalt.global_position = $"Crucible".global_position - Vector2(0,20)
	add_child(newSalt)

func _on_inv_dragged(inv_slot):
	print(inv_slot)
	var inv_data = PlayerData.read_inv()
	var itemID = inv_data[inv_slot]["Item"]
	var quantity = inv_data[inv_slot]["Quantity"]
	if itemID != null:
		var newItem = IngredientScene.instantiate()
		newItem.data = ResourceLoader.load("res://Assets/Resources/Ingredients/" + str(itemID) + ".tres")
		newItem.global_position = get_viewport().get_mouse_position()
		add_child(newItem)
		if quantity == 1:
			inv_data[inv_slot]["Item"] = null
			inv_data[inv_slot]["Quantity"] = 0 
		else:
			inv_data[inv_slot]["Quantity"] = quantity - 1
		print(inv_data[inv_slot]["Item"])
		PlayerData.write_inv(inv_data)

func _on_ped_pressed(item: Resource):
	var newItem = PotionScene.instantiate()
	newItem.setType(item)
	newItem.global_position = get_viewport().get_mouse_position()
	add_child(newItem)

func _on_shelf_body_entered(body):
	body.rotation = 0
	
func spawn_customer():
	# instatiate a customer scene
	#print("start location is: ", customerStartLocation, " end is: ", customerEndLocation, " Walk out is: ", customerWalkOutLocation)
	
	walkOut = false
	currentCustomer = customerScene.instantiate()
	currentCustomer.position = customerStartLocation
	add_child(currentCustomer) # add new customer to the main scene so you can see it
	move_child(currentCustomer, 0)
	
	print("valid cust? ",is_instance_valid(currentCustomer))
	
	# set up the customer's data
	#custArray[0].customerName = customerNames[randi() % customerNames.size()] # set customer's name randomly
	currentCustomer._setup(custArray[0])
	
	# display what the customer wants
	var currentTxtBox = txtBox.instantiate() # ready current textbox
	var formatString = "%s wants a %s"
	var actualString = formatString % [str(currentCustomer.data.customerName), str(currentCustomer.data.order.name)]
	currentTxtBox.order = actualString
	add_child(currentTxtBox) # show 
	
	# send data to Bell 
	_on_customer_spawner_order_to_bell(currentCustomer.data)
	
	outWalkSpeed = currentCustomer.data.walkSpeed / 80
	print("outwalkspeed is: ", outWalkSpeed)

func _on_ring_bell_correct_go_to_cust_spawner(id): # code gets here when there is a correct order
	next_step(id)
	print(currentCustomer.data.customerName, " recieved a ",  currentCustomer.data.order.name)
	walkOut = true
	o = 0 # need a reset

func nextCust():
	currentCustomer.queue_free()
	t = 0
	o = 0
	spawn_customer()

func _on_pedestal_send_to_bell(item):
	potionOnPedestal = item.id

func _on_customer_spawner_order_to_bell(data):
	custOrder = data.order.id
	orderPrice = data.orderPrice
	orderRep = data.reputationChange

func _on_ring_bell_pressed():
	if !potionOnPedestal: return
	if custOrder == potionOnPedestal:
		print("correct order!")
		_on_ring_bell_correct_go_to_cust_spawner(potionOnPedestal)
		CorrectGoToCustSpawner.emit() # send another one, get ride of this guy 
		potionOnPedestal = ""
		PlayerData.changeMoney(orderPrice)
		PlayerData.changeReputation(orderRep)
	else:
		PlayerData.changeReputation(orderRep * -1)
