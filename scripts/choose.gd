extends Label

@onready var animation_player = $AnimationPlayer

func card_chosen():
	if Global.selected_effect == 1:
		self.text = "Increased visibility."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 2:
		self.text = "Increased flashlight distance."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 3:
		self.text = "Ghosts visibility decreased."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 4:
		self.text = "Sanity recovers faster."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 5:
		self.text = "More ghosts can be found on the map."
		self.self_modulate = Color.INDIAN_RED
	elif Global.selected_effect == 6:
		self.text = "Ghosts are more agressive."
		self.self_modulate = Color.INDIAN_RED
	elif Global.selected_effect == 7:
		self.text = "More sanity."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 8:
		self.text = "Less sanity."
		self.self_modulate = Color.INDIAN_RED
	elif Global.selected_effect == 9:
		self.text = "Movement speed increased."
		self.self_modulate = Color.SPRING_GREEN
	elif Global.selected_effect == 10:
		self.text = "Movement speed decreased."
		self.self_modulate = Color.INDIAN_RED
		
	animation_player.play("chosen")
