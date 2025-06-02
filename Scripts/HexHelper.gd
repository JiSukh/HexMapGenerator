extends Node
class_name HexHelper

const hex_width = 1.15 * sqrt(3)
const hex_height = 1.15 * 1.5

static func offset_to_world(col: int, row: int) -> Vector3:
	var x = hex_width * col

	if (row & 1) == 1:
		x += hex_width / 2
	
	var z = hex_height * row
	
	return Vector3(x, 0, z)

static func offset_to_world_chunk(col: int, row: int, chunk_size: int) -> Vector3:
	var chunk_tile_count = chunk_size * 2 + 1
	
	# alculate base position of chunk origin (in world space)
	var x = hex_width * col * chunk_tile_count
	var z = hex_height * row * chunk_tile_count
	
	if (row & 1) == 1:
		x += hex_width / 2
	
	return Vector3(x, 0, z)
	
### NEIGHBOUR ALGORITHM

static func get_neighbor(coord: Vector2i, direction: int) -> Vector2i:
	var oddr_direction_differences = [
		# even rows reordered to start from 5
		[[0, +1], [+1, 0], [0, -1], [-1, -1], [-1, 0], [-1, +1]],
		# odd rows reordered to start from 5
		[[+1, +1], [+1, 0], [+1, -1], [0, -1], [-1, 0], [0, +1]]
	]

	var parity = coord.y & 1
	var diff = oddr_direction_differences[parity][direction]
	return Vector2i(coord.x + diff[0], coord.y + diff[1])
	
	
static func world_to_chunk_coord(pos: Vector3, chunk_size: int) -> Vector2i:
	
	var row = pos.z / (1.15 * chunk_size)

	var x_adjusted = pos.x
	if int(row) & 1:
		x_adjusted -= hex_width / 2
	
	var col = x_adjusted / (1.15 * chunk_size)
	
	return Vector2i(col, row)
