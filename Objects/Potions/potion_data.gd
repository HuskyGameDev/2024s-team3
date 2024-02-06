extends Resource

@export var id: String
@export var potion_name: String
@export_multiline var description: String
@export var image: Texture2D
@export var recipe: Array[String]

func _init(p_id = "", p_name = "", p_description = "", p_image = null, p_recipe = [] as Array[String]):
	id = p_id
	potion_name = p_name
	description = p_description
	image = p_image
	recipe = p_recipe
