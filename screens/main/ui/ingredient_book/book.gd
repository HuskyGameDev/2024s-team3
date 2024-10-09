extends Node2D

@onready var sprite = $Sprite
@onready var ingredient = $Ingredient
@onready var description = $Description
@onready var forward = $Forward
@onready var back = $Back
@onready var anim = $"Book Animation"
@onready var values = $Values
@onready var ingrName = $Name


var batWing = preload("res://common/items/ingredients/bat_wing/bat_wing.tres")
var frogLeg = preload("res://common/items/ingredients/frog_leg/frog_leg.tres")
var nightshade = preload("res://common/items/ingredients/nightshade_petals/nightshade_petals.tres")
var owlFeather = preload("res://common/items/ingredients/owl_feather/owl_feather.tres")
var peppermint = preload("res://common/items/ingredients/peppermint_leaves/peppermint_leaves.tres")
var pineResin = preload("res://common/items/ingredients/pine_resin/pine_resin.tres")
var poisonIvy = preload("res://common/items/ingredients/poison_ivy/poison_ivy.tres")
var sunFlower = preload("res://common/items/ingredients/sunflower_seeds/sunflower_seeds.tres")
var thistleRoot = preload("res://common/items/ingredients/thistle_root/thistle_root.tres")
var eyeOfNewt = preload("res://common/items/ingredients/eye_of_a_newt/eye_of_a_newt.tres")


var up: bool = false

var current_ingr_key
@export var max_ingr = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	current_ingr_key = 0
	_update_data()

func _move_up():
	if (!up):
		position = Vector2(306, 858)
		up = true
	else:
		position = Vector2(306, 1248)
		up = false
	



func _add_one():
	current_ingr_key += 1
	_update_data()


func _sub_one():
	current_ingr_key -= 1
	_update_data()

func _update_data():
	var current_ingr: Ingredient
	match current_ingr_key:
		0:
			current_ingr = thistleRoot
		1:
			current_ingr = nightshade
		2:
			current_ingr = sunFlower
		3:
			current_ingr = pineResin
		4:
			current_ingr = peppermint
		5:
			current_ingr = owlFeather
		6:
			current_ingr = poisonIvy
		7:
			current_ingr = frogLeg
		8:
			current_ingr = batWing
		9:
			current_ingr = eyeOfNewt
	
	
	# Change all the data
	ingrName.text = current_ingr.name
	description.text = current_ingr.description
	ingredient.texture = current_ingr.image
	var valuesArray = values.get_children()
	
	valuesArray[0].get_node("Value").text = str(current_ingr.effects.healing_poison) 
	valuesArray[1].get_node("Value").text = str(current_ingr.effects.warm_cold)
	valuesArray[2].get_node("Value").text = str(current_ingr.effects.calming_agitation)
	valuesArray[3].get_node("Value").text = str(current_ingr.effects.strength_weakness)
	valuesArray[4].get_node("Value").text = str(current_ingr.effects.energy_fatigue)
	valuesArray[5].get_node("Value").text = str(current_ingr.effects.light_dark)
	valuesArray[6].get_node("Value").text = str(current_ingr.effects.luck_misfortune)
	valuesArray[7].get_node("Value").text = str(current_ingr.effects.clarity_confusion)
	valuesArray[8].get_node("Value").text = str(current_ingr.effects.defense_vulnerability)
	valuesArray[9].get_node("Value").text = str(current_ingr.effects.swiftness_slowness)
	
	#for i in valuesArray.size():
		#valuesArray[i].value 
	
	# yada yada
	
	
	
	
	
	
	
	
	pass


func _on_forward_pressed() -> void:
	if (current_ingr_key < (max_ingr - 1)):
		anim.play("Forward")
	else:
		pass
	
	


func _on_back_pressed() -> void:
	if (current_ingr_key > 0):
		anim.play("Backward")
	else:
		pass
