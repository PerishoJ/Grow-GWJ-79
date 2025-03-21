extends Node

@export var bot : BotController
@onready var cameraPivot : Node3D = $CameraPivot
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
  
func _physics_process(delta):
  if bot :
    bot.handleInput(_get_player_input(), delta)
  pass


func _get_player_input():
  var input : BotInput = BotInput.new()
  input.movement = Input.get_vector("left","right","up","down")
  input.jump = Input.is_action_just_pressed("jump")
  input.referenceYAngle = cameraPivot.rotation.y
  return input
