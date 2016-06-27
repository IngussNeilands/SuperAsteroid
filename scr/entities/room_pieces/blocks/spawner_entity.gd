
extends Node2D

export var chance = 20

var GLOBAL

var parent

var entity = []
var spikeEntity = 0
var minerEntity = 0

var level = 0

func _ready():
	GLOBAL = get_node("/root/global")
	
	level = GLOBAL.game.level
	
	entity.push_back( load("res://entities/monsters/beholder.xml") )
	
	entity.push_back( load("res://entities/spikes.xml") )
	spikeEntity = entity.size() - 1
	
	entity.push_back( load("res://entities/miner.xml") )
	minerEntity = entity.size() - 1
	
	entity.push_back( load("res://entities/monsters/ghost.xml") )
	entity.push_back( load("res://entities/monsters/spore.xml") )
	entity.push_back( load("res://entities/monsters/spinner.xml") )
	
	randomize()
	
	parent = get_parent()
	
	initSpawn()
	
func initSpawn():
	if (rand_range(0, 100) <= chance + (level * rand_range(1, 6) ) ):
		var spawn = true
		
		var choice = ( rand_range(0, 80) + (level * rand_range(1, 6) ) ) / 100
		if (choice > 1):
			choice -= (choice - 1) + rand_range(0, choice - 1)
		choice = int( entity.size() * choice)
		
		if (choice == spikeEntity):
			if (parent.get_cell(int(get_pos().x / parent.TILE_WIDTH),int(get_pos().y / parent.TILE_HEIGHT) - 1) != parent.WALL_TILE):
				spawn = false
				
		if (choice == minerEntity):
			if ( (GLOBAL.getMiners() < GLOBAL.MAX_MINERS_PER_ROOM) && ( GLOBAL.getMiners() + 1 + GLOBAL.getSaved() <= GLOBAL.getToSave() ) ):
				GLOBAL.addMiner(1)
			else:
				spawn = false
		
		if (spawn):
			if (parent.get_entityCount() <= int(level * 1.5)):
				parent.add_entityCount()
				spawn(entity[choice], choice)
			else:
				if (choice == minerEntity):
					GLOBAL.addMiner(-1)
				
				destroy()
		else:
			#start over
			initSpawn()
	else:
		destroy()
	
func spawn(e, c):		
		e = e.instance()
		e.set_pos(get_pos())
		parent.call_deferred("_deferred_add_child", e, self)
		
func destroy():
	queue_free()


