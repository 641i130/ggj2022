extends Node


var points

# Called when the node enters the scene tree for the first time.
func _ready():
	self.points = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ringCollected():
	points += 1
	print(points)
	
	
