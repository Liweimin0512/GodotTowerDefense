extends Node2D
class_name Bullet

@export var damage : float = 10
@export var speed = 500  # 子弹速度
@export var dead_time : float = 3
var target = null  # 目标敌人的节点引用

func _ready() -> void:
	$Timer.wait_time = dead_time

func initialize(target : Enemy) -> void:
	self.target = target

func _on_timer_timeout() -> void:
	queue_free()
