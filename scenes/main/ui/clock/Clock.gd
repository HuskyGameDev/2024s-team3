extends Node2D

@onready var dayLabel = $Day
@onready var timeCircles = $"Time Circles"
@onready var symbol9 = $"Time Circles/Time Symbol9"
@onready var tween = create_tween()

var rotation_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	tween.tween_method(_clock_rotation, 0, 360, (abs(GameTime.STORE_OPEN_TIME - GameTime.STORE_CLOSE_TIME) * GameTime.GAME_TIME_SCALE)).set_trans(Tween.TRANS_LINEAR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dayLabel.text != str(GameTime.day):
		dayLabel.text = str(GameTime.day)

func _clock_rotation(value: int):
	timeCircles.rotation_degrees = value
