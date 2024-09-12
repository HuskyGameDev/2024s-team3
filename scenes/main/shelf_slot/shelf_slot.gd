extends Node

var dragging: DraggableObject #if something is being dragged over the slot
var heldNodes: Array[DraggableObject] #the nodes in the slot
var nodeShouldCenter: bool = false #should the node be centered

var isDisabled: bool = false

@export var centerItems: bool = true
@export var allowStack: bool = false
@export var allowDifferentItems: bool = false

signal items_changed(nodeArr: Array[DraggableObject], newItem: Item)

## To change what kind of item can be put in the slot change the Area2D's mask:
## Ingredients: 31
## Potions: 32

func _process(delta):
	for node in heldNodes:
		if node and not node.beingHeld and nodeShouldCenter \
		and node.global_position != $SlotCollider.global_position:
			node.global_position = $SlotCollider.global_position


func force_center_nodes():
	for node in heldNodes:
		node.global_position = $SlotCollider.global_position


func _on_slot_hover_entered(body):
	if isDisabled: return
	if body is DraggableObject:
		dragging = body


func _on_slot_hover_exited(body):
	if isDisabled: return
	if body in heldNodes:
		body.set_on_shelf(false)
		body.set_deferred("gravity_scale", 1)
		body.set_deferred("lock_rotation", false)
		heldNodes.erase(body)
		if heldNodes.size() > 0: heldNodes[-1].input_pickable = true
		items_changed.emit(heldNodes, null)
	dragging = null


func _unhandled_input(event):
	if Input.is_action_just_released("click") && dragging && not dragging.onShelf:
		if not can_hold(dragging.data): return
		if heldNodes.size() > 0: heldNodes[-1].input_pickable = false
		heldNodes.push_back(dragging)
		items_changed.emit(heldNodes, dragging.data)
		dragging.set_on_shelf(true)
		dragging.set_deferred("gravity_scale", 0)
		dragging.set_deferred("lock_rotation", true)
		dragging.set_deferred("freeze", true)
		var tween = create_tween()
		tween.tween_property(dragging, "rotation", 0, 0.1)
		nodeShouldCenter = false
		if centerItems:
			tween.tween_property(dragging, "global_position", $SlotCollider.global_position, 0.1)
		await tween.finished
		nodeShouldCenter = true
		dragging.set_deferred("freeze", false)


func can_hold(data: Item) -> bool:
	if heldNodes.size() == 0: return true
	elif allowStack and allowDifferentItems: return true
	elif allowStack and heldNodes[0].data.id == data.id: return true
	else: return false
