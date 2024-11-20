extends Node2D

const CAULDRON_EMPTY_COLOR = Vector3(0.1725, 0.1333, 0.1804)

var current_effects: EffectSet = EffectSet.new()
var has_ingredients: bool = false

var volume: int = -25
var delay: float = 0.5
var time: float = 0.5

@onready var SpriteShader:ShaderMaterial = $Sprite.material
@onready var correctSound:AudioStream = preload("res://common/audio/Finish_Potion.wav")
@onready var failedSounds:Array[AudioStream] = [preload("res://common/audio/Fail_Potion_1.wav"), preload("res://common/audio/Fail_Potion_2.wav"), preload("res://common/audio/Fail_Potion_3.wav")]
var failedDelays:Array[float] = [0.15, 0.4, 0.3]
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

signal potion_made(potion: Potion, pos: Vector2)
signal water_spawn

func _ready():
	SpriteShader.set_shader_parameter("make_flat", true)
	SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)
	$Bubbler.stop()


func _on_body_enter_cauldron(body):
	print("Not an ingredient")
	if not "data" in body: return
	if not body.data is Ingredient: return
	## Animate object movement to top of cauldron
	body.gravity_scale = 0
	var top_of_cauldron = self.position - Vector2(0, 80)
	var ingredient_position = body.global_position
	var time_to_animate = (top_of_cauldron.distance_to(ingredient_position)) / 1000
	var tween = create_tween().bind_node(body)
	tween.tween_property(body, "global_position", top_of_cauldron, time_to_animate).from(ingredient_position)
	await tween.finished
	## Add effects to cauldron's potion, check if water first
	has_ingredients = true
	if body.name == "Water":
		current_effects.half_strength(current_effects)
		SpriteShader.set_shader_parameter("make_flat", false)
		SpriteShader.set_shader_parameter("to", current_effects.get_color())
		print(current_effects)
		water_spawn.emit()
		body.queue_free()
		return
	current_effects.add(body.data.effects)
	SpriteShader.set_shader_parameter("make_flat", false)
	SpriteShader.set_shader_parameter("to", current_effects.get_color())
	print(current_effects)
	body.queue_free()
	## Set bubbler volume
	$Bubbler.playing = true
	volume = (volume*3/4)+5/2
	$Bubbler.volume_db = volume


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if has_ingredients:
			has_ingredients = false
			var potion = Potion.new()
			potion.effects = current_effects
			potion.image = ResourcePaths.get_random_potion_sprite()
			$Poofer.set_stream(correctSound)
			$Poofer.volume_db = -10
			delay = 0.4
			time = 0.5
			if potion.effects.all_null() || potion.effects.get_strongest_as_strings().size() > 4:
				var index:int = rng.randi_range(0,2)
				$Poofer.set_stream(failedSounds[index])
				delay = failedDelays[index]
				time = 0
			$Poofer.play(delay)
			await get_tree().create_timer(time).timeout
			potion_made.emit(potion, self.global_position - Vector2(0, 100))
			current_effects = EffectSet.new()
			SpriteShader.set_shader_parameter("make_flat", true)
			SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)
			## stop bubbling
			$Bubbler.playing = false
			volume = -25
