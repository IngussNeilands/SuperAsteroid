
extends "monster.gd"

const ATTACK_DELAY = 0.6

var startPos

var delay = 1
var attackTimer = 0
var chasing = false

func _ready():	
	startPos = get_pos()
	
	setSpeed(100)
	setRandomDir()
	
	set_process(true)
	
func _process(dt):
	if (attackTimer <= 0):
		if (delay >= 0):
			delay -= dt
		else:
			if (checkCanSeePlayer(1024)):
				setSpeed(145 + (GLOBAL.getLevel() * 5) )
				setFollowNav(true)
				setPathDest(PLAYER.get_pos())
				chasing = true
			else:
				chasing = false
	else:
		attackTimer -= dt
		
	
func _fixed_process(dt):	
	if not (dead):
		if (is_colliding()):
			if (get_collider() != null):
				if (get_collider().is_in_group("player")):			
					attackTimer = ATTACK_DELAY
					
					setFollowNav(true)
					setPathDest(startPos)
					
			if not (chasing):
				if (rand_range(0, 2) >= 1):
					setDir(getDir() * -1)
				else:
					setRandomDir()		
			
	if ((path.size() < 1) && (isCollidingWall())):
		setDir(getDir() * -1)
		
	if not (chasing):
		if (rand_range(0, 100) >= 99):
			setRandomDir()
			
	processSlide(dt)