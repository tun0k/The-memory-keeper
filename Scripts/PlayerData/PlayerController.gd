extends CharacterBody2D

@onready var tile_map = get_parent().get_node("TileMapLayer") # путь к TileMap

var cell_size = Vector2(16, 16)
var target_cell = Vector2i.ZERO 
var is_moving = false
var current_cell = Vector2i.ZERO

func _ready():
	current_cell = tile_map.local_to_map(position)
	position = tile_map.map_to_local(current_cell)
	target_cell = current_cell

func _input(event):
	if is_moving:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var clicked_cell = tile_map.local_to_map(mouse_pos)
		
	
		var delta = clicked_cell - current_cell
		if abs(delta.x) + abs(delta.y) == 1:
			target_cell = clicked_cell
			move_to_target()
		else:
			print("Нельзя ходить дальше 1 клетки!")

func move_to_target():
	is_moving = true
	var target_pos = tile_map.map_to_local(target_cell)
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.2)
	tween.tween_callback(_on_move_finished)

func _on_move_finished():
	current_cell = target_cell
	is_moving = false 
	cell_size = tile_map.local_to_map(position)
	
	
