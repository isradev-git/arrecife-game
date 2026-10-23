extends VBoxContainer

const STATUS_LABELS := {"LOCKED":"Sin recibir", "AVAILABLE":"Disponible", "ACTIVE":"Activo", "READY_TO_COMPLETE":"Listo para entregar", "COMPLETED":"Completado"}

func show_tab(host: Control, selected: String, contact: String = "", focus_message: String = "") -> void:
	if selected == "Mensajes" and not contact.is_empty():
		show_thread(host, contact, focus_message)
		return
	var tabs := HFlowContainer.new()
	tabs.add_theme_constant_override("h_separation", 18)
	add_child(tabs)
	var sections := ["Mensajes", "Contratos", "Archivo", "Noticias", "Contactos", "Lugares"]
	if State.data.missions.get("prueba_presion") == "COMPLETED":
		sections.append("Cierre")
	for tab in sections:
		var button := GameUI.action(tabs, tab, func(): host.show_device(tab))
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		if tab == selected:
			button.modulate = GameUI.AMBER
	GameUI.label(self, selected.to_upper(), 20).modulate = GameUI.AMBER
	match selected:
		"Mensajes":
			if contact.is_empty():
				show_threads(host)
			else:
				show_thread(host, contact)
		"Contratos":
			var received := false
			var mission_ids := Content.missions.keys()
			var priority := {"AVAILABLE": 0, "READY_TO_COMPLETE": 1, "ACTIVE": 2, "COMPLETED": 3, "LOCKED": 4}
			mission_ids.sort_custom(func(a, b): return priority[State.data.missions[a]] < priority[State.data.missions[b]])
			for id in mission_ids:
				var mission: Dictionary = Content.missions[id]
				var status: String = State.data.missions[id]
				if status == "LOCKED":
					continue
				received = true
				GameUI.label(self, mission.title + " / " + STATUS_LABELS[status], 28)
				GameUI.label(self, mission.summary + "\n\n" + mission.terms, 24)
				if status == "AVAILABLE":
					GameUI.button(self, "Aceptar contrato", accept_contract.bind(host, id))
				else:
					for step in mission.steps:
						GameUI.label(self, ("[ok]  " if State.data.flags.get(step.flag, false) else "o  ") + step.label, 22)
			if not received:
				GameUI.label(self, "No hay contratos recibidos. Revisa los mensajes.")
		"Archivo":
			GameUI.label(self, "Documentos leídos y notas guardadas", 24)
			for id in State.data.documents:
				GameUI.action(self, Content.story.documents[id].title, func(): host.show_document(id))
			for id in State.data.discoveries:
				GameUI.label(self, "— " + Content.story.records[id], 22)
			if State.data.discoveries.is_empty() and State.data.documents.is_empty():
				GameUI.label(self, "Todavía no has guardado ningún registro.")
		"Noticias":
			for article in Content.story.news:
				GameUI.label(self, article.title, 26)
				GameUI.label(self, article.text)
		"Contactos":
			for entry in Content.story.contacts:
				if not State.matches(entry.get("visible_if", {})):
					continue
				GameUI.action(self, entry.name, func(): host.show_device("Mensajes", entry.name))
				GameUI.label(self, entry.text)
		"Lugares":
			GameUI.label(self, "Rutas conocidas · el deck informa; los trayectos parten de los accesos de cada escena.", 22)
			for id in Content.world.zones:
				var zone: Dictionary = Content.world.zones[id]
				GameUI.label(self, zone.name + (" · conocida" if id in State.data.unlocked else " · sin acceso"), 26)
		"Cierre":
			GameUI.label(self, "EL ARRECIFE · FIN", 30).modulate = GameUI.AMBER
			GameUI.label(self, "El cargo discutido permanece suspendido. La Jefa ha concertado una verificación independiente de la conducción.", 24)
			GameUI.label(self, Content.dialogues.jefa.nodes.final_vecinos.text if State.data.flags.get("vecinos_primero", false) else Content.dialogues.jefa.nodes.final_policia.text, 24)

