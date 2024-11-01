extends DraggableObject

const IMAGE_SCALE = 6

# For handling with cauldron
@export var data: Ingredient



# Called when the node enters the scene tree for the first time.
func _ready():
	set_collider($Collider)
	set_default_collision_layer(1)
	set_holding_collision_layer(31)
	self.data = data
	super()


# stops rotation of ingredient if its on the shelf
func _on_body_entered(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(true)

# allows rotation when it leaves the shelf
func _on_body_exited(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(false)
