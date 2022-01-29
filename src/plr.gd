extends KinematicBody

var moveSpeed : float = 150.0
var jumpForce : float = 10.0
var gravity : float = 12.0

var minLookAngle : float = -90
var maxLookAngle : float = 90
var lookSensitivity : float = 20

var joySensitivity : float = 80

var toggled : bool = false # Mouse toggling for ESC button

# Velocity (player) is in 3d
var vel : Vector3 = Vector3()
# Mouse is in 2d plain
var mouseDelta : Vector2 = Vector2()

# Parts
onready var camera : Camera = get_node("Camera")

func _ready():
	# Right at start of game
	# Hide lock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide and lock mouse in center of screen


func _physics_process(delta):
	# Detect inputs, move player and add gravity
	# Reset 
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	# movement
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	
	# So we don't move faster diagonally
	input = input.normalized()
	
	# Get dir we are facing
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# Gives vector 
	var relativeDir = (forward * input.y + right * input.x)
	
	# Set velocity
	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	# Delta is for every frame
	#vel.y -= gravity * delta * 0.9
	
	# Move player!
	vel = move_and_slide(vel, Vector3.UP)
	
	# Jump
	#if Input.is_action_pressed("up"): # Pushes plane up
		# Set y to jump vel
	#	vel.y += jumpForce
	
	#if Input.is_action_pressed("shift"): # Pushes plane up
		# Set y to jump vel
		#vel.y -= jumpForce
	
# Process for none physics related 
func _process(delta):
	# Rotate camera along the x axis
	# (Up and down of mouse movement)
	if (toggled == false):
		camera.rotation_degrees.x -= (mouseDelta.y * lookSensitivity * delta)

		# Stop rotating when not moving (sensitivity)
		# Clamp camera x rotate
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x,minLookAngle,maxLookAngle) # Prevent over looking camera
		# Rotate player along Y axis
		rotation_degrees.y -= (mouseDelta.x * lookSensitivity * delta)
		# Reset mouse delta
	mouseDelta = Vector2()
	
	
func _input(event):
	# Called whenever an input is detected
	
	# Check if event is mouse related
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

	if Input.is_action_just_pressed("pause"):
		if (toggled == true):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			toggled = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			toggled = true
