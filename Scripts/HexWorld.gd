extends Node
class_name HexWorld

const CHUNKS := 5 #Number of chunks (radius) to render around base chunk

var noise_map = FastNoiseLite.new()
var chunk_map : Dictionary[Vector2i, ChunkData] = {}
var global_tile_map: Dictionary[Vector2i, HexTileData] = {}
var foliage_generator: FoliageGenerator


func _ready():
	noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_map.seed= randi()
	noise_map.frequency = 0.4
	
	foliage_generator = FoliageGenerator.new()
	
	generate_chunks()
	generate_foliage()
	
	for chunk_coords in chunk_map.keys():
		render_chunk(chunk_coords)

	
func generate_chunks():
	for world_col in range(-CHUNKS, CHUNKS+1):
		for world_row in range(-CHUNKS, CHUNKS+1):
			### PASS 1 - GENERATE BASIC TERRAIN
			var key = Vector2i(world_col, world_row)
			var chunk_data = ChunkData.new().generate_chunk(world_col, world_row, noise_map)
			chunk_map[key] = chunk_data
			
			# global tile map
			for chunk_coord in chunk_data.tile_map.keys():
				var tile = chunk_data.tile_map[chunk_coord]
				var global_coord = Vector2i(tile.world_tile_col, tile.world_tile_row)
				global_tile_map[global_coord] = tile
				

func generate_foliage():
	foliage_generator.generate_foliage(global_tile_map)

	


func render_chunk(chunk_coords: Vector2i):
	"""
	Renders a chunk, given its offset coordinates in the chunk_map.
	"""
	var chunk_data = chunk_map[chunk_coords]
	
	# Check if chunk node already exists (optional)
	if has_node("Chunk_%s_%s" % [chunk_coords.x, chunk_coords.y]):
		return
	
	# Create new HexChunk node
	var hex_chunk = HexChunk.new()
	hex_chunk.name = "Chunk_%s_%s" % [chunk_coords.x, chunk_coords.y]
	
	# Setup HexChunk with chunk_data (calls setup to create tile instances)
	hex_chunk.setup(chunk_data)
	
	# Position chunk node in world using HexHelper
	var chunk_pos = HexHelper.offset_to_world_chunk(chunk_coords.x, chunk_coords.y, chunk_data.CHUNK_SIZE)
	hex_chunk.position = chunk_pos
	
	# Add to scene tree
	add_child(hex_chunk)
