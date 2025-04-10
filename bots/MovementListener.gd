extends AnimationPlayer

@onready var status : Label3D = $"../Label3D"
var isGoing : bool = false
func _on_bot_movement(moveDir : Vector3):
  
  status.text = str(moveDir)
  if moveDir:
    if not isGoing:
      print("Starting to move")
      get_animation("bobble").loop_mode=Animation.LOOP_LINEAR
    isGoing = true;
    play("bobble")
    
  elif not moveDir:
    if isGoing:
      get_animation("bobble").loop_mode=Animation.LOOP_NONE
      print("Stopping movement")
    animation_set_next("bobble","RESET")
    isGoing = false
  pass # Replace with function body.
