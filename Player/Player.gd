extends KinematicBody2D

signal hit
signal decrease_time
signal creating_overpass

export var speed = 400 # How fast the player will move (pixels/sec).
export var velocity = Vector2(1, 0)
var screen_size # Size of the game window.
var already_hit = false # Whether or not player already hit the current obstacle
var may_move = false # Keeps player from moving when they shouldn't

func start(pos):
	position = pos
	may_move = true
	
	
func stop():
	may_move = false
	$AnimatedSprite.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(may_move):
		if Input.is_action_pressed("create_overpass"):
			emit_signal("creating_overpass")
		$AnimatedSprite.play()

func _physics_process(delta):
	if(may_move):
		move_and_slide(velocity, Vector2(0, -7), false, 4, 20)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("obstacles"):
				if(!already_hit):
					emit_signal("hit")
					already_hit = true
					collision.collider.queue_free()
					$CollisionTimer.start()


func hit_obstacle():
	emit_signal("decrease_time")


func _on_CollisionTimer_timeout():
	already_hit = false
