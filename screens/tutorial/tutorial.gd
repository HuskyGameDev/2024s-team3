extends Node

## Tutorial Steps:
## 1. Put nightshade petal from the ground into the cauldron
## 2. Put thistle root from the inventory into the cauldron
## 3. Create potion by clicking cauldron
## 4. Put potion on pedestal
## 5. Swing bell to sell to customer

@onready var nightshade_text = $NightshadeLabel
@onready var inventory_text = $InventoryLabel
@onready var thistleroot_text = $ThistleLabel
@onready var cauldron_text = $CauldronLabel
@onready var potion_text = $PotionLabel
@onready var finish_text = $FinishLabel

var active_step = 0

func _ready():
	## Setup player inventory
	var thistleroot_slot = InventorySlot.new()
	thistleroot_slot.item = load(ResourcePaths.get_ingredient_path("thistle_root"))
	thistleroot_slot.quantity = 1
	PlayerData.inventory[0] = thistleroot_slot
	
	## Connect signals
	var main_node:Node2D = get_parent()
	main_node.get_node("Cauldron/ValidArea").connect("body_entered", _on_ingredient_added)
	main_node.get_node("Cauldron").connect("potion_made", _on_potion_made)
	main_node.get_node("InventoryDrawer").connect("inventory_open", _on_inventory_open)
	#main_node.get_node("Bell").connect("pressed", _on_potion_sold)
	
	## Set visibility
	nightshade_text.visible = true
	inventory_text.visible = false
	thistleroot_text.visible = false
	cauldron_text.visible = false
	potion_text.visible = false
	finish_text.visible = false


func _on_ingredient_added(ingredient):
	if not "data" in ingredient: return
	if not ingredient.data is Ingredient: return
	if active_step == 0 and ingredient.data.id == "nightshade_petals":
		nightshade_text.visible = false
		inventory_text.visible = true
		active_step += 1
	elif active_step == 2 and ingredient.data.id == "thistle_root":
		thistleroot_text.visible = false
		cauldron_text.visible = true
		active_step += 1


func _on_inventory_open(open:bool):
	if active_step == 1 and open:
		inventory_text.visible = false
		thistleroot_text.visible = true
		active_step += 1


func _on_potion_made(potion, position):
	if active_step == 3:
		cauldron_text.visible = false
		potion_text.visible = true
		active_step += 1


func _on_potion_sold():
	if active_step == 4:
		potion_text.visible = false
		finish_text.visible = true
		
	## Wait 8 seconds then switch out of tutorial scene
	## This isn't under the if statement because selling a potion means they've understood enough
	await get_tree().create_timer(8).timeout
	get_tree().change_scene_to_file("res://screens/main/main.tscn")
