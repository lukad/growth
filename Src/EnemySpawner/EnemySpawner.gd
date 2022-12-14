class_name EnemySpawner
extends Area

export var spawn_rate := 10.0
export var variance := 15.0
export var max_snacks := 5

onready var timer: Timer = $Timer

var _collision_shape: CollisionShape
var _waiting := false

var snacks := [
	preload("res://Src/Snacks/Burger.tscn"),
	preload("res://Src/Snacks/CheeseBurger.tscn"),
	preload("res://Src/Snacks/DoubleBurger.tscn"),
	preload("res://Src/Snacks/DoubleCheeseBurger.tscn"),
	preload("res://Src/Snacks/Fries.tscn")
]

func _ready() -> void:
	timer.wait_time = rand_range(0.0, variance)
	for node in get_children():
		if node is CollisionShape:
			_collision_shape = node
			break

func _reset_timer() -> void:
	timer.wait_time = spawn_rate + rand_range(0.0, variance)
	timer.start()

func start() -> void:
	_spawn_enemy()
	timer.start()

func stop() -> void:
	timer.stop()

func _on_WaitTimer_timeout() -> void:
	if _waiting:
		_spawn_enemy()

func _on_Timer_timeout() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	if _collision_shape == null:
		return

	if get_tree().get_nodes_in_group("Snacks").size() >= max_snacks:
		_waiting = true
		return

	if _collision_shape.shape is BoxShape:
		var shape := _collision_shape.shape as BoxShape
		var spawn_area := shape.extents
		var origin := _collision_shape.global_translation - spawn_area
		var x = rand_range(origin.x, spawn_area.x)
		var z = rand_range(origin.z, spawn_area.z)
		snacks.shuffle()
		var snack: Snack = snacks[0].instance()
		get_tree().root.add_child(snack)
		snack.global_translation = Vector3(x, 1.0, z)
		_waiting = false
		_reset_timer()
