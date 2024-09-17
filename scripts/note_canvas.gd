extends TextureRect

@onready var animation_player = $AnimationPlayer

func _ready():
	Global.note_opened = true
	animation_player.play("note_opened")

func _on_button_button_down():
	Global.note_opened = false
	animation_player.play("node_closed")
