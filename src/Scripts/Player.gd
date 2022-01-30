extends Node

enum Mode {MENU, NIGHT, DAY}

const ringTimeValue_night = 1.0
const ringTimeValue_day = 0.5

var points
var day_cycle_total_time

var mode 
# Called when the node enters the scene tree for the first time.
func _ready():
	self.points = 0
	self.mode = Mode.NIGHT
	self.day_cycle_total_time = 30 # player gets atleast 10secs in day cycle
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#may require knowing which cycle finsihed if reused
func CycleComplete(mode):
	if mode == Mode.DAY:
		GameOver()

func GameOver():
	pass
	
func getTotalTime():
	return day_cycle_total_time

func addTime(delta):
	self.day_cycle_total_time += delta
	
func ringCollected():
	#TODO:: remove conditional by creating 'day'+'night' rings
	if mode == Mode.NIGHT:
		self.addTime(ringTimeValue_night)
	if mode == Mode.DAY:
		self.addTime(ringTimeValue_day)
		points += 1

	
	
