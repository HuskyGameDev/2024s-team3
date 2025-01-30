extends Node

# const INV_LOCATION = "user://inv_data_file.json" #inventory we save to when each day is done
const TEMP_SHOP_INV_LOCATION = "user://temp_shop_inv_data_file.json" #inventory we save to during game play
const SHOP_INV_LOCATION = "user://shop_data_file.json" #inventory we use for the shop

@onready var totalCostLabel   := $TotalCostPanelContainer/TotalCostMarginContainer/TotalCostLabel
@onready var LocationDisplays := $LocationShelf.get_children()
@onready var ExoticDisplays   := $ExoticShelf.get_children()
@onready var SpeechBubble     := $SpeechBubble
@onready var DialogueLabel    := $SpeechBubble/DialogueLabel

var totalCost = 0
var cart:Array[DraggableObject] = []

var ingredient_price_modifier : Callable :
	set(function):
		ingredient_price_modifier = function
		update_display_prices()
var drop_count: int = 0
signal shop_done


################# SHOPKEEPER DIALOGUE OPTIONS ################
func get_station_dialogue(station_name:String):
	return [
		"I found this %s outside. For sale!" % station_name,
		"Do you want a new %s?" % station_name,
		"Selling a %s, brand new, never used!" % station_name,
		"You could make more potions if you had this %s" % station_name,
		"All the best potion makers use a %s" % station_name,
		"You'd get even more customers with a %s" % station_name,
		"I'm selling a %s today" % station_name,
		"You NEED a %s" % station_name
	].pick_random()

func get_map_dialogue(location_name:String):
	return [
		"Have you ever heard of %s?" % location_name,
		"I've never been to %s, have you?" % location_name,
		"I found this map to %s" % location_name,
		"Do you want a map to %s?" % location_name,
		"I'm selling a map to %s today" % location_name,
		"You should buy this map to %s" % location_name,
		"I hear lots of people want potions in %s" % location_name,
		"Lots of new ingredients in %s" % location_name
	].pick_random()

############################ SETUP ###########################
func _ready():
	ingredient_price_modifier = func(p): return p
	
	$PlayerMoneyPanelContainer/PlayerMoneyMarginContainer/PlayerMoneyLabel.text = "$" + str(PlayerData.money)
	
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
	if PlayerData.location.unlockable_station_id != "" and not PlayerData.unlocked_stations.has(PlayerData.location.unlockable_station_id):
		shopkeeper_speak(get_station_dialogue(PlayerData.location.unlockable_station_id.replace("_", " ")))
		$StationDisplay.visible = true
		$MapDisplay.visible = false
		
		$StationDisplay.station_id = PlayerData.location.unlockable_station_id
		$StationDisplay.station_price = PlayerData.location.unlockable_station_price
		if PlayerData.location.unlockable_station_sprite: $StationDisplay.station_sprite = PlayerData.location.unlockable_station_sprite
	else: 
		## Add map options for the current location 
		## (only shows if the station has already been bought)
		$StationDisplay.visible = false
		
		var available_location_ids = ResourcePaths.get_all_location_ids().filter(func(id): return not PlayerData.unlocked_locations.has(id))
		var available_locations = available_location_ids.map(func(id): return ResourceLoader.load(ResourcePaths.get_location_path(id)))
		# weighted map to choose a location
		available_locations = available_locations.reduce(func(accum, location): 
			for i in range(0, location.map_weight):
				accum.append(location)
			return accum
		, [])
		if available_locations.size() > 0:
			var chosen_location = available_locations.pick_random()
			shopkeeper_speak(get_map_dialogue(chosen_location.name))
			$MapDisplay.visible = true
			$MapDisplay.location_id = chosen_location.id
			$MapDisplay.map_price = chosen_location.map_cost
			if chosen_location.map_color: $MapDisplay.map_color = chosen_location.map_color
		elif PlayerData.reputation >= 50:
			shopkeeper_speak("I have a very special map for you today")
			$MapDisplay.visible = true
			$MapDisplay.location_id = "home"
			$MapDisplay.map_price = 500
			$MapDisplay.map_color = Color(77, 232, 209)


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


