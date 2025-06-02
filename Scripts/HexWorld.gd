extends Node
class_name HexWorld

const CHUNKS := 6 #Number of chunks (radius) to render around base chunk
const SCALE := 0.4
var noise_map = FastNoiseLite.new()
var tree_map := FastNoiseLite.new()
var tree_map_b := FastNoiseLite.new()

#RENDER DISTANCE
const RENDER_DISTANCE := 5  # how many chunks to load around current center

var current_chunk_coords: Vector2i = Vector2i.ZERO
var rendered_chunks: Dictionary[Vector2i, HexChunk] = {}

var chunk_map : Dictionary[Vector2i, ChunkData] = {}
var global_tile_data_map: Dictionary[Vector2i, HexTileData] = {}
var global_tile_map: Dictionary[Vector2i, HexTile] = {}

# DEBUG
@onready var text: RichTextLabel = $"../Coordinate/y"
@onready var texture:TextureRect = $"../Coordinate/TextureRect"



func _ready():
	generate_noise_maps()
	update_chunks_around(Vector2i(0,0))
	
	for chunk_coords in chunk_map.keys():
		render_chunk(chunk_coords)
		
	#print(global_tile_map[Vector2i(0,0)].hex_tile_data.elevation)

func generate_noise_maps():
	noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_map.seed= randi()
	noise_map.frequency = 0.3
	
	tree_map.noise_type = FastNoiseLite.TYPE_SIMPLEX
	tree_map.seed= randi()
	tree_map.frequency = 0.2
	
	tree_map_b.noise_type = FastNoiseLite.TYPE_SIMPLEX
	tree_map_b.seed= randi()
	tree_map_b.frequency = 0.2
	
func _process(delta):
	var player_pos = $"../CharacterBody3D".global_position
	


	const tile_width = 1.15 * sqrt(3)
	const tile_height = 1.15 * 1.5

	var chunk_world_width = tile_width * ChunkData.CHUNK_SIZE * 2 + 1
	var chunk_world_height = tile_height * ChunkData.CHUNK_SIZE * 2 + 1

	var rough_chunk_x = round(player_pos.x / chunk_world_width)
	var rough_chunk_y = round(player_pos.z / chunk_world_height)

	var player_chunk_coords = Vector2i(rough_chunk_x, rough_chunk_y)

	if player_chunk_coords != current_chunk_coords:
		current_chunk_coords = player_chunk_coords
		update_chunks_around(current_chunk_coords)

		text.text = "Chunk: %s" % player_chunk_coords

		
		

func update_chunks_around(center_chunk: Vector2i):
	for dx in range(-RENDER_DISTANCE, RENDER_DISTANCE + 1):
		for dy in range(-RENDER_DISTANCE, RENDER_DISTANCE + 1):
			var chunk_coords = center_chunk + Vector2i(dx, dy)
			if not rendered_chunks.has(chunk_coords):
				
				
				# Generate if needed
				if not chunk_map.has(chunk_coords):
					var chunk_data = ChunkData.new().generate_chunk(chunk_coords.x, chunk_coords.y, noise_map, tree_map, SCALE)
					chunk_map[chunk_coords] = chunk_data

				# Render
				render_chunk(chunk_coords)
				



func render_chunk(chunk_coords: Vector2i):
	"""
	Renders a chunk, given its offset coordinates in the chunk_map.
	"""
	var chunk_data = chunk_map[chunk_coords]
	
	# Replace with chunk replacement logic soon.
	if has_node("Chunk_%s_%s" % [chunk_coords.x, chunk_coords.y]):
		return
	
	var hex_chunk = HexChunk.new()
	hex_chunk.name = "Chunk_%s_%s" % [chunk_coords.x, chunk_coords.y]
	hex_chunk.setup(chunk_data, self)
	
	# Position chunk within world
	var chunk_pos = HexHelper.offset_to_world_chunk(chunk_coords.x, chunk_coords.y, chunk_data.CHUNK_SIZE)
	hex_chunk.position.x = chunk_pos.x
	hex_chunk.position.z = chunk_pos.z
	add_child(hex_chunk)
	
	#add to rendered_chunks
	rendered_chunks[chunk_coords] = hex_chunk
