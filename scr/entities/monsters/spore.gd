
extends "monster.gd"

const ATTACK_DELAY = 2

var attackTimer = 0
var delay = 3

var bulletNode = preload("res://entities/monsters/spore_bullet.xml")

func _ready():
	pass
	
func _fixed_process(dt):
	if (attackTimer <= 0):
		if (delay >= 0):
			delay -= dt
		else:
			if (checkCanSeePlayer(1024)):
				shoot(PLAYER.get_pos() - Vector2(32,32))
	else:
		attackTimer -= dt
	
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


