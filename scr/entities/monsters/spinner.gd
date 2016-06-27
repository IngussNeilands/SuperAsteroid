
extends "monster.gd"

const ATTACK_DELAY = 1

var attackTimer = 0
var delay = 3
var chasing = false

var bulletNode = preload("res://entities/monsters/spore_bullet.xml")

func _ready():
	setSpeed(50)
	setRandomDir()
	
func _fixed_process(dt):
	if (attackTimer <= 0):
		if (delay >= 0):
			delay -= dt
		else:
			if (checkCanSeePlayer(1024)):
				var pPos = PLAYER.get_pos()
				
				if (checkDistanceTo(pPos) > 128):
					print(checkDistanceTo(pPos))
					shoot(pPos - Vector2(32,32))
				
				setSpeed(125 + (GLOBAL.getLevel() * 5) )
				setFollowNav(true)
				setPathDest(PLAYER.get_pos())
				
				chasing = true
			else:
				chasing = false
				
	else:
		attackTimer -= dt
		
	if ((path.size() < 1) && (isCollidingWall())):
		setDir(getDir() * -1)
	
	if not (chasing):
		if (rand_range(0, 100) >= 99):
			setRandomDir()
			
		if ((not dead) && (is_colliding())):
			if (rand_range(0, 2) < 1):
				setDir(getDir() * -1)
			else:
				setRandomDir()
				
	processSlide(dt)
	
func shoot(targetPos):
	var aimDir = targetPos - get_pos()
	aimDir = aimDir.normalized()
	
	var bullet = bulletNode.instance()
	
	get_parent().add_child(bullet)
	
	bullet.set_pos(get_pos())
	bullet.add_collision_exception_with(self)
	bullet.setDir(aimDir)
	
	get_node("Sound").play("MonsterShoot")
	
	attackTimer = ATTACK_DELAY
