extends Node2D

@export var pivotPoint: Node2D

@onready var nodeSymbol = $NodeSymbol

@export var clockRotationSpeed = 1
var clockRotationSpeedReductionRate = clockRotationSpeed * 3
var originalSpeed

var shouldRotate = false
var shouldBackRotate = false
var startingPoint
var radiansTraveled = 0.0
var paused = false # tracks if game is currently paused

@export var radianDivisor = 4
@export var backRadianDivisor = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	#GameTime.connect("pause", on_pause) #connrect to pause signal from global script gametime
	get_parent().get_parent().timerWentOff.connect(_rotate)
	originalSpeed = clockRotationSpeed
	


func _rotate():
	#if paused == false: # only rotate if unpaused
	startingPoint = position
	shouldBackRotate = true
	shouldRotate = true


func _physics_process(delta):
	if shouldRotate == true && paused == false: # only rotate if unpaused
		#first rotate back 1 pixel for animation purposes
		if shouldBackRotate == true:
			var toObject: Vector2 = position - pivotPoint.position
			toObject = toObject.rotated(clockRotationSpeed * -delta)
			position = pivotPoint.position + toObject
			radiansTraveled += clockRotationSpeed * delta
			clockRotationSpeed -= clockRotationSpeedReductionRate * delta
			if radiansTraveled >= PI/backRadianDivisor:
				shouldBackRotate = false
				radiansTraveled = -PI/backRadianDivisor
				clockRotationSpeed = originalSpeed - .1
				
		#then rotate to where we need to be
		else:
			var toObject: Vector2 = position - pivotPoint.position
			toObject = toObject.rotated(clockRotationSpeed * delta)
			#position = position.lerp(pivotPoint.position + toObject, delta * clockRotationSpeed)
			position = pivotPoint.position + toObject
			radiansTraveled += clockRotationSpeed * delta
			if radiansTraveled > PI/ (backRadianDivisor - 10) && clockRotationSpeed >= 0.5:
				clockRotationSpeed -= delta *  clockRotationSpeedReductionRate
				
			if radiansTraveled >= PI/radianDivisor:
				position = startingPoint.rotated(PI/radianDivisor)
				shouldRotate = false
				radiansTraveled = 0.0
				clockRotationSpeed = originalSpeed

 # runs when signaled, pausing or unpausing the rotation of the clock
#func on_pause():
		#if paused == true: # if paused
			#paused = false # unpause
		#else:
			#paused = true # pause
