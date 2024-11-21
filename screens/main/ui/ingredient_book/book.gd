extends Node2D

@onready var sprite = $Sprite
@onready var ingredient = $Ingredient
@onready var description = $Description
@onready var forward = $Forward
@onready var back = $Back
@onready var anim = $"Book Animation"
@onready var values = $Values
@onready var ingrName = $Name

#
#var batWing = preload("res://common/items/ingredients/bat_wing/bat_wing.tres")
#var frogLeg = preload("res://common/items/ingredients/frog_leg/frog_leg.tres")
#var nightshade = preload("res://common/items/ingredients/nightshade_petals/nightshade_petals.tres")
#var owlFeather = preload("res://common/items/ingredients/owl_feather/owl_feather.tres")
#var peppermint = preload("res://common/items/ingredients/peppermint_leaves/peppermint_leaves.tres")
#var pineResin = preload("res://common/items/ingredients/pine_resin/pine_resin.tres")
#var poisonIvy = preload("res://common/items/ingredients/poison_ivy/poison_ivy.tres")
#var sunFlower = preload("res://common/items/ingredients/sunflower_seeds/sunflower_seeds.tres")
#var thistleRoot = preload("res://common/items/ingredients/thistle_root/thistle_root.tres")
#var eyeOfNewt = preload("res://common/items/ingredients/eye_of_a_newt/eye_of_a_newt.tres")


@export var bookButton: TextureButton


var playData
var knownIngredients: Array

var up: bool = false

var current_ingr_key
@export var max_ingr: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	current_ingr_key = PlayerData.bookPageNumber
	
	
	playData = PlayerData.visited_locations
	
	for x in playData.size():
		var location = ResourceLoader.load(ResourcePaths.get_location_path(playData[x].id))
		for y in location.ingredients.size():
			knownIngredients.append(location.ingredients[y])
	
	
	_update_data()

func _move_up():
	if (!up):
		bookButton.disabled = true
		bookButton.hide()
		position = Vector2(306, 858)
		up = true
	else:
		bookButton.disabled = false
		bookButton.show()
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
	current_ingr = knownIngredients[current_ingr_key]
	
	
	
	
	
	
	
	
	
	#
	#match current_ingr_key:
		#0:
			#current_ingr = thistleRoot
		#1:
			#current_ingr = nightshade
		#2:
			#current_ingr = sunFlower
		#3:
			#current_ingr = pineResin
		#4:
			#current_ingr = peppermint
		#5:
			#current_ingr = owlFeather
		#6:
			#current_ingr = poisonIvy
		#7:
			#current_ingr = frogLeg
		#8:
			#current_ingr = batWing
		#9:
			#current_ingr = eyeOfNewt
	
	
	# Change all the data
	ingrName.text = current_ingr.name
	description.text = current_ingr.description
	ingredient.texture = current_ingr.image
	var valuesArray = values.get_children()
	
	valuesArray[0].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.HEALING_POISON)) 
	valuesArray[1].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.WARM_COLD)) 
	valuesArray[2].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.CALMING_AGITATION)) 
	valuesArray[3].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.STRENGTH_WEAKNESS)) 
	valuesArray[4].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.ENERGY_FATIGUE)) 
	valuesArray[5].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.LIGHT_DARK)) 
	valuesArray[6].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.LUCK_MISFORTUNE)) 
	valuesArray[7].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.CLARITY_CONFUSION)) 
	valuesArray[8].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.DEFENSE_VULNERABILITY)) 
	valuesArray[9].get_node("Value").text = str(current_ingr.effects.get_strength(EffectSet.SWIFTNESS_SLOWNESS)) 
	
	#for i in valuesArray.size():
		#valuesArray[i].value 
	
	# yada yada
	
	
	PlayerData.bookPageNumber = current_ingr_key
	
	
	
	
	
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
