extends Node

enum ColorEnum {
	WHITE = 0,
	RED = 1,
	BLUE = 2,
	GREEN = 3,
	PINK = 4,
}

enum Perspective {
	TRANSITIONING = 0,
	SIDESCROLLER = 1,
	TOPDOWN = 2
}

var starting_perspective: Perspective = Perspective.SIDESCROLLER
