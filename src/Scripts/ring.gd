extends Area3D

var dir
var original_pos
var speed
var move_range
var move_type
var move_dir
var thread
# Called when the node enters the scene tree for the first time.
func _ready():
	self.dir = 1.0
	self.original_pos = transform.origin
	self.speed = 0.05
	self.move_range = 12
	self.move_type = 0 # moveDirEnum {MOVE_X = 0, MOVE_Y = 1, MOVE_Z = 2}
	self.move_dir = 1.0
	
	# TODO give random orientation (rotate on x || y || z axis) 
#	if(move_)
#	{
#
#	}
#	rotate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass
	# randomly give ring move dir
#	if(move_type == 0):
#		transform.origin.x += (delta * move_dir)
#		if(transform.origin.distance_squared_to(self.original_pos)):
#			move_dir *= -1.0
	
func _on_ring_body_entered(body):
	$Mesh.hide()
	
	# player score update
	Player.ringCollected()
	
	# sound
	$RingSFX.pitch_scale = randf_range(0.7,1.7)
	$RingSFX.play()

func _on_ring_sfx_finished():
	self.queue_free()
