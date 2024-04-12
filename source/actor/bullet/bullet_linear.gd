extends Node2D
var speed = 400  # 子弹速度
var target_position = Vector2()  # 目标位置

func initialize(_target_position):
	target_position = _target_position
	var direction = (target_position - global_position).normalized()
	rotation = direction.angle()

func _process(delta):
	var step = speed * delta
	var move_vector = (target_position - position).normalized() * step
	position += move_vector
	if position.distance_to(target_position) < step:
		queue_free()  # 到达目标或超过一定距离后销毁
