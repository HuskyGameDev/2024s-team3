@tool
extends Resource
class_name Location


@export_group("Basic Information")
@export var id: String = ""
@export var name: String = ""
@export var ingredients: Array[Ingredient]

@export_group("Unlockable Station")
@export var unlockable_station_id: String
@export var unlockable_station_sprite: Texture2D
@export var unlockable_station_price: int = 50

@export_group("Map Information")
@export var map_weight: int = 1 # probability of the map being available (1 means it will have 1 entry in the random array)
@export var map_cost: int = 100
@export var map_color: Color

@export_group("Probability Tables")
@export var forage_table: LootTable
@export var ingredients_shop_table: LootTable
@export var customer_request_table: LootTable


## Get Random Item Functions
func forage_items(count:int) -> Array:
	return forage_table.get_random(count)
	
func get_shop_offerings(count:int) -> Array:
	return ingredients_shop_table.get_random(count)
	
func get_customer_request() -> CustomerOrder:
	return customer_request_table.get_one_random()
