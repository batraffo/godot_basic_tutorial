extends Area2D

signal hit

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func _ready():#chiamata quando un nodo entra nello scene tree
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _process(delta):#chiamata ad ogni frame
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed #nel caso cammino diagonale la normalizzo
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta #utilizziamo delta nel caso abbiamo perdite di frame
	position.x = clamp(position.x, 0, screen_size.x)#clamp permette alla posizione di non superare screensize
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	#disabilito le collisioni dopo che sono stato colpito, deferred mi permette di disabilitarle dopo
	#che ha elaborato quelle che erano in attesa di elaborazione (senza potrei avere errore)
	$CollisionShape2D.set_deferred("disabled", true)
	
