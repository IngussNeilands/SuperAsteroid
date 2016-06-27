
extends TileMap

# member variables here, example:
# var a=2
# var b="textvar"

const START_X = 1
const START_Y = 1
const WIDTH = 18
const HEIGHT = 8

func _ready():
	randomize()
	
	var x = START_X
	var y = START_Y
	
	while (x < WIDTH + 1):
		var oldY = y
		
		while (y < HEIGHT + 1):
			if (((x > 1) or (y > 1)) and (rand_range(0, 1) > rand_range(0.7, 0.9))):
				set_cell(x,y,0)
			y += 1
		
		y = oldY
		x += 1


