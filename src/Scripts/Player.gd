extends Node

enum Mode {MENU, NIGHT, DAY}

const ringTimeValue_night = 1.0
const ringTimeValue_day = 0.5

var points
const night_cycle_total_time = 10
var day_cycle_total_time

var mode 
var current_time
# Called when the node enters the scene tree for the first time.
func _ready():
	self.points = 0
	self.day_cycle_total_time = 30 # player gets atleast 10secs in day cycle
	self.mode = Mode.NIGHT
	self.current_time = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func resetCurrentTime():
	self.current_time = 0.0

func updateTime(delta):
	self.current_time += delta
	return self.current_time
	
func getCurrentTime():
	return self.current_time
	
##may require knowing which cycle finsihed if reused
#func cycleComplete(mode):
#	if self.mode == Mode.DAY:
#		self.GameOver()
#	elif self.mode == Mode.NIGHT:
#		self.switchToDayCycle()
#
#func switchToDayCycle():
#	get_tree().change_scene("res://Scenes/Day.tscn")	
#
#func GameOver():
#	print("GAMEOVER")
#	# stop cycling...
#
#func getTotalTime():
#	return day_cycle_total_time

func addTime(delta):
	self.day_cycle_total_time += delta
	
func getCycleTotalTime():
	if self.mode == Mode.DAY:
		return self.day_cycle_total_time
	elif self.mode == Mode.NIGHT:
		return self.night_cycle_total_time

func ringCollected():
	#TODO:: remove conditional by creating 'day'+'night' rings
	if mode == Mode.NIGHT:
		self.addTime(ringTimeValue_night)
	if mode == Mode.DAY:
		self.addTime(ringTimeValue_day)
		points += 1

func setMode(_mode):
	self.mode = _mode
	
