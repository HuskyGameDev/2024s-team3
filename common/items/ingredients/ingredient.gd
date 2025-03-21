extends DraggableObject

const CrushedSprite:Texture2D = preload("res://common/items/ingredients/crushed_ingredient.png")
const HueSwapMaterial:Material = preload("res://common/shaders/hue_swap.tres")


@onready var AnimalPickUp:Array[AudioStream] = [preload("res://common/audio/Animal_Ingredient_Pick_Up_1.wav"), preload("res://common/audio/Animal_Ingredient_Pick_Up_2.wav")]
@onready var AnimalDrop:AudioStream = preload("res://common/audio/Animal_Ingredient_Put_Down.wav")
@onready var MagicAnimalPickUp:Array[AudioStream] = [preload("res://common/audio/Magic_Animal_Ingredient_Pick_up_1.wav"), preload("res://common/audio/Magic_Animal_Ingredient_Pick_up_2.wav")]
@onready var MagicAnimalDrop:AudioStream = preload("res://common/audio/Magic_Animal_Ingredient_Put_Down_1.wav")
@onready var PlantPickUp:Array[AudioStream] = [preload("res://common/audio/Plant_Pickup_1.wav"), preload("res://common/audio/Plant_Pickup_2.wav")]
@onready var PlantDrop:Array[AudioStream] = [preload("res://common/audio/Plant_Drop_1.wav"), preload("res://common/audio/Plant_Drop_2.wav")]
@onready var MagicPlantPickUp:Array[AudioStream] = [preload("res://common/audio/Magic_Plant_Pickup_1.wav"), preload("res://common/audio/Magic_Plant_Pickup_2.wav")]
@onready var MagicPlantDrop:Array[AudioStream] = [preload("res://common/audio/Magic_Plant_Drop_1.wav"), preload("res://common/audio/Magic_Plant_Drop_2.wav")]
@onready var MineralPickUp:Array[AudioStream] = [preload("res://common/audio/Mineral_Pickup_1.wav"), preload("res://common/audio/Mineral_Pickup_2.wav")]
@onready var MineralDrop:Array[AudioStream] = [preload("res://common/audio/Mineral_Drop_1.wav"), preload("res://common/audio/Mineral_Drop_2.wav")]

var rng:RandomNumberGenerator = RandomNumberGenerator.new()


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
	
	
	Ingredient.Actions.get(1)
	## setup data
	if data: 
		set_tooltip_ingredients(data)
		if data.image != null: set_up_default_sprite()
		elif data.id != data.get_base_id():
			var base_ingredient = ResourceLoader.load(ResourcePaths.get_ingredient_path(data.get_base_id()))
			if data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CHOP)):
				if base_ingredient.image: set_up_chopped_sprite(base_ingredient.image)
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CRUSH)):
				if base_ingredient.average_color: set_up_crushed_sprite(base_ingredient.average_color)
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.MELT)):
				print_debug("Melted (TODO)")
			elif data.id.begins_with(Ingredient.action_to_string(Ingredient.Actions.CONCENTRATE)):
				print_debug("Concentrated (TODO)")
				
				
	$SFX_Player.stop()


# stops rotation of ingredient if its on the shelf
func _on_body_entered(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(true)
	
	# Plays a sound on pick up depending on the ingredient type
	var rand:int = rng.randi_range(0,1)
	match self.data.id:
		"aloe_jelly", "eye_of_a_newt", "frog_leg", "goats_blood", "goat_milk", "owl_feather", "raven_feather", "raw_leech", "robin_egg", "snake_oil", "squid_ink", "viper_fang":
				$SFX_Player.set_stream(AnimalDrop)
		"bugbear_hide", "dragon_claw", "harpy_feather", "phoenix_ash", "squonk_tears", "unicorn_horn", "werewolf_tooth", "yeti_fur":
				$SFX_Player.set_stream(MagicAnimalDrop)
		"bat_wing", "bison_fur", "elderberry_leaves", "eye_of_newt", "fairy_bell", "fire_flower", "fresh_moss", "holly_berries", "lavender", "lotus_petals", "nightshade_petals", "peppermint_leaves", "pine_resin", "poison_ivy", "rose", "sunflower_seeds", "thistle_root", "willow_bark":
				$SFX_Player.set_stream(PlantDrop[rand])
		"erdtree_branch", "mandrake_root", "pipe_weed":
				$SFX_Player.set_stream(MagicPlantDrop[rand])
		"amber", "amethyst", "diamond", "emerald", "fools_gold", "gold_dust", "ice", "jade", "pearl", "quartz", "ruby", "sapphire", "silver_dust", "topaz":
				$SFX_Player.set_stream(MineralDrop[rand])
	$SFX_Player.volume_db = -15
	$SFX_Player.play()

# allows rotation when it leaves the shelf
func _on_body_exited(body):
	if body.name == "Right Shelf" or body.name == "Left Shelf":
		set_on_shelf(false)
	
	# Plays a sound on drop depending on the ingredient type
	var rand:int = rng.randi_range(0,1)
	match self.data.id:
		"aloe_jelly", "eye_of_a_newt", "frog_leg", "goats_blood", "goat_milk", "owl_feather", "raven_feather", "raw_leech", "robin_egg", "snake_oil", "squid_ink", "viper_fang":
				$SFX_Player.set_stream(AnimalPickUp[rand])
		"bugbear_hide", "dragon_claw", "harpy_feather", "phoenix_ash", "squonk_tears", "unicorn_horn", "werewolf_tooth", "yeti_fur":
				$SFX_Player.set_stream(MagicAnimalPickUp[rand])
		"bat_wing", "bison_fur", "elderberry_leaves", "eye_of_newt", "fairy_bell", "fire_flower", "fresh_moss", "holly_berries", "lavender", "lotus_petals", "nightshade_petals", "peppermint_leaves", "pine_resin", "poison_ivy", "rose", "sunflower_seeds", "thistle_root", "willow_bark":
				$SFX_Player.set_stream(PlantPickUp[rand])
		"erdtree_branch", "mandrake_root", "pipe_weed":
				$SFX_Player.set_stream(MagicPlantPickUp[rand])
		"amber", "amethyst", "diamond", "emerald", "fools_gold", "gold_dust", "ice", "jade", "pearl", "quartz", "ruby", "sapphire", "silver_dust", "topaz":
				$SFX_Player.set_stream(MineralPickUp[rand])
	$SFX_Player.volume_db = -15
	$SFX_Player.play()	

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
		# remove chopped sprite
		$ChoppedSprite.queue_free()


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


# ingredient crushed image
func set_up_crushed_sprite(average_color:Color):
	# Add shader to sprite
	var new_material = HueSwapMaterial.duplicate()
	new_material.set_shader_parameter("from", Color(1, 1, 1))
	new_material.set_shader_parameter("tolerance", 0)
	new_material.set_shader_parameter("to", average_color)
	$"Sprite".material = new_material
	# Set up collider
	var image_size = CrushedSprite.get_size() * IMAGE_SCALE
	var collider_shape = CapsuleShape2D.new()
	collider_shape.height = image_size[0]
	collider_shape.radius = image_size[1] / 2
	$"Collider".rotation_degrees = 90
	$"Collider".set_shape(collider_shape)
	$"Sprite".texture = CrushedSprite
	# Remove chopped sprite
	$ChoppedSprite.queue_free()
	

	
