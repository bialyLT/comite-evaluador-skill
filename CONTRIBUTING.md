# Cómo contribuir

Gracias por querer mejorar el comité. Esta skill es un **contrato de runtime** para un modelo, no documentación para humanos, así que las contribuciones se evalúan por su efecto en el comportamiento del agente.

## Antes de abrir un issue o PR

1. Corré el validador: `bash scripts/validate-skill.sh`. Los 23 chequeos deben pasar.
2. Leé `AGENTS.md` para entender la arquitectura y las reglas de estilo.
3. Buscá si el problema ya está reportado.

## Reportar un problema

Abrí un issue de tipo **Bug report** e incluí:

- Qué invocaste exactamente y qué esperabas.
- Qué obtuviste, literalmente.
- La salida de la ronda donde se rompe (el bloque `ITERAR:` / `CERRAR:` y las posturas).
- Tu versión de OpenCode y el modelo que usaste.

Los issues que describen el comportamiento esperado son tan valiosos como los que reportan un fallo: son especificaciones.

## Modificar la skill

### Dónde vive cada cosa

| Archivo | Contiene | Guideline |
|---|---|---|
| `skills/comite-evaluador/SKILL.md` | Contrato de runtime: trigger, reglas duras, decision gates, pasos, output contract | **<= 900 palabras.** Es lo único que se carga en cada paso del modelo. |
| `references/committee-roles.md` | Mandatos de cada rol, deber del veredicto, mandato del lector | Roles, no procedures. |
| `references/deliberation-loop.md` | Protocolo de ronda, gate de iteración, dispatch, modos | Cambiarlo cambia cómo corre el comité. |
| `references/question-templates.md` | Bancos de preguntas por rol y tipo de solicitud | La parte más fácil de extender. |
| `references/output-format.md` | Formato de ronda y los tres artefactos de cierre | Contrato de salida. |
| `references/rosario-martinez-framework.md` | Marco metodológico completo | **No se modifica sin acuerdo con la Dra. Rosario Martínez.** Ver abajo. |

### Reglas de estilo (obligatorias)

1. `description` en una sola línea física, entrecomillada, con los triggers primero, <= 250 caracteres.
2. Frontmatter completo: `name`, `description`, `license`, `metadata.author`, `metadata.version`.
3. Secciones en este orden: Activation Contract, Hard Rules, Decision Gates, Execution Steps, Output Contract, References.
4. Las reglas duras son **verificables u observables**. "Sé riguroso" no es una regla; "nunca termines sin la tabla final" sí.
5. Todo contenido largo va a `references/`, nunca al cuerpo de `SKILL.md`.
6. Los links dentro de `SKILL.md` son relativos al directorio que contiene el `SKILL.md`.

### Reglas de contenido

- Las afirmaciones deben citar evidencia concreta: sección, página, línea o frase textual.
- El gate de iteración es un token literal: `ITERAR: <hueco>` o `CERRAR: <razón>`. Un veredicto ambiguo cuenta como `ITERAR`.
- Nunca agregues lógica que requiera un modelo específico, un provider o un modo de pago.
- Mantené el orden fijo de la ronda: Defensor, luego Escéptico, luego Metodólogo.

### Sobre el marco metodológico

El archivo `references/rosario-martinez-framework.md` reproduce el **Sistema de la Dra. Rosario Martínez** ("Ley del Rompecabezas" y método AQP/CCA), que es obra intelectual de la autora.

- Podés **corregir, ampliar o agregar** criterios con autorización explícita de la autora, citando la fuente en el PR.
- **No** reescribas las definiciones metodológicas sin ese acuerdo.
- No cambies la atribución del README ni del LICENSE.

## Pull requests

1. Rama desde `main`: `git checkout -b feat/mi-cambio`.
2. Editá lo que corresponda y corré `bash scripts/validate-skill.sh`.
3. Commit messages en formato Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
4. Sin atribución de IA en el commit. Sin `Co-Authored-By`.
5. Abrí el PR usando la plantilla y completá la lista de verificación.

La CI corre el validador automáticamente. Un PR con la CI en rojo no se revisa.

## Versionado

El `metadata.version` del frontmatter sigue semver. Subí la versión en el mismo commit que el cambio:

- `patch`: corrección de redacción o typos.
- `minor`: nuevo modo, nuevo banco de preguntas, nueva sección de referencia.
- `major`: cambio en el protocolo del ciclo o en el contrato de salida.

## Licencia

MIT. Al contribuir aceptás que tu trabajo se publique bajo esa licencia.
