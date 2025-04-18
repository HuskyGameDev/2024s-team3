extends Node

var packed_customer_scene = preload("res://screens/main/customers/customer.tscn")

static var GRACE_PERIOD_LENGTH = 15
# static var REP_DECREASE_PERIOD_LENGTH = 60

var current_customer: Customer
var customer_node: Node
var recent_requests: Array[String]

@onready var customer_timer: Timer = Timer.new()
@onready var time_modifier = 1
@onready var in_grace_period = true
@onready var reputationDif = 0;
@onready var repBonus = 0
@onready var moneyChange = 0
@onready var repLabel = $"../repLabel"
@onready var labelAnim = $"../repLabel/AnimationPlayer"
@onready var moneyLabelAnim = $"../moneyLabel/AnimationPlayer"
@onready var moneyLabel = $"../moneyLabel"

signal customer_created(customer: Customer)
signal repChanged(new_rep: int)


func _ready():
	moneyLabel.hide()
	repLabel.hide()
	if GameTime.hour < GameTime.STORE_CLOSE_TIME: # if it is day time
		create_customer()


func create_customer():
	current_customer = Customer.new()
	var isNew: int = 0
	var dialogue_number: int = 0
	while (isNew == 0):
		current_customer.order = PlayerData.location.customer_request_table.get_one_random()
		dialogue_number = randi() % current_customer.order.dialogueOptions.size()
		isNew = 1
		for request:String in recent_requests:
			if (current_customer.order.dialogueOptions[dialogue_number] == request):
				isNew = 0
				break
	# at this point, request must be new
	recent_requests.push_front(current_customer.order.dialogueOptions[dialogue_number])
	if (recent_requests.size() > 5):
		recent_requests.pop_back()
	
	customer_node = packed_customer_scene.instantiate().with_data(current_customer, dialogue_number)
	add_child(customer_node)
	
	in_grace_period = true
	add_child(customer_timer)
	customer_timer.connect("timeout", grace_period_timeout)
	customer_timer.start(GRACE_PERIOD_LENGTH)

func skip_customer():
	customer_node.leave_store()
	customer_timer.disconnect("timeout", grace_period_timeout)
	remove_child(customer_timer)
	PlayerData.change_reputation(-1) # Place holder amount for time being
	create_customer()

## Returns true if the potion was taken, otherwise false
func handle_purchase(potion: Potion) -> bool:
	if not current_customer: return false
	
	# calculate potion rep and money factors
	var strongest_effects = potion.effects.get_strongest(3).filter(func(e): return true if abs(potion.effects.get_strength(e)) >= EffectSet.NOTHING_RANGE else false)
	var total_price:float = 0
	var number_effects:int = 0
	var number_strong_effects:int = 0
	for effect: Effect in strongest_effects:
		if (abs(potion.effects.get_strength(effect)) > 4):
			var effect_strength = abs(potion.effects.get_strength(effect))
			total_price = total_price + (effect.money_factor*effect_strength/5)
			number_effects += 1
			if (effect_strength > 9): number_strong_effects += 1
	
	
	# calculate time to make potion and update reputation
	reputationDif = PlayerData.reputation
	if current_customer.order.check(potion):
		PlayerData.change_reputation(1)
		repBonus+= 1
		# apply bonuses
		total_price = total_price * (0.8+(0.2*number_effects))
		if (number_strong_effects > 0): total_price *= 1.5
		repBonus+= 1
		
		PlayerData.change_money(floor(total_price))
		if in_grace_period:
			PlayerData.change_reputation(1) # give an extra reputation if fast enough
			repBonus+= 1
	else:
		PlayerData.change_money(floor(total_price*0.4))
		PlayerData.change_reputation(-3)
		repBonus += -3
	repLabel.text = str(repBonus) + " Rep" 
	repLabel.position.x = randf_range(300, 1500)   # randomize x posistion of label
	repLabel.show() 
	labelAnim.play("losereputation") # this animation has red text
	if(repBonus > 0): 
		repLabel.text = "+" + str(repBonus) + " Rep"
		repLabel.position.x = randf_range(300, 1500)  # randomize x posistion of label
		repLabel.show() 
		labelAnim.play("gainreputation") # this animation has green text
	moneyLabel.text = "+ $" + str(total_price)
	moneyLabel.show()
	moneyLabel.position.x = randf_range(300, 1500)
	moneyLabelAnim.play("moneymation")
	repBonus = 0
	customer_node.leave_store()
	remove_child(customer_timer)
	return true


## Handles timer timeout to start decreasing reputation
func grace_period_timeout():
	in_grace_period = false
	customer_timer.disconnect("timeout", grace_period_timeout)
	
func _leave_end_day(): # call function in customer node to end day
	customer_node._end_day_leave_store()
