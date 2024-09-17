extends Label

var props_found = 0

@onready var prop_found_animation = $PropFoundAnimation

func _process(delta):
	if Global.found_props == props_found:
		return
	else:
		props_found = Global.found_props
		self.text = str(props_found) + "/5"
		prop_found_animation.play("found")
