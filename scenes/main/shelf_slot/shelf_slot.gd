extends Node

## To change what kind of item can be put in the slot change the Area2D's mask:
## Ingredients: 31
## Potions: 32

var packed_potion_scene = preload("res://common/items/potions/potion.tscn")
var packed_ingredient_scene = preload("res://common/items/ingredients/ingredient.tscn")

var dragging: DraggableObject # if something is being dragged over the slot
var heldNodes: Array[DraggableObject] # the nodes in the slot

var isDisabled: bool = false
var shouldCenter: bool = true # set to true if there are no movement animations going on

## Customization variables
@export var centerItems: bool = true # center held items?
@export var allowStack: bool = false # allow multiple items in one slot?
@export var allowDifferentItems: bool = false # allow different items in one slot?

signal items_changed(nodeArr: Array[DraggableObject], newItem: Item)


## Keep held nodes centered
func _process(delta):
	if centerItems and shouldCenter:
		for node in heldNodes: 
			if not node.beingHeld:
				node.global_position = $SlotCollider.global_position


## Center all nodes
func force_center_nodes():
	for node in heldNodes:
		node.global_position = $SlotCollider.global_position


## Track which body is being dragged over the slot
func _on_slot_hover_entered(body):
	if isDisabled: return
	if not body is DraggableObject: return
	dragging = body


## Track which body is removed from the slot
## If it's an item being removed, deal with removing it
func _on_slot_hover_exited(body):
	if isDisabled: return
	if body in heldNodes:
		drop_node(body)
	dragging = null


## If the player releases an item over the slot, check if
## it can be held, then handle holding it
func _unhandled_input(event):
	if isDisabled: return
	if Input.is_action_just_released("click") && dragging && not dragging.onShelf:
		if can_hold(dragging.data): 
			hold_node(dragging)


## Check if an item can be held
func can_hold(data: Item) -> bool:
	if heldNodes.size() == 0: return true
	elif allowStack and allowDifferentItems: return true
	elif allowStack and heldNodes[0].data.id == data.id: return true
	else: return false


## Add node to held items
func hold_node(node: Node):
	if heldNodes.size() > 0: heldNodes[-1].input_pickable = false
	self.isDisabled = true
	heldNodes.push_back(node)
	items_changed.emit(heldNodes, node.data)
	
	node.set_on_shelf(true)
	node.set_deferred("gravity_scale", 0)
	node.set_deferred("lock_rotation", true)
	node.set_deferred("freeze", true)
	
	shouldCenter = false
	var tween = create_tween()
	tween.tween_property(node, "rotation", 0, 0.1)
	if centerItems:
		tween.tween_property(node, "global_position", $SlotCollider.global_position, 0.1)
	await tween.finished
	shouldCenter = true
	
	node.set_deferred("freeze", false)
	self.isDisabled = false


## Remove node from held items
func drop_node(node: Node):
	node.set_on_shelf(false)
	node.set_deferred("gravity_scale", 1)
	node.set_deferred("lock_rotation", false)
	heldNodes.erase(node)
	if heldNodes.size() > 0: heldNodes[-1].input_pickable = true
	items_changed.emit(heldNodes, null)
