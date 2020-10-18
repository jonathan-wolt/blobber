extends KinematicBody2D

# Geschwindigkeiten
export var gravity := 20.0
export var acceleration := 60.0
export var deacceleration := 0.2
export var maxSpeed := 200.0
export var jumpHeight := 550.0

# Bewegung Steuerung
export var toLeft := "ui_left"
export var toRight := "ui_right"
export var toJump := "jump"

#==========================
# Objekte
#----------

# Sprite oder AnimatedSprite - nicht beide verwenden !!
onready var sprite : Sprite = null
onready var aniSprite : AnimatedSprite = $AnimatedSprite

# AnimationPlayer
onready var aniPlayer : AnimationPlayer = null

#======================
# Animationen
#-------------

# Namen
var ani_idle := "idle"
var ani_run := "run"
var ani_jump := "jump"
var ani_fall := "fall"

# Richtungen
var ani_O := "O"	# rechts
var ani_S := "S"	# nach unten
var ani_W := "W"	# nach links
var ani_N := "N"	# nach oben

# Starteinstellungen
var ani_name := ani_idle
var ani_direction := ani_O

#=================================
# Variablen
#-----------

var motion := Vector2()		# Bewegung
var up := Vector2(0, -1)	# Up-Richtung

#=================================
# Funktionen
#-------------

func _ready():
	if aniSprite:
		aniSprite.play("idle_O")


# move_and_slide im Physik Prozess
func _physics_process(_delta):
	# Bremsen ausschalten
	var friction := false
	
	# wenn Bewegung nach rechts
	if Input.is_action_pressed(toRight):
		# Animation
		ani_direction = ani_O
		ani_name = ani_run
		
		# Beschleunigung nach rechts
		motion.x = min(motion.x + acceleration, maxSpeed)
		
	elif Input.is_action_pressed(toLeft):
		# Animation
		ani_direction = ani_W
		ani_name = ani_run
		
		# Beschleunigung nach links
		motion.x = max(motion.x - acceleration, -maxSpeed)

	else:
		# Stillstand
		
		# Animation
		ani_name = ani_idle
		
		# Bremsen einschalten
		friction = true
		
	# Wenn am Boden
	if is_on_floor():
		# Springen abfragen
		if Input.is_action_just_pressed(toJump):
			motion.y -= jumpHeight
		
		# wenn Bremsen
		if friction == true:
			motion.x = lerp(motion.x, 0, deacceleration)
	else:
		# in der Luft

		# wenn es aufwärts geht
		if motion.y < 0:
			# Animation "jump"
			ani_name = ani_jump
		else:
			# Animation "fall"
			ani_name = ani_fall

	# Animation Name zusammenstellen
	var ani = ani_name + "_" + ani_direction
	
	# wenn ein Animationsplayer
	if aniPlayer and aniPlayer.has_animation(ani):
		aniPlayer.play(ani)
	elif aniSprite and aniSprite.frames and aniSprite.frames.has_animation(ani):
		# wenn Animated Sprite
		aniSprite.play(ani)
	elif sprite:
		# wenn Sprite
		
		# wenn nach Links dann spiegeln
		if ani_direction == ani_W:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	
	# Gravitation hinzufügen in FallRichtung
	motion.y += gravity
	
	# und Bewegen
	motion = move_and_slide(motion, up)

