extends Camera3D

var is_shaking := false

func shake_pos(intensity: float = 0.05, duration: float = 0.25) -> void:
	if is_shaking or not is_inside_tree():
		return

	is_shaking = true

	var tree := get_tree()
	if tree == null:
		is_shaking = false
		return

	var time_left := duration
	var start_position := position

	while time_left > 0.0 and is_inside_tree():
		var offset := Vector3(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity),
			0.0
		)

		position = start_position + offset
		time_left -= get_process_delta_time()
		await tree.process_frame

	if is_inside_tree():
		position = start_position

	is_shaking = false
