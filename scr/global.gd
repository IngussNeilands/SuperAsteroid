
extends Node

const GAME_SCENE = "res://game.tscn"
const GAME_NODE_PATH = "/root/Game/"
const WIN_SCENE = "res://win_screen.tscn"
const LOSE_SCENE = "res://lose_screen.tscn"
var HUD

var hudNode

const MAX_MINERS_PER_ROOM = 3

var root 
var currentScene = null

var paused = false

var game = {
	level = 1,
	saved = 0,
	toSave = 0
}

var room = {
	miners = 0
}

var player = {
	node = null,
	hp = 100
}

func _ready():
	var bgm = load("res://entities/BGM.xml")
	bgm = bgm.instance()
	add_child(bgm)
	
	hudNode = load("res://gui.xml") 
	
	root = get_tree().get_root()
	currentScene = root.get_child ( root.get_child_count() - 1)
	
func startGame():
	resetVars()
	
	gotoScene(GAME_SCENE, false, true)
	
func newGame():
	randomize()
	
	createHUD()
	
	setToSave(int(rand_range(10, 20)))
	
	HUD.displayMessage("YOU ARE SPACE MERCENARY, CAPTAIN\nASTRID TAM, TASKED WITH RESCUING THE\n" + str(getToSave()) + " SURVIVING MINERS STRANDED ON \nAN ALIEN-STRICKEN SUPER ASTEROID.\n\nGO SAVE 'EM, CAPTAIN.", 14, true, null)
	
func createHUD():
	HUD = hudNode.instance()
	get_node(GAME_NODE_PATH).add_child(HUD)
	
func resetVars():
	var game = {
		level = 1,
		saved = 0,
		toSave = 0
	}
	
	var room = {
		miners = 0
	}
	
	var player = {
		node = null,
		hp = 100
	}
	
func nextLevel():
	setMiners(0)
	addLevel()
	gotoScene(GAME_SCENE, true, false)
	
func gotoScene(path, levelChange, newGame):
	call_deferred("_deferred_gotoScene", path, levelChange, newGame)
	
func _deferred_gotoScene(path, levelChange, newGame):
	
	currentScene.free()
	
	var sc = ResourceLoader.load(path)
	
	currentScene = sc.instance()
	
	root = get_tree().get_root()
	root.add_child(currentScene)
	
	get_tree().set_current_scene(currentScene)
	
	if (levelChange):
		createHUD()
		
	if (newGame):
		newGame()
	
func pause(p):
	paused = p
	get_tree().set_pause(p)
	
func quit():
	get_tree().quit()
	
func setLevel(l):
	game.level = l
	
func getLevel():
	return game.level
	
func addLevel():
	game.level += 1
	
func setSaved(s):
	game.saved = s
	HUD.setSaved(game.saved)
	
func getSaved():
	return game.saved
	
func addSaved():
	game.saved += 1
	HUD.setSaved(game.saved)
	
func setToSave(s):
	game.toSave = s
	HUD.setToSave(game.toSave)
	
func getToSave():
	return game.toSave
	
func setPlayerNode(n):
	player.node = n
	
func getPlayerNode():
	return player.node
	
func setPlayerHP(h):
	player.hp = h
	HUD.setHP(h)
	
func getPlayerHP():
	return player.hp
	
func addPlayerHP(x):
	player.hp += x
	HUD.setHP(player.hp)

func hurtPlayer(x):
	player.hp -= x
	HUD.setHP(player.hp)
	
func rescueMiner():
	addSaved()
	addMiner(-1)

func addMiner(x):
	room.miners += x
	
func setMiners(m):
	room.miners = m
	
func getMiners():
	return room.miners
