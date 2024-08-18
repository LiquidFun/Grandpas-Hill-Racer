extends HBoxContainer


func swap_input_actions(action1: String, action2: String):
	
	var actions1 = InputMap.action_get_events(action1)
	var actions2 = InputMap.action_get_events(action2)
	
	InputMap.action_erase_events(action1)
	InputMap.action_erase_events(action2)
	
	for action in actions1:
		InputMap.action_add_event(action2, action)
	for action in actions2:
		InputMap.action_add_event(action1, action)

func swap_forward_side_actions():
	
	swap_input_actions("forward", "right")
	swap_input_actions("backward", "left")
	
	# ProjectSettings.save()
