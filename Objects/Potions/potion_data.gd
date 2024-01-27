extends Resource

@export var id: int
@export var potion_name: String
@export_multiline var description: String
@export var image: Texture2D
@export var recipe: Array[int]

func _init(p_id = 0, p_name = "", p_description = "", p_image = null, p_recipe = [] as Array[int]):
	id = p_id
	potion_name = p_name
	description = p_description
	image = p_image
	recipe = p_recipe
