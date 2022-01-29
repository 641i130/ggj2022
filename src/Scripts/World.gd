extends Node3D

const chunk_size = 64
const chunk_amount = 16

var noise
var chunks = {}
var unready_chunks = {}
var thread

# Multithreading!
var threads = []
const max_threads = 3

# Sun values
var xSun = -5

func _ready():
	# Init randomization stuffs
	# Enable threading for faster loadtimes!
	for i in max_threads:
		threads.append(Thread.new())

func _process(delta):
	# Chunks
	update_chunks() 
	clean_up_chunks()
	reset_chunks()
	

# ==================================================CHUNKS============================================
func add_chunk(x, z):
	var key = str(x) + "," + str(z) # Yes, keys are strings :P TODO optimize
	if chunks.has(key) or unready_chunks.has(key): # If the key we're making exsists, don't generate!
		return

	for t in threads: # If the thread didn't start, start it
		if not t.is_started():
			t.start(self.load_chunk,[t,x,z])
			unready_chunks[key] = 1 # Sets the chunk to unready state so we can add to it
			break 

func load_chunk(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	var chunk = Chunk.new(noise, x*chunk_size, z*chunk_size, chunk_size) # Gen chunk
	chunk.position = Vector3(x*chunk_size, 0, z*chunk_size) # Set chunk position
	call_deferred("chunk_load_done", chunk, thread) # End chunk gen for chunk
	
func chunk_load_done(chunk, thread):
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

func update_chunks():
	# Get player location
	var player_translation = $Plane.position
	var p_x = int(player_translation.x)/chunk_size
	var p_z = int(player_translation.z)/chunk_size
	
	for x in range(p_x - chunk_amount * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			add_chunk(x,z)
			var chunk = get_chunk(x, z)
			if chunk != null:
				chunk.should_remove = false # If its in our vision we don't remove!

func clean_up_chunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.should_remove:
			chunk.queue_free()
			chunks.erase(key)
		
	
func reset_chunks():
	for key in chunks:
		chunks[key].should_remove = true

# ==================================================CHUNKS============================================
