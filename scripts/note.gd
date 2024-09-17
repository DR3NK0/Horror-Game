extends Sprite2D

var is_hovering = false

var materialSelf = self.get_material()

@onready var animation_player = $AnimationPlayer

@export var main_canvas : CanvasLayer
const NOTE_CANVAS = preload("res://scenes/note_canvas.tscn")

const DEFAULT_CURSOR = preload("res://assets/default.png")
const PICKUP_CURSOR = preload("res://assets/pickup.png")

func _ready():
	materialSelf.set_shader_parameter("line_thickness", 0)
	is_hovering = false

func _process(delta):
	if Global.is_underworld:
		self.visible = false
	else:
		self.visible = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_hovering == true:
			animation_player.play("pickup")
			Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
			var node_open = NOTE_CANVAS.instantiate()
			main_canvas.add_child(node_open)

func _on_mouse_detection_mouse_entered():
	materialSelf.set_shader_parameter("line_thickness", 1)
	Input.set_custom_mouse_cursor(PICKUP_CURSOR)
	is_hovering = true

func _on_mouse_detection_mouse_exited():
	materialSelf.set_shader_parameter("line_thickness", 0)
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	is_hovering = false
