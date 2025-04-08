class_name Main_Screen extends Screen

var packed_potion_scene = preload("res://common/items/potions/potion.tscn")
var packed_ingredient_scene = preload("res://common/items/ingredients/ingredient.tscn")

@onready var CustomerFactory:Node = $CustomerFactory
@onready var PedestalSlot:Node = $Pedestal/ShelfSlot

@onready var dayStartSound:AudioStream = preload("res://common/audio/Day_Start_Chime.wav")
@onready var dayEndSound:AudioStream = preload("res://common/audio/Day_End_Chime.wav")
@onready var shopBellSound:AudioStream = preload("res://common/audio/shop-bell.wav")



func _ready():
	if GameTime.hour < GameTime.STORE_CLOSE_TIME: # true if it is daytime
		GameTime.start_day() #start game timer
		GameTime.end_of_day.connect(CustomerFactory._leave_end_day) #signal customer to move off the screen
		#Scene change occurs in customer node
		if GameTime.day > 1:
			$EndDayAndSkip.visible = true # make skip button visible
		#Set up a tween for the music
		$AmbientPlayer.play()
		var tween:Tween = get_tree().create_tween()
		tween.tween_property($AmbientPlayer, "volume_db", -13, 2)
		
		$Misc_SFX_Player.set_stream(dayStartSound)
		$Misc_SFX_Player.volume_db = -7
		$Misc_SFX_Player.play()
	else:
		GameTime.emit_signal("pause")
		$EndDayAndSkip.visible = false # during the night hide skip button
		$AmbientPlayer.volume_db = -40
		$AmbientPlayer.stop()
		
		
	
	$LocationBackgroundSwitcher.update_background()
	
	PedestalSlot.connect("items_changed", _on_selling_potion_change)
	
	# disable stations the player doesn't have yet
	$MortarAndPestle.visible      = PlayerData.unlocked_stations.has("mortar_and_pestle")
	$MortarAndPestle.process_mode = Node.PROCESS_MODE_INHERIT if PlayerData.unlocked_stations.has("mortar_and_pestle") else Node.PROCESS_MODE_DISABLED
	$CuttingBoard.visible      = PlayerData.unlocked_stations.has("cutting_board")
	$CuttingBoard.process_mode = Node.PROCESS_MODE_INHERIT if PlayerData.unlocked_stations.has("cutting_board") else Node.PROCESS_MODE_DISABLED


func _on_shelf_body_entered(body):
	body.rotation = 0


###################### POTION SELLING ######################
var sellingPotion: Potion ## the potion on the pedestal ready to be sold
var sellingPotionNode: DraggableObject

func _on_selling_potion_change(potionNode: Array[DraggableObject], newPotion: Potion):
	sellingPotion = newPotion
	if newPotion:
		sellingPotionNode = potionNode[0]

func _on_ring_bell():
	if sellingPotion:
		var took_potion = CustomerFactory.handle_purchase(sellingPotion)
		if took_potion: 
			PedestalSlot.heldNodes.clear()
			sellingPotion = null
			sellingPotionNode.queue_free()
			CustomerFactory.create_customer()
			$Misc_SFX_Player.set_stream(dayStartSound)
			$Misc_SFX_Player.volume_db = -7
			$Misc_SFX_Player.play()

##################### STATION HANDLERS #####################
func _on_item_made(item: Item, pos: Vector2, throw: bool = true):
	var newScene: Node2D
	if item is Potion:
		newScene = packed_potion_scene.instantiate().with_data(item)
	elif item is Ingredient:
		newScene = packed_ingredient_scene.instantiate().with_data(item)
	else: return
	
	newScene.global_position = pos
	self.add_child.call_deferred(newScene)
	self.move_child.call_deferred(newScene , get_node("InventoryDrawer").get_index() - 1 ) # move object to one less than drawer
	newScene.set_owner.call_deferred(self)
	if throw:
		## "throws" item
		## angle options: +/- 250, 350, 450, and 550
		var throwAngle = (randi_range(2, 5) * 100 + 50)
		if(bool(randi_range(0, 1))):
			throwAngle *= -1
		newScene.apply_central_impulse(Vector2(throwAngle, -2000))


func _on_inv_dragged(inv_slot): #moving object out of inventory
	var inv_data = PlayerData.read_inv()
	var itemID = inv_data[inv_slot]["Item"]
	var quantity = int(inv_data[inv_slot]["Quantity"])
	if itemID != null:
		var newItem = packed_ingredient_scene.instantiate()
		newItem.data = ResourceLoader.load("res://common/items/ingredients/" + str(itemID) + "/" + str(itemID) + ".tres")
		newItem.global_position = get_viewport().get_mouse_position()
		add_child(newItem)
		newItem.owner = self #sets main as objects owner
		move_child.call_deferred(newItem , get_node("InventoryDrawer").get_index() - 1 ) # move object to one less than drawer
		if quantity == 1:
			inv_data[inv_slot]["Item"] = null
			inv_data[inv_slot]["Quantity"] = 0 
		else:
			inv_data[inv_slot]["Quantity"] = quantity - 1
		PlayerData.write_inv(inv_data)
