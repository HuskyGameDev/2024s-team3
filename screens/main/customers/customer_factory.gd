extends Node

var packed_customer_scene = preload("res://screens/main/customers/customer.tscn")

var current_customer: Customer

signal customer_created(customer: Customer)


func _ready():
	create_customer()


func create_customer():
	current_customer = Customer.new()
	current_customer.order = PlayerData.location.customer_request_table.get_one_random()
	
	var customer_node = packed_customer_scene.instantiate().with_data(current_customer)
	add_child(customer_node)


## Returns true if the potion was taken, otherwise false
func handle_purchase(potion: Potion) -> bool:
	if not current_customer: return false
	if current_customer.order.check(potion):
		print_debug("Thanks for the potion")
	else:
		print_debug("This is the wrong potion")
	return true
