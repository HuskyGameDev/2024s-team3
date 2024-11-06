extends Control

const NUM_ITEMS = 3
var control_nodes:Array[Control] = []

func _ready():
	$LocationBackgroundSwitcher.update_background()
	var foragedItems = PlayerData.location.forage_items(NUM_ITEMS)
	for i in range(0, NUM_ITEMS):
		var new_control = Control.new()
		new_control.size_flags_horizontal |= Control.SIZE_EXPAND_FILL
		control_nodes.append(new_control)
		$IngredientsHBox.add_child(new_control)
	for i in range(0, NUM_ITEMS):
		await get_tree().create_timer(1).timeout
		show_forage(foragedItems[i], i)
	await get_tree().create_timer(3).timeout
	print_debug("EXIT")
	#exit()


func show_forage(ingredient:Ingredient, index:int):
	var new_sprite = TextureRect.new()
	new_sprite.stretch_mode |= TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_sprite.set_anchors_preset(Control.PRESET_FULL_RECT)
	new_sprite.texture = ingredient.image
	control_nodes[index].add_child(new_sprite)
	print_debug("foraged ", ingredient.name)
	PlayerData.add_item_to_inventory(ingredient, 1);


func exit():
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
