extends Node2D

@export var player : Node2D

@export var darkness : CanvasModulate

const PROPS = preload("res://scenes/props.tscn")
@export var props_locations : Array[Node2D] = []
var howManyProps = 0;

const GHOST = preload("res://scenes/ghost.tscn")
@export var ghost_locations : Array[Node2D] = []
var howManyGhosts = 0;
var moreGhosts = false

func _ready():
	apply_start_effects()
	
	choose_ghosts_start()
	choose_props_start()
	
	spawn_props_start()
	spawn_ghost_at_start()

func choose_props_start():
	howManyProps = randi_range(1,3)

func choose_ghosts_start():
	if moreGhosts:
		howManyGhosts = randi_range(2,4)
	else:
		howManyGhosts = randi_range(1,3)

func apply_start_effects():
	set_more_agressive_ghosts(false)
	set_more_ghosts(false)
	set_ghost_visibility_decreased(false)
	
	if Global.selected_effect == 1:
		darkness.color = Color(0.09,0.09,0.09)
	elif Global.selected_effect == 2:
		player.increase_flashlight_distance()
	elif Global.selected_effect == 3:
		set_ghost_visibility_decreased(true)
	elif Global.selected_effect == 4:
		player.sanity_recovers_faster()
	elif Global.selected_effect == 5:
		set_more_ghosts(true)
	elif Global.selected_effect == 6:
		set_more_agressive_ghosts(true)
	elif Global.selected_effect == 7:
		player.sanity_increased()
	elif Global.selected_effect == 8:
		player.sanity_decreased()
	elif Global.selected_effect == 9:
		player.player_speed_increased()
	elif Global.selected_effect == 10:
		player.player_speed_decreased()

func spawn_props_start():
	var spawned = 0
	while spawned < howManyProps:
		var random_index = randi_range(0, props_locations.size() - 1)
		
		if props_locations[random_index].get_child_count() > 0:
			return
		
		var newProp = PROPS.instantiate()
		props_locations[random_index].add_child(newProp)
		newProp.position = Vector2.ZERO
		
		spawned += 1

func spawn_ghost_at_start():
	var spawned = 0
	while spawned < howManyGhosts:
		var random_index = randi_range(0, ghost_locations.size() - 1)
		
		if ghost_locations[random_index].get_child_count() > 0:
			continue
		
		var newGhost = GHOST.instantiate()
		newGhost.player = player
		ghost_locations[random_index].add_child(newGhost)
		newGhost.position = Vector2.ZERO
		
		spawned += 1

func set_more_ghosts(state):
	moreGhosts = state
	
func set_more_agressive_ghosts(state):
	Global.more_agressive_ghosts = state
	print("more agressive")
	
func set_ghost_visibility_decreased(state):
	Global.ghost_visibilty_decreased = state
	print("decreased visibility")
