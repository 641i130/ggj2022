extends CharacterBody3D

# Can't fly below this speed
var min_flight_speed = 0
# Maximum airspeed
var max_flight_speed = 30
# Turn rate
var turn_speed = 0.25
# Climb/dive rate
var pitch_speed = 20
# Lerp speed returning wings to level
var level_speed = 0.75
# Throttle change speed
var throttle_delta = 30
# Acceleration/deceleration
var acceleration = 6.0
# Current speed
var forward_speed = 0
# Current speed
var upward_speed = 0
# Throttle input speed
var target_speedY = 0
var target_speedZ = 0

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
	
	$Mesh.rotation.x = clamp(lerp($Mesh.rotation.x, turn_input, level_speed * delta),-0.2,0.2)
	$Mesh.rotation.z = clamp(lerp($Mesh.rotation.z, pitch_input, level_speed * delta),-0.2,0.2)
	# Accelerate/decelerate
	forward_speed = lerp(forward_speed, target_speedZ, acceleration * delta)
	upward_speed = lerp(upward_speed, target_speedY, acceleration * delta)
	# Movement is always forward
	velocity = (-transform.basis.z * forward_speed + transform.basis.y * upward_speed)
	# Handle landing/taking off
	rotation.x = 0
	motion_velocity = velocity
	velocity = move_and_slide()

func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speedZ = min(forward_speed + throttle_delta * delta, max_flight_speed)
		target_speedY = min(upward_speed + throttle_delta * delta,30)
	if Input.is_action_pressed("throttle_down"):
		target_speedZ = max(forward_speed - throttle_delta * delta, min_flight_speed)
		target_speedY = max(upward_speed - throttle_delta * delta,-30)
	# Turn (roll/yaw) input
	turn_input = 0
	turn_input += Input.get_action_strength("roll_right")
	turn_input -= Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")
	
	

