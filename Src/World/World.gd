extends Spatial

onready var menu: Menu = $Menu

var _player_spawn: PlayerSpawn
var PlayerScene := preload("res://Src/Player/Player.tscn")

func _ready() -> void:
	_player_spawn = _find_player_spawn()

func _on_Menu_start_game() -> void:
	menu.queue_free()
	spawn_player()

func spawn_player() -> void:
	if _player_spawn == null:
		return
	var player := PlayerScene.instance() as Player
	player.global_transform = _player_spawn.global_transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_child(player)

func _on_Menu_quit_game() -> void:
	get_tree().quit()

func _find_player_spawn() -> PlayerSpawn:
	for child in get_children():
		if child is PlayerSpawn:
			return child

	return null
