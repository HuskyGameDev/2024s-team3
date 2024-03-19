extends Resource
class_name Location

const COMMON_CHANCE = 0.74
const UNCOMMON_CHANCE = 0.94
const RARE_CHANCE = 0.99

@export_group("Basic Information")
@export var id: String = ""
@export var name: String = ""

@export_group("Probability Tables")
@export var forage_table: Dictionary = {}
@export var ingredients_shop_table: Dictionary = {}
@export var customer_request_table: Dictionary = {}

func _ready():
	randomize()
	
func _setup(newName, forageTable, shopTable, customerTable):
	name = newName
	id = name.to_snake_case()
	for rarity in forageTable:
		var forageArr = []
		for ingredientId in forageTable[rarity]:
			forageArr.append(ResourceLoader.load("res://Assets/Resources/Ingredients/" + ingredientId + ".tres"))
		forage_table[rarity] = forageArr
		
		var customerRequestArr = []
		for dict in customerTable[rarity]:
			var potion = ResourceLoader.load("res://Assets/Resources/Potions/" + dict.request + ".tres")
			customerRequestArr.append({ 
				"moneyChange": dict.moneyChange, 
				"repChange": dict.repChange, 
				"potion": potion 
			})
		customerRequestArr[rarity] = customerRequestArr
	ingredients_shop_table = shopTable

## Get Random Item Functions
func forage_items(count:int) -> Array:
	var foundItems = []
	while true:
		var f = randf()
		var options:Array;
		if f < COMMON_CHANCE: # 74% chance
			options = forage_table["common"]
		elif f < UNCOMMON_CHANCE: # 20% chance
			options = forage_table["uncommon"]
		elif f < RARE_CHANCE: # 5% chance
			options = forage_table["rare"]
		else: # 1% chance
			options = forage_table["super_rare"]
		if options.size() == 0: continue
		foundItems.append(options[randi() % options.size()])
		if foundItems.size() == count: break
	return foundItems
	
func get_shop_offerings(count:int) -> Array:
	return []
	
func get_customer_requests(count:int) -> Array:
	var requests = []
	while true:
		var f = randf()
		var options:Array;
		if f < COMMON_CHANCE: # 74% chance
			options = customer_request_table["common"]
		elif f < UNCOMMON_CHANCE: # 20% chance
			options = customer_request_table["uncommon"]
		elif f < RARE_CHANCE: # 5% chance
			options = customer_request_table["rare"]
		else: # 1% chance
			options = customer_request_table["super_rare"]
		if options.size() == 0: continue
		requests.append(options[randi() % options.size()])
		if requests.size() == count: break
	return requests
