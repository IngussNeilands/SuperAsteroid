
extends TileMap

const TILE_WIDTH = 64
const TILE_HEIGHT = 64

const ROOM_WIDTH = 19
const ROOM_HEIGHT = 9

const FREE_TILE = 0
const WALL_TILE = 1
const BLOCKED_TILE = 2
const NAV_OCC_TILE = 12

const DETAIL_CHANCE = 7

const TOP_STALA = 3
const BOTTOM_STALA = 4
const LEFT_STALA = 5
const RIGHT_STALA = 6

const BACK_DETAIL_RANGE = Vector2(7, 11)

var entities = 0

func _ready():
	checkBlocks()
	
	addDetails()

func checkBlocks():
	var children = get_children()
	var blocks = []
	
	for child in children:
		if child.is_in_group("block"):
			blocks.push_back(child)
			
	for block in blocks:
		block.spawn()
		
func addDetails():

	var y = 0
	while (y < ROOM_HEIGHT + 1):
		
		var x = 0
		while (x < ROOM_WIDTH + 1):
			if ( (get_cell(x, y) != WALL_TILE) && (get_cell(x,y) != BLOCKED_TILE) ):
				if ( (get_cell(x, y - 1) == WALL_TILE) && (rand_range(0, 100) <= DETAIL_CHANCE) ):
					set_cell(x, y, TOP_STALA)
				elif ( (get_cell(x, y + 1) == WALL_TILE) && (rand_range(0, 100) <= DETAIL_CHANCE) ):
					set_cell(x, y, BOTTOM_STALA)
				elif ( (get_cell(x - 1, y) == WALL_TILE) && (rand_range(0, 100) <= DETAIL_CHANCE) ):
					set_cell(x, y, LEFT_STALA)
				elif ( (get_cell(x + 1, y) == WALL_TILE) && (rand_range(0, 100) <= DETAIL_CHANCE) ):
					set_cell(x, y, RIGHT_STALA)
				elif (rand_range(0, 100) <= DETAIL_CHANCE * 1.25):
					var n = rand_range(0, 100)
					var z = 100 / (BACK_DETAIL_RANGE.y - BACK_DETAIL_RANGE.x + 1)
					var picked = false
					
					var a = 0
					while (picked == false):
						if ( (n >= a) && ( (n <= a + z) || (n <= 100) ) ):
							set_cell(x, y, int(((int(n * 0.1) * 10) / z)) + BACK_DETAIL_RANGE.x)
							picked = true
						else:
							a += z
				
			x += 1
		
		y += 1
		
func add_entityCount():
	entities += 1
	
func get_entityCount():
	return entities

func get_tileSize():
	return Vector2(TILE_WIDTH, TILE_HEIGHT)
	
func get_roomSize():
	return Vector2(ROOM_WIDTH, ROOM_HEIGHT)
	
func get_wallTile():
	return WALL_TILE
	
func _deferred_add_child(e, p):	
	e.set_pos(e.get_pos() + get_pos())
	get_parent().add_child(e)
	
	p.destroy()