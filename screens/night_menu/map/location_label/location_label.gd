extends Area2D

signal move_to_location(location_id:String)

@export var location: Location

@onready var LabelNode = $Label
@onready var OutlineNode = $Label/Outline


func _ready():
	LabelNode.visible = false
	OutlineNode.visible = false
	
	$Label/PanelContainer/Label.text = location.name


func _on_location_area_entered(body):
	if body is CharacterBody2D:
		LabelNode.visible = true

func _on_location_area_exited(body):
	if body is CharacterBody2D:
		LabelNode.visible = false

func _on_location_area_mouse_entered():
	OutlineNode.visible = true

func _on_location_area_mouse_exited():
	OutlineNode.visible = false

func _on_location_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and LabelNode.visible and OutlineNode.visible:
		move_to_location.emit(location.id)
