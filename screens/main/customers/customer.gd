extends Node


const START_LOCATION = Vector2(1800, 500)
const ONSCREEN_LOCATION = Vector2(1200, 500)
const END_LOCATION = Vector2(300, 500)

var data: Customer
var walk_speed: float = 0.5


func with_data(data: Customer, number: int):
	self.data = data
	$DialogueLabel.text = data.order.dialogueOptions[number]
	return self


func _ready():
	self.global_position = START_LOCATION
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", ONSCREEN_LOCATION, walk_speed)


func leave_store():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", END_LOCATION, walk_speed)
	await tween.finished # wait for tween to finish
	self.queue_free()

func _end_day_leave_store(): # at the end of the day
	var tween = get_tree().create_tween() #move customer out of windoe
	tween.tween_property(self, "global_position", END_LOCATION, walk_speed) 
	await tween.finished # wait for tween to finish
	self.queue_free() #delete this node
	get_tree().change_scene_to_file("res://screens/night_menu/night_menu.tscn") # change scene to night menu
