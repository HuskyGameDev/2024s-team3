extends Node

@onready var totalCostLabel   := $UiLayer/TotalCostPanelContainer/TotalCostMarginContainer/TotalCostLabel
@onready var LocationDisplays := $LocationShelf.get_children()
@onready var ExoticDisplays   := $ExoticShelf.get_children()

var totalCost = 0
var cart:Array[Ingredient] = []

var ingredient_price_modifier : Callable :
	set(function):
		ingredient_price_modifier = function
		update_display_prices()
var drop_count: int = 0

############################ SETUP ###########################
func _ready():
	ingredient_price_modifier = func(p): return p
	
	$UiLayer/PlayerMoneyPanelContainer/PlayerMoneyMarginContainer/PlayerMoneyLabel.text = "$" + str(PlayerData.money)
	
	## Add ingredient displays for current location
	var current_location_ingredients = Array(PlayerData.location.ingredients)
	set_ingredient_displays(current_location_ingredients, LocationDisplays)
	
	## Add ingredient displays for other locations
	var visited_locations = PlayerData.visited_locations.filter(func(l): return l != PlayerData.location)
	if visited_locations.size() > 0:
		var other_location_ingredients:Array[Ingredient] = []
		visited_locations.map(func(l): other_location_ingredients.append_array(l.ingredients))
		set_ingredient_displays(other_location_ingredients, ExoticDisplays)
	else: $ExoticShelf.visible = false
	
	## Add station option for current location
	#TODO add stations to the store
	
	## Add map options for the current location
	#TODO add maps to the store


func calculate_ingredient_price(ingredient:Ingredient):
	var price = 0
	for effect in ingredient.effects.get_strongest():
		price += abs(ingredient.effects.get_strength(effect)) * effect.money_factor
	price /= 7 ## This number can be changed, anywhere between 5 and 10 is probably reasonable
	price = ingredient_price_modifier.call(price)
	return round(price)


func set_ingredient_displays(ingredients:Array[Ingredient], display_nodes:Array[Node]):
	ingredients.shuffle()
	for i in range(0, display_nodes.size()):
		var ingredient = ingredients[i]
		var display = display_nodes[i]
		display.quantity = randi_range(1, 5)
		display.price = calculate_ingredient_price(ingredient)
		display.ingredient = ingredient
		display.spawn_held_nodes(self)


####################### CART MECHANICS #######################
func _on_body_entered_basket(body):
	if not body is DraggableObject: return
	var ingredient = body.data as Ingredient
	cart.append(ingredient)
	updateTotal(calculate_ingredient_price(ingredient))


func _on_body_exited_basket(body):
	if not body is DraggableObject: return
	var ingredient = body.data as Ingredient
	cart.erase(ingredient)
	updateTotal(-calculate_ingredient_price(ingredient))


func updateTotal(changeAmount:int):
	totalCost += changeAmount
	totalCostLabel.text = "Total Cost: $" + str(totalCost)


####################### DROP MECHANICS #######################
func _on_ingredient_dropped():
	drop_count += 1
	#TODO make shopkeeper actually say dialogue
	match drop_count:
		1: print("Try not to drop things")
		3: print("Seriously, be careful")
		5: print("That's breakable!")
		10: print("This is your LAST warning!")
	if   drop_count > 20: ingredient_price_modifier = func(p): return (drop_count - 20) * 2 * (p + 15)
	elif drop_count > 15: ingredient_price_modifier = func(p): return p + 5 + 2 * (drop_count - 15)
	elif drop_count > 10: ingredient_price_modifier = func(p): return p + (drop_count - 10)


func update_display_prices():
	for display in LocationDisplays:
		if not display.ingredient: continue
		display.price = calculate_ingredient_price(display.ingredient)
	for display in ExoticDisplays:
		if not display.ingredient: continue
		display.price = calculate_ingredient_price(display.ingredient)

########################## CHECKOUT ##########################
func _on_buy_button_pressed():
	#TODO make buy work
	if PlayerData.money >= totalCost:
		PlayerData.money -= totalCost
		#TODO make shopkeeper say something before leaving
		get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
	else:
		#TODO make shopkeeper say this
		print("Not enough money")


func _on_exit_button_pressed():
	#TODO make shopkeeper say something before leaving
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
