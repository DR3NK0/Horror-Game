extends CharacterBody2D

@export var SPEED = 55
@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var player_entered = $PlayerEntered

@onready var under_world_detect = $UnderWorldDetect
@onready var exit_detect = $ExitDetect


var player : Node2D

#Chase Logic
var initial_position : Vector2

var player_in_range = false
var is_chasing = false
var trigger_once = false

func _ready():
	initial_position = self.position
	
	get_child(0).visible = false
	get_child(1).disabled = true
	
	if Global.more_agressive_ghosts:
		ghosts_more_agressive()
		
	if Global.ghost_visibilty_decreased:
		ghosts_visibility_decreased()

func _physics_process(delta: float) -> void:
	
	if !Global.is_underworld && !player_in_range:
			is_chasing = false
			get_child(0).visible = false
			get_child(1).disabled = true
			self.position = initial_position
	
	if trigger_once:
		if Global.is_underworld && player_in_range:
			self.get_child(0).visible = true
			get_child(1).disabled = false
			
			if !is_chasing:
				player_entered.play()
				
			is_chasing = true
		elif Global.is_underworld && !player_in_range:
			is_chasing = false
		elif !Global.is_underworld && player_in_range:
			is_chasing = true
		elif !Global.is_underworld && !player_in_range:
			is_chasing = false
			get_child(0).visible = false
			get_child(1).disabled = true
			self.position = initial_position
		
		trigger_once = false
	
	if is_chasing:
		var dir = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = dir * SPEED
		
		update_animation_parameters(velocity)
		move_and_slide()
		pick_new_state()

func make_path() -> void:
	navigation_agent.target_position = player.global_position

func _on_recalculate_timer_timeout():
	make_path()

func update_animation_parameters(move_input : Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",move_input)
		animation_tree.set("parameters/Walk/blend_position",move_input)
		
func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func ghosts_more_agressive():
	SPEED = 60
	
	under_world_detect.get_child(0).scale.x -= 1
	under_world_detect.get_child(0).scale.y -= 1
	
	exit_detect.get_child(0).scale.x += 2
	exit_detect.get_child(0).scale.y += 2
	
func ghosts_visibility_decreased():
	under_world_detect.get_child(0).scale.x += 1
	under_world_detect.get_child(0).scale.y += 1
	
	exit_detect.get_child(0).scale.x -= 2
	exit_detect.get_child(0).scale.y -= 2

func _on_under_world_detect_body_entered(body):
	if body.name == "Player":
		if Global.is_underworld:
			player_in_range = true
			trigger_once = true


func _on_exit_detect_body_exited(body):
	if body.name == "Player":
		trigger_once = true
		player_in_range = false
