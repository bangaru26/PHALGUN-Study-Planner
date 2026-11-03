# Fintech Kalp — Practical Lab Pack 01
## Synthetic AP exception analysis (Excel → SQL → Power BI → Python)

**Dataset:** `fintech-kalp_flutter/assets/fintech_kalp_ap_lab.csv`  
**Report date for this lab:** 3 November 2026  
**Currency:** INR. All records are fictional. Use only this file for practice.

## Outcomes
Learner can import a CSV, build an AP ageing and exception log, identify duplicate candidates without assuming fraud, investigate PO/receipt mismatches, aggregate using SQL, specify a dashboard, and validate totals with Python.

## Lab A — Excel AP ageing
1. Import CSV; preserve a raw tab and turn data into an Excel Table named `AP`.
2. Add `OpenAmount`: `=[@invoice_amount]-[@paid_amount]`.
3. Add `DaysOverdue`: `=IF(AND([@OpenAmount]>0,DATE(2026,11,3)>[@due_date]),DATE(2026,11,3)-[@due_date],0)` (ensure dates are typed as dates).
4. Add ageing bucket: Not due, 1–30, 31–60, 61–90, 90+ using report date and due date.
5. Duplicate candidate: count same supplier_id + invoice_id; review invoice number with supplier, amount and PO. Candidate is not conclusion.
6. Reconcile: total invoice amount, paid amount and open amount; prove invoice total = paid + open. Create Checks tab with PASS/FAIL.

**Questions:** Which open items are overdue? Which supplier has the largest open amount? Which invoices need receipt/price investigation? What data caveat affects any ageing summary?

## Lab B — Exception log & control
Create fields: exception_id, invoice_id, exception_type, amount_at_risk, risk, evidence_required, owner, next_action, due_date, status, reviewer.
- Price mismatch: compare invoice_unit_price with po_unit_price.
- Quantity mismatch: compare invoice_qty with receipt_qty.
- Duplicate candidate: identify repeated invoice key and independently compare documents.
- Aging: use the defined report date and open balance.
Do not automatically block or release solely based on a heuristic. Document tolerance and approval policy as assumptions.

## Lab C — SQL
Assume a table named `ap_lab`. Compute open balance by supplier:
```sql
SELECT supplier_id, supplier_name,
       SUM(invoice_amount - paid_amount) AS open_amount
FROM ap_lab
GROUP BY supplier_id, supplier_name
HAVING SUM(invoice_amount - paid_amount) > 0
ORDER BY open_amount DESC;
```
Price/quantity exception candidates:
```sql
SELECT invoice_id, supplier_id, invoice_amount,
       receipt_qty, invoice_qty, po_unit_price, invoice_unit_price
FROM ap_lab
WHERE receipt_qty <> invoice_qty
   OR po_unit_price <> invoice_unit_price;
```
Duplicate candidates (investigate; not proof):
```sql
SELECT supplier_id, invoice_id, COUNT(*) AS row_count
FROM ap_lab
GROUP BY supplier_id, invoice_id
HAVING COUNT(*) > 1;
```
Use SQL dialect-specific date functions for ageing; document dialect and date boundary.

## Lab D — Dashboard specification
Build pages or visuals for:
- KPI: open AP, overdue open AP, invoice count, exception count (define each).
- Ageing by bucket, supplier open balance, blocked items by reason, monthly invoice trend.
- Detail table: invoice, supplier, entity, due date, open amount, age, reason, owner.
- Slicers: entity, supplier, status, report period.
- Footer: report date, refresh timestamp, source row count, reconciliation PASS/FAIL.
**Acceptance:** dashboard totals reconcile to the workbook source; every KPI has a numerator/denominator or aggregation definition; drillthrough identifies underlying invoices.

## Lab E — Python validation
```python
import pandas as pd

df = pd.read_csv("fintech_kalp_ap_lab.csv")
for col in ["invoice_amount", "paid_amount", "receipt_qty", "invoice_qty",
            "po_unit_price", "invoice_unit_price"]:
    df[col] = pd.to_numeric(df[col], errors="raise")

df["open_amount"] = df["invoice_amount"] - df["paid_amount"]
assert (df["open_amount"] >= 0).all(), "Review overpayments/credits"
assert (df["invoice_amount"] == df["paid_amount"] + df["open_amount"]).all()
print("rows:", len(df))
print("invoice total:", df["invoice_amount"].sum())
print("paid total:", df["paid_amount"].sum())
print("open total:", df["open_amount"].sum())
print("price candidates:", (df["po_unit_price"] != df["invoice_unit_price"]).sum())
print("quantity candidates:", (df["receipt_qty"] != df["invoice_qty"]).sum())
```
If an assertion fails, investigate the data and accounting convention; do not silently drop or overwrite rows.

## Submission checklist
- [ ] Workbook with raw, calculations, ageing, exception log, checks, and dashboard.
- [ ] SQL queries and result screenshots/export (synthetic data only).
- [ ] Dashboard with defined KPIs and reconciled totals.
- [ ] Python validation script and output.
- [ ] One-page memo: findings, materiality, root cause hypotheses, owners/actions, controls and caveats.
- [ ] README: dataset version, report date, tools, steps to reproduce.

## Answer principles
Distinguish a candidate from a confirmed exception; never treat a KPI as a control by itself; preserve source lineage; document assumptions; require independent review for financial actions.
