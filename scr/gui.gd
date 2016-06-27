
extends CanvasLayer

var GLOBAL

var hpDisplay
var savedDisplay

var hp = 100
var saved = 0
var toSave = 0

var message = false
var messageTimer = 0
var messageCallback
var pausedByHUD = false

func _ready():
	GLOBAL = get_node("/root/global")
	
	setHP(GLOBAL.getPlayerHP())
	setSaved(GLOBAL.getSaved())
	setToSave(GLOBAL.getToSave())
	
	set_process(true)

func _process(dt):
	if (message):
		if (messageTimer > 0):
			messageTimer -= dt
			
			if (Input.is_action_pressed("shoot")):
				messageTimer = 0
		else:
			get_node("Message").set_hidden(true)
			message = false
			
			if (pausedByHUD):
				pausedByHUD = false
				GLOBAL.pause(false)
				
			if (messageCallback):
				messageCallback.call_func()
					
func displayMessage(string, time, pause, callback):
	get_node("Message/Text").set_text(string)
	get_node("Message").set_hidden(false)
	
	message = true
	messageTimer = time
	messageCallback = callback
	
	if ((pause) && (!GLOBAL.paused)):
		pausedByHUD = true
		GLOBAL.pause(true)
	
func setHP(h):
	hp = h
	
	get_node("GUI/HP Box/Value").set_text(str(hp))
	
func getHP():
	return hp

func setSaved(s):
	saved = s
	
	updateSavedLabel()
	
func getSaved():
	return saved
	
func setToSave(s):
	toSave = s
	
	updateSavedLabel()
	
func getToSave():
	return toSave
	
func updateSavedLabel():
	var savedString
	if (saved < 10):
		savedString = "0" + str(saved)
	else:
		savedString = str(saved)
		
	get_node("GUI/Saved Box/Value").set_text(savedString + " / " + str(toSave))

func setFlip(f):
	get_node("GUI/Portrait").set_flip_h(f)
