class_name Order

var _entries: Array[OrderEntry]
var final: bool = false:
	set(val):
		if val != true:
			return
		final = val
		finalized.emit()

signal pushed_entry(OrderEntry)
signal finalized()

func _init() -> void:
	_entries = []

func push_entry(new_entry: OrderEntry):
	if final:
		return
	
	_entries.push_back(new_entry)
	pushed_entry.emit(new_entry)

func finalize():
	final = true

func entry(index: int) -> OrderEntry:
	return _entries[index]

func length() -> int:
	return len(_entries)
