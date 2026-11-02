# Fintech Kalp — Learner Coursebook (Job-Ready Edition)

Purpose: Practical self-study for finance operations, accounting, Excel and analytics roles. Work through each lab and save evidence in a portfolio. Rules, accounting standards and software screens change; verify jurisdiction-specific requirements using current authoritative sources. This book does not confer professional certification.

## Study method
- 60–90 focused minutes/day, five days/week; read, recreate, solve unaided, explain aloud.
- Portfolio: workbook, query/script, dashboard, process map, control matrix and one-page memo.
- Synthetic data only. Never upload employer, customer, bank or confidential data.
- Aim for 80%+ on checks and explain the business impact and controls.

## Course map
1 Accounting foundations | 2 P2P/O2C/R2R | 3 Excel dictionary & labs | 4 Power Query/VBA | 5 FP&A/modeling | 6 SQL | 7 Power BI/DAX | 8 Python | 9 ERP/SAP FICO | 10 IFRS awareness | 11 Treasury/risk/controls | 12 AI, capstone & job readiness.

# 1. Accounting foundations

### Accounting equation and entries
Assets = Liabilities + Equity. Debits increase assets/expenses; credits increase liabilities/equity/revenue.
Owner invests ₹500,000: Dr Cash 500,000 / Cr Share Capital 500,000.
Equipment purchased for cash ₹80,000: Dr Equipment 80,000 / Cr Cash 80,000.
Credit sale ₹25,000: Dr AR 25,000 / Cr Revenue 25,000. Receipt ₹10,000: Dr Cash / Cr AR. AR remains ₹15,000.

### Accruals and close
Recognise revenue when earned and expenses when incurred, not merely when cash moves. Expense incurred but unbilled: Dr Expense / Cr Accrued Liability. Prepaid insurance used: Dr Expense / Cr Prepayment. Straight-line depreciation = (cost − residual value)/useful life. Cost ₹120,000, residual ₹12,000, life 36 months => ₹3,000/month.
Month-end: cut-off, subledger close, bank/AR/AP reconciliations, accruals/prepayments/depreciation, intercompany, analytics, approved journals, lock period, reporting.
A trial balance can balance while containing omissions, wrong accounts or equal errors.

### Exercise
Trial balance: Cash 50,000 Dr; AR 30,000 Dr; equipment 40,000 Dr; AP 20,000 Cr; capital 70,000 Cr; revenue 45,000 Cr; expenses 25,000 Dr. Confirm totals equal ₹145,000 each. Prepare simplified P&L and balance sheet.

# 2. Finance operations

### Procure-to-pay
Requisition → approval → PO → receipt/GRN → invoice capture → match → coding → approval → payment → supplier reconciliation.
2-way match: PO and invoice. 3-way: PO, receipt and invoice.
Case: PO 100 units × ₹500; receipt 90; invoice 100 × ₹520. Hold for investigation: quantity variance 10 and price variance ₹20/unit. Resolve with corrected documents or policy-approved evidence; do not auto-pay.

### Order-to-cash
Customer/credit setup → order → fulfilment → billing → AR → collection → cash application → dispute resolution. DSO = average AR / credit sales × days. Example AR ₹900,000, monthly credit sales ₹3,000,000, 30 days => DSO 9 days. An average can hide overdue invoices and disputes.

### Record-to-report and reconciliations
R2R covers journals, close calendar, reconciliations, intercompany, consolidation, reporting, controls and audit support. Reconciliation evidence must show source balance, GL balance, reconciling items, aging, owner, next action, evidence and reviewer.
Exception log fields: ID, process, masked reference, exception, amount, risk, root cause, owner, action, due date, status, evidence, reviewer.
Bank statement ₹245,000; outstanding cheques ₹12,000; deposit in transit ₹5,000 => adjusted bank ₹238,000. Compare to GL and investigate; never plug without evidence.

# 3. Excel core + formula dictionary

Build sheets Raw_Data, Mapping, Calculations, Reconciliation, Dashboard, Checks. Convert raw ranges to Tables, name assumptions, use control totals and avoid hardcoded values inside formulas.

