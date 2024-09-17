extends Node2D

@onready var transition_timer = $CardCanvas/TransitionTimer
@onready var cards_timer = $CardCanvas/CardsTimer

@onready var card_spawn = $CardCanvas/CardSpawn

@onready var fade = $Module/TransitionColor/Fade

@export var cards : Array[Node2D] = []

func _ready():
	card_spawn.play("cards")
	fade.get_parent().visible = false

func _on_continue_pressed():
	cards[0].burn()
	cards[1].burn()
	cards[2].burn()
	
	%Continue.visible = false
	Global.card_selected = true
	
	transition_timer.start(2)

func card_opened():
	cards_timer.start(3)

func _start_game():
	Global.goto_world()

func _on_transition_timer_timeout():
	fade.get_parent().visible = true
	fade.play("fade")

func _on_cards_timer_timeout():
	fade.get_parent().visible = true
	fade.play("fade")
