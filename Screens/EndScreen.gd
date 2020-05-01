extends Control

onready var label: Label = get_node("Score")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label.text % [PlayerData.score, PlayerData.deaths]
