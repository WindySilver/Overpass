extends Area2D
signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
export var velocity = Vector2(1, 0)
var screen_size # Size of the game window.

func start(pos):
	position = pos
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("create_overpass"):
		print("Creating overpass")
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	$AnimatedSprite.play()


func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
