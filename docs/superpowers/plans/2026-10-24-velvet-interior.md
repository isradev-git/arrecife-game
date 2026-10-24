# Velvet visto desde dentro Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convertir `fiebre_entrada` en una vista interior inequívoca de Velvet y mantener el recorrido existente.

**Architecture:** Conservar el ID estable y sustituir sólo el fondo candidato, las etiquetas, la observación y las coordenadas de sus dos hotspots. Guardar la versión exterior y el prompt. Ningún cambio en State ni en el número de vistas.

**Tech Stack:** Godot 4.7.2, GDScript, JSON, PNG.

**Spec:** `docs/superpowers/specs/2026-10-24-velvet-interior-design.md`

## Tarea 1: arte y ubicación

- [x] Preservar `fiebre_entrada.png` como variante exterior en `art/iterations/` y generar un fondo interior candidato con referencias al pasaje y los retratos originales.
- [x] Inspeccionar el PNG a tamaño de juego y ubicar salida y observación sobre elementos visibles.

## Tarea 2: recorrido y regresión

- [x] Ajustar `world.json`, `story.json` y las pruebas de navegación para entrar y salir de Velvet con el ID `fiebre_entrada` intacto.
- [x] Ejecutar pruebas headless y nativas, inspeccionar capturas, preservar canon/originales y exportar Web local.

## Tarea 3: continuidad

- [x] Actualizar dirección artística, validación, tarea y estado con la distinción entre implementación técnica y aprobación artística.
- [x] Confirmar la rama de trabajo sin incluir el GIF anterior modificado fuera de esta tarea.
