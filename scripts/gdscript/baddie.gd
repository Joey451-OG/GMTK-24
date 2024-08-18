extends CharacterBody2D
@export var wandering_speed := 170.0
@export var fighting_speed := 100.0
@export var fire_speed := 80.0
@export var fighting_range_limit_h := 500.0
@export var fighting_range_limit_l := 400.0
@export var col_area : Area2D
@export var player_object : Node2D
@export var isAlive := true

@onready var rc_right = $Wall_checks/Right
@onready var rc_left = $Wall_checks/Left

@onready var rc_right_f = $Floor_checks/Floot_RC_Right
@onready var rc_left_f = $Floor_checks/Floot_RC_Left

@onready var view_cast = $Vision_cast

var projectile_list = []
var projectile_velocity_data_list = []

var projectile_asset = preload("res://scenes/box.tscn")

var current_state := STATES.WANDER
var current_speed := 0.0
var playerFound := false
var wasHit := false
var resetTime = 0.1

var x_direction
var y_direction

var dir_to_player_x
var dir_to_player_y

var proj_index : int

enum STATES{
	WANDER,
	FIGHT
}

func _ready():
	x_direction = wandering_speed
	y_direction = 0.0

func _process(delta):
	_rotate_vision_ray(delta)
	_manage_states(delta)
	_move_character(delta)
	
	# really bad hack to reset wasHit every few milisecs
	if resetTime > 0:
		resetTime -= 0.00001
	else:
		resetTime = 0.001
		wasHit = false
	_update_spawned_projectiles(delta)

func _rotate_vision_ray(delta : float):
	view_cast.target_position = (player_object.position + Vector2(0.0,35.0)) - self.global_position

func _manage_states(delta : float) -> void:
	if view_cast.get_collider() != player_object:
		current_state = STATES.WANDER
	elif view_cast.get_collider() == player_object:
		current_state = STATES.FIGHT

func _move_character(delta : float) -> void:
	dir_to_player_x = (player_object.global_position.x - self.global_position.x)
	dir_to_player_y = (player_object.global_position.y - self.global_position.y) - 10.0
	if current_state == STATES.WANDER:
		if x_direction == 0.0:
			x_direction = wandering_speed
		if rc_left.is_colliding() or !rc_left_f.is_colliding():
			x_direction = wandering_speed
		elif rc_right.is_colliding() or !rc_right_f.is_colliding():
			x_direction = -wandering_speed
	if current_state == STATES.FIGHT:
		if (self.position.distance_to(player_object.global_position) > fighting_range_limit_h):
			x_direction = (dir_to_player_x/self.position.distance_to(player_object.global_position))*wandering_speed
		elif (self.position.distance_to(player_object.global_position) < fighting_range_limit_l):
			x_direction = -(dir_to_player_x/self.position.distance_to(player_object.global_position))*fighting_speed
		else:
			x_direction = 0.0
			if Input.is_action_just_pressed("leftClick"):
				_spawn_projectile(projectile_asset, Vector2(dir_to_player_x/self.position.distance_to(player_object.global_position), dir_to_player_y/self.position.distance_to(player_object.global_position)))
	
	if !is_on_floor():
		y_direction += (60 * 60) * delta
	else:
		y_direction = 0.0
	
	velocity.x = x_direction
	velocity.y = y_direction
	move_and_slide()

func _on_baddie_hit_box_area_entered(area: Area2D) -> void:
	wasHit = true

func _on_box_area_entered(box, inID) -> void:
	if box.get_meta("isFired"):
		_kill()

func _kill():
	if wasHit:
		wasHit = false
		self.queue_free()
	
func _spawn_projectile(asset, direction : Vector2):
	projectile_list.append(projectile_asset.instantiate())
	get_tree().root.add_child(projectile_list[proj_index])
	projectile_list[-1].global_position = $bullet_point.global_position
	
	proj_index += 1
	projectile_velocity_data_list.append(direction)

func _update_spawned_projectiles(delta : float):
	for p in projectile_list:
		p.global_position += (projectile_velocity_data_list[0] * fire_speed * delta)
