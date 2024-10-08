extends Node2D

@onready var sprite = $Sprite
@onready var ingredient = $Ingredient
@onready var description = $Description
@onready var forward = $Forward
@onready var back = $Back
@onready var anim = $"Book Animation"


var batWing = preload("res://common/items/ingredients/bat_wing/bat_wing.tres")
var frogLeg = preload("res://common/items/ingredients/frog_leg/frog_leg.tres")
var nightshade = preload("res://common/items/ingredients/nightshade_petals/nightshade_petals.tres")
var owlFeather = preload("res://common/items/ingredients/owl_feather/owl_feather.tres")
var peppermint = preload("res://common/items/ingredients/peppermint_leaves/peppermint_leaves.tres")
var pineResin = preload("res://common/items/ingredients/pine_resin/pine_resin.tres")
var poisonIvy = preload("res://common/items/ingredients/poison_ivy/poison_ivy.tres")
var sunFlower = preload("res://common/items/ingredients/sunflower_seeds/sunflower_seeds.tres")
var thistleRoot = preload("res://common/items/ingredients/thistle_root/thistle_root.tres")



var current_ingr_key
@export var max_ingr = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	current_ingr_key = 0
	_update_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _add_one():
	current_ingr_key += 1
	_update_data()
	


func _sub_one():
	current_ingr_key -= 1
	_update_data()

func _update_data():
	var current_ingr
	match current_ingr_key:
		0:
			current_ingr = batWing
		1:
			current_ingr = frogLeg
		2:
			current_ingr = nightshade
		3:
			current_ingr = owlFeather
		4:
			current_ingr = peppermint
		5:
			current_ingr = pineResin
		6:
			current_ingr = poisonIvy
		7:
			current_ingr = sunFlower
		8:
			current_ingr = thistleRoot
		9:
			pass
	
	
	# Change all the data
	print("we made it")
	print(current_ingr.description)
	description.text = current_ingr.description
	# yada yada
	
	
	
	
	
	
	
	
	pass


func _on_forward_pressed() -> void:
	if (current_ingr_key < max_ingr):
		anim.play("Forward")
	else:
		pass
	
	


func _on_back_pressed() -> void:
	if (current_ingr_key > 0):
		anim.play("Backward")
	else:
		pass
