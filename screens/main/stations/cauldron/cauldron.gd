extends Node2D

const CAULDRON_EMPTY_COLOR = Vector3(0.1725, 0.1333, 0.1804)

var current_effects: EffectSet = EffectSet.new()
var has_ingredients: bool = false

var volume: int = -10
var delay: float = 0.5
var time: float = 0.5
var ingredient_count = 0 # keep track of number of ingredients added to cauldron (for tooltip)

const packed_tooltip: PackedScene = preload("res://ui/tooltip/tooltip.tscn")
@onready var anim = $AnimationPlayer
var globalPotion: Potion
@onready var SpriteShader:ShaderMaterial = $Sprite.material

@onready var correctSound:AudioStream = preload("res://common/audio/Finish_Potion.wav")
@onready var failedSounds:Array[AudioStream] = [preload("res://common/audio/Fail_Potion_1.wav"), preload("res://common/audio/Fail_Potion_2.wav"), preload("res://common/audio/Fail_Potion_3.wav")]
@onready var splashSounds:Array[AudioStream] = [preload("res://common/audio/Cauldron_Splash_1.wav"), preload("res://common/audio/Cauldron_Splash_2.wav")]


var tooltip: Node
@onready var cauldronRightClicked = $ClickableArea/CollisionShape2D/Button

var failedDelays:Array[float] = [0.15, 0.4, 0.3]
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

signal potion_made(potion: Potion, pos: Vector2)
signal water_spawn



func _ready():
	tooltip = packed_tooltip.instantiate()
	tooltip.visible = false
	add_child(tooltip)
	tooltip.set_text("Cauldron Ingredients", "")
	tooltip.hide()
	SpriteShader.set_shader_parameter("make_flat", true)
	SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)
	$Bubbler.stop()
	$Splasher.stop()


func _on_body_enter_cauldron(body):
	
	
	print("Not an ingredient")
	if not "data" in body: return
	if not body.data is Ingredient: return

	# add ingredient name in cauldron to tooltip
	ingredient_count += 1
	if(ingredient_count > 1):
		tooltip.add_text(", ")
	tooltip.add_text(body.data.name)
	
	## Animate object movement to top of cauldron
	body.gravity_scale = 0
	var top_of_cauldron = self.position - Vector2(0, 80)
	var ingredient_position = body.global_position
	var time_to_animate = (top_of_cauldron.distance_to(ingredient_position)) / 1000
	var tween = create_tween().bind_node(body)
	tween.tween_property(body, "global_position", top_of_cauldron, time_to_animate).from(ingredient_position)
	await tween.finished
	## Add effects to cauldron's potion, check if water first
	if body.name == "Water":
		print("Water!")
		if (current_effects.get_strongest().size() != 0):
			current_effects.half_strength(current_effects)
			SpriteShader.set_shader_parameter("make_flat", false)
			SpriteShader.set_shader_parameter("to", current_effects.get_color())
		print(current_effects)
		# body.queue_free()
		body.free()
		water_spawn.emit()
		return
	has_ingredients = true
	current_effects.add(body.data.effects)
	SpriteShader.set_shader_parameter("make_flat", false)
	SpriteShader.set_shader_parameter("to", current_effects.get_color())
	print(current_effects)
	body.queue_free()
	
	# Play splash sound
	var rand:int = rng.randi_range(0,1)
	$Splasher.set_stream(splashSounds[rand])
	$Splasher.volume_db = -7
	$Splasher.play()
	
	## Set bubbler volume
	$Bubbler.playing = true
	volume = (volume*3/4)+5
	$Bubbler.volume_db = volume


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if has_ingredients:
			tooltip.set_text("Cauldron Ingredients", "")
			ingredient_count = 0
			has_ingredients = false
			var potion = Potion.new()
			potion.effects = current_effects
			potion.image = ResourcePaths.get_random_potion_sprite()
			globalPotion = potion
			
			
			$Poofer.set_stream(correctSound)
			$Poofer.volume_db = -7
			delay = 0.4
			time = 0.5
			var strongest:Array = potion.effects.get_strongest_as_strings()
			print(strongest.size())
			var isRightSize:bool = false
			if (strongest.size()>3):
				print("Strongest[3]:")
				var eff:String = strongest[3]
				if (!eff.contains("Slight")): isRightSize = true
				print(strongest[3])
			if potion.effects.all_null() || isRightSize:
				anim.play("Fail")
				var index:int = rng.randi_range(0,2)
				$Poofer.set_stream(failedSounds[index])
				delay = failedDelays[index]
				time = 0
				$Poofer.volume_db = 7
			else:
				anim.play("Stir")
			$Poofer.play(delay)
			await get_tree().create_timer(time).timeout
			
			
			




func emit_potion():
	potion_made.emit(globalPotion, self.global_position - Vector2(0, 100))
	current_effects = EffectSet.new()
	SpriteShader.set_shader_parameter("make_flat", true)
	SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)
	## stop bubbling
	$Bubbler.playing = false
	volume = -10
	globalPotion = null


var mouseInside = true ## show tooltip if mouse is over cauldron and right click is pressed
func _on_clickable_area_mouse_entered() -> void:
	mouseInside = true
	
# show tooltip when cauldron is right clicked
func _on_button_pressed() -> void:
	tooltip.global_position = self.global_position
	
	var viewport_rect = get_viewport_rect()
	var tooltip_rect = tooltip.get_rect()
	while not viewport_rect.encloses(tooltip_rect):
		## horizontal alignment
		if viewport_rect.position.x > tooltip_rect.position.x:
			tooltip.global_position.x += 25
		elif viewport_rect.end.x < tooltip_rect.end.x:
			tooltip.global_position.x -= 25
		## vertical alignment
		if viewport_rect.position.y > tooltip_rect.position.y:
			tooltip.global_position.x += 25
		elif viewport_rect.end.y < tooltip_rect.end.y:
			tooltip.global_position.y -= 25
		tooltip_rect = tooltip.get_rect()
		
	tooltip.show()
		
		
# hide tooltip when mouse leaves cauldorn area
func _on_clickable_area_mouse_exited() -> void:
	tooltip.hide()
	mouseInside = false
	
