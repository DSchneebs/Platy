extends Actor

var times_jumped = 0
var stomp_bounce = 1400.0
var just_stomped = false

func _ready():
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted:= Input.is_action_just_pressed("down") and _velocity.y < 0.0
	var direction: = get_direction()
	if just_stomped:
		just_stomped = false
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	if is_on_floor():
		times_jumped = 0
	set_animation(_velocity)
	

# Every n time between frames, grab current button being pressed to determine
# current direction the player shoudl be going.
func get_direction() -> Vector2:
	if Input.is_action_just_pressed("jump"):
		times_jumped += 1
	return Vector2(
		Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
		-1.0 if (Input.is_action_just_pressed("jump") and
			 (is_on_floor() or times_jumped < 3)) or just_stomped else 1.0
		)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity := linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0 and times_jumped < 2:
		new_velocity.y = speed.y * direction.y
	elif direction.y == -1.0 and times_jumped == 2:
		new_velocity.y = speed.y * (direction.y/2)
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity

func calculate_stomp_velocity(linear_velocity: Vector2, bounce: float) -> Vector2:
	var new_velocity:= linear_velocity
	new_velocity.y = -bounce
	return new_velocity
	
func set_animation(velocity: Vector2) -> void:
	if _velocity.x != 0:
		$AnimatedSprite.animation = "walking"
		$AnimatedSprite.play()
		$AnimatedSprite.flip_h = _velocity.x < 0
	else:
		$AnimatedSprite.animation = "default"
	if _velocity.y < 0 and times_jumped == 1:
		$AnimatedSprite.animation = "jumping"
	elif _velocity.y < 0 and times_jumped == 2:
		$AnimatedSprite.animation = "double_jumping"
	elif _velocity.y > 0:
		$AnimatedSprite.animation = "falling"
		
func _on_Enemy_stomped() -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_bounce)


func _on_EnemyCollisions_body_entered(_body: Node) -> void:
	die()


func _on_SpecialEnemy_stomped() -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_bounce * 1.5)

func die() -> void:
	PlayerData.deaths += 1
	queue_free()
