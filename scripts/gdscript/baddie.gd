extends CharacterBody2D
@export var wandering_speed := 40.0
@export var fire_speed := 80.0
@export var player_object : Node2D

@onready var chase_timer: Timer = $ChaseTimer
@onready var player_tracker_pivot: Node2D = $PlayerTrackerPivot
@onready var player_tracker_area: Area2D = $PlayerTrackerPivot/PlayerTrackerArea

var current_speed := 0.0
var playerFound := false
var other_area
var self_area

enum STATES{
	WANDER,
	FIGHT
}

var current_state = STATES.WANDER

func _ready():
	self.set_meta("isColliding", false)
	chase_timer.timeout.connect(_on_timer_timeout)
	printerr("Make sure you are running the AI_Test Scene!!!")

	
func _physics_process(delta: float) -> void:
	_handle_vision()
	_track_player()
	_handle_movement(delta)
	move_and_slide()
	pass


func _handle_movement(delta : float):
	var direction = self.global_position - player_object.global_position
	if current_state == STATES.WANDER:
		if !$Floor_checks/Floot_RC_Right.is_colliding():
			current_speed = -wandering_speed
		elif !$Floor_checks/Floot_RC_Left.is_colliding():
			current_speed = wandering_speed
	velocity.x = current_speed

func _track_player():
	player_tracker_pivot.look_at(player_object.global_position)

	
func _handle_vision():
	if self.get_meta("isColliding") and other_area.overlaps_area(self_area) and self_area.overlaps_area(other_area):
		print("FOUND PLAYER!!!")
		current_state = STATES.FIGHT
		playerFound = true
	else:
		playerFound = false
		
	
func _on_timer_timeout() -> void:
	if playerFound == false:
		current_state = STATES.WANDER


func _on_area_2d_area_entered(area: Area2D) -> void:
	self_area = area
	self.set_meta("isColliding", true)



func _on_player_body_area_entered(area: Area2D) -> void:
	other_area = area
