extends "res://Actors/Actor.gd"

signal stomped
export var score:= 100


func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	
func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	call_deferred("set", get_node("CollisionShape2D").disabled, true)
	emit_signal("stomped")
	die()

func die() -> void:
	PlayerData.score += score
	queue_free()
