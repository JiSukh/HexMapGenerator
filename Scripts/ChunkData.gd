extends Node
class_name ChunkData

const CHUNK_SIZE := 2

# Chunk's positioning within world.
var world_col: int
var world_row: int

#data for items in chunk
var tile_map : Dictionary[Vector2i, HexTileData] = {}

func generate_chunk(world_col:int, world_row:int, noise_map: FastNoiseLite, scale = 0.2) -> ChunkData:
	self.world_col = world_col
	self.world_row = world_row
	
	var chunk_tile_count = CHUNK_SIZE * 2 + 1
	
	for chunk_col in range(-CHUNK_SIZE, CHUNK_SIZE+1):
		for chunk_row in range(-CHUNK_SIZE, CHUNK_SIZE+1):
			var world_x = world_col * chunk_tile_count + chunk_col
			var world_y = world_row * chunk_tile_count + chunk_row
			var noise = noise_map.get_noise_2d(world_x * scale, world_y * scale)
			
			var key = Vector2i(chunk_col, chunk_row)
			var tile = TileStore.get_tile_by_noise(noise)
			tile.chunk_col = chunk_col
			tile.chunk_row = chunk_row
			tile.world_tile_col = world_x
			tile.world_tile_row = world_y
			tile.elevation = get_elevation(noise)
			
			tile_map[key] = tile
			
	return self
func get_elevation(noise:float) -> int:
	if noise > 0:
		return floor(noise*10)
	return 0
		
	
func clear_chunk():
	"""
	Deletes the chunk from memory
	"""
	for tile in tile_map.values():
		tile.queue_free()
	tile_map.clear()
