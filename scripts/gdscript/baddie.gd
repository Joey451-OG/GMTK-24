extends CharacterBody2D
@export var wandering_speed := 170.0
@export var fighting_speed := 100.0
@export var fire_speed := 80.0
@export var fire_rate := 2.0
@export var fighting_range_limit_h := 500.0
@export var fighting_range_limit_l := 200.0
@export var box_handler : Node2D
@export var player_object : Node2D
@export var isAlive := true

@onready var rc_right = $Wall_checks/Right
@onready var rc_left = $Wall_checks/Left

@onready var rc_right_f = $Floor_checks/Floot_RC_Right
@onready var rc_left_f = $Floor_checks/Floot_RC_Left

@onready var view_cast = $Vision_cast

var projectile_list = []
var projectile_velocity_data_list = []

var projectile_asset = preload("res://scenes/enemy_projectile.tscn")

var current_state := STATES.WANDER
var current_speed := 0.0
var playerFound := false
var wasHit := false
var resetTime = 0.1

var fire_time
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
	self.add_to_group("baddies")
	x_direction = wandering_speed
	y_direction = 0.0
	fire_time = 0.0

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
		if (self.position.distance_to(player_object.global_position) > fighting_range_limit_h) && rc_left.is_colliding() or !rc_left_f.is_colliding():
			x_direction = (dir_to_player_x/self.position.distance_to(player_object.global_position))*wandering_speed 
		elif (self.position.distance_to(player_object.global_position) < fighting_range_limit_l) && rc_right.is_colliding() or !rc_right_f.is_colliding():
			x_direction = -(dir_to_player_x/self.position.distance_to(player_object.global_position))*fighting_speed
		else:
			x_direction = 0.0
			fire_time += 2.34 * delta
			if fire_time > fire_rate:
				_spawn_and_apply_force_to_box(Vector2.ZERO)
				fire_time = 0.0
	
	if !is_on_floor():
		y_direction += (60 * 60) * delta
	else:
		y_direction = 0.0
	
	velocity.x = x_direction
	velocity.y = y_direction
	move_and_slide()

func _kill():
	self.queue_free()
	proj_index += 1

func _on_projectile_enter(body):
	if body.is_in_group("boxes"):
		if body.get_meta("isFired"):
			box_handler._despawn_box_object(body)
			for block in projectile_list:
				box_handler._despawn_box_object(block)
			projectile_list = []
			projectile_velocity_data_list = []
			_kill()

func _spawn_and_apply_force_to_box(dir_vector):
	var p_asset = projectile_asset.instantiate()
	get_tree().root.add_child(p_asset)
	p_asset.global_position = self.global_position - Vector2(0.0, 45.0)
	p_asset.linear_velocity = Vector2(dir_to_player_x*1500.0, dir_to_player_y*1500.0)/self.position.distance_to(player_object.global_position)
	p_asset.add_to_group("enemy_bullet")
