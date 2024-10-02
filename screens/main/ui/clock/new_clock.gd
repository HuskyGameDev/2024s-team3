extends Node2D

## If you want to change the number of nodes in the clock you have to change the radian divisor as well, both here and in the clock node script
## So 12 is 6, 8 nodes would mean a radian divisor of 3, 4 nodes would be 2, etc
@export var numberOfNodes = 8
@export var radianDivisor = 4


@onready var clockNodeHolder = %ClockNode_Holder
@onready var markerHolder = %MarkerHolder
@onready var timer = $Timer
@onready var progressBar = $TextureProgressBar
@onready var label = $Label
@onready var clockNodeInstance = preload("res://screens/main/ui/clock/new_clock_node.tscn")

@onready var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)


signal timerWentOff

# Called when the node enters the scene tree for the first time.
func _ready():
	var markers = markerHolder.get_children()
	for x in numberOfNodes:
		var instance = clockNodeInstance.instantiate()
		clockNodeHolder.add_child(instance)
		
		instance.pivotPoint = %ClockFace
		instance.position = markers[0].position.rotated(x * PI/radianDivisor)
		instance.nodeSymbol.region_rect = Rect2((x * 6) + 1, 0, 4, 6)
	
	timer.wait_time = GameTime.GAME_TIME_SCALE
	progressBar.value = 0
	label.text = str(GameTime.day)
	
	tween.tween_property(progressBar,"value", 100, abs(GameTime.STORE_OPEN_TIME - GameTime.STORE_CLOSE_TIME) * GameTime.GAME_TIME_SCALE)
	timer.start()


#var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
#tween.tween_property($Sprite, "modulate", Color.RED, 1)
#tween.tween_property($Sprite, "scale", Vector2(), 1)
#tween.tween_callback($Sprite.queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var past: float = .01
	#progressBar.value += (GameTime.GAME_TIME_SCALE) * delta
	pass
	#print(past)
	#print(1.0/GameTime.GAME_TIME_SCALE)
	#print(progressBar.value)


func _on_timer_timeout():
	print(progressBar.value)
	#tween.stop()
	#tween.finished
	#tween.tween_property(progressBar,"value",(GameTime.hour + 1) * (100/abs(GameTime.STORE_OPEN_TIME - GameTime.STORE_CLOSE_TIME)), GameTime.GAME_TIME_SCALE)
	emit_signal("timerWentOff")
	print("Timer")
