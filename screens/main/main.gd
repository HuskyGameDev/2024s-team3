extends Node2D

var packed_potion_scene = preload("res://common/items/potions/potion.tscn")
var packed_ingredient_scene = preload("res://common/items/ingredients/ingredient.tscn")

func _ready():
	GameTime.start_day()
	GameTime.end_of_day.connect(func(): get_tree().change_scene_to_file("res://screens/night_menu/menu/night_menu.tscn"));
	
	$Pedestal/ShelfSlot.connect("items_changed", _on_selling_potion_change)
	#$Bell/BellButton.connect("pressed", _on_ring_bell)


func _on_shelf_body_entered(body):
	body.rotation = 0


###################### POTION SELLING ######################
var sellingPotion: Potion ## the potion on the pedestal ready to be sold
var sellingPotionNode: DraggableObject

func _on_selling_potion_change(potionNode: Array[DraggableObject], newPotion: Potion):
	sellingPotion = newPotion
	sellingPotionNode = potionNode[0]

func _on_ring_bell():
	if sellingPotion:
		var took_potion = $CustomerFactory.handle_purchase(sellingPotion)
		if took_potion: 
			sellingPotion = null
			sellingPotionNode.queue_free()

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
	
	if throw:
		## "throws" item
		## angle options: +/- 250, 350, 450, and 550
		var throwAngle = (randi_range(2, 5) * 100 + 50)
		if(bool(randi_range(0, 1))):
			throwAngle *= -1
		newScene.apply_central_impulse(Vector2(throwAngle, -2000))
	