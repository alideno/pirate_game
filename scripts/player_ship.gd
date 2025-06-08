extends CharacterBody3D

var mouse_movement = Vector2()
@onready var camera = $H/V/Camera

const TILE_SIZE = Vector3(3,3,3)  

func _ready() -> void:
	$H/V.rotation_degrees.x = -15

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement += event.relative
	elif event is InputEventMouseButton and event.pressed:
		handle_click(event)

func _process(delta: float) -> void:
	if mouse_movement != Vector2():
		$H.rotation_degrees.y += -mouse_movement.x * 0.3
		$H/V.rotation_degrees.x += -mouse_movement.y * 0.3
		$H/V.rotation_degrees.x = clamp($H/V.rotation_degrees.x, -90, -15)
		mouse_movement = Vector2()

func handle_click(event: InputEventMouseButton) -> void:
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * 1000

	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(ray_params)
	
	if result:
		var hit_pos = result.position
		var grid = Vector3i(
			floor(hit_pos.x / TILE_SIZE.x),
			floor(hit_pos.y / TILE_SIZE.y),
			floor(hit_pos.z / TILE_SIZE.z)
		)
		var center = (Vector3(grid) + Vector3(0.5, 1, 0.5)) * TILE_SIZE
		print(center)
		move_to_tile(center)


func move_to_tile(pos: Vector3):
	global_position = pos  
