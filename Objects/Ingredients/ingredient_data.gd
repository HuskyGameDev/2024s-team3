extends Resource

@export var id: String
@export var ingredient_name: String
@export_multiline var description: String
@export var image: Texture2D

func _init(p_id = "", p_name = "", p_description = "", p_image = null):
	id = p_id
	ingredient_name = p_name
	description = p_description
	image = p_image
