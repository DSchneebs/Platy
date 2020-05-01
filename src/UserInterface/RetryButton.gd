extends Button


func _on_PlayButton_button_up() -> void:
	PlayerData.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready() -> void:
	pass # Replace with function body.
