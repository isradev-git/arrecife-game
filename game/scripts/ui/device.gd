extends VBoxContainer

const STATUS_LABELS := {"LOCKED":"Sin recibir", "AVAILABLE":"Disponible", "ACTIVE":"Activo", "READY_TO_COMPLETE":"Listo para entregar", "COMPLETED":"Completado"}

func show_tab(host: Control, selected: String) -> void:
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
			for id in Content.story.messages:
				var message: Dictionary = Content.story.messages[id]
				if not State.matches(message.get("visible_if", {})):
					continue
				GameUI.action(self, ("[ok] " if id in State.data.messages else "* ") + message.subject + " · " + message.from, func():
					State.apply({"message":id})
					State.apply(message.effects)
					host.open_panel(message.subject, "MENSAJE / " + message.from)
					GameUI.label(host.modal_body, message.text, 26)
					GameUI.button(host.modal_body, "Revisar contrato", func(): host.show_device("Contratos"))
					GameUI.button(host.modal_body, "Volver a mensajes", func(): host.show_device("Mensajes")))
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
			for contact in Content.story.contacts:
				GameUI.label(self, contact.name, 26)
				GameUI.label(self, contact.text)
		"Lugares":
			GameUI.label(self, "Rutas conocidas · el deck informa; los trayectos parten de los accesos de cada escena.", 22)
			for id in Content.world.zones:
				var zone: Dictionary = Content.world.zones[id]
				GameUI.label(self, zone.name + (" · conocida" if id in State.data.unlocked else " · sin acceso"), 26)
		"Cierre":
			GameUI.label(self, "EL ARRECIFE · FIN", 30).modulate = GameUI.AMBER
			GameUI.label(self, "El cargo discutido permanece suspendido. La Jefa ha concertado una verificación independiente de la conducción.", 24)
			GameUI.label(self, Content.dialogues.jefa.nodes.final_vecinos.text if State.data.flags.get("vecinos_primero", false) else Content.dialogues.jefa.nodes.final_policia.text, 24)

func accept_contract(host: Control, id: String) -> void:
	if State.accept(id):
		host.show_device("Contratos")
