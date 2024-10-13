@tool
extends GridContainer

@export var sprite_folder:String

func _ready():
	if not sprite_folder: return
	var sprite_paths = ResourcePaths._get_all_paths_with_extension(sprite_folder, ".png")
	for path in sprite_paths:
		var sprite_node = TextureRect.new()
		sprite_node.texture = load(path)
		sprite_node.stretch_mode |= TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		sprite_node.size_flags_vertical |= Control.SIZE_EXPAND
		sprite_node.size_flags_horizontal |= Control.SIZE_EXPAND
		add_child(sprite_node)
