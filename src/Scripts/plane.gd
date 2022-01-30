# Source
# http://kidscancode.org/godot_recipes/3d/simple_airplane/

extends CharacterBody3D

# Can't fly below this speed
var min_flight_speed = 1
# Maximum airspeed
var max_flight_speed = 5
# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 0.5
# Lerp speed returning wings to level
var level_speed = 3.0
# Throttle change speed
var throttle_delta = 1
# Acceleration/deceleration
var acceleration = 6.0

# Current speed
var forward_speed = 1
# Throttle input speed
var target_speed = 1

var velocity = Vector3.ZERO
var turn_input = 0
var pitch_input = 0


func _ready():
	pass
	
func _physics_process(delta):
	get_input(delta)
	# Rotate the transform based on the input values
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.DOWN, turn_input * turn_speed * delta)
	$Mesh.rotation.x = lerp($Mesh.rotation.x, turn_input, level_speed * delta)
	#$Mesh.rotation.z = lerp($Mesh.rotation.z, turn_input, level_speed * delta)
	# Accelerate/decelerate
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta*10)*10
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed 
	# Handle landing/taking off
	#velocity.y -= 1
	motion_velocity = velocity
	velocity = move_and_slide()#velocity, Vector3.UP)
		

func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if (forward_speed != 0 and Input.is_action_pressed("throttle_down")):
		target_speed = min(forward_speed - throttle_delta * delta, 10)
	# Turn (roll/yaw) input
	turn_input = 0
	if forward_speed > 0.5:
		turn_input += Input.get_action_strength("roll_right")
		turn_input -= Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")
	
