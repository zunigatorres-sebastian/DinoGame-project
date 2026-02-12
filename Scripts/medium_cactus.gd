extends StaticBody2D

var level: Node2D

func _physics_process(delta):
	if level == null:
		return
	
	position.x -= level.speed * delta
	
	if position.x < -30:
		queue_free()
