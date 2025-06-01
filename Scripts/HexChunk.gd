extends Node3D
class_name HexChunk

var chunk_data: ChunkData
var label_map: Dictionary[Vector2i, Label3D] = {}

func setup(chunk_data: ChunkData):
	self.chunk_data = chunk_data
	
	for coord in chunk_data.tile_map:
		var tile_data: HexTileData = chunk_data.tile_map[coord]
		var tile_scene = tile_data.scene
		
		if tile_scene:
			var tile_instance: Node3D = tile_scene.instantiate()
			if tile_instance:
				add_child(tile_instance)
				var tile_pos: Vector3 = HexHelper.offset_to_world(tile_data.chunk_col, tile_data.chunk_row)
				tile_pos.y = tile_data.elevation * 0.5
				
				### rotate if needed
				if tile_data.rotate != 0:
					tile_instance.rotation.y += (tile_data.rotate)
				
				### CREATE FOLIAGE
				if tile_data.foliage_objects.size() > 0:
					for f in tile_data.foliage_objects:
						var foliage : Node3D = load(f['model_path']).instantiate()
						add_child(foliage)
						var offset_x = randf_range(-0.5, 0.5)  # random float between -0.5 and 0.5
						var offset_z = randf_range(-0.5, 0.5)
						foliage.position = Vector3(tile_pos.x + offset_x, tile_pos.y, tile_pos.z + offset_z)
						foliage.rotate_y(randf() * TAU)

				
				### attatch bottom
				if not tile_data.is_water and tile_data.elevation > 0:
					var bottom = TileStore.get_tile_bottom().scene.instantiate()
					bottom.position = Vector3(tile_pos.x,-1,tile_pos.z)
					bottom.scale = Vector3(1, tile_data.elevation*0.5, 1)

					
					add_child(bottom)
					
				tile_instance.position = tile_pos
				### Prepare debug label (but hide it)
				var label = Label3D.new()
				label.text = "x: %d, z: %d, r: %d" % [tile_data.world_tile_col, tile_data.world_tile_row, tile_data.rotate]
				label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
				label.visible = false
				label.position = Vector3(0, 0.45, 0)
				tile_instance.add_child(label)
				label_map[coord] = label

func show_debug_labels(enable: bool):
	for label in label_map.values():
		label.visible = enable
