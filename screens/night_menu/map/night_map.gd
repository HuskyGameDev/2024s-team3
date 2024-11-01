extends Node

@onready var Player:CharacterBody2D = $Player

## PLAYER MOVEMENT
func _physics_process(_delta):
	Player.velocity = Vector2.ZERO
	if Input.is_action_pressed("MapMoveUp"):
		Player.velocity += Vector2.UP
	if Input.is_action_pressed("MapMoveDown"):
		Player.velocity += Vector2.DOWN
	if Input.is_action_pressed("MapMoveLeft"):
		Player.velocity += Vector2.LEFT
	if Input.is_action_pressed("MapMoveRight"):
		Player.velocity += Vector2.RIGHT
	Player.velocity *= 100
	Player.move_and_slide()


## HANDLE SCENE CHANGE
func move_to_location(location_id:String):
	var new_location = ResourceLoader.load(ResourcePaths.get_location_path(location_id))
	PlayerData.location = new_location
	if not PlayerData.visited_locations.map(func(location): return location.id).has(location_id):
		PlayerData.visited_locations.append(new_location)
		PlayerData.save_game_files()
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")


## THE CLEARING
@onready var ClearingAreaLabel = $LocationAreas/ClearingArea/Label
@onready var ClearingAreaOutline = ClearingAreaLabel.get_node("Outline")

func _on_clearing_area_entered(body):
	if body is CharacterBody2D:
		ClearingAreaLabel.visible = true

func _on_clearing_area_exited(body):
	if body is CharacterBody2D:
		ClearingAreaLabel.visible = false

func _on_clearing_area_mouse_entered():
	ClearingAreaOutline.visible = true

func _on_clearing_area_mouse_exited():
	ClearingAreaOutline.visible = false

func _on_clearing_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and ClearingAreaLabel.visible and ClearingAreaOutline.visible:
		move_to_location("the_clearing")

## THE OUTPOST
@onready var OutpostAreaLabel = $LocationAreas/OutpostArea/Label
@onready var OutpostAreaOutline = OutpostAreaLabel.get_node("Outline")

func _on_outpost_area_entered(body):
	if body is CharacterBody2D:
		OutpostAreaLabel.visible = true

func _on_outpost_area_exited(body):
	if body is CharacterBody2D:
		OutpostAreaLabel.visible = false

func _on_outpost_area_mouse_entered():
	OutpostAreaOutline.visible = true

func _on_outpost_area_mouse_exited():
	OutpostAreaOutline.visible = false

func _on_outpost_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and OutpostAreaLabel.visible and OutpostAreaOutline.visible:
		move_to_location("the_outpost")


## THE LABORATORY
@onready var LaboratoryAreaLabel = $LocationAreas/LaboratoryArea/Label
@onready var LaboratoryAreaOutline = LaboratoryAreaLabel.get_node("Outline")

func _on_laboratory_area_entered(body):
	if body is CharacterBody2D:
		LaboratoryAreaLabel.visible = true

func _on_laboratory_area_exited(body):
	if body is CharacterBody2D:
		LaboratoryAreaLabel.visible = false

func _on_laboratory_area_mouse_entered():
	LaboratoryAreaOutline.visible = true

func _on_laboratory_area_mouse_exited():
	LaboratoryAreaOutline.visible = false

func _on_laboratory_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and LaboratoryAreaLabel.visible and LaboratoryAreaOutline.visible:
		move_to_location("the_laboratory")


## THE TEMPLE
@onready var TempleAreaLabel = $LocationAreas/TempleArea/Label
@onready var TempleAreaOutline = TempleAreaLabel.get_node("Outline")

func _on_temple_area_entered(body):
	if body is CharacterBody2D:
		TempleAreaLabel.visible = true

func _on_temple_area_exited(body):
	if body is CharacterBody2D:
		TempleAreaLabel.visible = false

func _on_temple_area_mouse_entered():
	TempleAreaOutline.visible = true

func _on_temple_area_mouse_exited():
	TempleAreaOutline.visible = false

func _on_temple_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and TempleAreaLabel.visible and TempleAreaOutline.visible:
		move_to_location("the_temple")


## THE CITY
@onready var CityAreaLabel = $LocationAreas/CityArea/Label
@onready var CityAreaOutline = CityAreaLabel.get_node("Outline")

func _on_city_area_entered(body):
	if body is CharacterBody2D:
		CityAreaLabel.visible = true

func _on_city_area_exited(body):
	if body is CharacterBody2D:
		CityAreaLabel.visible = false

func _on_city_area_mouse_entered():
	CityAreaOutline.visible = true

func _on_city_area_mouse_exited():
	CityAreaOutline.visible = false

func _on_city_area_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and CityAreaLabel.visible and CityAreaOutline.visible:
		move_to_location("the_city")
