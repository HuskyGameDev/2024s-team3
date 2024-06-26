extends Node

################# Game Saving ###################
const SAVE_LOCATION = "user://savegame.save"
var TEMP_INV_LOCATION = "user://temp_inv_data_file.json" #inventory we save to during gameplay
var INV_LOCATION = "user://inv_data_file.json" #inventory we save to when each day is done
@export var save:SaveGameFile

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
	
	save = load_game()

func save_game():
	#saves temp inv to actual inventory
	var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()
	
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	save_file.store_var(var_to_str(save))
	save_file.close()

func load_game() -> SaveGameFile:
	## Load from file
	if not FileAccess.file_exists(SAVE_LOCATION):
		print("No save found")
		return SaveGameFile.new()
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	var loaded_save = str_to_var(save_file.get_var())
	if loaded_save is SaveGameFile:
		return loaded_save
	else:
		print("error reading save file")
		return SaveGameFile.new()

func read_inv(): #reads temporoay inventory to output
	var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	file.close()
	return content
	
func write_inv(data): # writes input to temporary inventory
	var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	return 
	
func create_new_inv(): #creates inventory and fills it with the contents of temp
	var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.READ)
	var content = JSON.parse_string(temp_file.get_as_text())
	temp_file.close()
	var file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()

func create_temp_inv(): #creates temporary inventoey
	if FileAccess.file_exists(INV_LOCATION): #if inventory exits, copies it to temp inventory
		var file = FileAccess.open(INV_LOCATION, FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		file.close()
		var temp_file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
		temp_file.store_string(JSON.stringify(content))
		temp_file.close()
	else: # else copy json to temp inv
		var json = FileAccess.open("res://Assets/Data/inv_data_file.json", FileAccess.READ)
		var content = JSON.parse_string(json.get_as_text())
		var file = FileAccess.open(TEMP_INV_LOCATION, FileAccess.WRITE)
		file.store_string(JSON.stringify(content))
		file.close()

func clear_save():
	DirAccess.remove_absolute(SAVE_LOCATION)
	DirAccess.remove_absolute(INV_LOCATION)
	create_temp_inv()

################ Event Triggers #################

func _on_end_of_day():
	save_game()
	
func _on_start_of_day():
	moneyToday = 0
	repToday = 0

func _on_potion_made(potion:Potion):
	if not save.madePotions.has(potion.id):
		save.madePotions.append(potion.id)

func add_item_to_inventory(item : Resource, quantity : int):
	var index = 0;
	var inv_data = PlayerData.read_inv()	
	for i in  inv_data: #find next available slot to put item
		
		var slotAmount = int(inv_data[i]["Quantity"])
		if inv_data[i]["Item"] == item.id && slotAmount != item.stackSize: #if this ingredient already exists in inventory
			if slotAmount + quantity > item.stackSize: #if adding this quantity to the amount in the stack would be larger than stack size
				inv_data[i]["Quantity"] = item.stackSize #fill the slot
				PlayerData.write_inv(inv_data)
				add_item_to_inventory(item, slotAmount + quantity - item.stackSize) #add the rest to a different slot
				break
			else: #else just update the quantity
				inv_data[i]["Quantity"] = slotAmount + quantity					
				break
		elif inv_data[i]["Item"] == null: #if this slot is empty 
			if quantity > 0:
				if quantity <= item.stackSize: #if quantity is not greater than allowed stack size add item to this slot

					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = quantity					
					break
				else: #else add max stack size to this slot and add the excess to another slot
					inv_data[i]["Item"] = item.id
					inv_data[i]["Quantity"] = item.stackSize
					PlayerData.write_inv(inv_data)
					add_item_to_inventory(item, quantity - item.stackSize)
					break
			else:
				return
		index = index + 1
	PlayerData.write_inv(inv_data)


############# Save Getters/Setters ##############
signal moneyChanged(newValue: int)
signal reputationChanged(newValue: int)
var moneyToday:int
var repToday:int

func changeMoney(amount:int):
	self.save.money += amount
	moneyToday += amount
	moneyChanged.emit(self.save.money)
func changeReputation(amount:int):
	self.save.reputation += amount
	repToday += amount
	reputationChanged.emit(self.save.reputation)
