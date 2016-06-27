
extends KinematicBody2D

const SPEED = 1600

var dir = Vector2(1,0)
var life = 5

var explosion

func _ready():
	explosion = load("res://entities/small_explosion.xml")
	
	set_fixed_process(true)
	
func _fixed_process(dt):
	life -= dt
	if (life <= 0):
		destroy()
		
	move(dir * SPEED * dt)
	
	if (is_colliding()):
		if (get_collider().is_in_group("monster")):
			get_collider().hitPlayerBullet()
		
		if (get_collider().is_in_group("destructible")):
			get_collider().destroy()
			
		if not (get_collider().is_in_group("player")):	
			destroy()
	
func setDir(direction):
	# expects Vector2
	dir = direction
	
	if (dir.x < 0):
		get_node("Sprite").set_flip_h(true)
	
func destroy():
	var ex = explosion.instance()
	ex.set_pos(get_pos() + Vector2(0, 12))
	get_parent().add_child(ex)
	
	queue_free()


