class_name OrderUpTicket
extends Control

var order_status: OrderStatus:
	set(val):
		%OrderEntriesGrid.status = val
		order_status = val
