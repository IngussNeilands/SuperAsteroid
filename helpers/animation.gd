
extends AnimatedSprite

var play = false

var elapsed = 0

var speed = 0.1

func _ready():
	set_process(true)
	
func _process(dt):
	if (play):
		elapsed += dt
   
		if (elapsed > speed):
			if (get_frame() == self.get_sprite_frames().get_frame_count()-1):
				set_frame(0)
			else:
				set_frame(get_frame() + 1)
		  
			elapsed = 0

func play():	
	play = true

func pause():
	play = false
	
func stop():
	play = false
	elapsed = 0
	set_frame(0)
		
func set_speed(s):
	speed = s
	
func get_speed():
	return speed
	
func get_elapsed():
	return elapsed

func get_playing():
	return play
