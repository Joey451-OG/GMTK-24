extends CharacterBody2D

@export var col_shape_1: CollisionShape2D
@export var col_shape_2: CollisionShape2D

@export var hover_partical_CPU_stationary: CPUParticles2D
@export var hover_partical_CPU_trail: CPUParticles2D

@export var falling_partical_CPU: CPUParticles2D
@export var landing_partical_CPU: CPUParticles2D

@export var hover_GUI_mesh: MeshInstance2D

@export var max_health := 100.0
@export var gravity := 54.0
@export var jump_force := 800.0
@export var walk_speed := 360.0
@export var sprint_speed := 80.0
@export var coyote_time := 0.02
@export var hover_amount := 2.0
@export var hover_recovery := 5.56
@export var hover_force := 340.0

@export var camera: Camera2D
@export var ceiling_collider: Area2D

var final_velocity: Vector2
var target_camera_position: Vector2

var crnt_health: float

var in_air: bool
var can_still_jump: bool
var just_jumped: bool

var c_time: float

var can_hover: bool
var can_recover_hover: bool
var is_hovering: bool
var hover_a: float
var can_impact: bool

var result: Vector2
var t_velocity_x: float
var t_velocity_y: float

var temp_result: Vector2

# signals
signal area_entered(area: Area2D)

func _on_death():
	pass

func _ready():
	self.add_to_group("player")
	just_jumped=true
	can_hover=false
	hover_a=hover_amount
	crnt_health=max_health

func _process(delta) -> void:
	#print("PLAYER HEALTH: ", crnt_health)
	final_velocity = _calculate_move_vector(delta)
	target_camera_position = Vector2.ZERO
	_update_hover_logic(delta)
	_update_falling_effect(t_velocity_y)
	_update_upper_collider_position(delta)
	_update_lower_collider_position(delta)
	_move(final_velocity)
	
	if crnt_health < 0.1:
		_on_death()

func _calculate_move_vector(delta : float) -> Vector2:
	if !is_on_floor():
		in_air = true
		if !is_hovering:
			t_velocity_y += (gravity*gravity)*delta
	else:
		t_velocity_y = 0
		if just_jumped == true:
			just_jumped = false
			c_time = 0.0
		if in_air == true:
			_on_land(result.x)
			in_air = false
		else:
			in_air = false
	
	if is_on_floor() && Input.is_action_pressed("Forward") || can_still_jump && Input.is_action_pressed("Forward"):	
		t_velocity_y-=jump_force
		landing_partical_CPU.emitting = true
		just_jumped = true
		if can_still_jump == true:
			can_still_jump=false
	
	if !just_jumped && !is_on_floor():
		if c_time < coyote_time:
			c_time+=0.15*delta
			can_still_jump=true
		else:
			can_still_jump=false
	
	result.y = t_velocity_y
	
	if is_on_ceiling():
		if is_hovering:
			hover_a = 0.0
		t_velocity_y+=20.0 
	
	t_velocity_x = (int(Input.is_action_pressed("Right"))-int(Input.is_action_pressed("Left")))*walk_speed
	if !is_on_floor():
		result.x = lerp(result.x, t_velocity_x, 12.23*delta)
	elif is_on_floor():
		result.x = lerp(result.x, t_velocity_x, 18.23*delta)
	return result

func _draw() -> void:
	_draw_debug_elements()

func _update_interactions() -> void:
	pass

func _update_hover_logic(delta : float) -> void:
	if !is_on_floor() && hover_a > 0.15:
		can_hover=true
	else:
		can_hover=false
	
	if is_on_floor():
		can_recover_hover=true
	else:
		can_recover_hover=false
	
	if can_hover && Input.is_action_pressed("Sprint"):
		hover_a-=1.2*delta
		t_velocity_y=-hover_force
		is_hovering=true
	else:
		if can_recover_hover:
			hover_a+=hover_recovery*delta
		is_hovering=false
	hover_a=clampf(hover_a, 0.0, hover_amount)
	
	if is_hovering:
		hover_partical_CPU_trail.emitting=true
		hover_partical_CPU_stationary.emitting=true
	else:
		hover_partical_CPU_trail.emitting=false
		hover_partical_CPU_stationary.emitting=false
		
	if hover_a == hover_amount:
		hover_GUI_mesh.visible=false;
	else:
		hover_GUI_mesh.visible=true;
	
	hover_GUI_mesh.scale.x=hover_a

func _update_falling_effect(t_velocity_y : float) -> void:
	if t_velocity_y > 893:
		falling_partical_CPU.emitting = true
	else:
		falling_partical_CPU.emitting = false

func _update_upper_collider_position(delta: float) -> void:
	col_shape_2.position = lerp(col_shape_2.position, Vector2(0.0, -30.0), 12.0*delta)

func _update_lower_collider_position(delta: float) -> void:
	col_shape_1.position = lerp(col_shape_1.position, Vector2(0.0, -10.0), 12.0*delta)

func _on_land(target_velocity_x : float) -> void: #called when the player lands...
	if target_velocity_x != 0.0:
		landing_partical_CPU.direction.y = -2.0
		landing_partical_CPU.direction.x = -int(Input.is_action_pressed("Right"))-int(Input.is_action_pressed("Left"))
	else:
		landing_partical_CPU.direction.y = -1.0
	landing_partical_CPU.emitting = true
	col_shape_2.position+=Vector2(0.0, 20.3)

func _move(target_velocity: Vector2) -> void: #sets target velocity and moves player...
	velocity = target_velocity;
	move_and_slide()

func _draw_debug_elements():
	pass

func _kill():
	print("POW! YOU ARE DED!")
	get_node("/root/root")._reset_scene()

func _on_box_clicked(node : Node2D, id : int):
	$AOE._update_box_list(node, id)

func _on_hitbox_area_entered(area: Area2D) -> void:
	area_entered.emit(area)

func _on_body_entered(body):
	if body.is_in_group("enemy_bullet") && body != self:
		crnt_health -= max_health
		crnt_health = clampf(crnt_health, 0.0, max_health)
		if crnt_health == 0: 
			_kill()