| Formula | Typical finance use |
|---|---|
| SUM(range) | total amount |
| SUMIFS(sum_range, criteria_range, criteria, …) | total by entity/month |
| COUNTIFS(range, criteria, …) | overdue/duplicate count |
| IF(test, true, false) | status flag |
| IFERROR(expression, fallback) | missing mapping handling |
| XLOOKUP(key, keys, results, "Not found") | account/vendor mapping |
| INDEX + MATCH | compatible key lookup |
| ROUND(value, 2) | currency precision |
| ABS(value) | absolute variance |
| TODAY() | aging date |
| EOMONTH(date, 0) | period end |
| YEAR(date), MONTH(date) | period attributes |
| TEXT(date, "yyyy-mm") | display period label |
| LEFT/RIGHT/MID | extract code segments |
| TRIM/CLEAN | remove whitespace/nonprintables |
| SUBSTITUTE | normalise IDs |
| LEN | validate key length |
| FILTER / UNIQUE / SORT | dynamic exception lists |
| SUBTOTAL(9, range) | filter-aware sum |
| SUMPRODUCT | conditional weighted calculations |
| PMT(rate,nper,pv) | loan payment |
| NPV(rate, future cash flows)+initial cash flow | investment value |
| IRR(cash flows) | periodic return estimate |

### AP workbook lab
Fields: InvoiceID, Supplier, Entity, InvoiceDate, DueDate, Amount, PaidAmount.
OpenAmount = Amount − PaidAmount.
DaysOverdue = MAX(0, TODAY() − DueDate).
Status = closed if open amount is zero; overdue if today exceeds due date; otherwise open.
Supplier total: SUMIFS over Supplier.
Duplicate candidate: COUNTIFS by Supplier + InvoiceID > 1.
Build an exception view for overdue >30 days and duplicates. Prove Amount = PaidAmount + OpenAmount in totals. Dates stored as text, leading zeros and inconsistent keys are common lookup failures.

# 4. Power Query and VBA

### Power Query recipe
Import monthly files → profile columns → set types → trim/clean → standardise entity/vendor keys → remove only verified duplicates → merge mapping → add period and exception flags → load → refresh → reconcile row counts and totals. Preserve source filename and refresh timestamp. Unmapped rows must remain visible.

### VBA concepts dictionary
Macro = reusable steps; VBA = Excel automation language; Sub = procedure; Range/Cells = references; Workbook/Worksheet = objects; variable = named value; loop = repeat; If = branch; Option Explicit = require declarations; error handler = controlled failure.
Starter macro:
    Option Explicit
    Sub RefreshFinancePack()
        On Error GoTo ErrHandler
        Application.ScreenUpdating = False
        ThisWorkbook.RefreshAll
        Worksheets("Checks").Range("B2").Value = Now
        Application.ScreenUpdating = True
        MsgBox "Refresh complete. Review controls before distribution."
        Exit Sub
    ErrHandler:
        Application.ScreenUpdating = True
        MsgBox "Refresh failed: " & Err.Description
    End Sub
Test on a copy. Do not auto-send reports or overwrite source data. Challenge: refresh queries, check debit=credit, and stop distribution with warning if check fails.

# 5. FP&A and modelling
Absolute variance = Actual − Budget. Variance % = (Actual − Budget)/ABS(Budget); handle zero budget explicitly. Expense ₹1,000,000 budget vs ₹1,080,000 actual => ₹80,000 / 8% unfavorable. Explain volume, rate, mix, timing or one-off.
NWC = current assets − current liabilities (define scope). CCC = DIO + DSO − DPO. DIO = average inventory/COGS × days; DSO = average AR/credit sales × days; DPO = average AP/purchases × days.
Build a 12-month model with revenue, cost, headcount, AR/AP days, cash and base/upside/downside scenarios. Keep assumptions separate from outputs; link statements consistently.

# 6. SQL for finance

