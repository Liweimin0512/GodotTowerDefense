extends Node2D

const TILE_ID_FOR_PLACEMENT : int = 22
const TILE_COORD_FOR_PLACEMENT : Vector2i = Vector2i(15, 0)

@onready var timer: Timer = $Timer
@onready var path_2d: Path2D = %Path2D
@onready var tile_map: TileMap = %TileMap
@onready var game_form: Control = %game_form

@export var enemies : Array[PackedScene] = []
#@export var towers : Array[PackedScene] = []
@export var max_health : float = 100
var current_health : float = 100 :
	set(value) :
		current_health = value
		health_changed.emit()
		if current_health <= 0:
			_game_over()
@export var coin : int  = 100:
	set(value):
		coin = value
		game_form.update_coin_display(coin)

signal health_changed

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
	current_health = max_health
	for tower : Tower in get_tree().get_nodes_in_group("tower"):
		tower.initialize()
	timer.start()
	game_form.replay_pressed.connect(_replay)
	game_form.update_coin_display(coin)

func _process(delta: float) -> void:
	if perview_tower:
		_perview_tower()

func _unhandled_input(event: InputEvent) -> void:
	if not perview_tower : return
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_turret_at_mouse_position()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_disperview_tower()

## 重启游戏
func _replay() -> void:
	current_health = max_health
	for actor in get_tree().get_nodes_in_group("actor"):
		if actor.is_in_group("cant free"): continue
		actor.queue_free()
	get_tree().paused = false
	game_form.replay()

## 预览塔摆放位置
func _perview_tower() -> void:
	if not perview_tower : return
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	var turret_position = tile_map.map_to_local(cell)
	perview_tower.position = turret_position
	perview_tower.modulate = Color.RED if not can_place_turret_here(cell) else Color.WHITE

## 取消塔的拜访预览
func _disperview_tower() -> void:
	if not perview_tower : return
	perview_tower.queue_free()
	remove_child(perview_tower)

## 生成敌人
func _spawn_enemy() -> void:
	var enemy_index : int = randi_range(0, enemies.size() - 1)
	var enemy = enemies[enemy_index].instantiate()
	path_2d.add_child(enemy)
	enemy.global_position = path_2d.curve.get_point_position(0)
	enemy.damaged.connect(
		func(damage: float) -> void:
			current_health -= damage
	)
	enemy.died.connect(
		func(loot_coin : int) -> void:
			coin += loot_coin
	)
	timer.wait_time = randf_range(1,3)
	timer.start()

## 在鼠标位置放置防御塔
func place_turret_at_mouse_position():
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	if can_place_turret_here(cell):
		coin -= perview_tower.cost
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

## 受到伤害
func damage(damage) -> void:
	current_health -= damage

## 游戏结束
func _game_over() -> void:
	print("GameOver!")
	get_tree().paused = true
	game_form.game_over()
