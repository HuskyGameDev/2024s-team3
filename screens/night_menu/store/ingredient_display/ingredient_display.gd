extends "res://common/shelf_slot/shelf_slot.gd"

@export var quantity : int :
	set(q):
		quantity = q
		if QuantityLabel: QuantityLabel.text = str(quantity)
@export var price : int :
	set(p):
		price = p
		if PriceLabel: PriceLabel.text = "$%s" % price

@onready var QuantityLabel := $QuantityLabel
@onready var PriceLabel    := $PriceLabel

func _ready():
	QuantityLabel.text = str(quantity)
	PriceLabel.text = "$%s" % price
