extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
export var velocity = Vector2(1, 0)
export var time_penalty = 2
onready var timer = get_node("/root/Main/LevelTimer")
var screen_size # Size of the game window.
var already_hit = false # Whether or not player already hit the current obstacle

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
	if(!already_hit):
		emit_signal("hit")
		already_hit = true


func timer_down():
	var time = timer.get_time_left() - time_penalty
	timer.stop()
	if (time <= 0):
		time = 0.1
	timer.set_wait_time(time)
	timer.start()


func _on_Player_body_exited(body):
	already_hit = false
