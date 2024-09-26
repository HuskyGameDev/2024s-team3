extends HBoxContainer

var ingredient: Ingredient

func _ready():
	$NameLabel.text = ingredient.name
	$DescriptionLabel.text = ingredient.description
	$StackSizeLabel.text = ingredient.stack_size
	$EffectLabel.text = ""
	$ImageLabel.texture = ingredient.image
