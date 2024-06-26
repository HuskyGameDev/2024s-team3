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
	
	self.forage_table = {}
	for rarity in forageTable:
		var forageArr = []
		for ingredientId in forageTable[rarity]:
			forageArr.append(ResourceLoader.load("res://Assets/Resources/Ingredients/" + ingredientId + ".tres"))
		self.forage_table[rarity] = forageArr
	
	self.customer_request_table = {}	
	for rarity in customerTable:
		var customerRequestArr = []
		for dict in customerTable[rarity]: 
			var newCustomer = Customer.new()
			newCustomer.order = ResourceLoader.load("res://Assets/Resources/Potions/" + dict.get("request") + ".tres")
			newCustomer.orderPrice = dict.get("moneyChange")
			newCustomer.reputationChange = dict.get("repChange")
			customerRequestArr.append(newCustomer)
		self.customer_request_table[rarity] = customerRequestArr
	
	self.ingredients_shop_table = {}
	for rarity in shopTable:
		var shopOfferingArr = []
		for dict in shopTable[rarity]: 
			var item;
			match dict.get("type"):
				"ingredient":
					item = ResourceLoader.load("res://Assets/Resources/Ingredients/" + dict.get("item") + ".tres")
			shopOfferingArr.append({
				"item": item,
				"cost": dict.get("cost"),
				"quantity": dict.get("quantity")
			})
		self.ingredients_shop_table[rarity] = shopOfferingArr
	

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
	var shopItems = []
	while true:
		var f = randf()
		var options:Array;
		if f < COMMON_CHANCE: # 74% chance
			options = ingredients_shop_table["common"]
		elif f < UNCOMMON_CHANCE: # 20% chance
			options = ingredients_shop_table["uncommon"]
		elif f < RARE_CHANCE: # 5% chance
			options = ingredients_shop_table["rare"]
		else: # 1% chance
			options = ingredients_shop_table["super_rare"]
		if options.size() == 0: continue
		shopItems.append(options[randi() % options.size()])
		if shopItems.size() == count: break
	return shopItems
	
func get_customer_requests(count:int) -> Array[Customer]:
	var requests:Array[Customer] = []
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
		var chosenCustomer = options[randi() % options.size()]
		requests.append(chosenCustomer)
		chosenCustomer.walkSpeed = randf_range(.4, 1.4) # walking speed range
		if requests.size() == count: break
	return requests
