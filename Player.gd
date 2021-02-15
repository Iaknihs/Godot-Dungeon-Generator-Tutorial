extends KinematicBody2D

var speed = 100

func _physics_process(delta):
	var movement = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		movement.y -= speed
	if Input.is_action_pressed("move_down"):
		movement.y += speed
	if Input.is_action_pressed("move_left"):
		movement.x -= speed
	if Input.is_action_pressed("move_right"):
		movement.x += speed
	
	move_and_slide(movement)
