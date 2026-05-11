extends Node2D

var bricks = [
	preload("res://circle.tscn"),
	preload("res://square.tscn")
]

var balls = preload("res://ball.tscn")
var bricks_location = Vector2(75, 100)
var cannon_location = Vector2(300, 950)

var level: int = 1
var balls_available: int = 10 + level
var can_shoot = true
var ball_count: int = 0
var cannon_angle: float = -90.0
var aim_line: Line2D

func _ready():
	randomize()
	create_field()
	aim_line = Line2D.new()
	aim_line.width = 3.0
	aim_line.default_color = Color.WHITE
	add_child(aim_line)

func _process(_delta):
	if Input.is_action_pressed("aim_left"):
		cannon_angle -= 3.0
	if Input.is_action_pressed("aim_right"):
		cannon_angle += 3.0
	cannon_angle = clamp(cannon_angle, -175.0, -5.0)
	update_aim()
	if Input.is_action_just_released("shoot") and can_shoot:
		print("disparando!")
		shoot_balls()

func update_aim():
	var direction = Vector2(cos(deg_to_rad(cannon_angle)), sin(deg_to_rad(cannon_angle)))
	aim_line.clear_points()
	aim_line.add_point(cannon_location)
	aim_line.add_point(cannon_location + direction * 200)

func create_field():
	for i in range(8):
		for x in range(8):
			var select_brick = randi() % bricks.size()
			var new_brick = bricks[select_brick].instantiate()
			new_brick.position = bricks_location
			add_child(new_brick)
			bricks_location.x += 65
		bricks_location.x = 75
		bricks_location.y += 65

func shoot_balls():
	can_shoot = false
	var direction = Vector2(cos(deg_to_rad(cannon_angle)), sin(deg_to_rad(cannon_angle)))
	for i in range(balls_available):
		var new_ball = balls.instantiate()
		new_ball.position = cannon_location
		add_child(new_ball)
		print("bola creada en: ", new_ball.position)
		new_ball.linear_velocity = direction * 1000
		ball_count += 1
		$shoot_delay.start(0.1)
		await $shoot_delay.timeout
	pass

func remove_ball():
	ball_count -= 1
	if ball_count <= 0:
		can_shoot = true
		ball_count = 0

func _on_boost_speed_timeout():
	$boost_speed.start()
	for ball in get_tree().get_nodes_in_group("ball"):
		ball.add_speed(1000)
