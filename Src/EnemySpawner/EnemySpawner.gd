class_name EnemySpawner
extends Area

export var spawn_rate := 10.0
export var variance := 15.0

onready var timer: Timer = $Timer

var _collision_shape: CollisionShape

var snacks := [
	preload("res://Src/Snacks/Burger.tscn"),
	preload("res://Src/Snacks/CheeseBurger.tscn"),
	preload("res://Src/Snacks/DoubleBurger.tscn"),
	preload("res://Src/Snacks/DoubleCheeseBurger.tscn"),
	preload("res://Src/Snacks/Fries.tscn")
]

func _ready() -> void:
	timer.wait_time = spawn_rate + rand_range(0.0, variance)
	timer.start()
	for node in get_children():
		if node is CollisionShape:
			_collision_shape = node
			break

func start() -> void:
	_spawn_enemy()
	timer.start()

func stop() -> void:
	timer.stop()

func _on_Timer_timeout() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	if _collision_shape == null:
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
