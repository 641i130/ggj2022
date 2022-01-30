extends DirectionalLight3D

# rotation angle in radians
const cycle_rot_start = 0
const cycle_rot_end = -3.14/2

#debug
const max_tic_rate = 0.04
const min_tic_rate = 0.0001 # smooth day transition delta (30secs-1min cycle)
	
var current_time 


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	self.initialize()

func initialize():
	Player.SetMode(Player.Mode.NIGHT)
	self.rotation = Vector3(cycle_rot_start,180,180)
	self.current_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.rotation.x += min_tic_rate
	#print(self.rotation.x)
	#print(delta)
	
	self.current_time += delta
	var max_time = Player.getCycleTotalTime()
	var tS = (current_time / max_time)

	self.quaternion = self.quaternion.slerp(Quaternion(Vector3.RIGHT, cycle_rot_end),tS * delta)

	if current_time >= max_time:
		self.CycleComplete()

##
## TODO:: handle cycle complete => switch scene || end game
##
func CycleComplete():
	#Player.CycleComplete()
	# must be called by nightime/daytime
	get_tree().change_scene("res://Scenes/Day.tscn")	
	#self.initialize()
