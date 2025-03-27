extends CharacterBody3D
class_name BotController
# Great Godot Types Tutorial https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_basics.html#annotations

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var mesh_base : Node3D = $MeshSkeleton

## These inputs are provided to the bot and handled during physics process
var _bot_input : BotInput = null


func _physics_process(delta):
  # apply gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta
  _apply_controller_input( _bot_input)
  move_and_slide()


func _apply_controller_input( arg_input ):
  if not arg_input or Time.get_ticks_msec() > arg_input.expire_time :
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
    return
 # Handle jump.
  if arg_input.jump and is_on_floor():
    velocity.y = JUMP_VELOCITY
  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir = arg_input.movement
  var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  direction = direction.rotated(Vector3.UP, arg_input.referenceYAngle - rotation.y) # Rotate the motion angle to match camera direction
  # TODO need to adjust for the input angle so the bot starts going the right direction.
  #   E.g. lerp the y-angle towards the input.rotation so that the robot slowely turns to face the correct direction
  #
  #  ~ Maybe I just want point and click, League style. Hmm
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
    # Rotate the mesh to point in same direction as camera TODO make this smooth w/ a quaternion lerp, or something
    mesh_base.rotate_y( arg_input.referenceYAngle - mesh_base.rotation.y )
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
    
## apply controller input here.   
func handleInput( input:BotInput):
  _bot_input = input;
  