####################### SPEAKING #######################
func shopkeeper_speak(text:String):
	if DialogueLabel: DialogueLabel.text = text
	if SpeechBubble:
		SpeechBubble.visible = true
		await get_tree().create_timer(3).timeout
		SpeechBubble.visible = false


####################### CART MECHANICS #######################
func _on_body_entered_basket(body):
	if not body is DraggableObject: return
	cart.append(body)
	updateTotal(calculate_ingredient_price(body.data))


func _on_body_exited_basket(body):
	if not body is DraggableObject: return
	cart.erase(body)
	updateTotal(-calculate_ingredient_price(body.data))


func updateTotal(changeAmount:int):
	totalCost += changeAmount
	totalCostLabel.text = "Total Cost: $" + str(totalCost)


####################### DROP MECHANICS #######################
func _on_ingredient_dropped():
	drop_count += 1
	match drop_count:
		1: shopkeeper_speak("Try not to drop things")
		3: shopkeeper_speak("Seriously, be careful")
		5: shopkeeper_speak("That's breakable!")
		10: shopkeeper_speak("This is your LAST warning!")
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
	if PlayerData.money >= totalCost:
		PlayerData.money -= totalCost
		$PlayerMoneyPanelContainer/PlayerMoneyMarginContainer/PlayerMoneyLabel.text = "$" + str(PlayerData.money)
		# add ingredients to inventory
		shopkeeper_speak("Thanks for coming!")
		var tween:Tween = get_tree().create_tween()
		tween.tween_property($Music_Player, "volume_db", linear_to_db(0.04), 2)
		await tween.finished
		$Music_Player.stop()
		for ingredient in cart:
			PlayerData.add_item_to_inventory(ingredient.data, 1)
			cart.erase(ingredient)
			ingredient.queue_free()
		shop_done.emit()
	else:
		shopkeeper_speak("You can't afford that")


func _on_exit_button_pressed():
	shopkeeper_speak("See you next time!")
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($Music_Player, "volume_db", linear_to_db(0.04), 2)
	await tween.finished
	$Music_Player.stop()
	shop_done.emit() # signal to night menu to reload inventory


func _on_map_or_station_purchased():
	$PlayerMoneyPanelContainer/PlayerMoneyMarginContainer/PlayerMoneyLabel.text = "$" + str(PlayerData.money)
	
	
############################ NEW INVENTORY SHENANIGANS ##########################
func create_shop_inv(): #creates inventory and fills it with the contents of temp
	var temp_file = FileAccess.open(TEMP_SHOP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(SHOP_INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	
func read_inv(): #reads temporary inventory to output
	var file = FileAccess.open(TEMP_SHOP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	file.close()
	return content
	
func write_inv(data): # writes input to temporary inventory
	var file = FileAccess.open(TEMP_SHOP_INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func save_shop():
	#saves temp inv to actual inventory
	var temp_file = FileAccess.open(TEMP_SHOP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(SHOP_INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	
func add_item_to_inventory(item : Resource, quantity : int):
	var index = 0;
	var inv_data = read_inv()
	for i in  inv_data: #find next available slot to put item
		var slotAmount = int(inv_data[i]["Quantity"])
		if inv_data[i]["Item"] == item.id && slotAmount != item.stack_size: #if this ingredient already exists in inventory
			if slotAmount + quantity > item.stack_size: #if adding this quantity to the amount in the stack would be larger than stack size
				inv_data[i]["Quantity"] = item.stack_size #fill the slot
				write_inv(inv_data)
				add_item_to_inventory(item, slotAmount + quantity - item.stack_size) #add the rest to a different slot
				break
			else: #else just update the quantity
				inv_data[i]["Quantity"] = slotAmount + quantity					
				break
		elif inv_data[i]["Item"] == null: #if this slot is empty 
			if quantity > 0:
				if quantity <= item.stack_size: #if quantity is not greater than allowed stack size add item to this slot

					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = quantity					
					break
				else: #else add max stack size to this slot and add the excess to another slot
					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = item.stack_size
					write_inv(inv_data)
					add_item_to_inventory(item, quantity - item.stack_size)
					break
			else:
				return
		index = index + 1
	write_inv(inv_data)
	save_shop()
