# AGENTS.md

Instrucciones para agentes de IA que trabajen en este repositorio.

## Qué es este repositorio

Una skill para OpenCode v2: `comite-evaluador`. Simula un comité evaluador de tesis de cuatro agentes que interroga, debate y dictamina sobre material de investigación.

La skill vive en `skills/comite-evaluador/`. Este repo es su distribución: README, licencia, instalador y andamiaje de contribución.

## Arquitectura en una línea

```
SKILL.md  ──►  contrato de runtime (se carga en cada paso del modelo)
   │
   ├── references/committee-roles.md          mandatos de los 4 roles
   ├── references/deliberation-loop.md        protocolo de ronda y gate
   ├── references/question-templates.md       bancos de preguntas
   ├── references/output-format.md            artefactos de cierre
   └── references/rosario-martinez-framework.md  marco de auditoría
```

`SKILL.md` es un **contrato de runtime**, no documentación. El modelo lo lee y lo ejecuta. Cambiar una línea ahí cambia el comportamiento del comité.

## Reglas del repositorio

1. **El cuerpo de `SKILL.md` no crece.** Si necesitás más detalle, va a `references/`. Tope: 900 palabras.
2. **Los links de `SKILL.md` son relativos al directorio del `SKILL.md`.** Si movés un reference, actualizá el link.
3. **Toda regla dura es verificable.** Escribí el criterio de éxito, no la intención.
4. **El gate de iteración es un token literal.** `ITERAR: <hueco>` o `CERRAR: <razón>`. Nada de veredictos ambiguos.
5. **El orden de la ronda es fijo**: Defensor, Escéptico, Metodólogo. Cada uno recibe la postura del anterior.
6. **El `id` de la skill lo deriva la ruta**, no el frontmatter. El directorio debe seguir siendo `skills/comite-evaluador/` o el ID cambia y la skill deja de invocarse con `@comite-evaluador`.
7. **El marco de la Dra. Rosario Martínez no se reescribe sin acuerdo** con la autora. Ver `CONTRIBUTING.md`.

## Comandos

```bash
bash scripts/validate-skill.sh    # 23 chequeos: estructura, frontmatter, secciones, links, presupuesto
bash -n install.sh                 # sintaxis del instalador
```

La CI ejecuta el validador en cada push y PR.

## Antes de commitear

```bash
bash scripts/validate-skill.sh && git diff --stat
```

Si agregaste un reference, agregá también su link en la sección `## References` de `SKILL.md`, o el validador falla.

## Commits

Conventional Commits, sin atribución de IA y sin `Co-Authored-By`. Subí `metadata.version` en el mismo commit cuando el cambio sea funcional.

## No romper el contrato con el usuario

La skill se usa en sesiones reales de tesis. Cualquier cambio que altere el **formato de salida** (la ronda, los artefactos de cierre, el texto literal del veredicto) es un cambio mayor: rompe la expectativa de quien ya la usa. Esos cambios requieren `major` en el frontmatter y una nota en el CHANGELOG.
