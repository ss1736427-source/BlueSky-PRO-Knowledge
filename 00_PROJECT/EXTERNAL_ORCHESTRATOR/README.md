# BlueSky PRO — External Orchestrator

Внешний управляющий цикл для разработки BlueSky PRO.

```text
GitHub main → новый SHA → CI именно этого SHA → PASS → 5 секунд → agent → следующий шаг → новый SHA
```

## Запуск

Требуется Python 3.10+ и `GITHUB_TOKEN` с необходимыми правами GitHub.

PowerShell:

```powershell
$env:GITHUB_TOKEN="YOUR_TOKEN"
$env:BS_REPO="ss1736427-source/BlueSky-PRO-Knowledge"
$env:BS_BRANCH="main"
$env:BS_POLL_SECONDS="5"
$env:BS_AGENT_COMMAND="YOUR_AGENT_COMMAND"
python .\bluesky_orchestrator.py
```

Agent получает `BS_CURRENT_SHA`, `BS_REPO`, `BS_BRANCH`, `BS_PROTOCOL` и `BS_WORKING_RULES`.

Код возврата `42` означает, что требуется решение пользователя; цикл останавливается.

`UNVERIFIED` никогда не считается `PASS`, а старый CI не подтверждает новый SHA.

Этот компонент является внешним управляющим циклом и не принимает архитектурных или продуктовых решений самостоятельно.
