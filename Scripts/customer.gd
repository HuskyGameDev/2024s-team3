extends Node
# creates generic customers 

var customerName = "joe" # default 
var walkSpeed = .25 # default
var foodOrder = ""
	
func setCustomerSpeed(speed):
	self.walkSpeed = speed # same as "this. in java"
	
func setCustomerName(name):
	self.customerName = name 
	
func setCustomerOrder(order):
	self.foodOrder = order 
