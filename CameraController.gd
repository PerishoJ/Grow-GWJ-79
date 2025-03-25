extends Node3D

# Camera Move Tutorial https://www.youtube.com/watch?v=ZCb12AHKMfE

@export var camera_sensitivity: float = 0.005
@export var zoom_sensitivity: float

@onready var camera := $Camera
@onready var spring_arm := $SpringArm3D

## Sends colliders
signal change_bot_request

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
  # Check to make sure we aren't in a menu, or "switch" mode
  if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    rotateCamera(event)
    zoomCamera(event)
  quitButton(event)


func _process(delta):
  toggleSelectMode()
  if Input.is_action_just_pressed("bot_select"):
    botSelect()
  pass



func botSelect():
  # Select From Camera
  # Ref https://forum.godotengine.org/t/godot-4-how-to-cast-a-ray-from-mouse-position-towards-camera-orientation-in-3d/5280/2
  var mouse_pos = get_viewport().get_mouse_position()
  var ray_length = 100
  var from = camera.project_ray_origin(mouse_pos)
  var to = from + camera.project_ray_normal(mouse_pos) * ray_length
  var space = get_world_3d().direct_space_state
  var ray_query = PhysicsRayQueryParameters3D.new()
  ray_query.from = from
  ray_query.to = to
  ray_query.collide_with_areas = true
  var raycast_result = space.intersect_ray(ray_query)
  if raycast_result != null and raycast_result.has("collider"):
    # If you click on a bot, you switch control to that one
    if(raycast_result.collider is BotController):
      change_bot_request.emit( raycast_result.collider )
      
      
func toggleSelectMode():
    if Input.is_action_just_pressed("switch") :
      Input.mouse_mode = Input.MOUSE_MODE_CONFINED
      print("Switch mode: ON")
    elif Input.is_action_just_released("switch") :
      Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
      print("Switch mode: OFF")

func rotateCamera(event):
  if event is InputEventMouseMotion:
    rotation.y -= event.relative.x * camera_sensitivity
    rotation.y = wrapf(rotation.y, 0.0, TAU) # Just wraps around 360 for precision errors

    rotation.x -= event.relative.y * camera_sensitivity
    rotation.x = clampf(rotation.x, -PI/2, PI/4) # Between 45(bottom) and 90 (top)

func zoomCamera(event):
  if event is InputEventMouseButton:
    if event.is_action_pressed("zoom_in"):
      spring_arm.spring_length -= zoom_sensitivity;
    elif event.is_action_pressed("zoom_out"):
      spring_arm.spring_length += zoom_sensitivity;

  # Another Way of handling the input...but without using input mappings. So a worse way.
  # if event is InputEventMouseButton:
  #   if event.button_index == MOUSE_BUTTON_WHEEL_UP:
  #     spring_length -= zoom_sensitivity;
  #   elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
  #     spring_length += zoom_sensitivity;


func quitButton(event):
  if event is InputEventKey:
    if (event as InputEventKey).keycode == KEY_ESCAPE:
      get_tree().quit()
