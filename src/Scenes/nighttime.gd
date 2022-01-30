extends DirectionalLight3D

# rotation angle in radians
const cycle_rot_start = 0
const cycle_rot_end = -3.14/2

var cycle

# Called when the node enters the scene tree for the first time.
func _ready():
	self.initialize()

func initialize():
	self.rotation = Vector3(self.cycle_rot_start,180,180)
	self.cycle = Cycle.new(Player.Mode.NIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tS = self.cycle.update(delta)
	
	self.quaternion = self.quaternion.slerp(Quaternion(Vector3.RIGHT, self.cycle_rot_end), tS * delta)

	if self.cycle.isCycleComplete():
		self.CycleComplete()

func CycleComplete():
	get_tree().change_scene("res://Scenes/Day.tscn")	

