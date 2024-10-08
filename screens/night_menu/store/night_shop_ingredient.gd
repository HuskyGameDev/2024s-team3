extends Node

var cost:int
var item:Ingredient
var quantityAvailable:int
var quantityBuying:int

var increaseButton:Button
var decreaseButton:Button
var quantityLabel:Label
signal totalChanged(changeAmount:int)

func _ready():
	increaseButton = $"AmountHBox/IncreaseButton"
	decreaseButton = $"AmountHBox/DecreaseButton"
	quantityLabel = $"AmountHBox/QuantityLabel"
	_updateQuantityButtons()

func setData(offering:Dictionary): # Dictionary with keys quantity, cost, and item (which is an ingredient)
	self.cost = offering.get("cost")
	self.quantityAvailable = offering.get("quantity")
	self.item = offering.get("item")
	self.quantityBuying = 0
	_updateLabels()

func handlePurchase():
	PlayerData.add_item_to_inventory(item, quantityBuying);


func _updateLabels():
	$"NameLabel".text = item.name + " - $" + str(cost)
	$"ItemTexture/AmountForSaleLabel".text = str(quantityAvailable)
	$"ItemTexture".texture = item.image

func _on_decrease_button_pressed():
	quantityBuying -= 1
	_updateQuantityButtons()
	totalChanged.emit(self.cost * -1)

func _on_increase_button_pressed():
	quantityBuying += 1
	_updateQuantityButtons()
	totalChanged.emit(self.cost)

func _updateQuantityButtons():
	quantityLabel.text = str(quantityBuying)
	
	if quantityBuying == 0: decreaseButton.disabled = true
	else: decreaseButton.disabled = false
		
	if quantityBuying == quantityAvailable: increaseButton.disabled = true
	else: increaseButton.disabled = false
