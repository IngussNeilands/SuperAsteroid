
extends Node2D

export var chance = 50

var parent

func _ready():
	randomize()
	parent = get_parent()
	
func spawn():
	var wallTile = parent.get_wallTile()
	var tileSize = parent.get_tileSize()
	var tilePos = Vector2(int(get_pos().x / tileSize.x), int(get_pos().y / tileSize.y))
	
	var roomSize = parent.get_roomSize()
	
	var chanceBoost = 0
	if ( (parent.get_cell(tilePos.x - 1, tilePos.y) == wallTile) || (parent.get_cell(tilePos.x + 1, tilePos.y) == wallTile) || (parent.get_cell(tilePos.x, tilePos.y - 1) == wallTile) || (parent.get_cell(tilePos.x, tilePos.y + 1) == wallTile) ):
		chanceBoost += rand_range(50 - chance, 100 - chance)
	
	if (rand_range(0, 100) <= chance + chanceBoost):
		parent.set_cell(tilePos.x, tilePos.y, wallTile)
		
	queue_free()


