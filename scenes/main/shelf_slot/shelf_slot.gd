extends Node

var dragging: DraggableObject #if something is being dragged over the slot
var heldNode: DraggableObject #the node in the slot
var nodeShouldCenter: bool = false #should the node be centered

@export var centerItems: bool = true
@export var allowMultipleItems: bool = false

signal item_changed(newItem: Item)

## To change what kind of item can be put in the slot change the Area2D's mask:
## Ingredients: 31
## Potions: 32

func _process(delta):
	if heldNode and not heldNode.beingHeld and nodeShouldCenter \
	and heldNode.global_position != $SlotCollider.global_position:
		heldNode.global_position = $SlotCollider.global_position

func _on_slot_hover_entered(body):
	if body is DraggableObject:
		dragging = body


func _on_slot_hover_exited(body):
	if body == heldNode:
		heldNode.set_on_shelf(false)
		heldNode.set_deferred("gravity_scale", 1)
		heldNode.set_deferred("lock_rotation", false)
		item_changed.emit(null)
		heldNode = null
	dragging = null


func _unhandled_input(event):
	if Input.is_action_just_released("click") && dragging && not dragging.onShelf:
		if not allowMultipleItems and heldNode: return
		heldNode = dragging
		item_changed.emit(heldNode.data)
		heldNode.set_on_shelf(true)
		heldNode.set_deferred("gravity_scale", 0)
		heldNode.set_deferred("lock_rotation", true)
		heldNode.set_deferred("freeze", true)
		var tween = create_tween()
		tween.tween_property(heldNode, "rotation", 0, 0.1)
		nodeShouldCenter = false
		if centerItems:
			tween.tween_property(heldNode, "global_position", $SlotCollider.global_position, 0.1)
		await tween.finished
		nodeShouldCenter = true
		heldNode.set_deferred("freeze", false)
