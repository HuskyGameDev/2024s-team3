extends Resource
class_name Location

@export_group("Basic Information")
@export var id: String = ""
@export var name: String = ""

@export_group("Probability Tables")
@export var forage_table: Array[Dictionary] = [] # dict type: { ingredient:Ingredient, weight:int }
@export var ingredients_shop_table: Array[Dictionary] = [] # dict type: { item:String, cost:int, weight:int }
@export var customer_request_table: Array[Dictionary] = [] # dict type: { request:Potion, repChange:int, moneyChange:int, weight:int }

## Get Random Item Functions
func forage_items(count:int) -> Array[Ingredient]:
	return []
	
func get_shop_offerings(count:int) -> Array[Dictionary]: # dict type: { item:String, cost:int }
	return []
	
func get_customer_requests(count:int) -> Array[Dictionary]: # dict type: { request:Potion, repChange:int, moneyChange:int }
	return []
