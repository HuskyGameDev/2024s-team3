extends Node

################# Game Saving ###################
const SAVE_LOCATION = "user://savegame.save"
const INV_LOCATION = "user://inventory.json"

const INVENTORY_SIZE = 20

@export var location: Location = ResourceLoader.load("res://common/locations/grassy_clearing.tres")
@export var money: int = 0
@export var reputation: int = 0
@export var tutorial_complete: bool = false
@export var inventory: Array[InventorySlot] = []


func _ready():
	if not GameTime.start_of_day.is_connected(_on_start_of_day): 
		GameTime.start_of_day.connect(_on_start_of_day)
	
	load_game_files()


func save_game_files():
	## Write all variables to file
	var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	save_file.store_string(JSON.stringify({ 
		"money": money, 
		"reputation": reputation, 
		"location": location,
		"tutorial_complete": tutorial_complete
	}))
	save_file.close()
	
	var inv_file = FileAccess.open(INV_LOCATION, FileAccess.WRITE)
	inv_file.store_string(JSON.stringify(inventory))
	inv_file.close()


func load_game_files():
	## Load all variables from file
	if FileAccess.file_exists(SAVE_LOCATION):
		var save_file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		var save_data = JSON.parse_string(save_file.get_as_text())
		money = save_data.get("money")
		reputation = save_data.get("reputation")
		location = save_data.get("location")
		tutorial_complete = save_data.get("tutorial_complete")
		save_file.close()
	
	if FileAccess.file_exists(INV_LOCATION):
		var inv_file = FileAccess.open(INV_LOCATION, FileAccess.READ)
		inventory = JSON.parse_string(inv_file.get_as_text())
		inv_file.close()
	else:
		inventory.resize(INVENTORY_SIZE)
		inventory.fill(null)


func clear_save_files():
	DirAccess.remove_absolute(SAVE_LOCATION)
	DirAccess.remove_absolute(INV_LOCATION)

############# Save Getters/Setters ##############
signal moneyChanged(newValue: int)
signal reputationChanged(newValue: int)
var moneyToday: int
var repToday: int


func change_money(amount: int):
	self.save.money += amount
	moneyToday += amount
	moneyChanged.emit(self.save.money)


func change_reputation(amount: int):
	self.save.reputation += amount
	repToday += amount
	reputationChanged.emit(self.save.reputation)


func add_item_to_inventory(item: Item, quantity: int):
	var add_to_slot = func(i: int):
		var stack_size = item.stack_size
		var inv_count = inventory[i].quantity
		var inv_remaining = stack_size - inv_count
		if inv_remaining <= quantity:
			## add without leftovers
			inventory[i].quantity += quantity
		else:
			## add with leftovers
			inventory[i].quantity += inv_remaining
			add_item_to_inventory(item, quantity - inv_remaining)
	
	var index = inventory.map(func(e): 
		if not e: return null
		elif e.quantity >= e.item.stack_size: return null
		else: return e.item
	).find(item)
	
	if index >= 0:
		add_to_slot.call(index)
	else:
		index = inventory.find(null)
		add_to_slot.call(index)


################ Event Triggers #################

func _on_start_of_day():
	moneyToday = 0
	repToday = 0
	
	save_game_files()
