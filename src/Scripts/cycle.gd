#extends Node3D
#class_name Cycle
#
#
## Called when the node enters the scene tree for the first time.
#func _init():
#	#self.mode = _mode
#	# Just store curret gameMode in Player... (can be used across scenes)
#
#	self.current_time = 0.0
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func update(delta):
#	#self.rotation.x += min_tic_rate
#	#print(self.rotation.x)
#	#print(delta)
#
#
#func isCycleComplete():
#	if current_time >= getTotalTime():
#		return true
#	return false
#
#
#func getTotalTime():
#	Player.getCycleTotalTime()
##	if self.mode == Player.Mode.NIGHT:
##		return Player.getNightCycleTotalTime()
##	elif self.mode == Player.Mode.DAY:
##		return Player.getDayCycleTotalTime()
#
#
###
### TODO:: handle cycle complete => switch scene || end game
####
##func CycleComplete():
##	self.initialize()
##	Player.CycleComplete()
