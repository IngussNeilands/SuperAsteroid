
extends StaticBody2D

func _ready():

	pass
	
func rescue():
	get_node("/root/global").rescueMiner()
	
	queue_free()



