extends Bullet
class_name BulletLinear

var target_position = Vector2()  # 目标位置

func initialize(target: Enemy) -> void:
	target_position = target.position
	var direction = (target_position - global_position).normalized()
	rotation = direction.angle()

func _process(delta):
	var step = speed * delta
	var move_vector = (target_position - position).normalized() * step
	position += move_vector
	if position.distance_to(target_position) < step:
		queue_free()  # 到达目标或超过一定距离后销毁
