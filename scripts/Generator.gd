extends Node
class_name Generator

func generate(
	start_position: Vector2,
	iterations: int,
	length_reduction: float,
	color: Color,
	width: float,
	rule: Rule):

	var length: int = -20
	var arrangement: String = rule.axiom

	var width_reduction: float = 0.8

	var rot: float = 0.0
	var main_branch: Branch = Branch.new(start_position, start_position, color, width, rot)
	var current_branch: Branch = main_branch
	var cache_queue: Array[Variant] = []

	for i in range(iterations):
		var new_arrangement: String = ""
		for character in arrangement:
			new_arrangement += rule.get_character(character)
		arrangement = new_arrangement

	for character in arrangement:
		match rule.get_action(character):
			RuleAction.DRAW_FORWARD:
				var to: Vector2 = current_branch.get_to() + Vector2(0, length).rotated(deg_to_rad(rot))

				if current_branch.get_rotation() == rot:
					current_branch.set_to(to)
				else:
					if current_branch.get_children().is_empty():
						width *= width_reduction
					else:
						width = current_branch.get_children()[0].get_width()
					var new_branch: Branch = Branch.new(current_branch.get_to(), to, color, width, rot)
					current_branch.add_child(new_branch)
					current_branch = new_branch

			RuleAction.ROTATE_RIGHT:
				rot += rule.angle
			RuleAction.ROTATE_LEFT:
				rot -= rule.angle
			RuleAction.PUSH_TO_STACK:
				cache_queue.append([current_branch, rot, length * length_reduction])
			RuleAction.POP_FROM_STACK:
				if cache_queue.size() > 0:
					var cached_data = cache_queue.pop_back()
					current_branch = cached_data[0]
					rot = cached_data[1]
					length = cached_data[2]

	return main_branch
