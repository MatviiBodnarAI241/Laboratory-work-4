### Автоматизована перевірка норм кодування програмного коду

Лабораторна робота №4. ПП **TicTacAR**: Node.js 20 LTS (BL), PostgreSQL 16 (AL), TypeScript (мова модуля).

Сценарії лежать у `.github/workflows/` (копії тут).

| Сценарій | Що робить | Результат |
|---|---|---|
| [PrintSoftwareVersions.yml](PrintSoftwareVersions.yml) | Версії ПЗ рівня обробки даних (Node.js) та СКБД (PostgreSQL) за UML-діаграмою розгортання | `PrintSoftwareVersionsResult.jpg`, `PrintDBMSVersionsResult.jpg` |
| [DataSchemaCodeConvention.yml](DataSchemaCodeConvention.yml) | sqlfluff (`postgres`): [DataSchema.sql](DataSchema.sql) та [DataSchemaModified.sql](DataSchemaModified.sql) | `DataSchemaCodeConventionResult.jpg`, `DataSchemaModifiedCodeConventionResult.jpg` |
| [ProgramCodeConvention.yml](ProgramCodeConvention.yml) | Biome: [ProgramCode.ts](ProgramCode.ts) та [ProgramCodeModified.ts](ProgramCodeModified.ts) | `ProgramCodeConventionResult.jpg`, `ProgramCodeModifiedCodeConventionResult.jpg` |

Експеримент 1 (вихідні файли) — успішна перевірка, експеримент 2 (`*Modified`) — перевірка з помилками.
