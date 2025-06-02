extends Node3D
class_name HexTile

var hex_tile_data: HexTileData
var label: Label3D

func setup(hex_tile_data: HexTileData):
	self.hex_tile_data = hex_tile_data

	
	var tile_pos: Vector3 = HexHelper.offset_to_world(hex_tile_data.chunk_tile_coords.x, hex_tile_data.chunk_tile_coords.y)
	tile_pos.y = hex_tile_data.elevation * 0.5
	position = tile_pos
	
	
	var hex_tile_scene = hex_tile_data.scene.instantiate()
	add_child(hex_tile_scene)
	
	

	# Apply rotation if specified
	if hex_tile_data.rotate != 0:
		rotation.y += hex_tile_data.rotate

	# Create foliage
	if hex_tile_data.foliage_objects.size() > 0:
		for f: PackedScene in hex_tile_data.foliage_objects:
			var foliage = f.instantiate().duplicate()
			add_child(foliage)
			var offset_x = randf_range(-0.3, 0.3)
			var offset_z = randf_range(-0.3, 0.3)
			foliage.position = Vector3(offset_x, 0, offset_z)
			foliage.rotate_y(randf() * TAU)

	# Attach bottom tile if needed
	if not hex_tile_data.is_water and hex_tile_data.elevation > 0:
		var bottom = TileStore.get_tile_bottom().scene.instantiate()
		bottom.position = Vector3(0, -1, 0)
		bottom.scale = Vector3(1, hex_tile_data.elevation * 0.5, 1)
		add_child(bottom)

	attach_label()
	





func attach_label():
	# DEBUG LABEL
	label = Label3D.new()
	label.text = "x: %d, z: %d, r: %d" % [hex_tile_data.world_tile_coords.x, hex_tile_data.world_tile_coords.y, hex_tile_data.rotate]
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.visible = false
	label.position = Vector3(0, 0.45, 0)
	add_child(label)
