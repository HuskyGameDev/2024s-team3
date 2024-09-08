extends Resource
class_name Customer

@export var order: Potion = null
@export var orderPrice: int = 0
@export var reputationChange: int = 0
var customerName = "joe" # default, can also look at the acutal object name too
var walkSpeed = .25 # default

func _setup(orderId: String, cost: int, reputation: int):
	orderPrice = cost
	reputationChange = reputation
	var orderPath = "res://Assets/Resources/Potions/" + orderId + ".tres"
	if ResourceLoader.exists(orderPath):
		order = load(orderPath)
	else:
		print("Could not load potion" + orderId)
	
