extends Node

## Tutorial Steps:
## 1. Put nightshade petal from the ground into the cauldron
## 2. Put sunflower seed from the inventory into the cauldron
## 3. Create potion by clicking cauldron
## 4. Put potion on pedestal
## 5. Swing bell to sell to customer

@onready var nightshade_text = $NightshadeLabel
@onready var inventory_text = $InventoryLabel
@onready var sunflower_text = $SunflowerLabel
@onready var cauldron_text = $CauldronLabel
@onready var potion_text = $PotionLabel
@onready var finish_text = $FinishLabel

var skipButton
var active_step = 0

func _ready():
	## Connect signals
	var main_node:Node2D = get_parent()
	main_node.get_node("Cauldron/ValidArea").connect("body_entered", _on_ingredient_added)
	main_node.get_node("Cauldron").connect("potion_made", _on_potion_made)
	main_node.get_node("InventoryDrawer").connect("inventory_open", _on_inventory_open)
	main_node.get_node("BellButton").connect("pressed", _on_bell_rung)
	skipButton = main_node.get_node("EndDayAndSkip")
	## Set visibility
	skipButton.visible = false
	nightshade_text.visible = true
	inventory_text.visible = false
	sunflower_text.visible = false
	cauldron_text.visible = false
	potion_text.visible = false
	finish_text.visible = false
	
	
	## Set customer order
	var tutorial_order = preload("res://screens/tutorial/tutorial_order.tres")
	main_node.get_node("CustomerFactory/Customer").data.order = tutorial_order
	main_node.get_node("CustomerFactory/Customer/DialogueLabel").text = tutorial_order.dialogueOptions[0]


func _on_ingredient_added(ingredient):
	if not "data" in ingredient: return
	if not ingredient.data is Ingredient: return
	if active_step == 0 and ingredient.data.id == "nightshade_petals":
		nightshade_text.queue_free()
		inventory_text.visible = true
		active_step += 1
	elif active_step == 2 and ingredient.data.id == "sunflower_seeds":
		sunflower_text.queue_free()
		cauldron_text.visible = true
		active_step += 1


func _on_inventory_open(open:bool):
	if active_step == 1 and open:
		inventory_text.queue_free()
		sunflower_text.visible = true
		active_step += 1


func _on_potion_made(_potion, _position):
	if active_step == 3:
		cauldron_text.queue_free()
		potion_text.visible = true
		active_step += 1


func _on_bell_rung():
	if active_step == 4:
		potion_text.queue_free()
		finish_text.visible = true
		active_step = 5;
	
	## Wait 8 seconds then switch out of tutorial scene
	## This isn't under the if statement because selling a potion means they've understood enough
	await get_tree().create_timer(4).timeout
	PlayerData.tutorial_complete = true
	PlayerData.save_game_files()
	finish_text.queue_free()
	skipButton.visible = true
	self.queue_free()
