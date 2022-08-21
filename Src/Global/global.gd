extends Node

var _score := 0
var score := _score setget _set_score, _get_score
var _buildings_left := 0
var buildings_left := _buildings_left setget _set_buildings_left, _get_buildings_left

signal score_changed(score)
signal buildings_left_changed(buildings_left)

func _ready() -> void:
	pass

func reset() -> void:
	_set_score(0)
	_set_buildings_left(0)

func _set_score(value: int) -> void:
	_score = value
	emit_signal("score_changed", _score)

func _get_score() -> int:
	return _score

func _set_buildings_left(value: int) -> void:
	_buildings_left = value
	emit_signal("buildings_left_changed", _buildings_left)

func _get_buildings_left() -> int:
	return _buildings_left
