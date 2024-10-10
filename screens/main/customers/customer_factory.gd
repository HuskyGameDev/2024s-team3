extends Node

var packed_customer_scene = preload("res://screens/main/customers/customer.tscn")

## Time modifier starts at 1. After x seconds, it starts to decrease.
## If the potion is wrong, the modifier becomes 1 - modifier (so taking longer to
## make the wrong potion is worse)
static var TIMER_REP_WAIT = 5
static var REP_DECREASE_PER_SEC = 0.5
static var MAX_REP_DECREASE = -30

var current_customer: Customer
var customer_node: Node
var customer_timer: Timer

signal customer_created(customer: Customer)


func _ready():
	create_customer()
	customer_timer = Timer.new()
	customer_timer.autostart = false
	add_child(customer_timer)


func create_customer():
	current_customer = Customer.new()
	current_customer.order = PlayerData.location.customer_request_table.get_one_random()
	
	customer_node = packed_customer_scene.instantiate().with_data(current_customer)
	add_child(customer_node)


## Returns true if the potion was taken, otherwise false
func handle_purchase(potion: Potion) -> bool:
	if not current_customer: return false
	if current_customer.order.check(potion):
		print_debug("Thanks for the potion")
	else:
		print_debug("This is the wrong potion")
	customer_node.leave_store()
	return true
