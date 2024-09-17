extends CanvasLayer

@onready var label = $TransitionColor/Label
@onready var fade = $TransitionColor/Fade
@onready var transition_color = $TransitionColor

var game_ended = false

func end_game():
	if !game_ended:
		transition_color.visible = true
		fade.play("fade")
		game_ended = true
