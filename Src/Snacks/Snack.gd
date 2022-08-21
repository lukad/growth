class_name Snack
extends RigidBody

export var health := 100
export var damage := 10
export var growth := 1.0
export var attack_distance := 1.5
export var move_force := 5.0
export var cool_down := 5.0
export var points := 100

var _target: Building
var _stop := false
var _last_distance := 0.0
var _attack_timer := 0.0
var _eaten := 0

func _ready() -> void:
	add_to_group("Snacks")

func _process(delta: float) -> void:
	if _target == null and !_stop:
		_target = _find_target()
		if _target != null:
			# warning-ignore:return_value_discarded
			_target.connect("tree_exited", self, "_on_target_tree_exited")

	_attack_timer -= delta
	_attack_timer = max(_attack_timer, 0.0)

	if _target != null:
		if _get_distance_to_target() <= attack_distance and _attack_timer == 0.0:
			_attack()

	var desired_scale := Vector3.ONE + Vector3.ONE * float(_eaten) / 10.0
	if !desired_scale.is_equal_approx(scale):
		scale = desired_scale

func _get_distance_to_target() -> float:
	var h_translation := Vector3(global_translation.x, 0, global_translation.z)
	var target_h_translation := Vector3(_target.global_translation.x, 0, _target.global_translation.z)
	return h_translation.distance_to(target_h_translation)

func _physics_process(_delta: float) -> void:
	if _target != null:
		var h_translation := Vector3(global_translation.x, 0, global_translation.z)
		var target_h_translation := Vector3(_target.global_translation.x, 0, _target.global_translation.z)
		var distance := h_translation.distance_to(target_h_translation)
		if distance > attack_distance:
			add_central_force((target_h_translation - h_translation).normalized() * move_force)
			if compare_floats(distance, _last_distance, 0.005):
				apply_central_impulse(Vector3.UP * 0.5)
			_last_distance = distance

func _on_target_tree_exited():
	_target = null

func _find_target() -> Building:
	var min_distance := 1e100
	var min_building: Building = null
	var buildings := get_tree().get_nodes_in_group("Buildings")

	if buildings.size() == 0:
		_stop = true
		return null

	for node in buildings:
		if node is Building:
			var distance := global_translation.distance_squared_to(node.global_translation)
			if distance < min_distance:
				min_distance = distance
				min_building = node

	return min_building

func _attack() -> void:
	var h_translation := Vector3(global_translation.x, 0, global_translation.z)
	var target_h_translation := Vector3(_target.global_translation.x, 0, _target.global_translation.z)
	var recoil_dir := (h_translation - target_h_translation + Vector3.UP * 0.5).normalized()
	apply_central_impulse(recoil_dir * 10.0)
	_attack_timer = cool_down
	_eaten += _target._attack(damage)

func hit(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		Global.score += 100
		queue_free()

static func compare_floats(a: float, b: float, epsilon: float) -> bool:
	return abs(a - b) <= epsilon
