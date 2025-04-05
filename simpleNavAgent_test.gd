extends CharacterBody3D
# check here https://www.youtube.com/watch?v=EOocBMBbL-E
@onready var nav : NavigationAgent3D  = $NavAgent
@export var target: Node3D
@export var speed : float
@export var accel : float

func _physics_process(delta: float) -> void:
  var direction = Vector3()
  nav.target_position = target.global_position

  direction = nav.get_next_path_position() - global_position
  direction = direction.normalized()

  velocity = velocity.lerp ( direction * speed , accel * delta)
  move_and_slide()
