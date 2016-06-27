
extends KinematicBody2D

const BULLET_COOLDOWN = 0.4
const HURT_COOLDOWN = 0.5

const ACCEL = 600
const F = 1500
const MAX_SPEED = 600
const MIN_SPEED = 20

var GLOBAL

var bulletTimer = 0
var hurtTimer = 0

var v = Vector2()
var aimDir = 1

var bulletNode = preload("res://entities/PlayerBullet.xml")

var sprite
var jet

const JET_POS_R = Vector2(-64, 0)
const JET_POS_L = Vector2(64, 0)
const JET_SPEED = MAX_SPEED * 0.0001

func _ready():
	GLOBAL = get_node("/root/global")
	GLOBAL.setPlayerNode(self)
	
	sprite = get_node("Sprite")
	jet = get_node("Jet")
	jet.set_speed(JET_SPEED)
	
	set_fixed_process(true)
	set_process(true)
	
func _process(dt):	
	if (GLOBAL.getPlayerHP() <= 0):
		GLOBAL.gotoScene(GLOBAL.LOSE_SCENE, false, false)
	
	#hurt protection cooldown
	if (hurtTimer > 0):
		hurtTimer -= dt
	
	#movement
	var force = Vector2()
	var stop = Vector2()
	
	#check for horizontal movement and apply force and set aim if detected
	if (Input.is_action_pressed("moveLeft") and (v.x > -MAX_SPEED)):
		if (v.x > F * dt):
			force.x -= F
		else:
			force.x -= ACCEL
			
		aimDir = -1
		sprite.set_flip_h(true)
		GLOBAL.HUD.setFlip(true)
	elif (Input.is_action_pressed("moveRight") and (v.x < MAX_SPEED)):
		if (v.x < -F * dt):
			force.x += F
		else:
			force.x += ACCEL
			
		aimDir = 1
		sprite.set_flip_h(false)
		GLOBAL.HUD.setFlip(false)
	else:
		stop.x = 1
	
	#check for vertical movement and apply force if detected
	if (Input.is_action_pressed("moveUp") and (v.y > -MAX_SPEED)):
		if (v.y > F * dt):
			force.y -= F
		else:
			force.y -= ACCEL
	elif (Input.is_action_pressed("moveDown") and (v.y < MAX_SPEED)):
		if (v.y < -F * dt):
			force.y += F
		else:
			force.y += ACCEL
	else:
		stop.y = 1
		
	#apply force to velocity
	v += force * dt
	
	#apply friction if stopped
	if (stop.x == 1):
		v.x = calcFriction(v.x, F, MIN_SPEED, dt)
	if (stop.y == 1):
		v.y = calcFriction(v.y, F, MIN_SPEED, dt)
		
	#jet animation
	if (stop.x != 1):
		if (aimDir == -1):
			jet.set_flip_h(true)
			jet.set_pos(JET_POS_L)
		else:
			jet.set_flip_h(false)
			jet.set_pos(JET_POS_R)
		
		jet.show()
		jet.play()
	else:
		jet.pause()
		jet.hide()
	
func _fixed_process(dt):
	#shooting
	if (bulletTimer <= 0):
		if (Input.is_action_pressed("shoot")):
			var bulletInstance = bulletNode.instance()
	
			get_parent().add_child(bulletInstance)
			
			bulletInstance.set_pos(get_pos())
			bulletInstance.setDir(Vector2(aimDir, 0))
			
			get_node("Sound").play("PlayerShoot")
			
			bulletTimer = BULLET_COOLDOWN
	else:
		bulletTimer -= dt
	
	#move
	var motion = v * dt
	motion = move(motion)
	
	if (is_colliding()):
		#check collisions
		if (get_collider().is_in_group("exit")):
			hitExit()
			
		if (get_collider().is_in_group("miner")):
			get_node("Sound").play("Blip")
			get_collider().rescue()
			
		if (get_collider().is_in_group("monster")):
			takeDamage(get_collider().getAttackDamage())
		
		#slide
		var n = get_collision_normal()
		
		motion = n.slide(motion)
		v = n.slide(v)
		move(motion)
	
func calcFriction(vel, f, minV, dt):
	var vsign = sign(vel)
	var vabs = abs(vel)
	
	if (vabs > minV):
		return vel - (f * vsign) * dt
	else:
		return 0
		
func takeDamage(dam):
	if (hurtTimer <= 0):
		hurtTimer = HURT_COOLDOWN
		
		GLOBAL.hurtPlayer(dam)
		
		get_node("Sound").play("Hit")
		
func hitExit():
	var miners = GLOBAL.room.miners
	
	if (miners <= 0):
		if (GLOBAL.getSaved() >= GLOBAL.getToSave()):
			GLOBAL.gotoScene(GLOBAL.WIN_SCENE, false, false)
		else:
			GLOBAL.HUD.displayMessage("LEVEL CLEARED", 2, true, funcref(GLOBAL, "nextLevel"))
	else:
		var minerStr = "MINER"
		if (miners > 1):
			minerStr += "S"
			
		GLOBAL.HUD.displayMessage("YOU STILL HAVE " + str(miners) + " " + minerStr + "\n LEFT TO SAVE HERE!", 3, true, null)
	
