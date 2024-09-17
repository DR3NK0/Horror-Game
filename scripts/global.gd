extends Node
#Menu
var card_selected = false
static var selected_effect = 0

#World
var is_underworld = false
var flashlight_toggle = true
var note_opened = false

var found_props = 0

var more_agressive_ghosts = false
var ghost_visibilty_decreased = false

var game_lost = false

func _ready():
	if get_tree().get_current_scene().get_name() == "Menu":
		selected_effect = 0
		card_selected = false
	elif get_tree().get_current_scene().get_name() == "World":
		is_underworld = false
		found_props = 0
		note_opened = false
		game_lost = false

func goto_world():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func goto_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

