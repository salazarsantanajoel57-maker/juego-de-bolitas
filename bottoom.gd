extends Area2D

func _on_bottoom_body_entered(body):
	if body.is_in_group("ball"):
		body.get_parent().remove_ball()
		body.queue_free()
