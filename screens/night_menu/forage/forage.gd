extends Node2D

const NUM_ITEMS = 3

var bottom_of_screen:Vector2
@onready var forageSounds:Array[AudioStream] = [preload("res://common/audio/Forage_1.wav"), preload("res://common/audio/Forage_2.wav"), preload("res://common/audio/Forage_3.wav")]
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

signal forage_done # signal night menu that forage is done

func _ready():
	## Setup scene
	$LocationBackgroundSwitcher.update_background()
	var foragedItems = PlayerData.location.forage_items(NUM_ITEMS)
	bottom_of_screen = get_viewport_rect().size / Vector2(2, 1)
	
	## Do forage
	var pos_increment = get_viewport_rect().size.x / NUM_ITEMS
	var pos = -pos_increment/2
	for i in range(0, NUM_ITEMS):
		await get_tree().create_timer(1).timeout
		pos += pos_increment
		show_forage(foragedItems[i], pos, i)
	
	## delete self
	await get_tree().create_timer(3).timeout
	forage_done.emit()
	self.queue_free()


func show_forage(ingredient:Ingredient, pos:float, index:int):
	## Set up sprite
	var new_sprite = Sprite2D.new()
	new_sprite.texture = ingredient.image
	new_sprite.scale = Vector2(0.1, 0.1)
	new_sprite.global_position = bottom_of_screen
	$Sprites.add_child(new_sprite)
	var n = rng.randi_range(0,2)
	$Forager.stream = forageSounds[n]
	$Forager.play()
	
	## Do animation
	var tween = get_tree().create_tween()
	tween.tween_property(new_sprite, "scale", Vector2(23 - NUM_ITEMS, 23 - NUM_ITEMS), 0.25)
	tween.parallel().tween_property(new_sprite, "global_position", Vector2(pos, get_viewport_rect().size.y / 2), 0.25)
	tween.tween_property(new_sprite, "rotation_degrees", 5, 0.05).from(0)
	for i in range(0, (NUM_ITEMS + 1.8 - index) / 0.2):
		tween.tween_property(new_sprite, "rotation_degrees", -5, 0.1).from(5)
		tween.tween_property(new_sprite, "rotation_degrees", 5, 0.1).from(-5)
	tween.tween_callback(func(): tween.kill())
	
	PlayerData.add_item_to_inventory(ingredient, 1);
