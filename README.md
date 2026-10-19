# comite-evaluador

Skill para [OpenCode](https://opencode.ai) que simula un **Comité Evaluador de Tesis** de cuatro agentes con personalidades, objetivos y criterios distintos. El comité interroga, debate y dictamina sobre cualquier material de investigación: una sección de tesis, un cambio metodológico propuesto, o una idea de investigación contrastada contra un corpus de antecedentes.

## Qué hace

El comité no emite un informe de una sola pasada. Corre un **ciclo deliberativo** donde el Jurado interroga y los tres roles responden, y la ronda se repite hasta que el Metodólogo declara que el intercambio llegó a una posición defendible.

| Actor | Postura | Rol dentro del framework metodológico |
|---|---|---|
| ⚖️ **Jurado** | Evaluador de defensa | Formula las preguntas de cada ronda. No tiene postura propia. |
| 🛡️ **Defensor** | Mentor optimista | Defiende el aporte, el vacío que se llena y por qué vale la pena. |
| 🔍 **Escéptico** | Revisor implacable | Ataca supuestos débiles, trampas técnicas y comparaciones injustas. |
| 📐 **Metodólogo** | Arquitecto del sistema | Verifica que las piezas encajen y emite el veredicto `ITERAR:` o `CERRAR:`. |

### El bucle de deliberación

```
Usuario: "evaluen la justificación que escribí"
        │
        ▼
  ⚖️ JURADO  ── formula las preguntas de la ronda
        │
        ├─▶ 🛡️ DEFENSOR    (responde)
        ├─▶ 🔍 ESCÉPTICO   (rebate al Defensor)
        └─▶ 📐 METODÓLOGO  (integra ambos + veredicto)
                │
                ├── ITERAR: <hueco>  ──▶ el Jurado pregunta sobre ese hueco
                │                          y los tres roles reinician
                │
                └── CERRAR: <razón>    ──▶ se entrega el artefacto final
```

Los tres roles corren **secuencialmente**: el Escéptico necesita la postura del Defensor para rebatirla, y el Metodólogo necesita ambas para integrar. En la iteración los roles reinician desde su propia postura: el Jurado conserva su hilo de preguntas, los roles no heredan la concesión de la ronda anterior.

## Modos de uso

| Tu pedido | Qué hace el comité | Artefacto final |
|---|---|---|
| *"necesito que el comité evalúe la justificación que escribí"* | Modo auditoría: aplica la ley del rompecabezas a esa sección | Matriz de cumplimiento |
| *"necesito que el comité evalúe este cambio para la metodología"* | Modo auditoría del cambio contra las reglas que toca | Matriz de cumplimiento |
| *"tengo estos antecedentes y mi idea es esta, propongan posibles investigaciones"* | Lectura del corpus por subagentes, evaluación de la idea, propuesta de líneas | Tabla de líneas de investigación |
| *"¿qué tan viable es implementar tal cosa?"* | Evaluación de factibilidad | Tabla de respuestas |
| *"necesito un dictamen/informe"* | Informe estático de 3 partes sin rondas en vivo | Informe + tabla |

## El marco metodológico

Cuando el material es una tesis bajo evaluación formal, el comité evalúa bajo el **Sistema de la Dra. Rosario Martínez** ("la ley del rompecabezas"):

> *Una tesis es un rompecabezas donde cada pieza debe encajar de forma exacta con la anterior; si una pieza no encaja, todo el estudio se cae.*

Cubre las tres reglas generales (prohibición de tesis Frankenstein, simetría léxica estricta, correspondencia 1 a 1 en el cierre) y los criterios de auditoría de las cuatro partes del planteo: diagnóstico AQP/CCA, coherencia de diseño y matrices, marco teórico y operacionalización, y cierre de resultados/discusión/conclusiones/recomendaciones.

> **Créditos:** el marco de evaluación "Ley del Rompecabezas" y el método AQP/CCA son obra de la Dra. Rosario Martínez y se usan aquí con reconocimiento explícito. Esta distribución no implica ningún tipo de acuerdo ni colaboración con la autora.

## Requisitos

- [OpenCode](https://opencode.ai) v2 (o cualquier runtime con soporte de skills compatible con el formato `SKILL.md`).
- Un modelo con capacidad de delegación a subagentes (la skill usa el mecanismo de subagentes del runtime).

## Instalación

### Opción A — Configuración por `skills` (recomendada)

Cloná el repo y apuntá la configuración global de OpenCode al directorio `skills/`:

```bash
git clone https://github.com/bialyLT/comite-evaluador-skill.git \
  ~/.local/share/comite-evaluador-skill
```

Agregá esta entrada en `~/.config/opencode/opencode.jsonc`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "skills": [
    "~/.local/share/comite-evaluador-skill/skills"
  ]
}
```

Con esta variante las actualizaciones son un `git pull` y no se copia nada dentro de la carpeta de configuración.

### Opción B — Copia directa (sin tocar la configuración)

```bash
git clone https://github.com/bialyLT/comite-evaluador-skill.git /tmp/comite-evaluador
cp -r /tmp/comite-evaluador/skills/comite-evaluador ~/.config/opencode/skills/
rm -rf /tmp/comite-evaluador
```

OpenCode descubre automáticamente las skills en `~/.config/opencode/skills/`.

### Opción C — Instalador

```bash
git clone https://github.com/bialyLT/comite-evaluador-skill.git /tmp/comite-evaluador
bash /tmp/comite-evaluador/install.sh
rm -rf /tmp/comite-evaluador
```

El instalador clona el repo, agrega la entrada `skills` a `~/.config/opencode/opencode.jsonc` si no existe, y verifica que la skill quede registrada. Al finalizar imprime la atribución del marco metodológico.

### Instalación por proyecto

Si preferís que la skill viva solo en un repositorio, copiala a `.opencode/skills/comite-evaluador/` dentro del proyecto. OpenCode busca `.opencode/skills` desde el directorio actual hasta la raíz del proyecto.

## Verificación

```bash
opencode run "listá las skills disponibles"
```

O directamente:

```bash
opencode run "activá el comité evaluador y decime qué modos soporta"
```

## Cómo se invoca

No hace falta ningún comando especial. La skill se activa por trigger en el `description` (`comite`, `comité evaluador`, `tesis`, `proyecto de investigación`) o de forma explícita:

```
@comite-evaluador
```

Ejemplos que funcionan tal cual:

- `necesito que el comité evalúe la justificación que escribí`
- `necesito que el comité evalúe este cambio para la metodología que quiero implementar: <cambio>`
- `tengo todos estos antecedentes en este proyecto y mi idea es la siguiente: <idea>. ¿Pueden evaluar esta idea según los antecedentes y proponer posibles investigaciones?`

## Estructura

```
comite-evaluador-skill/
├── README.md
├── AGENTS.md                 ← guía para agentes de IA que trabajen en el repo
├── CONTRIBUTING.md           ← cómo contribuir
├── CODE_OF_CONDUCT.md
├── CHANGELOG.md
├── LICENSE
├── install.sh
├── scripts/
│   └── validate-skill.sh     ← 23 chequeos de contrato (lo corre la CI)
└── skills/
    └── comite-evaluador/
        ├── SKILL.md
        └── references/
            ├── committee-roles.md
            ├── deliberation-loop.md
            ├── question-templates.md
            ├── output-format.md
            └── rosario-martinez-framework.md
```

`SKILL.md` es el contrato de runtime. Los `references/` contienen el detalle largo: mandatos de cada rol, protocolo del ciclo, bancos de preguntas por rol y tipo de solicitud, el marco metodológico completo y los formatos de salida.

## Contribuir

Leé [CONTRIBUTING.md](CONTRIBUTING.md) y [AGENTS.md](AGENTS.md). El flujo básico:

```bash
git clone https://github.com/bialyLT/comite-evaluador-skill.git
cd comite-evaluador-skill
bash scripts/validate-skill.sh      # debe dar 23/23
```

La CI valida el contrato de la skill en cada push y PR: estructura, frontmatter, secciones obligatorias, resolución de links y presupuesto del cuerpo.

Si vas a tocar `references/rosario-martinez-framework.md`, necesitás el acuerdo explícito de la Dra. Rosario Martínez.

## Licencia

MIT. Ver [LICENSE](LICENSE).
