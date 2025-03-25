extends Node
@export var camera_follow_aggressiveness : float = 2
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
    _follow_bot(delta)
  pass


func _get_player_input():
  var input : BotInput = BotInput.new()
  input.movement = Input.get_vector("left","right","up","down")
  input.jump = Input.is_action_just_pressed("jump")
  input.referenceYAngle = cameraPivot.rotation.y
  return input
  
func _follow_bot(delta):
  var target = (bot.get_node("CameraBase") as Node3D).global_position
  cameraPivot.position = lerp(cameraPivot.position, target , delta * camera_follow_aggressiveness)


func _on_camera_pivot_change_bot_request(collision):
  bot = collision ; 
  pass # Replace with function body.
