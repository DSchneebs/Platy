extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
export var score:= 10


func _ready() -> void:
	pass # Replace with function body.


func _on_Coin_body_entered(_body: Node) -> void:
	collected()

func collected() -> void:
		PlayerData.score += score
		anim_player.play("fade_out")
		
