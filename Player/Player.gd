extends KinematicBody2D


signal decrease_time(penalty)
signal creating_overpass
signal victory


export var downward = 10 # Speed downward (for going on the ground), often the same as velocity.y
export var velocity = Vector2(1, 0) # The player's speed
export var gravity = 50 # The gravity force pulling the player down when falling
var screen_size # Size of the game window.
var may_move = false # Keeps player from moving when they shouldn't
var items = {"Jewel": false, "Undefined": false, "Book": false, "Coin": false, "Heart": false, "Floppy": false} # The items the player can collect
var still_in_air = false # Whether or not the player is still falling


# Sets the player character in the starting position and allows it to move
func start(pos):
	position = pos
	may_move = true
	if $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = false


# Stops the player character from moving
func stop():
	may_move = false
	$AnimatedSprite.stop()


# Allows the player character to start moving from its current position
# (different from start, which always puts the player to the same spot)
func unstop():
	may_move = true
	$AnimatedSprite.play()


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(may_move):
		if Input.is_action_pressed("create_overpass"):
			emit_signal("creating_overpass")
		$AnimatedSprite.play()


# Processes physics things
func _physics_process(_delta):
	if(may_move):
		# This needs to be done to have any semblance of "real" gravity while not getting stuck at overpass corners
		# (collision detection starts too early because the RayCast has to be set too high to work properly with Tilemap)
		if !$RayCast2D.is_colliding():
			if !still_in_air:
				still_in_air = true
			velocity.y = gravity
		else:
			if still_in_air:
				if $GravityTimer.is_stopped():
					$GravityTimer.start()
			else:
				velocity.y = downward

		# Move the player and handle any potential collisions
		var _move = move_and_slide(velocity, Vector2(0, 7), false, 4, 20)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("obstacles"):
				hit_obstacle(collision.collider.penalty)
				collision.collider.play_audio()
				collision.collider.hide_properly()
			elif collision.collider.is_in_group("items"):
				var col_name = collision.collider.name
				match col_name:
					"Jewel":
						items.Jewel = true
					"Book":
						items.Book = true
					"Coin":
						items.Coin = true
					"Heart":
						items.Heart = true
					"Floppy":
						items.Floppy = true
					_:
						items.Undefined = true
				collision.collider.play_audio()
				collision.collider.hide_properly()
			elif collision.collider.is_in_group("victory"):
				emit_signal("victory")
				collision.collider.play_audio()


# Handle player hitting an obstacle
func hit_obstacle(var penalty):
	emit_signal("decrease_time", penalty)


# Initiated restoring the downward velocity to keep player able to get past overpasses
func _on_GravityTimer_timeout():
	still_in_air = false


# Flips the sprite horizontally
func flip_me():
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
