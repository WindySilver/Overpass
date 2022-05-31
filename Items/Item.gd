extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
	self.hide()

func restore():
	$CollisionShape2D.disabled = false
	self.show()
