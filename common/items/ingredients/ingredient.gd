extends DraggableObject

const IMAGE_SCALE = 6

@export var data: Ingredient


func with_data(data: Ingredient):
	self.data = data
	return self


func _ready():
	## setup draggable object variables
	set_collider($Collider)
	set_default_collision_layer(1)
	set_holding_collision_layer(31)
	super()
	
	## setup data
	if data: 
		set_tooltip(data)
		if data.id != data.get_base_id():
			var base_sprite = ResourceLoader.load(ResourcePaths.get_ingredient_path(data.get_base_id())).image
			if !base_sprite: return
			if data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CHOP)):
				set_up_chopped_sprite(base_sprite)
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CHOP)):
				print_debug("Crushed")
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CHOP)):
				print_debug("Melted")
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CHOP)):
				print_debug("Concentrated")
		else: set_up_default_sprite()
			

# stops rotation of ingredient if its on the shelf
func _on_body_entered(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(true)

# allows rotation when it leaves the shelf
func _on_body_exited(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(false)


# default ingredient image
func set_up_default_sprite():
	## Use default ingredient sprite
	if data.image:
		var image_size = data.image.get_size() * IMAGE_SCALE
		var collider_shape = CapsuleShape2D.new()
		collider_shape.height = image_size[1]
		collider_shape.radius = image_size[0] / 2
		$"Collider".set_shape(collider_shape)
		$"Sprite".texture = data.image


# ingredient chopped image
func set_up_chopped_sprite(base_sprite:Texture2D):
	# Rotate sprite so longest direction is horizontal
	var image_width = base_sprite.get_size()[0]
	var image_height = base_sprite.get_size()[1]
	if image_height > image_width:
		var image = base_sprite.get_image()
		image.rotate_90(COUNTERCLOCKWISE)
		base_sprite = ImageTexture.create_from_image(image)
		image_width = base_sprite.get_size()[0]
		image_height = base_sprite.get_size()[1]
	
	$"Sprite".texture = base_sprite
	$"ChoppedSprite".visible = true
	
	# Calculate pieces in pixel size
	var num_pieces = randi_range(3, 5)
	var piece_width = floor(image_width / num_pieces)
	var piece_offset = piece_width
	
	# Add pieces
	for i in range(0, num_pieces):
		# the last piece needs to take the whole remaining sprite
		if i == num_pieces-1: piece_width = image_width - (piece_width * (num_pieces - 1))
		var piece_node = $Sprite.duplicate()
		# only show part of the sprite
		piece_node.region_enabled = true
		piece_node.region_rect = Rect2(piece_offset * i, 0, piece_width, image_height)
		piece_node.offset = Vector2((piece_offset * i) - (image_width / 2), 0)
		# rotate randomly
		piece_node.rotation_degrees = randf_range(-30, 30)
		# add gap between pieces
		piece_node.position.x = 10 * i
		$ChoppedSprite.add_child(piece_node)
	# Set up collider
	var image_size = base_sprite.get_size() * IMAGE_SCALE
	var collider_shape = CapsuleShape2D.new()
	collider_shape.height = image_size[0]
	collider_shape.radius = image_size[1] / 2
	$"Collider".rotation_degrees = 90
	$"Collider".set_shape(collider_shape)
	# Remove single sprite
	$Sprite.queue_free()
	
