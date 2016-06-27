extends StaticBody2D

var explosion
var body

func _ready():
	explosion = load("res://entities/small_explosion.xml")
		
func destroy():
	var ex = explosion.instance()
	var parent = get_parent()
	ex.set_pos(get_pos() + Vector2(96, 96))
	get_parent().add_child(ex)
	
	parent.set_cell(int(get_pos().x / parent.TILE_WIDTH),int(get_pos().y / parent.TILE_HEIGHT),parent.FREE_TILE)	
		
	queue_free()
	