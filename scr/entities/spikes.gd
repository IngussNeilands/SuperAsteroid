
extends KinematicBody2D

const DAMAGE = 25
const FALL_SPEED = 500
const WIDTH = 64
var PLAYER

var startPos

var shaking = false
var falling = false

var explosion

func _ready():
	PLAYER = get_node("/root/global").player.node
	
	startPos = get_pos()
	
	explosion = load("res://entities/small_explosion.xml")
	
	set_fixed_process(true)
	
func _fixed_process(dt):
	if (!shaking):
		var playerPos = PLAYER.get_pos()
		
		if (playerPos.y > startPos.y):
			if ( ( playerPos.x - 32 >= startPos.x - 32) && ( playerPos.x + 32 <= startPos.x + WIDTH + 32 ) ):
				if (checkCanSeePlayer(800)):
					get_node("Animation").play("SpikesShaking")
					shaking = true
	
	if (falling):
		move(Vector2(0, FALL_SPEED * dt))
		
	if (is_colliding()):
		if (get_collider().is_in_group("player")):
			PLAYER.takeDamage( DAMAGE )
			
			destroy()
		
		if (get_collider().is_in_group("destructible")):
			get_collider().destroy()
			destroy()
			
		if not (get_collider().is_in_group("monster")):	
			destroy()
		else:
			if (!falling):
				add_collision_exception_with(get_collider())
			else:
				get_collider().hitPlayerBullet()
				
func checkCanSeePlayer(rng):
	var pPos = PLAYER.get_pos()
	
	if (checkDistanceTo(pPos) <= rng):
		var spaceState = get_world_2d().get_direct_space_state()
		var result = spaceState.intersect_ray(get_pos() + Vector2(32, 65), pPos)
		
		if (result.empty()):
			return true
		else:
			if (result.collider.is_in_group("player")):
				return true
		
		return false
	
func checkDistanceTo(targetPos):
	var pos = get_pos() + Vector2(32, 16)
	return ( abs( targetPos.x - pos.x ) + abs( targetPos.y - pos.y ) )

func destroy():
	var ex = explosion.instance()
	ex.set_pos(get_pos() + Vector2(32, 32))
	get_parent().add_child(ex)
	
	queue_free()

func _on_Animation_finished():
	get_node("Sound").play("Hit")	
	falling = true
