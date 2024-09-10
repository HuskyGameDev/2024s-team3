extends Node2D

func _ready():
	GameTime.start_day()
	GameTime.end_of_day.connect(func(): get_tree().change_scene_to_file("res://scenes/night_menu/menu/night_menu.tscn"));
	
	$Pedestal/ShelfSlot.connect("item_changed", _on_selling_potion_change)
	$Bell/BellButton.connect("pressed", _on_ring_bell)


func _on_shelf_body_entered(body):
	body.rotation = 0


################## POTION SELLING ##################
var sellingPotion: Potion ## the potion on the pedestal ready to be sold

func _on_selling_potion_change(newPotion: Potion):
	sellingPotion = newPotion

func _on_ring_bell():
	pass
