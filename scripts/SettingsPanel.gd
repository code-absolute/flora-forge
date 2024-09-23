extends Panel
class_name SettingsPanel

@onready var axiom_text_edit: TextEdit = %AxiomTextEdit
@onready var angle_text_edit: TextEdit = %AngleTextEdit
@onready var rules_container: VBoxContainer = %RulesContainer
@onready var add_rule_button: Button = %AddRuleButton
@onready var actions_list_label: Label = %ActionsList
@onready var generate_button: Button = %GenerateButton

var axiom: String = "X"
var angle: int = 20

var rules: Dictionary = {
	"X": "-Y[+Y][--X]+Y-Y[++++X]-X",
	"Y": "YY",
}

var actions: Dictionary = {
	"X": RuleAction.DRAW_FORWARD,
	"Y": RuleAction.DRAW_FORWARD,
	"Z": RuleAction.DRAW_FORWARD,
	"+": RuleAction.ROTATE_RIGHT,
	"-": RuleAction.ROTATE_LEFT,
	"[": RuleAction.PUSH_TO_STACK,
	"]": RuleAction.POP_FROM_STACK,
}

const RULE_NAMES: Dictionary = {
	RuleAction.DRAW_FORWARD: "Draw Forward",
	RuleAction.ROTATE_RIGHT: "Rotate Right",
	RuleAction.ROTATE_LEFT: "Rotate Left",
	RuleAction.PUSH_TO_STACK: "Push To Stack",
	RuleAction.POP_FROM_STACK: "Pop From Stack",
}
var currentRule: Rule = null
signal current_rule_changed(rule)


func _ready():

	axiom_text_edit.text = axiom
	angle_text_edit.text = str(angle)

	for key in rules.keys():
		_add_preset_rule(key, rules.get(key))

	var actionsString: String = ""
	var actionsArray: Array = actions.keys().map(func(k): return "{0} -> {1}\n".format([str(k), RULE_NAMES[actions.get(k)]]))
	for action in actionsArray:
		actionsString += action

	actions_list_label.text = actionsString

	add_rule_button.connect("pressed", _add_rule)
	generate_button.connect("pressed", _generate)


func _add_preset_rule(symbol: String, rule: String):
	var rule_row: Node = preload ("res://rule_row.tscn").instantiate()
	rules_container.add_child(rule_row)
	rule_row.set_rule(symbol, rule)


func _add_rule():
	var rule_row: Node = preload ("res://rule_row.tscn").instantiate()
	rules_container.add_child(rule_row)


func _generate():

	var rule = Rule.new()
	rule.axiom = axiom_text_edit.text
	rule.angle = angle_text_edit.text.to_int()

	for rule_row: RuleRow in rules_container.get_children():
		var r: Dictionary = rule_row.get_rule()
		rule.rules[r.symbol] = r.rule

	rule.actions = actions
	currentRule = rule

	emit_signal("current_rule_changed", rule)
