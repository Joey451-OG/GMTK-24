class_name Baddie
extends CharacterBody2D

@onready var left: RayCast2D = $Wall_checks/Left
@onready var right: RayCast2D = $Wall_checks/Right
@onready var floot_rc_left: RayCast2D = $Floor_checks/Floot_RC_Left
@onready var floot_rc_right: RayCast2D = $Floor_checks/Floot_RC_Right
@onready var player_tracker_rc: RayCast2D = $PlayerTrackerPivot/PlayerTrackerRC
@onready var player_tracker_pivot: Node2D = $PlayerTrackerPivot

@onready var chase_timer: Timer = $ChaseTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var wandering_speed := 40.0
@export var fire_speed := 80.0

var current_speed := 0.0
var playerFound := false

enum STATES {
	WANDER,
	CHASE,
}

var current_state = STATES.WANDER

func _ready():
	chase_timer.timeout.connect(_on_timer_timeout)
	
func _physics_process(delta: float) -> void:
	pass
	
func _handle_vision():
	if player_tracker_rc.is_colliding():
		pass ##ERROR HERE EARILER
	
func _on_timer_timeout() -> void:
	if playerFound == false:
		current_state = STATES.WANDER
