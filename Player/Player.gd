extends KinematicBody2D

signal hit
signal decrease_time
signal creating_overpass
signal victory

export var downward = 10 # Speed downward (for going on the ground), often the same as velocity.y
export var velocity = Vector2(1, 0)
export var gravity = 50
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
func _process(_delta):
	if(may_move):
		if Input.is_action_pressed("create_overpass"):
			emit_signal("creating_overpass")
		$AnimatedSprite.play()

func _physics_process(_delta):
	if(may_move):
		# This needs to be done to have any semblance of "real" gravity while not getting stuck at overpass corners
		# TODO Set up a timer that allows gravity to remain in effect for the last of fall
		# (collision detection starts too early because the RayCast has to be set too high to work properly with Tilemap)
		if !$RayCast2D.is_colliding():
			velocity.y = gravity
		else:
			velocity.y = downward
		
		var _move = move_and_slide(velocity, Vector2(0, 7), false, 4, 20)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("obstacles"):
				if(!already_hit):
					emit_signal("hit")
					already_hit = true
					collision.collider.hide_properly()
					$CollisionTimer.start()
			elif collision.collider.is_in_group("victory"):
				emit_signal("victory")


func hit_obstacle():
	emit_signal("decrease_time")


func _on_CollisionTimer_timeout():
	already_hit = false
