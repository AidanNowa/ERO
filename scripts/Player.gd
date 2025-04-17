extends CharacterBody2D

signal hit

@export var speed = 100 #How fast the player will move (pixels/sec)
var screen_size #size of game window

# Called when the node enters the scene tree for the first time.
#func _ready():
#	screen_size = get_viewport_rect().size
#	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play()
	#var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$ is shorthand for get_node()
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
	
	#clamp the position value to keep player on screen
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
	#animation type and direction handling
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		#if poitive we are going right (false and don't flip), if negative we go left (true and flip)
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y !=0 && velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
		#down is positive so logic is flipped
		#$AnimatedSprite2D.flip_v = velocity.y > 0
	elif velocity.y !=0 && velocity.y > 0:
		$AnimatedSprite2D.animation = "down"
	else:
		$AnimatedSprite2D.animation = "idle"
	

func _on_body_entered(body):
	hide() #disappear after being hit
	hit.emit()
	#must be defered to prevent error caused if it happens in the middel of the engine's collsion
	$CollisionShape2D.set_deferred("disabled", true) #disable to prevent more than one "hit" signal

#func start(pos):
#	position = pos
#	show()
#	$CollisionShape2D.disabled = false
