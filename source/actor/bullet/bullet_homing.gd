extends Bullet
class_name BulletHoming

func _process(delta):
	if not target : 
		queue_free()
		return
	if target and not target.is_queued_for_deletion():
		var direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
		position += direction * speed * delta
	else:
		queue_free()  # 如果目标不存在或被销毁，销毁子弹

func _on_timer_timeout() -> void:
	queue_free()
