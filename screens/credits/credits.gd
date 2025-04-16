extends PanelContainer

@onready var Objects:Array[RigidBody2D] = []

func _ready():
	var Ingredients = $Ingredients
	var Default = $Ingredients/Default
	for path in ResourcePaths.get_all_non_variant_ingredient_paths():
		var ingredient = ResourceLoader.load(path)
		# set up node
		var node = Default.duplicate()
		node.get_node("Sprite").texture = ingredient.image
		node.get_node("Collider").shape.height = 6 * ingredient.image.get_height()
		node.get_node("Collider").shape.radius = 6 * ingredient.image.get_width() / 2
		# position node
		node.global_position.y = randi_range(-200, 1500)
		node.global_position.x = randi_range(0, 1920) # right
		# spawn node
		Objects.append(node)
		Ingredients.add_child(node)
	Default.queue_free()

func _physics_process(delta):
	# window size is 1920x1080
	for object in Objects:
		object.linear_velocity.y = 150
		if object.global_position.y >= 1500:
			object.global_position.y = -200
			object.rotation = randi_range(-45, 45)
			if randi_range(0, 1):
				object.global_position.x = randi_range(0, 750) # left
			else:
				object.global_position.x = randi_range(1200, 1920) # right
