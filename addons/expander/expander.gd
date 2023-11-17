@tool
extends EditorPlugin

var shortcut := _get_or_set_shortcut()

# Original implementation: https://github.com/godotengine/godot-proposals/issues/2024#issuecomment-1378782833

const PLUGIN_ID := "expander"
const PLUGIN_PATH := "plugins/"+PLUGIN_ID

func _get_or_set_shortcut() -> Shortcut:
	var key := PLUGIN_PATH + "/shortcut"
	if not ProjectSettings.has_setting(key):
		var default_shortcut := preload("res://addons/expander/expander.tres")
		var property_info := {
			"name": key,
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "Shortcut"
		}
		ProjectSettings.set_setting(key, default_shortcut)
		ProjectSettings.add_property_info(property_info)

	var loaded_shortcut: Shortcut = ProjectSettings.get_setting(key)
	return loaded_shortcut

func _input(event: InputEvent) -> void:
	if shortcut and shortcut.matches_event(event):
		var selected = get_editor_interface().get_selection().get_selected_nodes()
		if selected.size() > 0 and selected[0] is Control:
			var control_node = selected[0]
			var parent_node = control_node.get_parent()
			if parent_node is Container:				
				# container parent:
				control_node.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
				control_node.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
			else :
				# no container parent:
				control_node.anchor_top = 0
				control_node.anchor_bottom = 1
				control_node.anchor_left = 0
				control_node.anchor_right = 1
				control_node.offset_top = 0
				control_node.offset_bottom = 0
				control_node.offset_left = 0
				control_node.offset_right = 0
			
func _enter_tree():
	print("Expander plugin loaded.")
	pass


func _exit_tree():
	print("Expander plugin unloaded.")
	pass
