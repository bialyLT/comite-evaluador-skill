---
name: Bug report
description: El comité se comporta de forma inesperada o produce una salida incorrecta
title: "[Bug] "
labels: ["bug"]
body:
  - type: markdown
    attributes:
      value: |
        Gracias por reportar. Los issues bien documentados son especificaciones valiosas.

  - type: input
    id: invocation
    attributes:
      label: Qué invocaste
      description: El mensaje exacto que le diste al comité.
      placeholder: "necesito que el comité evalúe la justificación que escribí"
    validations:
      required: true

  - type: input
    id: expected
    attributes:
      label: Qué esperabas
      description: Qué debería haber hecho el comité.
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Qué obtuviste
      description: Literalmente. Incluí el bloque de la ronda donde se rompe.
      render: markdown
    validations:
      required: true

  - type: textarea
    id: round
    attributes:
      label: Evidencia de la ronda
      description: Las preguntas del Jurado, las tres posturas y la línea ITERAR/CERRAR.
      render: text
    validations:
      required: false

  - type: input
    id: environment
    attributes:
      label: Entorno
      description: "OpenCode: <versión> | Modelo: <modelo> | OS: <sistema>"
      placeholder: "OpenCode: v2 | Modelo: claude-sonnet-4-6 | OS: linux"
    validations:
      required: true

  - type: dropdown
    id: mode
    attributes:
      label: Modo en uso
      options:
        - Modo consulta (pregunta abierta)
        - Modo auditoría (sección de tesis)
        - Modo cambio metodológico
        - Modo líneas de investigación desde corpus
        - Modo dictamen estático
        - No estoy seguro
    validations:
      required: true

  - type: checkboxes
    id: checks
    attributes:
      label: Verificaciones
      options:
        - label: Corrí `bash scripts/validate-skill.sh` y pasa
          required: false
        - label: Busqué si el issue ya existe
          required: false
