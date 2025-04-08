extends Node

## Tutorial Steps:
## 1. Put nightshade petal from the ground into the cauldron
## 2. Put sunflower seed from the inventory into the cauldron
## 3. Create potion by clicking cauldron
## 4. Put potion on pedestal
## 5. Swing bell to sell to customer

@onready var welcome_text = $welcome/WelcomeText
@onready var nightshade_text = $NightshadeLabel
@onready var inventory_text = $InventoryLabel
@onready var sunflower_text = $SunflowerLabel
@onready var cauldron_text = $CauldronLabel
@onready var potion_text = $PotionLabel
@onready var finish_text = $FinishLabel
@onready var welcome_continue_button = $welcome/welcomeButton
@onready var welcome = $welcome
@onready var arrow = $arrow
@onready var arrowAnim = $arrow/AnimationPlayer
@onready var endDay = $EndDayAndSkip

var pressed = 0
var skipButton
var active_step = 0

func _ready():
	## Connect signals
	var main_node:Node2D = get_parent()
	main_node.get_node("Cauldron/ValidArea").connect("body_entered", _on_ingredient_added)
	main_node.get_node("Cauldron").connect("potion_made", _on_potion_made)
	main_node.get_node("InventoryDrawer").connect("inventory_open", _on_inventory_open)
	main_node.get_node("Pedestal/ShelfSlot").connect("items_changed", Callable(self, "_on_pedestal_item_changed"))
	main_node.get_node("EndDayAndSkip").connect("end_day_pressed", _on_end_day_pressed)
	main_node.get_node("EndDayAndSkip").connect("confirm_pressed", _on_confirm_pressed)


	main_node.get_node("BellButton").connect("pressed", _on_bell_rung)
	skipButton = main_node.get_node("EndDayAndSkip")
	GameTime.emit_signal("pause")
	## Set visibility
	welcome.visible = true
	skipButton.visible = false
	nightshade_text.visible = false
	inventory_text.visible = false
	sunflower_text.visible = false
	cauldron_text.visible = false
	potion_text.visible = false
	finish_text.visible = false
	arrow.hide()
	
	
	## Set customer order
	var customer = main_node.get_node_or_null("CustomerFactory/Customer")
	if customer and "data" in customer:
		var tutorial_order = preload("res://screens/tutorial/tutorial_order.tres")
		main_node.get_node("CustomerFactory/Customer").data.order = tutorial_order
		main_node.get_node("CustomerFactory/Customer/DialogueLabel").text = tutorial_order.dialogueOptions[0]

func _on_welcome_button_pressed() -> void:
	pressed += 1
	if pressed == 1:
		welcome_text.text = "your goal is to sell potions as fast as possible to get reputation and money"
	if pressed == 2:
		welcome_text.text = "gaining reputation will allow you to sell potions in new areas"
	if pressed == 3:
		welcome_text.text = "you will be able to spend your money to buy more ingredients at the end of each day"
	if pressed == 4:
		welcome_text.text = "Now, lets get you familiar with the potion shack"
	if pressed == 5:
		arrow.show()
		arrowAnim.play("arrowmove")
		welcome_text.text = "this is the clock it will show you how much time is left to sell potions, for the tutorial it is paused"
	if pressed == 6:
		arrowAnim.play("arrowmove_2")
		welcome_text.text = "this is the ingredient book you can click on it to learn about each ingredient"
	if pressed == 7:
		arrowAnim.play("arrowmove_3")
		welcome_text.text = "this shows you your current money and reputation"
	if pressed == 8:
		welcome_text.text = "now, lets help this customer"
	if pressed == 9:
		welcome_continue_button.hide()
		arrowAnim.play("arrowmove_4")
		welcome_text.text = "click here to open up your inventory"
		active_step += 1
	if pressed == 10:
		welcome_text.text = "hover over the ingredients to find out their name and effect"
		
		
		
		
		
	
	

	#if not "data" in ingredient: return
	#if not ingredient.data is Ingredient: return
	#if active_step == 0 and ingredient.data.id == "nightshade_petals":
		#nightshade_text.queue_free()
		#inventory_text.visible = true
		#active_step += 1
	#elif active_step == 2 and ingredient.data.id == "sunflower_seeds":
		#sunflower_text.queue_free()
		#cauldron_text.visible = true
		#active_step += 1
		

func _on_inventory_open(open:bool):
	print(active_step)
	if(active_step == 1):
		welcome_text.text = "find 'nightshade petals' by hovering over the ingredients and drag them to the cauldron"
		active_step += 1
		
func _on_ingredient_added(ingredient):
		if not "data" in ingredient: return
		if not ingredient.data is Ingredient: return
		if(active_step == 2):
			if ingredient.data.id == "nightshade_petals":
				active_step += 1
				welcome_text.text = "Great! now add a sunflower seed to the cauldron as well"
		if(active_step == 3):
			if ingredient.data.id == "sunflower_seeds":
				active_step += 1
				welcome_text.text = "Right click the cauldron to see the effects, slight effects will have no bearing on the order, and customers generally want weak effect potions unless they specify otherwise, mixing ingredients with opposite effects will cancel/lessen their effects"
	
func _on_potion_made(_potion, _position):
	print(active_step)
	if(active_step == 4):
		active_step += 1
		arrowAnim.play("arrowmove_5")
		welcome_text.text = "drag the potion here"
	
func _on_pedestal_item_changed(held_nodes: Array, new_item):
	if(active_step == 5):
		active_step += 1
		arrowAnim.play("arrowmove_6")
		welcome_text.text = "Now just click the bell to sell the potion"
	
func _on_bell_rung():
	if(active_step == 6):
		active_step += 1
		welcome_text.text = "Click the 'end day' button"
		arrowAnim.play("arrowmove_7")
		skipButton.visible = true
		
func _on_end_day_pressed():
	if(active_step == 7):
		active_step += 1
		arrowAnim.play("arrowmove_8")
		welcome_text.text = "now press yes"
	
func _on_confirm_pressed():
	if(active_step == 8):
		active_step += 1
		welcome_text.text = "nice"

#func _on_potion_made(_potion, _position):
	#if active_step == 3:
		#cauldron_text.queue_free()
		#potion_text.visible = true
		#active_step += 1
#
#
#func _on_bell_rung():
	#if active_step == 4:
		#potion_text.queue_free()
		#finish_text.visible = true
		#active_step = 5;
		#GameTime.emit_signal("pause")
	#
	### Wait 8 seconds then switch out of tutorial scene
	### This isn't under the if statement because selling a potion means they've understood enough
	#await get_tree().create_timer(4).timeout
	#PlayerData.tutorial_complete = true
	#PlayerData.save_game_files()
	#finish_text.queue_free()
	#skipButton.visible = true
	#self.queue_free()
