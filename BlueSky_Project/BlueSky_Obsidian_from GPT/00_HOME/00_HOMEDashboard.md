# Flight Planner � Certification Dashboard

## ����������

```dataview
TABLE
    type AS "���",
    status AS "������",
    criticality AS "�����������"
FROM ""
WHERE contains(type, "requirement")
SORT id ASC
```

## ���������� ��� �����������

```dataview
TABLE
    id,
    status,
    verification_method
FROM ""
WHERE contains(type, "requirement")
AND verification_method = null
```

## �������� ��������

```dataview
TABLE
    id,
    severity,
    status
FROM "11_ANOMALIES"
WHERE type = "anomaly"
AND status != "closed"
SORT severity DESC
```

## �����

```dataview
TABLE
    id,
    status
FROM "09_VERIFICATION/Test_Cases"
WHERE type = "test_case"
SORT id ASC
```


