
extends KinematicBody2D

const SPEED = 600
const ATTACK_DAMAGE = 25

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
		if (get_collider().is_in_group("player")):
			get_node("/root/global").player.node.takeDamage( ATTACK_DAMAGE )
			
			destroy()
		
		if (get_collider().is_in_group("destructible")):
			if (get_collider().is_in_group("spikes")):
				add_collision_exception_with(get_collider())
			else:
				get_collider().destroy()
			
		if not (get_collider().is_in_group("monster")):	
			destroy()
		else:
			add_collision_exception_with(get_collider())

func setDir(direction):
	# expects Vector2
	dir = direction

func destroy():
	var ex = explosion.instance()
	ex.set_pos(get_pos() + Vector2(32, 32))
	get_parent().add_child(ex)
	
	queue_free()