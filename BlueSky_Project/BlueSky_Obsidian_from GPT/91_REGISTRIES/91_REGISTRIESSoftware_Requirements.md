# ������ ���������� ��

```dataview
TABLE
    id AS "ID",
    status AS "������",
    criticality AS "�����������",
    parent AS "��������",
    verification_method AS "Verification",
    baseline AS "Baseline"
FROM "04_SOFTWARE/SW_Requirements"
WHERE type = "software_requirement"
SORT id ASC
```


