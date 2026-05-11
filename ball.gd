extends RigidBody2D

var ball_speed: int = 1000

func _ready():
	gravity_scale = 0
	add_to_group("ball")
	contact_monitor = true
	max_contacts_reported = 10
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 1
	physics_material_override.friction = 0

func _process(_delta):
	pass

func _integrate_forces(state):
	if state.linear_velocity.length() < ball_speed - 100:
		state.linear_velocity = state.linear_velocity.normalized() * ball_speed
	var ball_safe_zone = self.position
	if ball_safe_zone.x < -50 or ball_safe_zone.x > 650 or ball_safe_zone.y < -50 or ball_safe_zone.y > 1100:
		call_deferred("_eliminar")

func _eliminar():
	get_parent().remove_ball()
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("brick"):
		body.take_life()
	if body.is_in_group("bottom"):
		get_parent().remove_ball()
		queue_free()

func add_speed(speed_boost):
	ball_speed += speed_boost
