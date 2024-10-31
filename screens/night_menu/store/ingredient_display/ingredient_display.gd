extends "res://common/shelf_slot/shelf_slot.gd"

static var PackedIngredientScene = preload("res://common/items/ingredients/ingredient.tscn")

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


func spawn_held_nodes(held_node_parent):
	# Add ingredients to held node array
	for i in range(0, quantity):
		var ingredient_node = PackedIngredientScene.instantiate().with_data(ingredient)
		self.heldNodes.append(ingredient_node)
	# Create the held item nodes
	super(held_node_parent)
