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

@export var player_object := CharacterBody2D

var current_speed := 0.0
var playerFound := false

enum STATES {
	WANDER,
	CHASE,
}

var current_state = STATES.WANDER

func _ready():
	chase_timer.timeout.connect(_on_timer_timeout)
	printerr("Make sure you are running the AI_Test Scene!!!")

func _physics_process(delta: float) -> void:
	_handle_vision()
	_track_player()
	_handle_movement()
	move_and_slide()
	pass

func _handle_movement():
	var direction = self.global_position - player_object.global_position
	if current_state == STATES.WANDER:
		if !$Floor_checks/Floot_RC_Right.is_colliding():
			current_speed = -wandering_speed
		if !$Floor_checks/Floot_RC_Left.is_colliding():
			current_speed = wandering_speed
		if $Wall_checks/Left.is_colliding():
			current_speed = -wandering_speed
		if $Wall_checks/Right.is_colliding():
			current_speed = wandering_speed
	velocity.x = current_speed
	
func _track_player():
		
	var dir_to_player : Vector2 = Vector2(player_object.position.x, player_object.position.y - 12)\
	 - player_tracker_rc.position
	player_tracker_pivot.look_at(dir_to_player)

func _handle_vision():
	if player_tracker_rc.is_colliding():
		var collision_result = player_tracker_rc.get_collider()
		if collision_result != player_object:
			return
		else:
			current_state = STATES.CHASE
			chase_timer.start(1)
			playerFound = true
	else:
		playerFound = false
func _on_timer_timeout() -> void:
	if playerFound == false:
		current_state = STATES.WANDER
