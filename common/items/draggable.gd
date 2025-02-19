extends RigidBody2D
class_name DraggableObject


############### Add Required Nodes ##############
const packed_tooltip: PackedScene = preload("res://ui/tooltip/tooltip.tscn")
var timer: Timer
var tooltip: Node
var collider: CollisionShape2D
var default_collision_layer: int
var holding_collision_layer: int
var shelf_collision_layer: int = 20

func _ready():
	timer = Timer.new()
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	
	tooltip = packed_tooltip.instantiate()
	tooltip.visible = false
	add_child(tooltip)
	
	self.connect("input_event", _on_input_event)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)


func set_collider(collision_shape: CollisionShape2D):
	self.collider = collision_shape


func set_default_collision_layer(layer: int):
	self.default_collision_layer = layer
	set_collision_layer_value(default_collision_layer, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)


func set_holding_collision_layer(layer: int):
	self.holding_collision_layer = layer


func set_tooltip(item: Item):
	tooltip.set_text(item.name, item.description)
	

func set_tooltip_ingredients(ingredient: Ingredient):
	tooltip.set_text(ingredient.name, ingredient.description)
	tooltip.add_text("\nEffects:")
	for str in ingredient.effects.get_strongest_as_strings():
		tooltip.add_text("\n" + str)


############ Drag and Drop Functions ############
var beingHeld = false
var onShelf = false

func _on_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		hold()
	elif Input.is_action_just_released("click"):
		drop()


func hold():
	beingHeld = true
	tooltip.visible = false
	set_deferred("gravity_scale", 0)
	set_collision_layer_value(holding_collision_layer, true)
	set_collision_mask_value(31, true)
	set_collision_mask_value(32, true)
	set_collision_layer_value(default_collision_layer, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	var tween = create_tween()
	tween.tween_property(self, "rotation", 0, 0.1)
	self.z_index = 10


func drop():
	if not beingHeld: pass
	beingHeld = false
	if not onShelf:
		set_deferred("gravity_scale", 1)
		set_collision_layer_value(default_collision_layer, true)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(holding_collision_layer, false)
		set_collision_mask_value(31, false)
		set_collision_mask_value(32, false)
		self.z_index = 0

func _integrate_forces(_state):
	if beingHeld:
		var mousePos = get_global_mouse_position()
		var distance = global_position.distance_to(mousePos)
		var direction = global_position.direction_to(mousePos)
		rotation = 0 
		set_linear_velocity(direction * distance * 40)
	elif onShelf: # if object is on shelf and not being held
		rotation = 0 # stop object from rotating


func set_on_shelf(val: bool):
	onShelf = val
	if onShelf:
		set_collision_layer_value(shelf_collision_layer, true)
		set_collision_layer_value(default_collision_layer, false)
		set_collision_layer_value(holding_collision_layer, false)
		set_collision_mask_value(2, false)
		set_collision_mask_value(31, false)
		set_collision_mask_value(32, false)
	else:
		set_collision_layer_value(shelf_collision_layer, false)
		set_collision_layer_value(holding_collision_layer, true)
		set_collision_mask_value(31, true)
		set_collision_mask_value(32, true)

################### Tooltips ####################
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
	
