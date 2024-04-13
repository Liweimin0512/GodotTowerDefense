extends Node2D
class_name Tower

@onready var area_2d: Area2D = $Area2D
@onready var fort: Node2D = $fort

@export var p_bullet : PackedScene
@export var cooldown : float = 0.2
@export var damage : float = 10
@export var cost : int = 10
@export var bullet_count : int = 1

var current_cd : float = 0
var enemies : Array = []
var current_bullet_count : int

func _ready() -> void:
	#initialize()
	pass

func _process(delta: float) -> void:
	if enemies.is_empty(): return
	if current_cd > 0:
		current_cd -= delta
	else:
		_attack_enemy()
	fort.look_at(enemies[0].global_position)

## 初始化
func initialize() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exit)
	for area in area_2d.get_overlapping_areas():
		enemies.append(area.owner)
	current_bullet_count = bullet_count
	
## 能否拜访建筑物
func can_place_tower(coin: int) -> bool:
	return coin - cost >= 0

func _on_area_entered(area : Area2D) -> void:
	enemies.append(area.owner)

func _on_area_exit(area: Area2D) -> void:
	enemies.erase(area.owner)

func _attack_enemy() -> void:
	if enemies.is_empty() : return
	if current_bullet_count > 0:
		await _spawn_bullet()
	else:
		current_bullet_count = bullet_count
		current_cd = cooldown
	
func _spawn_bullet() -> void:
	var bullet = p_bullet.instantiate()
	bullet.damage = damage
	add_child(bullet)
	bullet.initialize(enemies[0])
	current_bullet_count -= 1
	$audio_explosion.play()
	await get_tree().create_timer(0.5).timeout
