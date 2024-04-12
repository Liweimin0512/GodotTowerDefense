extends Node2D

const TILE_ID_FOR_PLACEMENT : int = 22
const TILE_COORD_FOR_PLACEMENT : Vector2i = Vector2i(15, 0)

@onready var timer: Timer = $Timer
@onready var path_2d: Path2D = %Path2D
@onready var tile_map: TileMap = %TileMap
@onready var game_form: Control = %game_form

@export var enemies : Array[PackedScene] = []
@export var towers : Array[PackedScene] = []

var perview_tower : Tower = null :
	set(value):
		if value != null and perview_tower != null:
			perview_tower.queue_free()
			tile_map.remove_child(perview_tower)
		perview_tower = value

func _ready() -> void:
	timer.timeout.connect(
		_spawn_enemy
		)
	game_form.w_tower_released.connect(
		func(w_tower) -> void:
			perview_tower = w_tower.p_tower.instantiate()
			tile_map.add_child(perview_tower)
	)
	for tower : Tower in get_tree().get_nodes_in_group("tower"):
		tower.initialize()
	timer.start()

func _process(delta: float) -> void:
	if perview_tower:
		_perview_tower()

func _perview_tower() -> void:
	if not perview_tower : return
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	var turret_position = tile_map.map_to_local(cell)
	perview_tower.position = turret_position
	perview_tower.modulate = Color.RED if not can_place_turret_here(cell) else Color.WHITE

func _disperview_tower() -> void:
	if not perview_tower : return
	perview_tower.queue_free()
	remove_child(perview_tower)

func _spawn_enemy() -> void:
	var enemy = enemies[0].instantiate()
	path_2d.add_child(enemy)
	enemy.global_position = path_2d.curve.get_point_position(0)
	_reset_timer()

func _reset_timer() -> void:
	timer.wait_time = randf_range(1,3)
	timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if not perview_tower : return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_turret_at_mouse_position()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_disperview_tower()

## 在鼠标位置放置防御塔
func place_turret_at_mouse_position():
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	if can_place_turret_here(cell):
		perview_tower.initialize()
		perview_tower = null
		#var turret_instance = preload("res://path/to/Turret.tscn").instance()
		#var turret_position = map_to_world(cell) + cell_size / 2
		#turret_instance.position = turret_position
		#add_child(turret_instance)
		pass

## 能否放置防御塔
func can_place_turret_here(cell : Vector2i):
	var tile_id = tile_map.get_cell_source_id(1, cell)
	var tile_coord = tile_map.get_cell_atlas_coords(1, cell)
	return tile_id == TILE_ID_FOR_PLACEMENT and tile_coord == TILE_COORD_FOR_PLACEMENT  # 确保tile ID匹配可以放置炮台的tile
