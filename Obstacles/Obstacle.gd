extends RigidBody2D

export var penalty = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_audio():
	$Audio.play()

func hide_properly():
	$CollisionShape2D.disabled = true

func restore():
	$CollisionShape2D.disabled = false
