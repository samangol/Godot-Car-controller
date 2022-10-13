extends RigidBody2D
class_name Player

var wheel_base = 64
var drag = .9
var turn = .0
var steering_angle = 15
var steer_angle = .0
var steer_torque = 5000
var rpm_counter = .0
var engine_power = 0
var initianl_engine_sfx = .2
var gear = 0
var speed = linear_velocity.length()
var engine_on = false

onready var engine_loop_sound: AudioStreamPlayer = $engine_loop_sound
onready var engine_startup_sfx = load('res://Assets/Car_Engine_Start_Up.ogg')
onready var engine_loop_sfx = load('res://Assets/engine-loop-1-normalized.wav')
onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
onready var camera = get_node('../Camera2D')

func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	remote_transform_2d.remote_path = camera.get_path()
	engine_loop_sound.playing = false
	engine_loop_sound.volume_db = -15
	linear_damp = 2

func _physics_process(delta: float) -> void:
	start_engine()
	engine_system()
	steer()
	apply_engine_power()
	#brake
	if Input.is_action_pressed('brake'):
		linear_damp = 5
	else:
		linear_damp = 2
	
	#handbrake for drift
	if Input.is_action_pressed('handbrake'):
		if rpm_counter >= 0:
			rpm_counter -= 9
		set_linear_damp(2.5)
	else:
		set_linear_damp(2)

func engine_system():
	if engine_on:
		#gear system
		if Input.is_action_just_pressed('gear_up'):
			if gear == 5:
				return
			gear += 1
			rpm_counter -= rpm_counter * .3
		if Input.is_action_just_pressed('gear_down'):
			if gear == 0:
				return
			gear -= 1
			rpm_counter += .3 * rpm_counter * (gear+1)/2
		#rpm
		if rpm_counter >= 1000:
			rpm_counter -= 1
		if Input.is_action_pressed('accelerate'):
			if rpm_counter < 1000:
				if gear == 0:
					rpm_counter += 20
				else:
					rpm_counter += (10 / ((gear) + gear))
		#engine power 
			if gear == 0:
				engine_power = 0
			else:
				engine_power = rpm_counter/30 * ((gear+1))
		else:
			if rpm_counter > 0:
				rpm_counter -= 5
#			print(engine_power)
		
			
		#engine sfx
		engine_loop_sound.pitch_scale = initianl_engine_sfx + (rpm_counter/1000 * (gear+2)/2)

func start_engine():
	if Input.is_action_just_pressed('start_engine'):
		engine_loop_sound.stream = engine_startup_sfx
		engine_loop_sound.pitch_scale = 1.5
		engine_loop_sound.play()
		yield(engine_loop_sound, 'finished')
		engine_loop_sound.stream = engine_loop_sfx
		engine_loop_sound.play()
		engine_on = true
	
func steer():
	#steer---
	#steering wheel go back speed
	set_angular_velocity(lerp(angular_velocity, 0, 2)) 
	if speed > 80:
		steer_torque *= .8
	if linear_velocity.length() > 0:
		if Input.is_action_pressed('steer_left'):
			apply_torque_impulse(-steer_torque)
		if Input.is_action_pressed('steer_right'):
			apply_torque_impulse(steer_torque)
			
func apply_engine_power():
	#accelerate---
	if Input.is_action_pressed('accelerate'):
		#add engine force to car 
		apply_central_impulse(transform.x * engine_power)
	elif linear_velocity.length() < 5:
		linear_velocity = Vector2.ZERO
	#backwards
	if Input.is_action_pressed('brake'):
		if linear_velocity.length() <= 0.1:
			apply_central_impulse(-transform.x * engine_power)
