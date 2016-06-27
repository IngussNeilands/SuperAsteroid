
extends Node2D

var GLOBAL
var inputDelay = 0.5

func _ready():
	GLOBAL = get_node("/root/global")
	set_process(true)
	
func _process(dt):
	if (inputDelay <= 0):
		if (Input.is_action_pressed("shoot")):
			GLOBAL.gotoScene("res://main_menu.tscn", false, false)
	else:
		inputDelay -= dt


