extends Node

var packed_customer_scene = preload("res://screens/main/customers/customer.tscn")

static var GRACE_PERIOD_LENGTH = 5
static var REP_DECREASE_PERIOD_LENGTH = 60

var current_customer: Customer
var customer_node: Node
var customer_timer: Timer

@onready var time_modifier = 1
@onready var in_grace_period = true

signal customer_created(customer: Customer)


func _ready():
	customer_timer = Timer.new()
	add_child(customer_timer)
	create_customer()


func create_customer():
	current_customer = Customer.new()
	current_customer.order = PlayerData.location.customer_request_table.get_one_random()
	
	customer_node = packed_customer_scene.instantiate().with_data(current_customer)
	add_child(customer_node)
	
	in_grace_period = true
	customer_timer.connect("timeout", grace_period_timeout)
	customer_timer.start(GRACE_PERIOD_LENGTH)


## Returns true if the potion was taken, otherwise false
func handle_purchase(potion: Potion) -> bool:
	if not current_customer: return false
	
	# calculate potion rep and money factors
	var strongest_effects = potion.effects.get_strongest(3).filter(func(e): return true if potion.effects.get_strength(e) >= EffectSet.NOTHING_RANGE else false)
	var reputation_change = 0
	var money_change = 0
	for effect in strongest_effects:
		reputation_change += effect.reputation_factor
		var effect_strength = potion.effects.get_strength(effect)
		var strength_factor = 1
		if abs(effect_strength) < EffectSet.WEAK_RANGE:
			strength_factor = 0.5
		elif abs(effect_strength) >= EffectSet.REGULAR_RANGE:
			strength_factor = 1.5
		money_change += effect.money_factor * strength_factor
	
	# calculate num effects and update money
	PlayerData.change_money(money_change * pow(1.2, strongest_effects.size()))
	
	# calculate time to make potion and update reputation
	var time_modifier = 1
	if not in_grace_period:
		var time_to_create = REP_DECREASE_PERIOD_LENGTH - round(customer_timer.time_left)
		time_modifier = time_to_create / REP_DECREASE_PERIOD_LENGTH
	if current_customer.order.check(potion):
		PlayerData.change_reputation(reputation_change * time_modifier)
	else:
		PlayerData.change_reputation(-reputation_change * (1 - time_modifier))
	
	customer_node.leave_store()
	remove_child(customer_timer)
	return true


## Handles timer timeout to start decreasing reputation
func grace_period_timeout():
	in_grace_period = false
	customer_timer.disconnect("timeout", grace_period_timeout)
	customer_timer.start(REP_DECREASE_PERIOD_LENGTH) 
