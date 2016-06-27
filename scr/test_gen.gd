
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

const BOARD_START_X = 0
const BOARD_START_Y = 0

const BOARD_WIDTH = 3
const BOARD_HEIGHT = 3

const TILE_WIDTH = 64
const TILE_HEIGHT = 64

const ROOM_TILE_WIDTH = 19
const ROOM_TILE_HEIGHT = 9

const MAP_TILE_START_X = 0
const MAP_TILE_START_Y = 0

const MAP_TILE_WIDTH = 78
const MAP_TILE_HEIGHT = 38

var board = {}
var tilemap = TileMap.new()
var tileset = load("res://assets/tilemap/tilemap.xml")

const WALL_TILE = 1

var roomPiece = {}

func _ready():
	#setup room pieces
	roomPiece[0] = preload("res://entities/room_pieces/room_0.tscn")
	roomPiece[1] = preload("res://entities/room_pieces/room_1.tscn")
	roomPiece[2] = preload("res://entities/room_pieces/room_2.tscn")
	roomPiece[3] = preload("res://entities/room_pieces/room_3.tscn")
	roomPiece[4] = preload("res://entities/room_pieces/room_4.tscn")
	roomPiece[5] = preload("res://entities/room_pieces/room_5.tscn")

	
	randomize()
	board = generateBoard()
	
	tilemap.add_to_group("wall")
	tilemap.set_tileset(tileset)
	get_node("Nav").add_child(tilemap)
	
	generateMap()
	
	pass
	

func generateBoard():
	var brd = {}
	
	var sx = BOARD_START_X
	var sy = BOARD_START_Y
	
	var curPos = Vector2(sx, sy)
	
	#init first room
	brd[curPos] = 1
	
	#generate solution path
	
	#	0 : side room
	#	1 : l / r
	#	2 : l / r / b
	#	3 : l / r / t
	#	4 : l / r / t / b
	#	5 : exit
	
	var exitPlaced = false
	var lastDir = 0
	while(!exitPlaced):
		var lastCurPos = curPos
		var dir = int(rand_range(1,5))
		if ( ( (dir < 5) && (dir > 2) ) && (curPos.x < 2) ):
			dir += int(rand_range(0,1))
		
		if (dir <= 2):
			curPos -= Vector2(1, 0)
			lastDir = 180
		elif (dir <= 4):
			curPos += Vector2(1, 0)
			lastDir = 0
		else:
			curPos += Vector2(0, 1)
			lastDir = 270
			
		if ((curPos.x < 0) or (curPos.x > BOARD_WIDTH)):
			curPos = lastCurPos
			
			if (curPos.y < BOARD_HEIGHT):
				if (brd[curPos] == 3):
					brd[curPos] = 4
				else:
					brd[curPos] = 2
				
				curPos += Vector2(0, 1)
				lastDir = 270
			else:
				brd[curPos] = 5
				exitPlaced = true
				break
		
		if ((lastDir == 270) or ((brd.has(curPos)) and (brd[curPos] == 3))):
			brd[curPos] = 3
		else:
			brd[curPos] = 1
	
	# fill in blank squares with side rooms
	var y = sy
	while (y < BOARD_HEIGHT + 1):
		var x = sx
		while (x < BOARD_WIDTH + 1):
			var pos = Vector2(x,y)
			
			if not (brd.has(pos)):
				brd[pos] = 0
			
			x += 1
		
		y += 1
	
	return brd
	
func generateMap():	
	#generate outer walls
	generateRoomOuterWalls(MAP_TILE_START_X, MAP_TILE_START_Y, MAP_TILE_WIDTH, MAP_TILE_HEIGHT)
	
	#generate rooms
	var sx = BOARD_START_X
	var sy = BOARD_START_Y
	
	var y = sy
	while (y < BOARD_HEIGHT + 1):
		var x = sx
		while (x < BOARD_WIDTH + 1):
			var boardPos = Vector2(x, y)
			
			var startTX = x * ROOM_TILE_WIDTH + 1
			var startTY = y * ROOM_TILE_HEIGHT + 1
						
			var roomX = startTX * TILE_WIDTH
			var roomY = startTY * TILE_HEIGHT
			
			# print("Room Type: " + str(board[boardPos]) + " ||| Board Pos: " + str(boardPos) + " ||| T POS: " + str(Vector2(startTX, startTY)) + " ||| REL X/Y POS: " + str(Vector2(roomX, roomY)))
			
			#	0 : side room
			#	1 : l / r
			#	2 : l / r / b
			#	3 : l / r / t
			#	4 : l / r / t / b
			#	5 : exit
			
			var room = roomPiece[board[boardPos]].instance()
			room.set_pos(Vector2(roomX, roomY))
			get_node("Nav").add_child(room)
			
			x += 1
		
		y += 1
		
func generateHWall(x, y, w):
	w -= 1
	
	var a = 0
	while (a < w + 1):
		tilemap.set_cell(x + a,y,WALL_TILE)
		a += 1
		
func generateVWall(x, y, h):
	h -= 1
	
	var a = 0
	while (a < h + 1):
		tilemap.set_cell(x, y + a,WALL_TILE)
		a += 1
			
func generateRoomOuterWalls(sx, sy, w, h):
	w -= 1
	h -= 1
	
	var a = 0
	while (a < h + 1):
		var b = 0
		while (b < w + 1):
			if ((sy + a == sy) or (sy + a == h) or (sx + b == sx) or (sx + b == w)):
				tilemap.set_cell(sx + b, sy + a, WALL_TILE)
			b += 1
		
		a += 1
