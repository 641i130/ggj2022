extends Spatial

const chunk_size = 128
const chunk_amount = 16

var noise
var chunks = {}
var unready_chunks = {}
var thread

var drops = {}
var unready_drops = {}

func _ready():
	# Init randomization stuffs
	# Enable threading for faster loadtimes!
	thread = Thread.new()

func _process(delta):
	# Chunks
	update_chunks() 
	clean_up_chunks()
	reset_chunks()
	
	# Drops
	update_drops() 
	clean_up_drops()
	reset_drops()
	

	

func add_drop(x, z):
	var key = str(x) + "," + str(z) # Yes, keys are strings :P TODO optimize
	if drops.has(key) or unready_drops.has(key): # If the key we're making exsists, don't generate!
		return
	
	if not thread.is_active(): # If the thread didn't start, start it
		thread.start(self, "load_drop",[thread,x,z])
		unready_drops[key] = 1 # Sets the chunk to unready state so we can add to it

func load_drop(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	var drop = Drop.new(x,z) # Gen chunk
	drop.translation = Vector3(x, rand_range(100,400), z) # Set chunk position
	call_deferred("drop_load_done", drop, thread) # End chunk gen for chunk

func update_drops():
	# Get player location
	var player_translation = $Player.translation
	var p_x = int(player_translation.x)/chunk_size
	var p_z = int(player_translation.z)/chunk_size
	
	for x in range(p_x - chunk_amount * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			for dIndex in range(0,chunk_size): # Amount of drops per chunk area
				
				# Randomly spawn
				# TODO conditional for randomly spreading them out
				add_drop(rand_range(0,128)+x,rand_range(0,128)+z)
				
				var drop = get_drop(x, z)
				if drop != null:
					drop.should_remove = false # If its in our vision we don't remove!

func drop_load_done(drop, thread):
	add_child(drop)
	var key = str(drop.x) + "," + str(drop.z) # TODO optimize
	drops[key] = drop #PUT into ready chunks!
	unready_drops.erase(key) # remove from ready state buffer
	thread.wait_to_finish()
	
func get_drop(x, z):
	var key = str(x) + "," + str(z)
	if drops.has(key):
		return drops.get(key)
	return null

func clean_up_drops():
	for key in drops:
		var drop = drops[key]
		if drop.should_remove:
			drop.queue_free()
			drops.erase(key)

func reset_drops():
	for key in drops:
		drops[key].should_remove = true

# ==================================================DROPS=============================================
# ==================================================CHUNKS============================================
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
	var player_translation = $Player.translation
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
