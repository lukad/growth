class_name Menu
extends CanvasLayer

signal start_game()
signal quit_game()

onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
onready var music_anim: AnimationPlayer = $AudioStreamPlayer/AnimationPlayer

func _ready() -> void:
	if OS.get_name() == "HTML5":
		hide_quit_button()
	remove_child(music_player)
	get_tree().root.call_deferred("add_child", music_player)


func close() -> void:
	music_anim.play("Fadeout")
	queue_free()

func hide_quit_button() -> void:
	find_node("Quit").queue_free()

func _on_Start_pressed() -> void:
	emit_signal("start_game")

func _on_Quit_pressed() -> void:
	emit_signal("quit_game")
