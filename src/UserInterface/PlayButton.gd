tool
extends Button

export(String, FILE) var next_scene_path:= ""


func _ready() -> void:
	pass # Replace with function body.

func _on_PlayButton_button_up() -> void:
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "next_scene_path must be set for button to work" if next_scene_path == "" else ""
