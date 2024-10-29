@tool
extends Resource
class_name Location


@export_group("Basic Information")
@export var id: String = ""
@export var name: String = ""
@export var ingredients: Array[Ingredient]

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
