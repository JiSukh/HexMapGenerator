extends Resource
class_name HexTileData

@export var tile_name : String = ""
@export var scene : PackedScene 
@export var is_water: bool = false

### positional data
var elevation: int = 0 # goes up by 0.5 tiles per elevation

# positioning in chunk
var chunk_col: int
var chunk_row: int
# positioning in world
var world_tile_col: int
var world_tile_row: int

var world_tile_coordinates: Vector2i

var rotate: float = 0.0

var foliage_objects: Array = []
