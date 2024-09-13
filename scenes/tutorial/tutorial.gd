extends Node

var thistle = false

func next_step(id): #tutorial progression
	var nightShadeText = get_node("Tutorial/NightShadeText")
	var thistleRootText = get_node("Tutorial/ThistlerootText")
	var cauldronText = get_node("Tutorial/CauldronText")
	var potionText = get_node("Tutorial/PotionText")
	var finishText = get_node("Tutorial/FinishText")
	if id == "nightshade_petals" && nightShadeText.visible == true && (finishText.visible == false):
		nightShadeText.visible = false
		if (thistle == true):
			cauldronText.visible = true
		else:
			thistleRootText.visible = true
	elif id == "thistle_root" && thistleRootText.visible == true && (finishText.visible == false):
		thistleRootText.visible = false
		cauldronText.visible = true
	elif id == "healing_potion" && (potionText.visible == false && (finishText.visible == false)):
		nightShadeText.visible = false
		thistleRootText.visible = false
		cauldronText.visible = false
		potionText.visible = true
	elif id == "healing_potion" && potionText.visible == true && (finishText.visible == false):
		potionText.visible = false
		finishText.visible = true
		await get_tree().create_timer(8).timeout 
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	elif id == "thistle_root":
		thistle = true
