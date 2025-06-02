extends Resource
class_name HexTileData

@export var tile_name : String = ""
@export var scene : PackedScene 
@export var is_water: bool = false

### POSITIONAL DATA
var elevation: int = 0 # goes up by 0.5 tiles per elevation
var chunk_tile_coords: Vector2i
var world_tile_coords: Vector2i

var rotate: float = 0.0
var foliage_objects: Array = []

#place holder
func add_foliage_object(obj):
	foliage_objects.append(obj)
