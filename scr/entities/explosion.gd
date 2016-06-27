
extends AnimationPlayer

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("Sound").play("Explosion")
		
func set_pos(pos):
	get_node("Sprite").set_pos(pos)

func _on_Small_Explosion_finished():
	queue_free()
