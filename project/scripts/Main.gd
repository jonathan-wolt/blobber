extends Node2D

# Objekte
var world: Node
var player: Node


# bein Start
func _ready():
	# merken der ZugriffsPfade
	world = $World
	player = $Player/Blobber


