extends Node

var forage = preload("res://screens/night_menu/forage/forage.tscn") # preload night menu scenes
var shop = preload("res://screens/night_menu/store/night_shop.tscn")
var map = preload("res://screens/night_menu/map/night_map.tscn")

var main

func _ready():
	GameTime.hour = GameTime.STORE_CLOSE_TIME
	$"Shutter/CenterContainer/VBoxContainer/HBoxContainer/SalesNumber".text = "$%d" % PlayerData.moneyToday # change text on shutter to match money earned today
	$"Shutter/CenterContainer/VBoxContainer/HBoxContainer/ReputationNumber".text = "%d Reputation" % PlayerData.repToday# change text on shutter to match reputation earned today
	var darkness = $CanvasLayer/Darkness
	var tween = create_tween() 
	tween.tween_property(darkness, "modulate:a", 150, 5) #tween transarancy of darkness
	tween.parallel().tween_property($NightThemePlayer, "volume_db", -15, 5)
	
	var group = get_tree().get_nodes_in_group("main") # set main as node in group main. Necessary as name of main changes
	main = group[0]

func _on_buy_button_pressed(): 
	var group = get_tree().get_nodes_in_group("main") # get main scene
	main = group[0]
	#tween out song
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($NightThemePlayer, "volume_db", -40, 0.5)
	await tween.finished
	$NightThemePlayer.stop()
	
	#pause main
	main.visible = false
	main.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	main.process_mode = Node.PROCESS_MODE_DISABLED
	
	#pause shutter
	$Shutter.visible = false
	$Shutter.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	$Shutter.process_mode = Node.PROCESS_MODE_DISABLED
	
	#start Nightshop
	$NightShop.visible = true
	$NightShop/NightShop/Music_Player.volume_db = -15
	$NightShop/NightShop/Music_Player.play()
	$NightShop/NightShop.shop_done.connect(_on_action_done) # connect signal
	$NightShop.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON

func _on_forage_button_pressed():
	var instance = forage.instantiate() # instantiate forage scene
	add_child(instance)
	$CanvasLayer/ForageButton.disabled = true # disable forage button from being pressed again
	instance.forage_done.connect(_on_action_done) # connect signal

func _on_move_button_pressed():	
	#tween out song
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($NightThemePlayer, "volume_db", -40, 0.5)
	await tween.finished
	$NightThemePlayer.stop()
	var instance = map.instantiate() # instantiate map schene
	$Map.add_child(instance)
	instance.move_done.connect(_on_action_done) # connect signal
	$CanvasLayer/MoveButton.disabled = true # disable map button from being pressed again
	
	var group = get_tree().get_nodes_in_group("main") # get main scene
	main = group[0]
	#pause main
	main.visible = false
	main.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	main.process_mode = Node.PROCESS_MODE_DISABLED
	
	#pause shutter
	$Shutter.visible = false
	$Shutter.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	$Shutter.process_mode = Node.PROCESS_MODE_DISABLED
	
	

func _on_action_done():
	#start shutter
	$Shutter.visible = true
	$Shutter.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
	$Shutter.process_mode = Node.PROCESS_MODE_ALWAYS

	#stop Nightshop
	$NightShop.visible = false
	$NightShop.process_mode = Node.PROCESS_MODE_INHERIT
	$NightShop.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

	var group = get_tree().get_nodes_in_group("main") # get main scene
	main = group[0]
	
	#tween out song
	$NightThemePlayer.play()
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($NightThemePlayer, "volume_db", -15, 3)
	
	#start main
	main.visible = true
	main.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
	main.process_mode = Node.PROCESS_MODE_INHERIT
	
	var packed_scene = PackedScene.new() 
	packed_scene.pack(main) #gets the main scene and all things it owns 
	ResourceSaver.save(packed_scene, "res://screens/main/packed_main.tscn" ) # overwrite old packed main with new packed main
	
	#reload main to refresh inventory
	main.queue_free() # delete main scene in scene 
	var packed_main = load("res://screens/main/packed_main.tscn") # load packed main scene
	var instance = packed_main.instantiate() # instantiate main scene
	add_child(instance, true)
	instance.name = "Main2" 
