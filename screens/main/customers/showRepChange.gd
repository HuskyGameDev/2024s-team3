extends Node2D

@onready var repLabel = $RepLabel

func _ready() -> void:
	repLabel.show()
	if get_parent().has_signal("repChanged"):
		get_parent().repChanged.connect(displayRep)
		print("repchanged")

func displayRep(new_rep: int): 
	repLabel.text = str(new_rep)
	repLabel.show()
