extends Sprite2D

var is_hovering = false
var materialSelf = self.get_material()

@onready var animation_player = $AnimationPlayer

const DEFAULT_CURSOR = preload("res://assets/default.png")
const PICKUP_CURSOR = preload("res://assets/pickup.png")

func _ready():
	materialSelf.set_shader_parameter("line_thickness", 0)
	is_hovering = false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_hovering == true:
			Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
			animation_player.play("opened")


func _on_mouse_detect_mouse_entered():
	materialSelf.set_shader_parameter("line_thickness", 1)
	Input.set_custom_mouse_cursor(PICKUP_CURSOR)
	is_hovering = true


func _on_mouse_detect_mouse_exited():
	materialSelf.set_shader_parameter("line_thickness", 0)
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	is_hovering = false
