extends Node
class_name HerringboneWangGenerator

export var wang_tile_size := 6
export var margin := 2

onready var horizontal_tiles := $Horizontal.get_children().duplicate()
onready var vertical_tiles := $Vertical.get_children().duplicate()

var horizontal_index := 0
var vertical_index := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func generate(tile_map:TileMap) -> void:
	
	var region := tile_map.get_used_rect()
	region = region.grow(margin * -1)
	
	var buffer := 2 * wang_tile_size
	
	var cell_y := 0
	var cell_x := 0
	
	var cell_h := (region.size.y / wang_tile_size) + buffer
	var cell_w := (region.size.x / wang_tile_size) + buffer
	
	
	var x := 0
	var y := 0
	
	while cell_y < cell_h:
		y = cell_y * wang_tile_size
		x = (cell_y % 4) * wang_tile_size
		
		y -= buffer
		x -= buffer
		
		cell_x = 0
		while cell_x < cell_w:
			match (cell_x % 3):
				0:
					update_tiles(tile_map, region, Vector2(x,y) + region.position, get_vertical_tile())
				1:
					update_tiles(tile_map, region, Vector2(x,y) + region.position, get_horizontal_tile())
					x += wang_tile_size
					
			x += wang_tile_size
			cell_x += 1
		
		cell_y += 1
			
	tile_map.update_bitmask_region()



func update_tiles(tile_map : TileMap, region:Rect2, start_position:Vector2, wang_tile:TileMap) ->void:
	
	var source_rect := wang_tile.get_used_rect()
	
	for sy in range(source_rect.position.y, source_rect.size.y):
		for sx in range(source_rect.position.x, source_rect.size.x):
			var destination := Vector2(sx,sy) + start_position
			
			if region.has_point(destination):
				var tile = wang_tile.get_cell(sx,sy)
				tile_map.set_cellv(destination, tile)


func get_horizontal_tile() -> TileMap:
	horizontal_index += 1
	
	if horizontal_index >= horizontal_tiles.size():
		horizontal_tiles.shuffle()
		horizontal_index = 0
		
	return horizontal_tiles[horizontal_index]


func get_vertical_tile() -> TileMap:
	vertical_index += 1
	
	if vertical_index >= vertical_tiles.size():
		vertical_tiles.shuffle()
		vertical_index = 0
		
	return vertical_tiles[vertical_index]
	
	
