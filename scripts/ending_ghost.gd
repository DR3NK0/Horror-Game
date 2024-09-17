extends CharacterBody2D

@export var SPEED = 60
@export var player: Node2D
@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED
		
		update_animation_parameters(velocity)
		move_and_slide()
		pick_new_state()

func make_path() -> void:
	navigation_agent.target_position = get_parent().global_position

func update_animation_parameters(move_input : Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",move_input)
		animation_tree.set("parameters/Walk/blend_position",move_input)
		
func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


func _on_recalculate_timer_timeout():
	make_path()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		get_parent().remove_sanity(20);
		self.queue_free()
