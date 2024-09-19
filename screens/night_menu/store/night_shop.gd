extends Node

const NUMBER_OF_ITEMS = 4

var offeringScene = preload("res://screens/night_menu/store/night_shop_ingredient.tscn")
var totalCostLabel:Label

var totalCost = 0;

func _ready():
	var shopOfferings = PlayerData.location.get_shop_offerings(NUMBER_OF_ITEMS)
	totalCostLabel = $"TotalInfoVBox/TotalCostLabel"
	var moneyLabel = $"MoneyLabel"
	var hbox = $"OfferingsHBox"
	
	moneyLabel.text = "$" + str(PlayerData.money)
	
	## Dictionary with keys quantity, cost, and item (which is an ingredient)
	for i:Dictionary in shopOfferings:
		var newOffering = offeringScene.instantiate()
		newOffering.call("setData", i)
		hbox.add_child(newOffering)
		newOffering.add_to_group("ingredientsForSale")
		newOffering.totalChanged.connect(_updateTotal)
	hbox.move_child(hbox.add_spacer(true), floor(NUMBER_OF_ITEMS/2))


func _updateTotal(changeAmount:int):
	totalCost += changeAmount
	totalCostLabel.text = "Total $" + str(totalCost)
	

func _on_buy_button_pressed():
	if PlayerData.money >= totalCost:
		get_tree().call_group("ingredientsForSale", "handlePurchase")
		PlayerData.money -= totalCost
		get_tree().change_scene_to_file("res://screens/main/main.tscn")
	else:
		print("Not enough money")


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://screens/main/main.tscn")
