class_name Menu
extends CanvasLayer

signal start_game()
signal quit_game()

func _ready() -> void:
	if OS.get_name() == "HTML5":
		hide_quit_button()

func hide_quit_button() -> void:
	find_node("Quit").queue_free()

func _on_Start_pressed() -> void:
	emit_signal("start_game")

func _on_Quit_pressed() -> void:
	emit_signal("quit_game")
