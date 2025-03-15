extends Camera3D

@export var target_position: Node3D
@export var lerp_power: float = 1.0



func _process(delta):
  position = lerp(position, target_position.position, delta * lerp_power)
