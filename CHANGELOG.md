# Changelog

Todas las versiones significantes de este proyecto se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es/1.1.0/) y el versionado sigue [SemVer](https://semver.org/lang/es/).

La versión en `skills/comite-evaluador/SKILL.md` (`metadata.version`) es la que controla el comportamiento del agente.

## [3.0.0] - 2026-10-19

### Agregado
- Modo auditoría bajo el Sistema de la Dra. Rosario Martínez ("Ley del Rompecabezas"): reglas generales R1/R2/R3, criterios A a D y mapeo de los cuatro evaluadores sobre los cuatro roles del comité.
- Artefacto de cierre `matriz de cumplimiento` para material bajo evaluación formal.
- Artefacto de cierre `tabla de líneas de investigación` para propuestas derivadas de un corpus.
- Regla de objeto bajo evaluación: el padre lo declara antes de la ronda 1 y lo pasa a todos los roles.
- Regla de fundamentación: nunca se posa sobre una idea sin base.
- Regla de auditoría parcial: las comprobaciones imposibles por falta de material se declaran con nombre y motivo.
- Modo de evaluación de cambios propuestos, con bancos de preguntas y reglas específicas.
- `scripts/validate-skill.sh` con 23 chequeos de contrato.
- CI con validación del contrato, sintaxis del instalador y cobertura de las opciones de instalación.
- Andamiaje de contribución: `CONTRIBUTING.md`, `AGENTS.md`, `CODE_OF_CONDUCT.md`, plantillas de issue y PR.

## [2.0.0] - 2026-10-19

### Cambiado
- El informe estático de una sola pasada se reemplaza por un **ciclo deliberativo interactivo**: el Jurado interroga, los tres roles responden en orden fijo (Defensor, Escéptico, Metodólogo) y la ronda se repite hasta que el Metodólogo emite `CERRAR`.
- El gate de iteración pasa a ser determinista: solo el Metodólogo lo emite y un veredicto ausente cuenta como `ITERAR`.
- Tope duro de 3 rondas.
- Los roles corren secuencialmente para que la rebatiuda y la integración tengan sentido.

## [1.0.0] - 2026-10-19

### Agregado
- Versión inicial: 4 roles, formato de salida de 3 partes, bancos de preguntas y formato de tabla de ruta.
