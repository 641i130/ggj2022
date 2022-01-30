extends Area3D

#var dir
#var original_pos
#var speed
#var move_range
#var move_dir

#var angles = [3.14, 3.14 / 2, 3.14 * 2, 0, 3.14 / 6, 3.14 / 4, 3.14 / 3, 7 * 3.14 / 6, 5 * 3.14 / 4, 4 * 3.14 / 3, 11 * 3.14 / 6, 7 * 3.14 / 4, 5 * 3.14 / 3, 3 * 3.14 / 2]
#var angles = [3.14, 3.14 / 2, 3.14 * 2, 0]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	self.dir = 1.0
#	self.original_pos = transform.origin
#	self.speed = 0.05
#	self.move_range = 12
#	var rng = RandomNumberGenerator.new()
#	self.move_dir = rng.randi() % 3 # moveDirEnum {MOVE_X = 0, MOVE_Y = 1, MOVE_Z = 2}
#	print(move_dir)
#	# TODO give random orientation (rotate on x || y || z axis) 
#	if(move_dir == 0):
#		rotate_y(self.angles[rng.randi() % len(angles)])
#	elif(move_dir == 1):
#		rotate_x(self.angles[rng.randi() % len(angles)])
#	else:
#		rotate_z(self.angles[rng.randi() % len(angles)])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	pass
	# randomly give ring move dir
#	if(move_type == 0):
#		transform.origin.x += (delta * move_dir)
#		if(transform.origin.distance_squared_to(self.original_pos)):
#			move_dir *= -1.0
	
func _on_ring_body_entered(_body):
	$Mesh.hide()
	
	# player score update
	Player.ringCollected()
	
	# sound
	$RingSFX.pitch_scale = randf_range(0.7,1.7)
	$RingSFX.play()

func _on_ring_sfx_finished():
	self.queue_free()
