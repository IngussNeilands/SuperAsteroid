
extends Node2D

export var chance = 50
export var entityPath = "res://entities/room_pieces/blocks/destructible_block.xml"

var parent
var entity

func _ready():
	entity = load(entityPath)
	
	randomize()
	parent = get_parent()
	
func spawn():		
	if (rand_range(0, 100) <= chance):
		var e = entity.instance()
		e.set_pos(get_pos())
		parent.add_child(e)
		parent.set_cell(int(get_pos().x / parent.TILE_WIDTH),int(get_pos().y / parent.TILE_HEIGHT),parent.NAV_OCC_TILE)
		
	queue_free()


