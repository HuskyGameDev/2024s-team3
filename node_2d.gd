extends Node2D

@onready var repLabel = $RepLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	repLabel.hide
	get_parent().connect("repChanged", self, "displayRep")
	pass # Replace with function body.

func displayRep(new_rep: int): 
	repLabel.text = str(new_rep)
	repLabel.show
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
