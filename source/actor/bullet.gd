extends Node2D
class_name Bullet

@export var damage : float = 10
@export var speed = 500  # 子弹速度
@export var dead_time : float = 3
var target = null  # 目标敌人的节点引用

func _ready() -> void:
	$Timer.wait_time = dead_time
	$Area2D.area_entered.connect(_on_area_entered)

func initialize(target : Enemy) -> void:
	self.target = target

func hit(enemy : Enemy) -> void:
	enemy.damage(damage)
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_entered(area : Area2D) -> void:
	if not area or not area.owner is Enemy : return
	var enemy : Enemy = area.owner
	hit(enemy)
