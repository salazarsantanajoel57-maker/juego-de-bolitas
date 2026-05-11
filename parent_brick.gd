extends StaticBody2D

var brick_lives = 10
var life: int

func _ready():
	life = randi() % brick_lives + 1
	$brick_life.text = str(life)
	add_to_group("brick")

func take_life():
	life -= 1
	$brick_life.text = str(life)
	if life < 1:
		queue_free()
