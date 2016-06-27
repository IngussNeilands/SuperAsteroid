
extends Sprite

export var text = "BUTTON"

func _ready():
	pass

func setText(s):
	text = s
	get_node("Label").set_text(text)

