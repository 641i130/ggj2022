extends Node3D
class_name Cycle

var current_time 

# Called when the node enters the scene tree for the first time.
func _init(_mode):
	Player.SetMode(_mode)
	# Just store curret gameMode in Player... (can be used across scenes)
	self.current_time = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	#self.rotation.x += min_tic_rate
	#print(self.rotation.x)
	#print(delta)
	self.current_time += delta
	var max_time = Player.getCycleTotalTime()
	return (current_time / max_time)


func isCycleComplete():
	if current_time >= Player.getCycleTotalTime():
		return true
	return false


#func getTotalTime():
#	Player.getCycleTotalTime()
#	if self.mode == Player.Mode.NIGHT:
#		return Player.getNightCycleTotalTime()
#	elif self.mode == Player.Mode.DAY:
#		return Player.getDayCycleTotalTime()


##
## TODO:: handle cycle complete => switch scene || end game
###
#func CycleComplete():
#	self.initialize()
#	Player.CycleComplete()
