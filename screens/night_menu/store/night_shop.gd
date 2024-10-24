extends Node

@onready var totalCostLabel   := $UiLayer/TotalCostPanelContainer/TotalCostMarginContainer/TotalCostLabel
@onready var LocationDisplays := $LocationShelf.get_children()
@onready var ExoticDisplays   := $ExoticShelf.get_children()

var totalCost = 0;

func _ready():
	$UiLayer/PlayerMoneyPanelContainer/PlayerMoneyMarginContainer/PlayerMoneyLabel.text = "$" + str(PlayerData.money)
	
	## Add ingredient displays for current location
	var current_location_ingredients = Array(PlayerData.location.ingredients)
	current_location_ingredients.shuffle()
	current_location_ingredients = current_location_ingredients.slice(0, 10)
	for i in range(0, current_location_ingredients.size()):
		var ingredient = current_location_ingredients[i]
		var display = LocationDisplays[i]
		display.quantity = randi_range(1, 5)
		var price = 0
		for effect in ingredient.effects.get_strongest():
			price += abs(ingredient.effects.get_strength(effect)) * effect.money_factor
		price /= 7 ## This number can be changed, anywhere between 5 and 10 is probably reasonable
		display.price = round(price)
	
	## Add ingredient displays for other locations
	#TODO
	
	## Add station option for current location
	#TODO


func _updateTotal(changeAmount:int):
	totalCost += changeAmount
	totalCostLabel.text = "Total Cost: $" + str(totalCost)
	

func _on_buy_button_pressed():
	#TODO make buy work
	if PlayerData.money >= totalCost:
		PlayerData.money -= totalCost
		#TODO make shopkeeper say something before leaving
		get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
	else:
		#TODO make shopkeeper say this
		print("Not enough money")


func _on_exit_button_pressed():
	#TODO make shopkeeper say something before leaving
	get_tree().change_scene_to_file("res://screens/main/packed_main.tscn")