Core pattern:
    SELECT entity, account, SUM(amount) AS balance
    FROM journal_lines
    WHERE posting_date >= DATE '2026-10-01'
      AND posting_date < DATE '2026-11-01'
    GROUP BY entity, account
    ORDER BY entity, account;
Half-open intervals include all time on first date and exclude next period. State SQL dialect because date operations vary.
Dictionary: SELECT columns; FROM source; WHERE row filter; GROUP BY grain; HAVING aggregate filter; JOIN match keys; LEFT JOIN retains unmatched left rows; CASE conditional; COALESCE default for NULL; CTE WITH stages; window functions compute across rows; primary key unique; NULL is not zero.

Unmapped accounts:
    SELECT j.account_code, SUM(j.amount) AS amount
    FROM journal_lines j
    LEFT JOIN account_mapping m ON j.account_code = m.account_code
    WHERE m.account_code IS NULL
    GROUP BY j.account_code;
Duplicate invoice candidates: group supplier_id + invoice_number; COUNT rows; HAVING COUNT(*)>1.
Aging bucket: CASE on due date into not due, 1–30, 31–60, 61–90, 90+. Reconciliation challenge: aggregate GL/subledger by entity/account/period, FULL OUTER JOIN, report unmatched keys and differences over tolerance.

# 7. Power BI and DAX
Model star schema: transaction fact tables, Date/Entity/Account/Supplier dimensions, one-to-many relationships, marked Date table, defined grain.
Measures:
    Total Amount = SUM(FactJournal[Amount])
    Actual = CALCULATE([Total Amount], FactJournal[Scenario] = "Actual")
    Budget = CALCULATE([Total Amount], FactJournal[Scenario] = "Budget")
    Variance = [Actual] - [Budget]
    Variance % = DIVIDE([Variance], ABS([Budget]))
    Open AP = SUM(FactAP[OpenAmount])
    Overdue AP = CALCULATE([Open AP], FactAP[DaysOverdue] > 0)
Measures respond to filter context; calculated columns are row-level. Dashboard lab: KPI cards, monthly trend, entity comparison, aging, drill-through, definitions, refresh date and reconciliation total. Check slicers and totals.

# 8. Python for finance
    import pandas as pd
    ap = pd.read_csv("ap_synthetic.csv")
    ap["invoice_date"] = pd.to_datetime(ap["invoice_date"], errors="coerce")
    ap["amount"] = pd.to_numeric(ap["amount"], errors="coerce")
    ap["open_amount"] = ap["amount"] - ap["paid_amount"]
    print({
        "rows": len(ap),
        "missing_ids": int(ap["invoice_id"].isna().sum()),
        "invalid_dates": int(ap["invoice_date"].isna().sum()),
        "total_amount": float(ap["amount"].sum()),
        "open_total": float(ap["open_amount"].sum())
    })
Dictionary: variable, function, list, dict key/value, DataFrame, read_csv, to_datetime, groupby, merge, isna, to_excel, exception, logging, unit test. Lab: normalise account codes, group by entity/account, check debit-credit, export exceptions. Never silently drop rows; assert row counts and totals.

# 9. ERP / SAP FICO awareness
Company code = legal accounting entity; chart of accounts; fiscal year variant; posting period; controlling area; cost/profit center; vendor/customer master; payment terms; tax code; document type. FI covers external accounting (GL/AP/AR/assets/bank); CO supports management accounting (cost centers, orders, profitability). Configuration differs by version and employer.
P2P map: PO → goods receipt/GR-IR → invoice → AP liability → payment → bank clearing. Investigate GR/IR aging, invoice blocks, account assignment and cut-off. Interview: explain supplier invoice flow and evidence for a blocked invoice. Do not represent conceptual study as hands-on configuration.

