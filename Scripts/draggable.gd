extends RigidBody2D

############ Drag and Drop Functions ############
var beingHeld = false
var shelf = false # true if ingredient is on shelf
var parentNode: Node2D

func _unhandled_input(_event):
	if not Input.is_action_pressed("click") and beingHeld:
		beingHeld = false
		set_deferred("gravity_scale", 1)
		if parentNode.data is Potion:
			set_collision_layer_value(2, true)
			set_collision_layer_value(32, false)
			set_collision_mask_value(2, true)
			set_collision_mask_value(32, false)
		elif parentNode.data is Ingredient:
			set_collision_layer_value(1, true)
			set_collision_layer_value(32, false)
			set_collision_mask_value(1, true)
			set_collision_mask_value(32, false)
		


func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		beingHeld = true
		tooltip.visible = false
		set_deferred("gravity_scale", 0)
		if parentNode.data is Potion:
			set_collision_layer_value(2, false)
			set_collision_layer_value(32, true)
			set_collision_mask_value(2, false)
			set_collision_mask_value(32, true)
		elif parentNode.data is Ingredient:
			set_collision_layer_value(1, false)
			set_collision_layer_value(32, true)
			set_collision_mask_value(1, false)
			set_collision_mask_value(32, true)
		var tween = create_tween()
		tween.tween_property(self, "rotation", 0, 0.1)
	
	
func _integrate_forces(_state):
	if beingHeld:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		var direction = global_position.direction_to(mousePos)
		rotation = 0 
		set_linear_velocity(direction * distance * 40)
	elif shelf: # if object is on shelf and not being held
		rotation = 0 # stop object from rotating


############### Object Functions ################
@export_enum("Potion", "Ingredient") var object_type: String
@export var object_data:Resource
var tooltip;
var timer:Timer;

func _ready():
	parentNode = get_parent()
	timer = $Timer
	tooltip = $Tooltip
	if object_data: tooltip.set_text(object_data.name, object_data.description)

func data_updated():
	if object_data:
		if object_data.image != null:
			var imageSize = object_data.image.get_size()
			var colliderShape = CapsuleShape2D.new()
			colliderShape.height = imageSize[1]
			colliderShape.radius = imageSize[0] / 2
			$"Collider".set_shape(colliderShape)
			$"DraggableSprite".texture = object_data.image
		if tooltip != null: tooltip.set_text(object_data.name, object_data.description)
		
func _on_mouse_entered():
	if not beingHeld:
		timer.start(1)
		
func _on_mouse_exited():
	timer.stop()
	tooltip.visible = false

func _on_timer_timeout():
	tooltip.global_position = self.global_position
	
	var viewport_rect = get_viewport_rect()
	var tooltip_rect = tooltip.get_rect()
	while not viewport_rect.encloses(tooltip_rect):
		## horizontal alignment
		if viewport_rect.position.x > tooltip_rect.position.x:
			tooltip.global_position.x += 25
		elif viewport_rect.end.x < tooltip_rect.end.x:
			tooltip.global_position.x -= 25
		## vertical alignment
		if viewport_rect.position.y > tooltip_rect.position.y:
			tooltip.global_position.x += 25
		elif viewport_rect.end.y < tooltip_rect.end.y:
			tooltip.global_position.y -= 25
		tooltip_rect = tooltip.get_rect()
	
	tooltip.visible = true

# stops rotation of ingredient if its on the shelf
func _on_body_entered(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		shelf = true

# allows rotation when it leaves the shelf
func _on_body_exited(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		shelf = false