func show_threads(host: Control) -> void:
	var contacts: Array[String] = []
	var unread_contacts: Array[String] = []
	var latest := {}
	var unread := State.unread_messages()
	for id in Content.story.messages:
		var message: Dictionary = Content.story.messages[id]
		if not State.matches(message.get("visible_if", {})):
			continue
		if message.from not in contacts:
			contacts.append(message.from)
		if id in unread and message.from not in unread_contacts:
			unread_contacts.append(message.from)
		latest[message.from] = message.subject
	var ordered := unread_contacts.duplicate()
	for name in contacts:
		if name not in ordered:
			ordered.append(name)
	contacts = ordered
	for name in contacts:
		var count := 0
		for id in unread:
			if Content.story.messages[id].from == name:
				count += 1
		var label := name + (" · %d nuevo%s" % [count, "s" if count != 1 else ""] if count else " · al día")
		GameUI.action(self, label, func(): host.show_device("Mensajes", name))
		GameUI.label(self, latest[name], 18).modulate = GameUI.MUTED

func show_thread(host: Control, contact: String, focus_message: String = "") -> void:
	GameUI.action(self, "Volver a mensajes", func(): host.show_device("Mensajes"))
	var newest: Control
	var first_unread: Control
	var focused: Control
	for id in Content.story.messages:
		var message: Dictionary = Content.story.messages[id]
		if message.from != contact or not State.matches(message.get("visible_if", {})):
			continue
		var was_unread: bool = id not in State.data.messages
		var offer: String = message.get("effects", {}).get("offer", "")
		if was_unread or (not offer.is_empty() and State.data.missions.get(offer) == "LOCKED"):
			var effects: Dictionary = message.get("effects", {}).duplicate()
			effects["message"] = id
			if not State.apply(effects):
				return
		newest = bubble(message.subject + "\n\n" + message.text, false)
		if was_unread and not first_unread:
			first_unread = newest
		if id == focus_message:
			focused = newest
		var saved_reply: String = State.data.choices.get("message:" + id, "")
		for reply in message.get("replies", []):
			if saved_reply == reply.id:
				bubble(reply.text, true)
				var answer := bubble(reply.answer, false)
				if id == focus_message:
					focused = answer
			elif saved_reply.is_empty():
				GameUI.action(self, "Responder: " + reply.text, func():
					if State.reply_to_message(id, reply.id):
						host.show_device("Mensajes", contact, id)).modulate = GameUI.AMBER
		if message.get("effects", {}).has("offer") and State.data.missions[message.effects.offer] in ["AVAILABLE", "ACTIVE", "READY_TO_COMPLETE"]:
			GameUI.button(self, "Revisar contrato", func(): host.show_device("Contratos"))
	var target := focused if focused else first_unread if first_unread else newest
	if target:
		reveal_message.call_deferred(target)

func reveal_message(target: Control) -> void:
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if is_instance_valid(target) and is_inside_tree():
		var scroller := get_parent().get_parent() as ScrollContainer
		var maximum := scroller.get_v_scroll_bar().max_value - scroller.get_v_scroll_bar().page
		scroller.scroll_vertical = clampi(roundi(target.global_position.y - scroller.global_position.y + scroller.scroll_vertical - 8), 0, roundi(maximum))

func bubble(value: String, outgoing: bool) -> MarginContainer:
	var indent := MarginContainer.new()
	indent.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	indent.add_theme_constant_override("margin_left" if outgoing else "margin_right", 56)
	add_child(indent)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", GameUI.box(Color("302a25") if outgoing else Color("122b30"), Color("aa8a58") if outgoing else Color("406165"), 12))
	indent.add_child(panel)
	GameUI.label(panel, value, 23)
	return indent

func accept_contract(host: Control, id: String) -> void:
	if State.accept(id):
		host.show_device("Contratos")
