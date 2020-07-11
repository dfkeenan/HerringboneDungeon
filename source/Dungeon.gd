extends Node2D

onready var generator := $HerringboneWangGenerator
onready var tile_map : TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generator.generate(tile_map)
	
	var used_rect := tile_map.get_used_rect()
	
	var map_size := tile_map.cell_size * used_rect.size
	var camera_size := map_size / get_viewport().size	
	
	$Camera2D.position = tile_map.map_to_world(used_rect.position) + (map_size / 2)
	#$Camera2D.zoom = Vector2(ceil(max(camera_size.x, camera_size.y)), ceil(max(camera_size.x, camera_size.y)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		generator.generate(tile_map)
