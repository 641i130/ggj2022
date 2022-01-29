extends Spatial

const chunk_size = 64
const chunk_amount = 16

var noise
var chunks = {}
var unready_chunks = {}
var thread

func _ready():
	# Init randomization stuffs
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.period = 80
	noise.octaves = 6
	# Enable threading for faster loadtimes!
	thread = Thread.new()

func add_chunk(x, z):
	var key = str(x) + "," + str(z) # Yes, keys are strings :P TODO optimize
	if chunks.has(key) or unready_chunks.has(key): # If the key we're making exsists, don't generate!
		return
	
	if not thread.is_active(): # If the thread didn't start, start it
		thread.start(self, "load_chunk",[thread,x,z])
		unready_chunks[key] = 1 # Sets the chunk to unready state so we can add to it

func load_chunk(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	var chunk = Chunk.new(noise, x*chunk_size, z*chunk_size, chunk_size) # Gen chunk
	chunk.translation = Vector3(x * chunk_size, 0, z * chunk_size) # Set chunk position
	
	call_deferred("load_done", chunk, thread) # End chunk gen for chunk
	
func load_done(chunk, thread):
	add_child(chunk)
	var key = str(chunk.x / chunk_size) + "," + str(chunk.z / chunk_size) # TODO optimize
	chunks[key] = chunk #PUT into ready chunks!
	unready_chunks.erase(key) # remove from ready state buffer
	thread.wait_to_finish()
	
func get_chunk(x, z):
	var key = str(x) + "," + str(z)
	if chunks.has(key):
		return chunks.get(key)
	return null
	
func _process(delta):
	update_chunks() 
	clean_up_chunks()
	reset_chunks()
	
func update_chunks():
	# Get player location
	var player_translation = $Player.translation
	var p_x = int(player_translation.x)/chunk_size
	var p_z = int(player_translation.z)/chunk_size
	
	for x in range(p_x - chunk_amount * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			add_chunk(x,z)
	
	
func clean_up_chunks():
	pass
	
func reset_chunks():
	pass
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
