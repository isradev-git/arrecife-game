extends VBoxContainer

const STATUS_LABELS := {"LOCKED":"Sin recibir", "AVAILABLE":"Disponible", "ACTIVE":"Activo", "READY_TO_COMPLETE":"Listo para entregar", "COMPLETED":"Completado"}

func show_tab(host: Control, selected: String) -> void:
	var tabs := HFlowContainer.new()
	add_child(tabs)
	for tab in ["Mensajes", "Contratos", "Archivo", "Noticias", "Contactos", "Lugares"]:
		var button := GameUI.button(tabs, tab, func(): host.show_device(tab))
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		if tab == selected:
			button.modulate = GameUI.AMBER
	GameUI.label(self, selected.to_upper(), 20).modulate = GameUI.AMBER
	match selected:
		"Mensajes":
			for id in Content.story.messages:
				var message: Dictionary = Content.story.messages[id]
				GameUI.button(self, ("[ok] " if id in State.data.messages else "* ") + message.subject + " · " + message.from, func():
					State.apply({"message":id})
					State.apply(message.effects)
					host.open_panel(message.subject, "MENSAJE / " + message.from)
					GameUI.label(host.modal_body, message.text, 26)
					GameUI.button(host.modal_body, "Revisar contrato", func(): host.show_device("Contratos"))
					GameUI.button(host.modal_body, "Volver a mensajes", func(): host.show_device("Mensajes")))
		"Contratos":
			for id in Content.missions:
				var mission: Dictionary = Content.missions[id]
				var status: String = State.data.missions[id]
				if status == "LOCKED":
					GameUI.label(self, "No hay contratos recibidos. Revisa los mensajes.")
					continue
				GameUI.label(self, mission.title + " / " + STATUS_LABELS[status], 28)
				GameUI.label(self, mission.summary + "\n\n" + mission.terms, 24)
				if status == "AVAILABLE":
					GameUI.button(self, "Aceptar contrato", func():
						State.accept(id)
						host.show_device("Contratos"))
				else:
					for step in mission.steps:
						GameUI.label(self, ("[ok]  " if State.data.flags.get(step.flag, false) else "o  ") + step.label, 22)
		"Archivo":
			GameUI.label(self, "Documentos leídos y notas guardadas", 24)
			for id in State.data.documents:
				GameUI.button(self, Content.story.documents[id].title, func(): host.show_document(id))
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
				GameUI.label(self, "La encontrarás en el pasaje junto a Velvet al aceptar el contrato.")
		"Lugares":
			GameUI.label(self, "Rutas conocidas · el deck informa; los trayectos parten de los accesos de cada escena.", 22)
			for id in Content.world.zones:
				var zone: Dictionary = Content.world.zones[id]
				GameUI.label(self, zone.name + (" · conocida" if id in State.data.unlocked else " · sin acceso"), 26)
				if id in ["nudo", "puntales"]:
					GameUI.label(self, "Continuación prevista en otro hito.", 20)
