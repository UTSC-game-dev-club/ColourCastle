# autoload for game state
# game_start() should only be invoked when playing is false
# game_end() should be invoked only when playing is true
# set_perspective() should be invoked only when playing is true, on set, it emits perspective_change signal
# get_perspective() should be invoked only when playing is true


extends Node

enum Perspective {
	SIDESCROLLER = 0,
	TOPDOWN = 1,
	SIDESCROLLER_TO_TOPDOWN = 2,
	TOPDOWN_TO_SIDESCROLLER = 3,
}

var starting_perspective: Perspective = Perspective.SIDESCROLLER

var playing: bool = true # toggle around this when debugging
var perspective: Perspective:
	set(new_perspective):
		assert(playing)
		perspective = new_perspective
		perspective_change.emit()

signal perspective_change

func game_start() -> void:
	assert(!playing)
	playing = true
	perspective = starting_perspective

func game_end() -> void:
	assert(playing)
	playing = false

func set_perspective(new_perspective) -> void:
	assert(playing)
	perspective = new_perspective
	perspective_change.emit()

func get_perspective() -> Perspective:
	assert(playing)
	return perspective
