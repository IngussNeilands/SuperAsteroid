
extends KinematicBody2D

var GLOBAL
var PLAYER

var dead = false
var hp = 100
var speed = 150
var v = Vector2(0, 0)
var dir = Vector2(0, 0)
var nav = false
var navMesh
var path = []
var pathDest
var drawPath = false
var motion
var attackDamage = 25 
var explosion = load("res://entities/small_explosion.xml")
var center

func _ready():
	GLOBAL = get_node("/root/global")
	PLAYER = GLOBAL.player.node
	
	navMesh = get_node(GLOBAL.GAME_NODE_PATH + "Nav")
	
	if (has_node("Sprite")):
		setCenterPos(get_node("Sprite").get_region_rect().size * 2)
	else:
		setCenterPos(Vector2(32, 32) )
	
	setPathDest(get_pos() )
	
	set_fixed_process(true)
	
func _fixed_process(dt):				
	if (not dead):
		if (nav):
			path = navMesh.get_simple_path(get_global_pos() + getCenterPos(), getPathDest())

		if(path.size() >= 1):
			setDir( (path[1] - get_global_pos()).normalized() )
			if (drawPath):
				update()
	
		applyMotion(dt)
		
		if (is_colliding()):
			if (get_collider().is_in_group("player")):
				PLAYER.takeDamage( getAttackDamage() )
				
			if (get_collider().is_in_group("turret")):
				add_collision_exception_with(get_collider())
				
			if (get_collider().is_in_group("spikes")):
				if (!get_collider().falling):
					add_collision_exception_with(get_collider())
	else:
		set_fixed_process(false)
		
func _process(dt):
	if (dead):
		set_process(false)
	
func _draw():
	if (drawPath):
		if (path.size() >= 1):
			for i in range(path.size()):
				draw_circle(path[i] - get_global_pos(),10,Color(1,1,1))
		
func applyMotion(dt):
	v = (getSpeed() * getDir()) * dt
	motion = move(v)
	
func processSlide(dt):
	if is_colliding():
        	var n = get_collision_normal()
        	setDir(n.slide( getDir() ) )
        	move(getDir() * getSpeed() * dt)
	
func hitPlayerBullet():
	takeDamage(getHP())
		
func destroy():
	dead = true
	
	var ex = getExplosionScene().instance()
	ex.set_pos(get_pos() + getCenterPos())
	get_parent().add_child(ex)
	
	queue_free()
	
func checkCollidingGroup(g):
	if (is_colliding()):
		if (get_collider().is_in_group(g)):
			return get_collider()
	
	return false
		
func isCollidingWall():
	if (is_colliding()):
		if (get_collider().is_in_group("wall")):
			return true
	else:
		return false
		
func checkCanSeePlayer(rng):
	var pPos = PLAYER.get_pos()
	
	if (checkDistanceTo(pPos) <= rng):
		var spaceState = get_world_2d().get_direct_space_state()
		var result = spaceState.intersect_ray(get_pos() + getCenterPos(), pPos)
		
		if (result.empty()):
			return true
			print("I SEE PLAYER")
		else:
			if (result.collider.is_in_group("player")):
				return true
				print("I SEE PLAYER")
	
	return false
	
func checkDistanceTo(targetPos):
	var pos = get_pos() + getCenterPos()
	return ( abs( targetPos.x - pos.x ) + abs( targetPos.y - pos.y ) )

func setHP(h):
	hp = h
	
func getHP():
	return hp
	
func takeDamage(damage):
	hp -= damage
	
	if (hp <= 0):
		if (!dead):
			GLOBAL.addPlayerHP(5)
		
		destroy()
		
func setSpeed(s):
	speed = s
	
func getSpeed():
	return speed
	
func setDir(d):
	#Vector2
	dir = d
	
func getDir():
	return dir
	
func setRandomDir():
	randomize()
	
	var dirX = int(rand_range(0,2)) - 1
	var dirY = int(rand_range(0,2)) - 1
	
	if ((dirX == 0) && (dirY == 0)):
		dirX += int(rand_range(0,2)) - 1
		dirY += int(rand_range(0,2)) - 1
		
		if ((dirX == 0) && (dirY == 0)):
			randomize()
			dirX += int(rand_range(0,2)) - 1
			dirY += int(rand_range(0,2)) - 1
			
	dir = Vector2(dirX, dirY)
	
	if ((dirX != 0) && (dirY != 0)):
		dir *= 0.75

func setFollowNav(b):
	#boolean
	nav = b
	
func getFollowNav():
	return nav
	
func setPathDest(p):
	#Vector2
	pathDest = p
	
func getPathDest():
	return pathDest
	
func drawPath(b):
	#boolean
	drawPath = b
	
func setAttackDamage(d):
	attackDamage = d

func getAttackDamage():
	return attackDamage
	
func setExplosionScene(sc):
	#resource
	explosion = sc
	
func getExplosionScene():
	return explosion
	
func setCenterPos(c):
	#Vector2
	center = c
	
func getCenterPos():
	return center

