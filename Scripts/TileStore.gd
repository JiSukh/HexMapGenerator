extends Node

@export var tile_data_folder := "res://HexTiles/Resources"

### dict of all tiles {name: data}
var tiles : Dictionary[String, HexTileData] = {}

func _ready():
	load_tile_data_from_folder(tile_data_folder)

func load_tile_data_from_folder(folder_path: String) -> void:
	var dir = DirAccess.open(folder_path)
	if dir == null:
		push_error("HexTileStore: Could not open tile data folder: " + folder_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var file_path = folder_path.path_join(file_name)
			var tile_data = load(file_path)
			if tile_data is HexTileData:
				tiles[tile_data.tile_name] = tile_data
		file_name = dir.get_next()
	dir.list_dir_end()



func get_tile_by_noise(noise: float) -> HexTileData:
	if noise < -0.1:
		return tiles['Water'].duplicate()
	else:
		return tiles['GrassTop'].duplicate()
		
func get_tile_bottom() -> HexTileData:
	return tiles['GrassBottom'].duplicate()
	