# 10. IFRS awareness
For every standard record objective, scope, recognition, measurement, presentation/disclosure, judgement, effective date and official reference. Study topics: IAS 2 inventory; IAS 7 cash flow; IAS 16 PPE/depreciation; IAS 21 FX; IAS 36 impairment; IFRS 9 instruments/ECL; IFRS 15 revenue; IFRS 16 leases; IAS 12 taxes; IAS 37 provisions; IAS 10 subsequent events; presentation/going concern. Check current IFRS Foundation materials and local adoption.
Case: shipment before period end, invoice later. Assess contract/control transfer, evidence, cut-off and disclosure; write memo with checked standard paragraphs.

# 11. Treasury, FP&A, risk and controls
Treasury: cash positioning, liquidity forecasts, bank reconciliation, FX exposure, debt covenants, counterparty risk. Forecast = opening cash + receipts − payments = closing cash. Separate committed/uncertain flows and explain forecast error.
13-week cash lab: forecast by week/entity/currency; compare forecast vs actual and explain drivers.
Control matrix:
| Risk | Control | Evidence | Frequency |
|---|---|---|---|
| Duplicate payment | duplicate key check + independent approval | exception report | payment run |
| Unauthorised journal | role segregation + reviewer | workflow | each journal |
| Bank fraud | maker-checker + beneficiary verification | approval trail | payment |
| Period misstatement | cut-off + reconciliation | close pack | monthly |
| Data leakage | least privilege + masking | access review | periodic |
A good control defines population, criteria, owner, frequency, evidence, exception path and reviewer.

# 12. AI, capstone and job readiness

AI may help draft explanations, SQL or test cases using synthetic data. Verify output against source/policy; do not upload confidential records or let AI approve journals/payments. Record human reviewer and evidence where applicable.

### Capstone — AP exceptions to management dashboard
Synthetic case: 1,200 invoices, 30 duplicate candidates, 45 price/quantity mismatches, 20 unmapped accounts, 80 invoices overdue >30 days.
Deliver: data dictionary/lineage; Excel or Power Query cleaning with totals/row checks; exception log with reason/owner/action; SQL aggregation; Power BI dashboard; optional safe VBA/Python refresh; control matrix; one-page memo; README and reproducibility instructions.
Acceptance: reconciled totals, traceable exceptions, no silent deletion, KPI definitions, refresh date, conclusions supported.

### Interview method (STAR + control)
Situation/process scale; task; actions/tools/checks/collaboration; result (quantify only measured); control/evidence. Unreconciled balance response: confirm source and GL populations, period/entity/grain; inspect timing/mapping; quantify; trace samples; log owner/root cause; obtain approval for correction; reperform and retain evidence—never plug.

### Job readiness
Prepare tailored one-page resume, 60-second intro, 3 STAR stories (reconciliation, improvement, stakeholder exception), portfolio workbook/query/dashboard/memo/control matrix, and application tracker. Interview practice: journal entries, P2P/O2C/R2R, Excel lookup/aggregation, SQL joins/grouping, dashboard design, data quality, close controls. Claim skills only supported by evidence.

### Self-check
1. Why can a balanced trial balance still be wrong?
2. Compare 2-way and 3-way match.
3. When use SUMIFS vs XLOOKUP?
4. Why a half-open SQL month filter?
5. Explain DAX filter context.
6. Find unmapped codes in SQL.
7. Prevent distributing an unreconciled report?
8. DSO and limitation?
9. Maker-checker?
10. What evidence is in capstone?

Answer cues: equal debit/credit can coexist with omissions or wrong accounts; PO/invoice vs PO/receipt/invoice; conditional aggregate vs key lookup; include all start-date times and exclude next month; filters context measures; LEFT JOIN + NULL; fail-gate/log/review; AR relative to credit sales but averages hide aging; independent maker/approver; capstone evidence listed above.

## Completion tracker
- [ ] accounting and finance ops cases
- [ ] Excel formula workbook + macro challenge
- [ ] budget model
- [ ] SQL labs + reconciliation
- [ ] Power BI dashboard with totals verified
- [ ] Python validation
- [ ] ERP/IFRS memo with current references
- [ ] treasury forecast + control matrix
- [ ] capstone README + interview stories

Fintech Kalp principle: Rise • Build • Learn • Serve — competence is reproducible work, clear explanation and sound controls.
