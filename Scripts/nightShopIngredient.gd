extends Node

var cost:int
var quantity:int
var item

func setData(offering:Dictionary):
	self.cost = offering.get("cost")
	self.quantity = offering.get("quantity")
	self.item = offering.get("item")
	_updateLabels()
	
func _updateLabels():
	$"NameLabel".text = item.name + " - $" + str(cost)
	$"ItemTexture/AmountForSaleLabel".text = str(quantity)
	$"ItemTexture".texture = item.image
