extends CharacterBody3D

# Great Godot Types Tutorial https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_basics.html#annotations

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## This is meant to be called during _process_physics.
func handleInput( input:BotInput , delta):
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta
  # Handle jump.
  if input.jump and is_on_floor():
    velocity.y = JUMP_VELOCITY
  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir = input.movement
  var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  # TODO need to adjust for the input angle so the bot starts going the right direction.
  #   E.g. lerp the y-angle towards the input.rotation so that the robot slowely turns to face the correct direction
  #
  #  ~ Maybe I just want point and click, League style. Hmm
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
  
  move_and_slide()
