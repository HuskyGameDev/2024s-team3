extends RigidBody2D
var beingHeld = false
var startPos = Vector2(988, 355)
var moved = false
var mousePos = 0
var hover # true if mouse is above shutter

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(988, 355), 2)
	await tween.finished
	moved = true;

func _input(event): 
	if event is InputEventMouseButton:
		if event.is_pressed() and hover == true: #if mouse was clicked over shutter
			mousePos = event.position.x #get mouse position
			beingHeld = true 
		elif event.is_released(): # called when mouse is unclicked
			beingHeld = false
			self.position.x = startPos.x #move shutter back to original position over window
			self.position.y = startPos.y
			
	if event is InputEventMouseMotion: #called when mouse moves
		if beingHeld == true && event.position.x > 460: 
			var draggingDistance = event.position.x - mousePos # caluclate how far the mouse has moved
			if position.x + (draggingDistance) > startPos.x: # prevent window from being dragged left
				position.x = position.x + (draggingDistance) # move shutter the distance the mouse has moved
			mousePos = event.position.x # save the mouse position
			if position.x > 1400: # if shutter was moves to left start day
				var tween = create_tween() 
				tween.tween_property(self, "position", Vector2(2400, 340), 2) #tween the shutter the rest of the way open
				await tween.finished
				GameTime.end_of_night.emit() # emit signal to GameTime
				var packed_scene = PackedScene.new() #create new packed main
				var group = get_tree().get_nodes_in_group("main") # get main scene
				var main = group[0]
				packed_scene.pack(main) #gets the main scene and all things it owns 
				ResourceSaver.save(packed_scene, "res://screens/main/packed_main.tscn" ) # save main scene node
				get_tree().change_scene_to_file("res://screens/main/packed_main.tscn") # change scene

func _on_mouse_entered(): #called when mouse enters shutter
	hover = true


func _on_mouse_exited(): #called when mouse exits shutter
	hover = false
