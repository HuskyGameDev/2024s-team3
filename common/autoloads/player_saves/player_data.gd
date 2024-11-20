extends Node

################# Game Saving ###################
const SAVE_LOCATION = "user://savegame.save"
const INV_LOCATION = "user://inv_data_file.json" #inventory we save to when each day is done
const TEMP_INV_LOCATION = "user://temp_inv_data_file.json" #inventory we save to during game play

@export var location: Location = ResourceLoader.load("res://common/locations/the_clearing/the_clearing.tres")
@export var visited_locations: Array[Location] = [ location ]
@export var unlocked_locations: Array = [ location.id ]
@export var unlocked_stations: Array = []
@export var money: int = 0
@export var reputation: int = 0
@export var tutorial_complete: bool = false
@export var inventory: Array[InventorySlot] = []


func _ready():
	if not GameTime.start_of_day.is_connected(_on_start_of_day): GameTime.start_of_day.connect(_on_start_of_day)
	if not GameTime.end_of_day.is_connected(_on_end_of_day):GameTime.end_of_day.connect(_on_end_of_day)
	create_temp_inv()
	if !FileAccess.file_exists(INV_LOCATION): 
		create_new_inv()
	else: #write inv to temporary inventory
		var file = FileAccess.open(INV_LOCATION, FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		file.close()
		var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
		temp_file.store_string(JSON.stringify(content))
		temp_file.close()
	load_game_files()

func save_game_files():
	## Write all variables to file
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	save_file.store_string(JSON.stringify({ 
		"money": money, 
		"reputation": reputation, 
		"location": location.id,
		"visited_locations": visited_locations.map(func(l): return l.id),
		"unlocked_locations": unlocked_locations,
		"unlocked_stations": unlocked_stations,
		"tutorial_complete": tutorial_complete
	}))
	save_file.close()

func save_game():
	#saves temp inv to actual inventory
	var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	save_game_files()

func load_game_files():
	## Load all variables from file
	if FileAccess.file_exists(SAVE_LOCATION):
		var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		var save_data = JSON.parse_string(save_file.get_as_text())
		if save_data:
			money = save_data.get_or_add("money", 0)
			reputation = save_data.get_or_add("reputation", 0)
			var location_id = save_data.get_or_add("location", "the_clearing")
			if location_id: location = ResourceLoader.load(ResourcePaths.get_location_path(location_id))
			var visited_location_ids = save_data.get_or_add("visited_locations", ["the_clearing"])
			if visited_location_ids:
				visited_locations.clear()
				for id in visited_location_ids:
					visited_locations.append(ResourceLoader.load(ResourcePaths.get_location_path(id)))
			unlocked_locations = save_data.get_or_add("unlocked_locations", ["the_clearing"])
			unlocked_stations = save_data.get_or_add("unlocked_stations", [])
			tutorial_complete = save_data.get_or_add("tutorial_complete", true)
		save_file.close()

func read_inv(): #reads temporary inventory to output
	var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	file.close()
	return content
	
func write_inv(data): # writes input to temporary inventory
	var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func create_new_inv(): #creates inventory and fills it with the contents of temp
	var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()

func create_temp_inv(): #creates temporary inventory
	if FileAccess.file_exists(INV_LOCATION): #if inventory exits, copies it to temp inventory
		var file = FileAccess.open(INV_LOCATION, FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		file.close()
		var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
		temp_file.store_string(JSON.stringify(content))
		temp_file.close()
	else: # else copy json to temp inv
		var json = FileAccess.open("res://screens/main/ui/inventory/inv_data_file.json", FileAccess.READ)
		var content = JSON.parse_string(json.get_as_text())
		var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
		file.store_string(JSON.stringify(content))
		file.close()

func clear_save_files():
	DirAccess.remove_absolute(SAVE_LOCATION)
	DirAccess.remove_absolute(INV_LOCATION)
	create_temp_inv()

################ Event Triggers #################

func _on_end_of_day():
	save_game()

func _on_start_of_day():
	moneyToday = 0
	repToday = 0
	
	save_game_files()

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
	save_game()

############# Save Getters/Setters ##############
signal moneyChanged(newValue: int)
signal reputationChanged(newValue: int)
var moneyToday: int
var repToday: int

func change_money(amount: int):
	self.money += amount
	moneyToday += amount
	moneyChanged.emit(self.money)

func change_reputation(amount: int):
	self.reputation += amount
	repToday += amount
	reputationChanged.emit(self.reputation)
