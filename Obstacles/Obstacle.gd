extends RigidBody2D

export var penalty = 2


# Plays the obstacle's hit audio
func play_audio():
	$Audio.play()


# Does the needed operations for hiding the obstacle so that player can pass through
func hide_properly():
	$CollisionShape2D.disabled = true


# Restores the obstacle to its original status (needed for restarting game)
func restore():
	$CollisionShape2D.disabled = false
