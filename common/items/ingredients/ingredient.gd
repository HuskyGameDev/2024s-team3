extends DraggableObject

@export var data: Ingredient

func _ready():
	## setup draggable object variables
	set_collider($Collider)
	set_default_collision_layer(1)
	super()
	
	## setup data
	if data: 
		set_tooltip(data)
		if data.image:
			var image_size = data.image.get_size()
			var collider_shape = CapsuleShape2D.new()
			collider_shape.height = image_size[1]
			collider_shape.radius = image_size[0] / 2
			$"Collider".set_shape(collider_shape)
			$"Sprite".texture = data.image
