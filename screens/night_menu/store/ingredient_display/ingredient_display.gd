extends "res://common/shelf_slot/shelf_slot.gd"


################## EXPORTED VARS ##################
@export var quantity : int :
	set(q):
		quantity = q
		if QuantityLabel: QuantityLabel.text = str(quantity)
@export var price : int :
	set(p):
		price = p
		if PriceLabel: PriceLabel.text = "$%s" % price

@export var ingredient : Ingredient

################## ONREADY VARS ##################
@onready var QuantityLabel := $QuantityLabel
@onready var PriceLabel    := $PriceLabel

################## OTHER VARS ##################


################## FUNCTIONS ##################
func _ready():
	QuantityLabel.text = str(quantity)
	PriceLabel.text = "$%s" % price
