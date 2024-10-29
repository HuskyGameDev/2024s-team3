extends Node2D

const CAULDRON_EMPTY_COLOR = Vector3(0.1725, 0.1333, 0.1804)

var current_effects: EffectSet = EffectSet.new()
var has_ingredients: bool = false
var volume: int = -15
var making_potion: bool = false

@onready var SpriteShader:ShaderMaterial = $Sprite.material

signal potion_made(potion: Potion, pos: Vector2)

func _ready():
	SpriteShader.set_shader_parameter("make_flat", true)
	SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)


func _on_body_enter_cauldron(body):
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
	## Add effects to cauldron's potion
	has_ingredients = true
	current_effects.add(body.data.effects)
	SpriteShader.set_shader_parameter("make_flat", false)
	SpriteShader.set_shader_parameter("to", current_effects.get_color())
	body.queue_free()
	if (volume<10): 
		volume = volume + 5
		if (!$Bubbler.playing): $Bubbler.playing = true
		$Bubbler.volume_db = volume


func _on_cauldron_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		if has_ingredients && !making_potion: 
			making_potion = true
			$CauldronFinishPlayer.play(0.43)
			await get_tree().create_timer(0.47).timeout
			var potion = Potion.new()
			potion.effects = current_effects
			potion.image = ResourcePaths.get_random_potion_sprite()
			potion_made.emit(potion, self.global_position - Vector2(0, 100))
			has_ingredients = false
			current_effects = EffectSet.new()
			volume = -15
			$Bubbler.volume_db=volume
			$Bubbler.playing = false
			making_potion = false
			SpriteShader.set_shader_parameter("make_flat", true)
			SpriteShader.set_shader_parameter("to", CAULDRON_EMPTY_COLOR)
