
extends "monster.gd"

func _ready():	
	setRandomDir()
	
func _fixed_process(dt):
	if (rand_range(0, 100) >= 99):
			setRandomDir()
	
	if (is_colliding()):
		if (rand_range(0, 2) >= 1):
			setDir(getDir() * -1)
		else:
			setRandomDir()