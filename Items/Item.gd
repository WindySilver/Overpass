extends RigidBody2D


#Plays the item's pickup audio
func play_audio():
	$Audio.play()


# Does the needed operations for hiding the item so that player can pass through
func hide_properly():
	$CollisionShape2D.disabled = true
	self.hide()


# Restores the item to its original status (needed for restarting game)
func restore():
	$CollisionShape2D.disabled = false
	self.show()
