extends Node2D

var activated = false
@onready var area_2d = $Area2D
@onready var sfx = $SFX

func _on_area_2d_body_entered(body):
	if body.name == "Player" && !activated:
		activated = true
		
		sfx.play()
		area_2d.queue_free()
		Global.found_props += 1
	
