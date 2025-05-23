extends XRController3D

@export var labelImModding: Label3D
@export var hand_node_path: NodePath
@export var move_speed = 3
@export var turn_speed = 2.0
@export var deadzone = 0.1

var isTriggerPressed := false
var isGripped := false

var leftController : XRController3D
var rightController : XRController3D
var hand: XRToolsHand

func _ready() -> void:
	var leftController = $LeftHand
	var rightController = $RightHand
	
	button_pressed.connect(btnPressed)
	button_released.connect(btnReleased)

	hand = get_node_or_null(hand_node_path)
	if hand == null:
		push_error("Missing XRToolsHand at %s" % hand_node_path)

func _process(delta):
	if leftController:
		var left_stick = Vector2(
			leftController.get_vector2("primary").x,
			leftController.get_vector2("primary").y
		)
		
		if left_stick.length() > deadzone:
			var camera_basis = $XRCamera3D.global_transform.basis
			var farmforward = -camera_basis.z
			farmforward.y = 0
			farmforward = farmforward.normalized()
			
			var right = camera_basis.x
			right.y = 0
			right = right.normalized()
			
			var moving = farmforward * left_stick.y + right * left_stick.x
			moving = moving.normalized() * delta * move_speed

func btnPressed(btnName: String) -> void:
	if btnName == "trigger_click":
		isTriggerPressed = true
		_update_hand_pose()

	if btnName == "grip_click":
		isGripped = true
		_update_hand_pose()

func btnReleased(btnName: String) -> void:
	if btnName == "trigger_click":
		isTriggerPressed = false
		_update_hand_pose()

	if btnName == "grip_click":
		isGripped = false
		_update_hand_pose()

func _update_hand_pose() -> void:
	if hand == null:
		return

	if isGripped:
		hand.set_hand_pose("grip")
	elif isTriggerPressed:
		hand.set_hand_pose("grip") 
	else:
		hand.set_hand_pose("open")

func onTheLine():
	pass
