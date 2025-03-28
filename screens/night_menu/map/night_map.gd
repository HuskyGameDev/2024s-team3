extends Node

@onready var Player:CharacterBody2D = $Player
signal move_done

@onready var chicken: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var sidewalk: AnimatedSprite2D = $Player/AnimatedSprite2D



## PLAYER MOVEMENT
func ready():
	chicken.scale = Vector2(0.5, 0.5)  # Reduces the size to half
		 
		
func _physics_process(_delta):
	Player.velocity = Vector2.ZERO
	if Input.is_action_pressed("MapMoveUp"):
		Player.velocity += Vector2.UP
		sidewalk.play("topdown")
		chicken.scale.y = -.5
		chicken.scale.x = .5
	if Input.is_action_just_released("MapMoveUp"):
		sidewalk.stop()
	if Input.is_action_pressed("MapMoveDown"):
		Player.velocity += Vector2.DOWN
		sidewalk.play("topdown")
		chicken.scale.y = .5
		chicken.scale.x = .5
	if Input.is_action_just_released("MapMoveDown"):
		sidewalk.stop()
	if Input.is_action_pressed("MapMoveLeft"):
		Player.velocity += Vector2.LEFT
		sidewalk.play("sideside")
		chicken.scale.x = -.5
		chicken.scale.y = .5
	if Input.is_action_just_released("MapMoveLeft"):
		sidewalk.stop()
	if Input.is_action_pressed("MapMoveRight"):
		Player.velocity += Vector2.RIGHT
		sidewalk.play("sideside")
		chicken.scale.x = .5
		chicken.scale.y = .5
	if Input.is_action_just_released("MapMoveRight"):
		sidewalk.stop()
	Player.velocity *= 100
	Player.move_and_slide()


## HANDLE SCENE END
func move_to_location(location_id:String):
	if location_id == "home": 
		get_tree().change_scene_to_file("res://screens/credits/credits.tscn")
		return
	var new_location = ResourceLoader.load(ResourcePaths.get_location_path(location_id))
	PlayerData.location = new_location
	if not PlayerData.visited_locations.map(func(location): return location.id).has(location_id):
		PlayerData.visited_locations.append(new_location)
	PlayerData.save_game_files()
	move_done.emit()
	self.queue_free()  # delete this scene


## HANDLE AREA MOVEMENT
func _ready():
	for LocationArea in $LocationAreas.get_children():
		if PlayerData.location.id == LocationArea.location.id:
			# spawn player at their current position
			Player.global_position = LocationArea.global_position
			# move camera to player without smoothing animation
			$Player/Camera.position_smoothing_enabled = false
			await get_tree().create_timer(0.1).timeout
			$Player/Camera.position_smoothing_enabled = true
		# only show unlocked areas on the map
		if PlayerData.unlocked_locations.has(LocationArea.location.id):
			LocationArea.connect("move_to_location", move_to_location)
		else:
			LocationArea.queue_free()
	
