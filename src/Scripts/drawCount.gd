extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# If player in night scene
	if (Player.mode == Player.Mode.NIGHT):
		self.text = ""
	else:
		self.text = "Rings : " + str(Player.points)
