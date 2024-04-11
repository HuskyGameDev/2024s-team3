extends Node2D

var PotionScene = preload("res://Scenes/Potion.tscn")
var IngredientScene = preload("res://Scenes/Ingredient.tscn")

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
	# Called when the node enters the scene tree for the first time.

func next_step(id): #tutorial progression
	if id == "nightshade_petals" && get_node("Tutorial/NightShadeText").visible == true:
		get_node("Tutorial/NightShadeText").visible = false
		get_node("Tutorial/ThistlerootText").visible = true
	elif id == "thistle_root" && get_node("Tutorial/ThistlerootText").visible == true:
		get_node("Tutorial/ThistlerootText").visible = false
		get_node("Tutorial/CauldronText").visible = true
	elif id == "healing_potion" && get_node("Tutorial/CauldronText").visible == true:
		get_node("Tutorial/CauldronText").visible = false
		get_node("Tutorial/PotionText").visible = true
	elif id == "healing_potion" && get_node("Tutorial/CauldronText").visible == true:
		get_node("Tutorial/CauldronText").visible = false
		get_node("Tutorial/PotionText").visible = true
	elif id == "healing_potion" && get_node("Tutorial/PotionText").visible == true:
		get_node("Tutorial/PotionText").visible = false
		get_node("Tutorial/FinishText").visible = true
		await get_tree().create_timer(8).timeout 
		get_node("Tutorial/NightShadeText").visible = false
		get_node("Tutorial/ThistlerootText").visible = false
		get_node("Tutorial/CauldronText").visible = false
		get_node("Tutorial/PotionText").visible = false
		get_node("Tutorial/FinishText").visible = false

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
