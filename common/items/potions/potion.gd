extends DraggableObject

const IMAGE_SCALE = 6

@export var data: Potion


func with_data(data: Potion):
	self.data = data
	return self


func _ready():
	## setup draggable object variables
	set_collider($Collider)
	set_default_collision_layer(2)
	set_holding_collision_layer(32)
	super()
	
	## setup data
	if data: 
		set_tooltip(data)
		if data.image:
			var image_size = data.image.get_size() * IMAGE_SCALE
			var collider_shape = CapsuleShape2D.new()
			collider_shape.height = image_size[1]
			collider_shape.radius = image_size[0] / 2
			$"Collider".set_shape(collider_shape)
			$"Sprite".texture = data.image
