extends CanvasLayer

# const CHAR_READ_RATE = 0.05 # might use this

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/Label

@export var order: String


func _ready(): # keep this there is a bug, for now
	add_text("text to be added!")

func hide_textbox():
	label.text = ""
	textbox_container.hide() # hides the text only
	
func show_textbox():
	textbox_container.show()
	
func add_text(next_text):
		label.text = order
		show_textbox()


