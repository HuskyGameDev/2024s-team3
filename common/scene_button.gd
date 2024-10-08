class_name SceneButton extends Button

@export_enum("fade_to_black",
"fade_to_white",
"wipe_to_right",
"zelda",
"no_transition") var transition_type:String #Transition we want to use when the button is pressed

@export var path_to_new_scene:String # scene we want to load when touchign this door
#@export var entry_door_name:String # name of the door we're entering through in the next room
