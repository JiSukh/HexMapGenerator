extends Node3D
class_name HexChunk

var chunk_data: ChunkData
var label_map: Dictionary[Vector2i, Label3D] = {}
var aabb: AABB

func setup(chunk_data: ChunkData, world: HexWorld):
	self.chunk_data = chunk_data
	
	for coord in chunk_data.tile_map:
		var tile_data: HexTileData = chunk_data.tile_map[coord]
		var tile_scene = tile_data.scene

		# Check if chunk node already exists (optional)
		if has_node("Tile_%s_%s" % [tile_data.chunk_tile_coords.x, tile_data.chunk_tile_coords.y]):
			continue
		
		# Create new HexTile (node3D)
		var hex_tile = HexTile.new()
		hex_tile.name = "Tile_%s_%s" % [tile_data.chunk_tile_coords.x, tile_data.chunk_tile_coords.y]
		hex_tile.setup(tile_data)
		world.global_tile_map[tile_data.world_tile_coords] = hex_tile
		
		add_child(hex_tile)

func show_debug_labels(enable: bool):
	for label in label_map.values():
		label.visible = enable
		
