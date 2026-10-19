---
name: Feature request
description: Sugerir un modo nuevo, un banco de preguntas, un artefacto de salida o una mejora de ergonomía
title: "[Feature] "
labels: ["enhancement"]
body:
  - type: markdown
    attributes:
      value: |
        Un buen feature request describe el comportamiento esperado, no la implementación.

  - type: textarea
    id: problem
    attributes:
      label: Qué problema resuelve
      description: Qué caso de uso real falla hoy o no se puede cubrir.
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Comportamiento esperado
      description: Si esto se implementara, ¿qué haría el comité que hoy no hace?
    validations:
      required: true

  - type: dropdown
    id: area
    attributes:
      label: Dónde caería el cambio
      options:
        - "SKILL.md (reglas duras, gates, output contract)"
        - "references/committee-roles.md (mandatos de los roles)"
        - "references/deliberation-loop.md (protocolo de ronda)"
        - "references/question-templates.md (bancos de preguntas)"
        - "references/output-format.md (artefactos de cierre)"
        - "Instalador o documentación"
        - No estoy seguro
    validations:
      required: true

  - type: textarea
    id: impact
    attributes:
      label: Impacto en el output del usuario
      description: ¿Cambia el formato de salida, el gate de iteración o el protocolo? Eso obliga a un `major`.
    validations:
      required: false

  - type: checkboxes
    id: checks
    attributes:
      label: Verificaciones
      options:
        - label: Leí CONTRIBUTING.md
          required: false
        - label: El cambio no modifica el marco de la Dra. Rosario Martínez sin acuerdo
          required: false
