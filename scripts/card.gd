extends Sprite2D

@onready var card_reveal = $CardReveal

@export var menu : Node2D
@export var Choosen : Label

var randomFrame = 0;
var is_hovering = false
var is_opened = false
var trigger_burn = false

var tween_hover : Tween
var tween_destroy : Tween
var tween_position : Tween

func _ready():
	randomFrame = randi_range(1, 11)

func _process(delta):
	if Global.card_selected and self.is_opened == true:
		if !trigger_burn:
			burn()
			trigger_burn = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT && !Global.card_selected:
		if is_hovering == true:
			%Continue.visible = false
			self.frame = randomFrame
			self.is_opened = true
			
			tween_position = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
			tween_position.tween_property(self, "position", Vector2(self.position.x, self.position.y - 50), 0.1)
			
			Global.card_selected = true
			Global.selected_effect = randomFrame
			
			card_reveal.play()
			
			Choosen.card_chosen()
			menu.card_opened()

func burn():
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
		
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0,2.5).from(1.0)

func _on_mouse_detection_mouse_entered():
	is_hovering = true
	if Global.card_selected != true:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.tween_property(self, "scale", Vector2(9, 9), 0.4)
	
func _on_mouse_detection_mouse_exited():
	is_hovering = false

	if !is_opened:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.tween_property(self, "scale", Vector2(7, 7), 0.6)

