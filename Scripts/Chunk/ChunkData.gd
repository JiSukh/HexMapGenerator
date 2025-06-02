extends Node
class_name ChunkData

const CHUNK_SIZE := 2

# Chunk's positioning within world.
var world_chunk_coords: Vector2i




var tile_map : Dictionary[Vector2i, HexTileData] = {}

func generate_chunk(world_col:int, world_row:int, noise_map: FastNoiseLite, tree_map: FastNoiseLite, scale = 0.7) -> ChunkData:
	self.world_chunk_coords = Vector2i(world_col, world_row)
	
	# For working out a tile's world coordinates.
	var chunk_tile_count = CHUNK_SIZE * 2 + 1
	
	for chunk_col in range(-CHUNK_SIZE, CHUNK_SIZE+1):
		for chunk_row in range(-CHUNK_SIZE, CHUNK_SIZE+1):
			var world_x = world_col * chunk_tile_count + chunk_col
			var world_y = world_row * chunk_tile_count + chunk_row
			var noise = noise_map.get_noise_2d(world_x * scale, world_y * scale)
			var tree_noise = tree_map.get_noise_2d(world_x * scale, world_y * scale)
			
			### Generate tile with data
			var key = Vector2i(chunk_col, chunk_row)
			var tile: HexTileData = TileStore.get_tile_by_noise(noise)
			tile.chunk_tile_coords = Vector2i(chunk_col, chunk_row)
			tile.world_tile_coords = Vector2i(world_x, world_y)
			tile.elevation = generate_tile_elevation(noise)
			
			### Generate trees or tree rocks
			if not tile.is_water:
				var tree = TileStore.get_tree_by_noise(tree_noise, tile.elevation)
				if tree:
					tile.foliage_objects.append(tree)
					
					
			### Generate Houses, 
				
				
			tile_map[key] = tile
	return self
	
	
func generate_tile_elevation(noise:float) -> int:
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
