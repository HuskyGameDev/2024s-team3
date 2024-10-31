extends Node
var modulate_color : Color

func _ready():
	modulate_color.r = 54 # RGB is the color
	modulate_color.g = 47
	modulate_color.b = 72
	modulate_color.a = 100
	
	$"CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/SalesNumber".text = "$%d" % PlayerData.moneyToday
	$"CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/ReputationNumber".text = "%d Reputation" % PlayerData.repToday
	var tween = create_tween()
	tween.tween_property($Shutter, "position", Vector2(988, 355), 2)
	tween.set_parallel()
	tween.tween_property($CanvasLayer/CenterContainer, "position", Vector2(448, 115), 2)
	tween.tween_property($CanvasLayer/Darkness, "modulate", Color.RED, 2)



func _on_buy_button_pressed():
	get_tree().change_scene_to_file("res://screens/night_menu/store/night_shop.tscn")

func _on_forage_button_pressed():
	get_tree().change_scene_to_file("res://screens/night_menu/forage/forage.tscn")

func _on_move_button_pressed():	
	get_tree().change_scene_to_file("res://screens/night_menu/map/night_map.tscn")
