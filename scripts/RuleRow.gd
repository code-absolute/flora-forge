extends HBoxContainer
class_name RuleRow

@onready var symbol_text_edit: TextEdit = $SymbolTextEdit
@onready var rule_text_edit: TextEdit = $RuleTextEdit
@onready var remove_button: Button = $RemoveButton


func _ready() -> void:
    remove_button.connect("pressed", Callable(self, "remove"))


func remove() -> void:
    queue_free()


func set_rule(symbol: String, rule: String):
    symbol_text_edit.text = symbol
    rule_text_edit.text = rule


func get_rule() -> Dictionary:
    return {"symbol": symbol_text_edit.text, "rule": rule_text_edit.text}
