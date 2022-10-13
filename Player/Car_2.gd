extends KinematicBody2D

var acceleration = 1000
var drag = 10
var max_speed = 1000
var brake_force = 2

var forward_force = Vector2.ZERO
var velocity = Vector2.ZERO
var input = Vector2.ZERO

func _physics_process(delta: float) -> void:
	#accelerate
	if Input.is_action_pressed('accelerate'):
		forward_force = forward_force.move_toward(transform.x * max_speed, acceleration * delta)
		velocity = forward_force
		#drag
		if velocity != Vector2.ZERO:
			var drag_force = velocity * drag
			forward_force -= drag_force
	#steering
	input = Input.get_axis('steerleft', 'steerright')
	rotation_degrees += input * 3.5
	#move
	velocity = move_and_slide(velocity)
	pass
	
