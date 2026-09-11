# BlueSky PRO — External Orchestrator

Внешний управляющий цикл для разработки BlueSky PRO.

```text
GitHub main → новый SHA → CI именно этого SHA → PASS → 5 секунд → agent → следующий шаг → новый SHA
```

## Запуск на Windows

Требуется Python 3.10+ и `GITHUB_TOKEN` с необходимыми правами GitHub.

Сначала укажи исполняемый файл локального агента и его аргументы:

```powershell
$env:GITHUB_TOKEN="YOUR_TOKEN"
$env:BS_REPO="ss1736427-source/BlueSky-PRO-Knowledge"
$env:BS_BRANCH="main"
$env:BS_POLL_SECONDS="5"
$env:BS_AGENT_EXECUTABLE="codex.exe"
$env:BS_AGENT_ARGUMENTS="exec --full-auto"
python .\bluesky_orchestrator.py
```

Для PowerShell-обвязки:

```powershell
.\run_orchestrator.ps1
```

Адаптер `agent_adapter.ps1` передаёт агенту точный проверенный SHA и пути к:
- `00_PROJECT/GITHUB_DEVELOPMENT_PROTOCOL.md`
- `00_PROJECT/BLUE_SKY_PRO_WORKING_RULES.md`

Agent должен вернуть:
- `0` — техническая работа завершена, можно продолжать;
- `42` — требуется решение пользователя, цикл останавливается;
- другой ненулевой код — ошибка агента.

`UNVERIFIED` никогда не считается `PASS`, а старый CI не подтверждает новый SHA.

Этот компонент является внешним управляющим циклом и не принимает архитектурных или продуктовых решений самостоятельно.
