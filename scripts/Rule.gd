class_name Rule

var axiom: String
var rules: Dictionary = {}
var actions: Dictionary = {}
var angle: int


func get_character(character: String) -> Variant:
    if rules.has(character):
        return rules.get(character)
    return character


func get_action(character: String) -> Variant:
    return actions.get(character)
