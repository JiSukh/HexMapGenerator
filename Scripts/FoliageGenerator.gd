extends RefCounted
class_name FoliageGenerator

# Foliage configuration
const FOLIAGE_DENSITY := .6 # Probability of foliage spawning on valid tiles
const FOLIAGE_FOLDER_PATH := "res://Assets/decoration/nature/"# Path to foliage folder

var foliage_noise: FastNoiseLite
var foliage_paths: Array = [] # Will be populated from folder

func _init():
	# Setup foliage noise
	foliage_noise = FastNoiseLite.new()
	foliage_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	foliage_noise.seed = randi()
	foliage_noise.frequency = .2 # Higher frequency for more varied foliage distribution
	
	# Load all foliage files from folder
	load_foliage_from_folder()

func load_foliage_from_folder():
	"""Load all GLTF files from the foliage folder"""
	foliage_paths.clear()
	
	var dir = DirAccess.open(FOLIAGE_FOLDER_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Check if it's a GLTF file
			if file_name.ends_with(".gltf") or file_name.ends_with(".glb"):
				var full_path = FOLIAGE_FOLDER_PATH + file_name
				foliage_paths.append(full_path)
				print("Loaded foliage: ", full_path)
			
			file_name = dir.get_next()
	else:
		print("Error: Could not open foliage folder: ", FOLIAGE_FOLDER_PATH)
		# Fallback to some default paths if folder doesn't exist
		foliage_paths = [
			"res://models/tree_01.gltf",
			"res://models/bush_01.gltf"
		]
	
	print("Total foliage models loaded: ", foliage_paths.size())

func generate_foliage(global_tile_map: Dictionary[Vector2i, HexTileData]):
	"""Generate foliage data for all tiles in the global tile map"""
	for global_coord in global_tile_map.keys():
		var tile = global_tile_map[global_coord]
		
		# Skip if tile type doesn't support foliage
		if not can_have_foliage(tile):
			continue
			
		# Use noise to determine foliage probability
		var noise_value = foliage_noise.get_noise_2d(global_coord.x, global_coord.y)
		var foliage_chance = (noise_value + 1.0) / 2.0 # Normalize to 0-1
		
		# Check if foliage should spawn based on density and noise
		if foliage_chance > (1.0 - FOLIAGE_DENSITY):
			spawn_foliage_on_tile(tile, foliage_chance)

func can_have_foliage(tile: HexTileData) -> bool:
	"""Check if a tile can support foliage based on terrain type"""
	# Don't place foliage on water tiles
	if tile.is_water:
		return false
	
	# Check elevation - maybe no foliage on very high elevations
	if tile.elevation > 3:  # Adjust this threshold as needed
		return false

	
	return true

func spawn_foliage_on_tile(tile: HexTileData, noise_value: float):
	"""Create foliage data for a specific tile"""
	
	# Select foliage type based on noise value
	var foliage_path = foliage_paths[randi_range(0,foliage_paths.size()-1)]
	
	var foliage_data = {
		"model_path": foliage_path,
	}
	
	tile.foliage_objects.append(foliage_data)


func get_loaded_foliage_models() -> Array:
	"""Get list of all loaded foliage model paths"""
	return foliage_paths.duplicate()

func reload_foliage_models():
	"""Reload foliage models from folder (useful for runtime changes)"""
	load_foliage_from_folder()
