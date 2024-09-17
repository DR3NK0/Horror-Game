extends Label

var am = 0
@onready var tick = $Tick
@onready var hour_changed = $HourChanged

@export var Player : Node2D

func _ready():
	am = 0
	self.text = "12 AM"
	

func _on_timer_timeout():
	am += 1
	calculateTime()
	
func calculateTime():
	if am == 0:
		self.text = "12 AM"
	elif am == 1:
		self.text = "1 AM"
	elif am == 2:
		self.text = "2 AM"
	elif am == 3:
		self.text = "3 AM"
	elif am == 4:
		self.text = "4 AM"
	elif am == 5:
		self.text = "5 AM"
	elif am == 6:
		self.text = "6 AM"
		
		if !Global.game_lost:
			Player.game_ended_spawn_ghosts(true)
		else:
			Player.game_ended_spawn_ghosts(false)

	hour_changed.play("found")
	tick.play()
