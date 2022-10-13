extends KinematicBody2D

var wheel_base = 64 # Distance from front to rear wheel
var steering_angle = .2  # Amount that front wheel turns, in degrees

var friction = -0.9
var drag = -0.0015

var braking = -450
var max_speed_reverse = 250

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = .1 # High-speed traction
var traction_slow = .7  # Low-speed traction

var velocity = Vector2.ZERO
var steer_angle
var engine_power = 1600
var rpm_counter = 0.0
var gear = 1
var acceleration = Vector2.ZERO

onready var traction = traction_slow

onready var engine_loop_sound: AudioStreamPlayer = $EngineLoopSound
onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	cpu_particles_2d.emitting = false
	engine_loop_sound.playing = true
	pass

func _physics_process(delta):
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	
	engine_loop_sound.pitch_scale = .4 + (rpm_counter/1000 + ((gear)/5))
	

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	print(turn,' ', steering_angle)
	steer_angle = turn * steering_angle
	if Input.is_action_just_pressed('gear_up') and gear != 5:
		if gear >= 5:
			return
		gear += 1
		
		
		if rpm_counter > 300:
			rpm_counter -= 300

	if Input.is_action_just_pressed('gear_down'):
		if gear == 0:
			return
		gear -= 1
		if rpm_counter < 1000:
			rpm_counter += 300
	if Input.is_action_pressed('accelerate'):
		
		if rpm_counter < 1000:
			rpm_counter += (10 / (gear + 1))
		if gear == 0:
			engine_power = 0
		else:
			engine_power = rpm_counter * ((gear+1))
	else:
		if rpm_counter > 0:
			rpm_counter -= 10
	if Input.is_action_pressed('handbrake'):
		if rpm_counter >= 0:
			rpm_counter -= 10
		steering_angle = .4
		traction = 0
		cpu_particles_2d.emitting = true
	else:
		steering_angle = .2
		cpu_particles_2d.emitting = false
	acceleration = Vector2.ZERO
	if Input.is_action_pressed("accelerate"):
		print(velocity.length())
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
		
	

	

func calculate_steering(delta):
	
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	if velocity.length() > slip_speed:
		traction = lerp(traction, traction_fast, .1)
	elif velocity.length() < slip_speed:
		traction = lerp(traction, traction_slow, .1)
	
	print(traction)
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force
