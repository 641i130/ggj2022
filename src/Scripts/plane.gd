extends CharacterBody3D

# Can't fly below this speed
var min_flight_speed = 0
# Maximum airspeed
var max_flight_speed = 30
# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 30
# Lerp speed returning wings to level
var level_speed = 3.0
# Throttle change speed
var throttle_delta = 30
# Acceleration/deceleration
var acceleration = 6.0

# Current speed
var forward_speed = 0
# Throttle input speed
var target_speed = 0
# Lets us change behavior when grounded
var grounded = false

var velocity = Vector3.ZERO
var turn_input = 0
var pitch_input = 0

func _physics_process(delta):
	get_input(delta)
	# Rotate the transform based on the input values
	# For pitch input (up and down) rotate x based off of that
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	# For turn input (left and right) rotate vector DOWN based off of that
	transform.basis = transform.basis.rotated(Vector3.DOWN, turn_input * turn_speed * delta)
	
	var lookAt = transform.origin - transform.basis.z
	
	$Mesh.rotation.x = lerp($Mesh.rotation.x, turn_input, level_speed * delta)
	$Mesh.rotation.z = lerp($Mesh.rotation.z, pitch_input*1, level_speed * delta)
	# Accelerate/decelerate
	transform.basis.z = transform.origin - lookAt
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
	# Movement is always forward
	print(transform.basis.z)
	velocity = (-transform.basis.z * forward_speed)
	# Handle landing/taking off
	
	rotation.x = 0
	motion_velocity = velocity
	velocity = move_and_slide()

func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if Input.is_action_pressed("throttle_down"):
		target_speed = max(forward_speed - throttle_delta * delta*2, min_flight_speed)
	# Turn (roll/yaw) input
	turn_input = 0
	turn_input += Input.get_action_strength("roll_right")
	turn_input -= Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")

