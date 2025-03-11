extends DraggableObject

const IMAGE_SCALE = 6

# For handling with cauldron
@export var data: Ingredient
@export var x_spawn = 245
@export var y_spawn = 580

func with_data(data: Ingredient):
	self.data = data
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collider($Collider)
	set_default_collision_layer(1)
	set_holding_collision_layer(31)
	super()
	Ingredient.Actions.get(1)
	if data:
		set_water_tooltip()
	
	
	self.position = Vector2(x_spawn, y_spawn)


# stops rotation of ingredient if its on the shelf
func _on_body_entered(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(true)

# allows rotation when it leaves the shelf
func _on_body_exited(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(false)
