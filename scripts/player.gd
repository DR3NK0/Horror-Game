extends CharacterBody2D

var SPEED : float = 100

@export var WALK_SPEED = 90
@export var SPRINT_SPEED = 130

@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var sanity_timer = $SanityTimer
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sfx = $SFX

@onready var footstep_sfx = $FootstepSFX

@export var underlife_clouds: CanvasLayer
@onready var underworld_delay = $UnderworldDelay
@onready var underworldSFX = $UnderworldSFX

@export var TilemapBG : Node2D
@export var TilemapFG : Node2D

@export var flashlight: Node2D
@export var sanity: ProgressBar
@export var camera: Camera2D

const GHOST_JUMP_SCARE = preload("res://scenes/ghost_jump_scare.tscn")

@export var ending_ghost_distance = 150
const ENDING_GHOST = preload("res://scenes/ending_ghost.tscn")
@onready var ending_ghost_timer = $Ending_Ghost_Timer

var sanity_recovery = false

#Noises
@onready var random_noises_timer = $Random_Noises_Timer
@onready var random_noises_sfx = $RandomNoisesSFX

const KNOCKING = preload("res://assets/newSounds/newSounds/Knocking.wav")
const CREAK_1 = preload("res://assets/newSounds/newSounds/Creak1.wav")
const CREAK_2 = preload("res://assets/newSounds/newSounds/Creak2.wav")

@export var region_label : Label

func _ready():
	update_animation_parameters(starting_direction)
	
	underworld_delay.start(2)

func _physics_process(delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	
	update_animation_parameters(input_direction)
	velocity = input_direction * SPEED
	
	player_sprint()
	
	toggle_flashlight()
	
	enter_underlife()
	
	check_sanity()
	
	move_and_slide()
	
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",move_input)
		animation_tree.set("parameters/Walk/blend_position",move_input)
		
func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func player_sprint():
	if Input.is_action_pressed("sprint"):
		SPEED = SPRINT_SPEED
	else:
		SPEED = WALK_SPEED

func increase_flashlight_distance():
	flashlight.get_child(0).texture_scale = flashlight.get_child(0).texture_scale + 0.5

func toggle_flashlight():
	if Input.is_action_just_pressed("flashlight"):
		if flashlight.is_visible_in_tree():
			flashlight.visible = false
			Global.flashlight_toggle = false
			sfx.play()
		else:
			flashlight.visible = true
			Global.flashlight_toggle = true
			sfx.play()

func game_ended_spawn_ghosts(state):
	if state:
		ending_ghost_timer.start()
	elif !state:
		ending_ghost_timer.stop()

func ghosts_spawn_around_player():
	var angle = randf_range(0, 2 * PI)
	
	var offset = Vector2(cos(angle), sin(angle)) * ending_ghost_distance
	var spawn_position = self.position + offset
	
	var edning = ENDING_GHOST.instantiate()
	edning.position = spawn_position
	add_child(edning)

func enter_underlife():
	if Input.is_action_just_pressed("underlife"):
		if !Global.is_underworld && !Global.note_opened && underworld_delay.time_left <= 0:
			underlife_clouds.visible = true
			var matBG = TilemapBG.material
			var matFG = TilemapFG.material
			matBG.set_shader_parameter("sensivity", 0.8)
			matFG.set_shader_parameter("sensivity", 0.8)
			
			underworldSFX.pitch_scale = 1.4
			underworldSFX.play()
			
			flashlight.get_child(0).texture_scale = flashlight.get_child(0).texture_scale - 0.1
			
			underworld_delay.start(2)
			
			Global.is_underworld = true
		elif Global.is_underworld && underworld_delay.time_left <= 0:
			underlife_clouds.visible = false
			var matBG = TilemapBG.material
			var matFG = TilemapFG.material
			matBG.set_shader_parameter("sensivity", 0)
			matFG.set_shader_parameter("sensivity", 0)
			
			underworldSFX.pitch_scale = 1.8
			underworldSFX.play()
			
			flashlight.get_child(0).texture_scale = flashlight.get_child(0).texture_scale + 0.1
			
			underworld_delay.start(2)
			
			Global.is_underworld = false;

func sanity_recovers_faster():
	sanity_recovery = true

func _on_sanity_timer_timeout():
	if !Global.is_underworld:
		if flashlight.is_visible_in_tree():
			if sanity.value < sanity.max_value:
				if sanity_recovery:
					add_sanity(2)
				else:
					add_sanity(1)
		else:
			if sanity.value > sanity.min_value:
				remove_sanity(1)

		sanity_timer.wait_time = randf_range(0.2,0.5)
		sanity_timer.start()
	else:
		if flashlight.is_visible_in_tree():
			if sanity.value > sanity.min_value:
				remove_sanity(1)
				
			sanity_timer.wait_time = randf_range(0.15,0.35)
			sanity_timer.start()
		else:
			if sanity.value > sanity.min_value:
				remove_sanity(2)
				
			sanity_timer.wait_time = randf_range(0.1,0.2)
			sanity_timer.start()

func remove_sanity(value):
	if !Global.game_lost:
		if sanity.value - value <= sanity.min_value:
			sanity.value = sanity.min_value
		else:
			sanity.value -= value

func add_sanity(value):
	if !Global.game_lost:
		if sanity.value + value >= sanity.max_value:
			sanity.value = sanity.max_value
		else:
			sanity.value += value

func check_sanity():
	if sanity.value <= 0:
		Global.game_lost = true
		%Module.end_game()

func _on_ghost_detect_body_entered(body):
	if body.name == "Ghost":
		var jumpscare = GHOST_JUMP_SCARE.instantiate()
		add_child(jumpscare)
		body.queue_free()
		remove_sanity(20)

func player_speed_increased():
	WALK_SPEED += 10
	SPRINT_SPEED += 10

func player_speed_decreased():
	WALK_SPEED -= 10
	SPRINT_SPEED -= 10

func sanity_increased():
	sanity.max_value += 10
	sanity.value = sanity.max_value

func sanity_decreased():
	sanity.max_value -= 10
	sanity.value = sanity.max_value

func _on_ending_ghost_timer_timeout():
	ghosts_spawn_around_player()

func _on_random_noises_timer_timeout():
	var rndmNoise = randi_range(0,2)
	
	if rndmNoise == 0:
		random_noises_sfx.stream = KNOCKING
		random_noises_sfx.play()
	elif rndmNoise == 1:
		random_noises_sfx.stream = CREAK_1
		random_noises_sfx.play()
	elif rndmNoise == 2:
		random_noises_sfx.stream = CREAK_2
		random_noises_sfx.play()
		
	random_noises_timer.wait_time = randf_range(15,30)

func play_footstep():
	footstep_sfx.pitch_scale = randf_range(1.2,1.5)
	footstep_sfx.play()

func _on_region_detect_area_entered(area: Area2D) -> void:
	if area.name == region_label.text:
		pass
	else:
		region_label.new_region_changed(area.name)
