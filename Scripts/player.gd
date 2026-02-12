extends CharacterBody2D

const JumpForce: int = 250
const Gravity: int = 450

enum PlayerState {RUN, DAETH}
var state: PlayerState = PlayerState.RUN

signal die

func _physics_process(delta: float) -> void:
	if state == PlayerState.RUN:
		$AnimatedSprite2D.play("Run")
		Jump(delta)
		move_and_slide()
		TakeDamage()
	elif state == PlayerState.DAETH:
		$AnimatedSprite2D.play("Death")

func Jump(delta):
	## Gravity
	if not is_on_floor():
		velocity.y += Gravity * delta
	## Short jump
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= 0.5
	## High jump
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = -JumpForce
		$Jump.play()

func TakeDamage():
	for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("obstacle"):
				Die()

func Die():
	state = PlayerState.DAETH
	velocity = Vector2.ZERO
	emit_signal("die")
