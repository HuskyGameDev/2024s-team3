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
@onready var welcomePanel = $welcome
@onready var panelAnim = $welcome/panelMove


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
	#main_node.get_node("Cauldron").connect("cauldron_pressed", _on_cauldron_pressed)

	main_node.get_node("BellButton").connect("pressed", _on_bell_rung)
	skipButton = main_node.get_node("EndDayAndSkip")
	GameTime.emit_signal("tutorial_time")
	
	## Set visibility
	if(welcome != null):
		welcome.visible = true
	skipButton.visible = false
	nightshade_text.visible = false
	inventory_text.visible = false
	sunflower_text.visible = false
	cauldron_text.visible = false
	potion_text.visible = false
	finish_text.visible = false
	
	if(arrow != null):
		arrow.hide()
	
	if(welcomePanel != null):
		panelAnim.play("welcome_panel")
		if(TutorialPressed.pressed > 1):
			panelAnim.play("welcome_panel_2")
	PlayerData.change_reputation(6) # starting reputation to balance ending the day early
	
	
	

func _on_welcome_button_pressed() -> void:
	TutorialPressed.pressed += 1
	if TutorialPressed.pressed == 1:
		welcome_text.text = "Your goal is to sell potions as fast as possible to get reputation and money."
	if TutorialPressed.pressed == 2:
		welcome_text.text = "Gaining reputation will allow you to sell potions in new areas."
	if TutorialPressed.pressed == 3:
		welcome_text.text = "You will be able to spend your money to buy more ingredients at the end of each day."
	if TutorialPressed.pressed == 4:
		welcome_text.text = "Now, lets get you familiar with the potion shack!"
	if TutorialPressed.pressed == 5:
		arrow.show()
		arrowAnim.play("arrowmove")
		welcome_text.text = "This is the clock."
	if TutorialPressed.pressed == 6:
		welcome_text.text = "It will show you how much time is left to sell potions."
	if TutorialPressed.pressed == 7:
		arrowAnim.play("arrowmove_2")
		welcome_text.text = "This is the ingredient book."
	if TutorialPressed.pressed == 8:
		welcome_text.text = "You can click on it to learn about each ingredient."
	if TutorialPressed.pressed == 9:
		arrowAnim.play("arrowmove_3")
		welcome_text.text = "This shows you your current money and reputation."
	if TutorialPressed.pressed == 10:
		welcome_text.text = "Now, lets help this customer!"
	if TutorialPressed.pressed == 11:
		welcome_continue_button.hide()
		arrowAnim.play("arrowmove_4")
		welcome_text.text = "Click here to open up your inventory."
		active_step += 1
	if TutorialPressed.pressed == 12:
		welcome_text.text = "Hover over the ingredients to find out their name and effect."
	if TutorialPressed.pressed == 13:
		arrow.show()
		arrowAnim.play("arrowmove_9")
		welcome_text.text = "Clicking this button will bring you to the shop where you can buy ingredients."
	if TutorialPressed.pressed == 14:
		welcome_text.text = "to buy ingredients you just click and drag them into the basket."
	if TutorialPressed.pressed == 15:
		arrowAnim.play("arrowmove_10")
		welcome_text.text = "This is the forage button."
	if TutorialPressed.pressed == 16:
		welcome_text.text = "You should make sure to press it every night because foraging will get you free ingredients!"
	if TutorialPressed.pressed == 17:
		arrowAnim.play("arrowmove_11")
		welcome_text.text = "This is the move button."
	if TutorialPressed.pressed == 18:
		welcome_text.text = "It will bring you to the overworld where you can move using the arrow keys."
	if TutorialPressed.pressed == 19:
		welcome_text.text = "In the overworld you may also find new locations which you can enter by clicking on them."
	if TutorialPressed.pressed == 20:
		welcome_text.text = "Just make sure you have enough reputation!"
	if TutorialPressed.pressed == 21:
		arrowAnim.play("arrowmove_12")
		welcome_text.text = "Lastly, this is the curtain."
	if TutorialPressed.pressed == 22:
		welcome_text.text = "It displays your net money and reputation gain/loss for the day."
	if TutorialPressed.pressed == 23:
		welcome_text.text = "Whenever you want to start the next day, just CLICK and DRAG the curtain to the right."
	if TutorialPressed.pressed == 24:
		arrow.hide()
		welcome_continue_button.hide()
		welcome_text.text = "This concludes the tutorial, good luck!"
		await get_tree().create_timer(2).timeout
		welcomePanel.queue_free()
		arrow.queue_free()
		PlayerData.tutorial_complete = true
		PlayerData.save_game_files()
		
		
	
		
	
func _on_inventory_open(open:bool):
	print(active_step)
	if(active_step == 1):
		welcome_text.text = "Find 'nightshade petals' by hovering over the ingredients and drag them to the cauldron"
		
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
				welcome_text.text = "Right click the cauldron to see the effects, slight effects will have no bearing on the order, and customers generally want weak effect potions unless they specify otherwise, mixing ingredients with opposite effects will cancel/lessen their effects."
	
func _on_potion_made(_potion, _position):
	print(active_step)
	if(active_step == 4):
		active_step += 1
		arrowAnim.play("arrowmove_5")
		welcome_text.text = "Drag the potion here:"
	
func _on_pedestal_item_changed(held_nodes: Array, new_item):
	if(active_step == 5):
		active_step += 1
		arrowAnim.play("arrowmove_6")
		welcome_text.text = "Now just click the bell to sell the potion!"
	
func _on_bell_rung():
	if(active_step == 6):
		active_step += 1
		welcome_text.text = "Click the 'end day' button."
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
		welcome_continue_button.show()
		welcomePanel.z_index = 100
		welcome_text.text = "welcome to the nightime!"
		TutorialPressed.pressed += 1
		

		
