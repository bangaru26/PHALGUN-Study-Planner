# Fintech Kalp — Excel Formula Dictionary (Core Finance Set)

Version 1.0 · 3 November 2026 · Practical quick reference

This focused dictionary covers frequently used formulas in finance operations and analytics. It is deliberately curated rather than an exhaustive catalog. Formula separators and function availability vary by Excel version and regional settings. Use synthetic data in labs and validate outputs before relying on them.

## 1. Conditional totals and counts

| Function | Syntax | Finance use | Example |
|---|---|---|---|
| SUM | `=SUM(B2:B100)` | Total invoice amount | Sum invoice values |
| SUMIF | `=SUMIF(A:A,"Hyderabad",B:B)` | Sum by one condition | Total by entity |
| SUMIFS | `=SUMIFS(C:C,A:A,"India",B:B,"Open")` | Sum by multiple criteria | Open India invoices |
| COUNT | `=COUNT(C2:C100)` | Count numeric values | Count populated amounts |
| COUNTA | `=COUNTA(A2:A100)` | Count nonblank entries | Count invoice IDs |
| COUNTIF | `=COUNTIF(D:D,"Overdue")` | Count matching records | Overdue invoices |
| COUNTIFS | `=COUNTIFS(A:A,"Supplier X",D:D,"Overdue")` | Multi-condition count | Supplier overdue items |

## 2. Lookups and matching

| Function | Syntax | Finance use |
|---|---|---|
| XLOOKUP | `=XLOOKUP(A2,Master!A:A,Master!B:B,"Not found")` | Retrieve supplier name / payment terms |
| VLOOKUP | `=VLOOKUP(A2,Master!A:D,3,FALSE)` | Legacy exact-match lookup |
| INDEX + MATCH | `=INDEX(B:B,MATCH(A2,A:A,0))` | Flexible exact-match lookup |
| XMATCH | `=XMATCH(A2,A:A,0)` | Find matching row position |

**Control tip:** Match on stable keys, handle not-found cases explicitly, and check duplicate master keys before lookup.

## 3. Date, ageing and period logic

| Function | Syntax | Finance use |
|---|---|---|
| TODAY | `=TODAY()` | Current date for ageing |
| EOMONTH | `=EOMONTH(A2,0)` | Month-end date |
| YEAR | `=YEAR(A2)` | Reporting year |
| MONTH | `=MONTH(A2)` | Reporting month |
| NETWORKDAYS | `=NETWORKDAYS(A2,B2)` | Business days between dates |
| DAYS | `=DAYS(B2,A2)` | Elapsed days |
| DATEDIF | `=DATEDIF(A2,B2,"d")` | Date interval (hidden legacy function) |

Invoice ageing days: `=MAX(0,TODAY()-DueDate)`

Age bucket (assuming days overdue in E2):
`=IFS(E2<=0,"Current",E2<=30,"1–30",E2<=60,"31–60",E2<=90,"61–90",TRUE,"90+")`

## 4. Error handling and data quality

| Function | Syntax | Finance use |
|---|---|---|
| IF | `=IF(B2>C2,"Review","OK")` | Flag condition |
| IFERROR | `=IFERROR(A2/B2,0)` | Handle formula error |
| ISBLANK | `=ISBLANK(A2)` | Missing-field check |
| ISNUMBER | `=ISNUMBER(A2)` | Validate numeric data |
| TRIM | `=TRIM(A2)` | Remove excess spaces |
| CLEAN | `=CLEAN(A2)` | Remove non-printing characters |
| EXACT | `=EXACT(A2,B2)` | Case-sensitive compare |
| AND / OR | `=AND(A2<>"",B2>0)` | Combined rule checks |

**Caution:** Do not hide every error with zero. Distinguish true zero from missing, invalid or failed data.

## 5. Dynamic arrays and modern analysis

| Function | Syntax | Finance use |
|---|---|---|
| FILTER | `=FILTER(A2:D100,D2:D100="Overdue","No items")` | List overdue items |
| UNIQUE | `=UNIQUE(A2:A100)` | Unique supplier list |
| SORT | `=SORT(A2:D100,3,-1)` | Sort by amount descending |
| SORTBY | `=SORTBY(A2:D100,D2:D100,-1)` | Sort using another range |
| LET | `=LET(x,B2-C2,x)` | Name intermediate calculation |
| TEXTJOIN | `=TEXTJOIN(", ",TRUE,A2:A5)` | Combine exception notes |

## 6. Finance formulas

- Variance: `=Actual-Budget`
- Variance %: `=IFERROR((Actual-Budget)/Budget,0)`
- Gross margin %: `=IFERROR((Revenue-COGS)/Revenue,0)`
- Current ratio: `=CurrentAssets/CurrentLiabilities`
- DSO (simplified): `=AverageAR/NetCreditSales*DaysInPeriod`
- DPO (simplified): `=AverageAP/EligiblePurchases*DaysInPeriod`
- Duplicate candidate: `=COUNTIFS(SupplierID,A2,InvoiceNumber,B2,Amount,C2)>1`

These are analytical aids, not accounting policy. Confirm definitions, period alignment, denominators, sign conventions and source reconciliation.

## 7. Macros / VBA — controlled use

A macro is an automation script, often written in VBA, that executes repeatable workbook steps. Common finance uses: refresh-and-format reports, create standardized month-end packs, and validate workbook inputs.

**Safety checklist**
1. Keep the source workbook unchanged; work on a copy.
2. Review macro code before enabling it.
3. Use trusted, signed macros where organizational policy requires.
4. Never store passwords or secrets in VBA.
5. Add clear error handling, logging and an owner.
6. Reconcile output totals against source data.
7. Respect employer security policy; macros may be blocked.

Example of a simple, non-destructive VBA routine:
```vb
Option Explicit

Sub RefreshAllQueries()
    ThisWorkbook.RefreshAll
    MsgBox "Refresh requested. Reconcile outputs before publishing.", vbInformation
End Sub
```

## Practice prompts

1. Sum invoices for one supplier that are currently open.
2. Return payment terms from a supplier master using XLOOKUP.
3. Create ageing buckets and total exposure by bucket.
4. Flag duplicate supplier + invoice number + amount combinations.
5. Calculate budget variance and variance percentage with zero-budget handling.
6. Describe three controls required before distributing a macro-generated report.
