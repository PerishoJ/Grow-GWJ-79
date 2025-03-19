## Provides the Robot with Input. Meant to be provided during _process_physics()
class_name BotInput
extends RefCounted

## The forward/Backward values given, from th point of view of the camera (player)
var movement: Vector2
## Whether the jump key was just pressed
var jump: bool
## The global angle of the player's camera
var referenceYAngle: float
