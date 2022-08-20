class_name Player
extends KinematicBody

export var speed := 7.0
export var acceleration := 9.0
export var air_acceleration := 3.0
export var gravity := 9.8
export var jump := 2.0
export var mouse_sensitivity := 0.3
export var max_speed := 1.75
export var head_bob_frequency := 20.0
export var head_bob_amplitude := 0.35

var _acceleration = acceleration
var cam_accel = 50
var _snap

var _velocity := Vector3.ZERO
var _gravity := Vector3.ZERO

onready var head: Spatial = $Head
onready var head_translation := head.translation
onready var camera: Camera = $Head/Camera
onready var head_anim: AnimationPlayer = $Head/AnimationPlayer
onready var blaster: Blaster = $Head/Camera/Blaster

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				_start_firing()
			else:
				_stop_firing()

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(
			head.global_transform.origin, cam_accel * delta
		)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform

func _physics_process(delta):
	var direction := _get_desired_direction()
	_velocity = _velocity.linear_interpolate(direction * speed, _acceleration * delta)
	var horizontal_clamped := Vector3(_velocity.x, 0, _velocity.z).limit_length(max_speed)
	_velocity.x = horizontal_clamped.x
	_velocity.z = horizontal_clamped.z

	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = jump

	_velocity -= Vector3(0, gravity, 0) * delta
	_velocity = move_and_slide(_velocity, Vector3.UP, true)

	if is_on_floor():
		_acceleration = acceleration
		var head_bob := direction.length() * OS.get_ticks_msec() / 1000.0 * head_bob_frequency
		var target_head_translation := head_translation + Vector3.UP * sin(head_bob) * head_bob_amplitude
		head.translation = head.translation.linear_interpolate(target_head_translation, delta)
	else:
		_acceleration = air_acceleration

func _get_desired_direction() -> Vector3:
	var forward = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	var right = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input := Vector3(right, 0, forward).normalized()
	return global_transform.basis.xform(input)

func _start_firing() -> void:
	pass

func _stop_firing() -> void:
	pass
