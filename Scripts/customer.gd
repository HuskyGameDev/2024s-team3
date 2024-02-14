extends Node
# creates generic customers 

var customerName = "joe" # default 
var walkSpeed = .25 # default
var foodOrder = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setCustomerSpeed(speed):
	self.walkSpeed = speed # same as "this. in java"
	
func setCustomerName(name):
	self.customerName = name 
	
func setCustomerOrder(order):
	self.foodOrder = order 
