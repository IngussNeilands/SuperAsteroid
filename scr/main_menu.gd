
extends Node2D

const CENTER_X = 640
const START_Y = 352
const BUTTON_WIDTH = 256
const BUTTON_HEIGHT = 64
const BUTTON_MARGIN = 16
const INPUT_DELAY = 0.2

var GLOBAL

var buttonRes = load("res://entities/menu/button.xml")
var selectorRes = load("res://entities/menu/selector.xml")

var soundPlayer

var buttons = []

var inputDelayTimer = INPUT_DELAY

var selector = {
	node = null,
	selected = 0
}

func _ready():
	GLOBAL = get_node("/root/global")
	
	soundPlayer = get_node("Sound")
	
	addButton("START", "START GAME")
	addButton("HELP", "res://help.tscn")
	addButton("QUIT", "QUIT")
	
	addSelector()
	
	set_process(true)
	
func _process(dt):
	if (inputDelayTimer <= 0):
		if (Input.is_action_pressed("moveDown")):
			if (getSelected() < buttons.size() - 1):
				addSelected(1)
			else:
				setSelected(0)
				
			soundPlayer.play("MonsterShoot")
			inputDelayTimer = INPUT_DELAY
			
		elif (Input.is_action_pressed("moveUp")):
			if (getSelected() > 0):
				addSelected(-1)
			else:
				setSelected(buttons.size() - 1)
				
			soundPlayer.play("MonsterShoot")
			inputDelayTimer = INPUT_DELAY
			
		if (Input.is_action_pressed("shoot")):
			pushButton(buttons[selector.selected].path)
		
	else:
		inputDelayTimer -= dt
	
func addButton(label, destScenePath):
	var pos = Vector2(CENTER_X, START_Y + (buttons.size() * (BUTTON_HEIGHT + BUTTON_MARGIN) ) )
	
	var b = {
		label = label,
		path = destScenePath,
		pos = pos
	}
	
	buttons.push_back(b)
	
	var button = buttonRes.instance()
	add_child(button)
	button.set_pos(pos)
	button.setText(label)
	
func pushButton(path):
	if (path == "QUIT"):
		GLOBAL.quit()
	elif (path == "START GAME"):
		GLOBAL.startGame()
	else:
		GLOBAL.gotoScene(path, false, false)
	
func addSelector():
	selector.node = selectorRes.instance()
	add_child(selector.node)
	updateSelector()
	
func addSelected(s):
	selector.selected += s
	
	updateSelector()
	
func setSelected(s):
	selector.selected = s
	
	updateSelector()
	
func getSelected():
	return selector.selected
	
func updateSelector():
	selector.node.set_pos( Vector2(CENTER_X, START_Y + (selector.selected * (BUTTON_HEIGHT + BUTTON_MARGIN) ) ) )


