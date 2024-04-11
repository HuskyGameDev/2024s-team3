extends Sprite2D

var rotation_speed = 0.0001
@onready var tween = create_tween()

func _ready():
	tween.tween_method(_symbol_rotation, 0, 360, (abs(GameTime.STORE_OPEN_TIME - GameTime.STORE_CLOSE_TIME) * GameTime.GAME_TIME_SCALE)).set_trans(Tween.TRANS_LINEAR)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#global_rotation -= rotation_speed



func _symbol_rotation(value: int):
	rotation_degrees = -value
