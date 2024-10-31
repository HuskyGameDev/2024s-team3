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
var ingredientNodes:Array[Node] = []

################## FUNCTIONS ##################
func _ready():
	QuantityLabel.text = str(quantity)
	PriceLabel.text = "$%s" % price


func spawn_held_nodes(held_node_parent):
	# Add ingredients to held node array
	for i in range(0, quantity):
		var ingredient_node = PackedIngredientScene.instantiate().with_data(ingredient)
		self.heldNodes.append(ingredient_node)
		self.ingredientNodes.append(ingredient_node)
	# Create the held item nodes
	super(held_node_parent)


func drop_node(node: Node):
	self.quantity -= 1
	super(node)


func hold_node(node):
	if ingredient and node.data.id != ingredient.id: return
	self.quantity += 1
	super(node)


func recover_fallen_node(node):
	node.global_position = self.global_position
	hold_node(node)


func _physics_process(delta):
	## If one of the ingredients that should be in this slot falls off the 
	## screen, add it back to the slot
	for node in ingredientNodes:
		if node.global_position.y >= 1200 and not heldNodes.has(node):
			call_deferred("recover_fallen_node", node)
			#TODO make the shopkeeper yell at you for dropping things
