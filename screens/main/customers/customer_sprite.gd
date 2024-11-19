extends Node2D

###### SPRITES ######
## EYES
const EyesDir := "res://screens/main/customers/sprites/eyes"
const eyes := [ "big_eyes", "small_eyes" ]

## NOSE
const NoseDir := "res://screens/main/customers/sprites/noses"
const noses := [ "big_nose", "small_nose", "tall_nose" ]

## MOUTH
const MouthDir := "res://screens/main/customers/sprites/mouths/"
const mouths := [ "big_mouth", "small_mouth" ]

## NECKLINE
const NecklineDir := "res://screens/main/customers/sprites/necklines"
const female_necklines    := [ "cutout_neckline", "deep_u_neckline", "sweetheart_neckline" ]
const neutral_necklines   := [ "collared_v_neckline", "crewneck_neckline", "deep_v_neckline", "high_neckline", "rectangle_neckline", "square_neckline" ]
const no_sleeve_necklines := [ "collared_sweetheart_neckline", "off_shoulder_neckline" ] # these are female only too

## SLEEVES
const SleevesDir := "res://screens/main/customers/sprites/sleeves"
const female_sleeves  := [ "juliet_sleeves", "puff_sleeves" ]
const neutral_sleeves := [ "3_4_sleeves", "bishop_sleeves", "flared_sleeves", "full_sleeves", "petal_sleeves", "poet_sleeves" ]

## HAIR
const HairDir := "res://screens/main/customers/sprites/hair"
const short_hair  := [ "hair_1", "hair_2", "hair_6", "hair_9", "hair_13" ]
const medium_hair := [ "hair_5", "hair_7", "hair_8", "hair_10", "hair_12" ]
const long_hair   := [ "hair_3", "hair_4", "hair_11" ]

###### PALETTES ######
static var skin_palette:Image    = preload("res://screens/main/customers/sprites/skin_palette.png").get_image()
static var eye_palette:Image     = preload("res://screens/main/customers/sprites/eye_palette.png").get_image()
static var clothes_palette:Image = preload("res://screens/main/customers/sprites/clothes_palette.png").get_image()
static var hair_palette:Image    = preload("res://screens/main/customers/sprites/hair_palette.png").get_image()

func get_random_from_palette(palette:Image) -> Color:
	# we subtract 1 because randi_range is inclusive on both ends
	var x = randi_range(0, palette.get_width() - 1)
	var y = randi_range(0, palette.get_height() - 1)
	return palette.get_pixel(x, y)

###### WEIGHTS ######
# all weights should be between 0 and 1 (0% to 100%)
const percent_male = 0.5
const percent_long_hair_female = 0.5
const percent_short_hair_female = 0.1
const percent_long_hair_male = 0.1
const percent_short_hair_male = 0.5

###### SHADERS ######
@onready var baseShader:ShaderMaterial = $Base.material
@onready var eyesShader:ShaderMaterial = $Eyes.material
@onready var noseShader:ShaderMaterial = $Nose.material
@onready var mouthShader:ShaderMaterial = $Mouth.material
@onready var necklineShader:ShaderMaterial = $Neckline.material
@onready var sleevesShader:ShaderMaterial = $Sleeves.material
@onready var hairShader:ShaderMaterial = $Hair.material

##### RANDOMIZERS #####
func randomize_face():
	$Eyes.texture  = ResourceLoader.load("%s/%s.png" % [EyesDir, eyes.pick_random()])
	$Nose.texture  = ResourceLoader.load("%s/%s.png" % [NoseDir, noses.pick_random()])
	$Mouth.texture = ResourceLoader.load("%s/%s.png" % [MouthDir, mouths.pick_random()])


func randomize_clothes(isMale:bool):
	if isMale:
		$Neckline.texture = ResourceLoader.load("%s/%s.png" % [NecklineDir, neutral_necklines.pick_random()])
		$Sleeves.texture  = ResourceLoader.load("%s/%s.png" % [SleevesDir, neutral_sleeves.pick_random()])
	else:
		var sleeve_necklines = female_necklines + neutral_necklines
		if randi_range(0, sleeve_necklines.size() + no_sleeve_necklines.size()) < no_sleeve_necklines.size():
			$Neckline.texture = ResourceLoader.load("%s/%s.png" % [NecklineDir, no_sleeve_necklines.pick_random()])
			$Sleeves.texture = null
		else:
			$Neckline.texture = ResourceLoader.load("%s/%s.png" % [NecklineDir, sleeve_necklines.pick_random()])
			$Sleeves.texture  = ResourceLoader.load("%s/%s.png" % [SleevesDir, (female_sleeves + neutral_sleeves).pick_random()])


func randomize_hair(isMale:bool):
	var weight = randf()
	if isMale:
		if weight < percent_short_hair_male:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, short_hair.pick_random()])
		elif weight > percent_long_hair_male:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, long_hair.pick_random()])
		else:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, medium_hair.pick_random()])
	else:
		if weight < percent_short_hair_female:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, short_hair.pick_random()])
		elif weight > percent_long_hair_female:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, long_hair.pick_random()])
		else:
			$Hair.texture = ResourceLoader.load("%s/%s.png" % [HairDir, medium_hair.pick_random()])


func randomize_palette():
	var skin_tone = get_random_from_palette(skin_palette)
	baseShader.set_shader_parameter("to", skin_tone)
	noseShader.set_shader_parameter("to", skin_tone)
	mouthShader.set_shader_parameter("to", skin_tone)
	
	# if the eye color has a higher luminance than the skin tone, we darken the eyes
	var eye_color = get_random_from_palette(eye_palette)
	while eye_color.get_luminance() >= skin_tone.get_luminance():
		eye_color = eye_color.darkened(0.25)
	eyesShader.set_shader_parameter("to", eye_color)
	
	var shirt_color = get_random_from_palette(clothes_palette)
	necklineShader.set_shader_parameter("to", shirt_color)
	sleevesShader.set_shader_parameter("to", shirt_color)
	
	# if the hair color has a much higher luminance than the skin tone, we
	# darken the hair and lerp it closer to the skin tone
	var hair_color = get_random_from_palette(hair_palette)
	while hair_color.get_luminance() >= skin_tone.get_luminance() * 1.5:
		hair_color = hair_color.darkened(0.2)
		hair_color = hair_color.lerp(skin_tone, 0.2)
	hairShader.set_shader_parameter("to", hair_color)


## Randomizes the customer sprite
func _ready():
	# Set sprite offsets (all non-hair sprites are 64x64 where the first 32 
	# pixels are female variants and the second are male variants)
	var isMale = randf() < percent_male
	[$Base, $Eyes, $Nose, $Mouth, $Neckline, $Sleeves].map(func(node):
		node.region_rect.position.x = 32 if isMale else 0
	)
	randomize_face()
	randomize_clothes(isMale)
	randomize_hair(isMale)
	randomize_palette()
