# GFPA Master Syllabus & Learning Specification
**Version:** 1.0 design baseline · **Last reviewed:** 29 October 2026  
**Purpose:** An original, modular curriculum and delivery specification for GFPA and its focused Fintech Kalp pathway.

## 1. Product boundaries
- **GFPA — Global Finance Professional Academy:** the full 13-domain academy.
- **Fintech Kalp:** a focused finance + technology pathway selected from GFPA; it is not a replacement for the whole academy.
- **PHALGUN:** learning navigation, study plans, assessments, progress, revision and portfolio continuity.
- **AAROH:** lean orchestration and integration; it should reference curriculum services rather than duplicate lesson content.

## 2. Learning architecture
Use stable IDs: `GFPA-01` for a domain, `GFPA-01-C01` for a chapter, `GFPA-01-C01-L01` for a lesson, `GFPA-CAP-01` for a capstone. Keep content, learner attempts, assessment keys and source metadata separate. Each lesson record should include: title; ID; version; status (outline/draft/reviewed/published/needs-review/retired); prerequisites; objectives; estimated time; jurisdiction; applicable-as-of date where relevant; original teaching text; worked examples; practical files or datasets; assessment schema; rubric; references; revision history; accessibility and offline assets.

### Required chapter package
1. **Orientation:** why the topic matters, prerequisites, outcomes and key vocabulary.
2. **Teach:** original explanations from first principles through practitioner level; diagrams described in text; formulas with symbol definitions and assumptions.
3. **Worked example:** realistic fictional data, calculations shown line by line, interpretation and common mistakes.
4. **Practice:** a guided walkthrough, then an independent task with acceptance criteria.
5. **Cross-functional lens:** impacts on Finance Ops, Procurement, Treasury, GL/R2R, AR/O2C, FP&A, IT/Data, Risk/Audit and management where relevant.
6. **Quality & controls:** accuracy, evidence, approvals, privacy, segregation of duties and exception handling.
7. **Knowledge check:** MCQs, short answers and applied questions. Do not reveal keys or explanations until submission; then show rationale for every option.
8. **Recall:** flashcards, revision gist, formula sheet and spaced-review suggestions.
9. **Transfer:** assignment and topic-block mini-capstone with deliverables and rubric.
10. **Resources:** primary official sources first, then original or permissively licensed supporting resources; record author/publisher, title, URL, access date and license where applicable.
11. **Navigation:** previous, next, related lessons and domain home.
12. **Export:** printable lesson, downloadable PDF/HTML where technically supported, learner worksheet, answer record and capstone portfolio package.

## 3. The 13 GFPA domains and syllabus map

### GFPA-01 — Accounting & Finance Core
**Scope:** accounting principles; financial statements and linkages; accruals, prepayments and provisions; chart of accounts; journal entries; AP/AR; procure-to-pay (P2P) and order-to-cash (O2C); record-to-report (R2R); month-end close; reconciliations; working capital; cash conversion cycle; cost behaviour; budgeting basics; internal controls; management reporting; finance business partnering.  
**Practical evidence:** post and explain journals; reconcile a control account; analyse an ageing schedule; build a close checklist; explain how a transaction flows from source evidence to statements.  
**Mini-capstone:** diagnose late supplier payments and rising month-end exceptions.

### GFPA-02 — Global Finance Operations
**Scope:** shared services and GCC models; service catalogues; process ownership; SLAs/OLAs; KPI definitions; workload/capacity; queue and exception management; escalation; stakeholder communication; standard operating procedures; quality sampling; governance; transition and knowledge transfer; continuous improvement.  
**Practical evidence:** define a KPI dictionary, SLA tree, RACI and operating review.  
**Mini-capstone:** redesign an AP service queue while protecting payment controls.

### GFPA-03 — FP&A & Finance Business Partnering
**Scope:** annual budgets; rolling forecasts; driver-based planning; flexible budgets; variance analysis; price/volume/mix; scenario and sensitivity analysis; unit economics; contribution margin; cash forecasting; forecast accuracy and bias; management packs; storytelling; business cases; benefits tracking.  
**Practical evidence:** build base/upside/downside scenarios and explain drivers to a non-finance stakeholder.  
**Mini-capstone:** create a 13-week cash forecast and management commentary.

### GFPA-04 — AI-Enabled Finance
**Scope:** AI and generative AI fundamentals; model limitations; prompt design; grounded workflows; summarisation and classification; assisted variance analysis; invoice exception triage; evaluation; hallucination risks; sensitive-data handling; human-in-the-loop approvals; logging; model monitoring; governance and acceptable use.  
**Practical evidence:** create a controlled AI-assisted workflow with test cases, reviewer checkpoints and fallback paths.  
**Mini-capstone:** evaluate an invoice-triage assistant without allowing autonomous payment approval.

### GFPA-05 — Data & Analytics
**Scope:** spreadsheet foundations; advanced Excel formulas; structured tables; pivots; lookup and conditional aggregation; data cleaning; Power Query/ETL; data modelling; dimensional models and star schemas; Power BI; DAX; visual design; SQL querying, joins, grouping and window functions; Python foundations for data analysis; validation; lineage; quality dimensions; privacy; dashboard storytelling.  
**Practical evidence:** document a reproducible transformation, SQL checks and dashboard metric definitions.  
**Mini-capstone:** build a finance KPI dashboard from fictional AP, AR and GL data.

### GFPA-06 — Automation & Intelligent Operations
**Scope:** process discovery; automation suitability; rules versus AI; RPA; workflow orchestration; OCR/IDP; document validation; APIs; exception queues; retries and idempotency; monitoring; access control; audit logs; business continuity; testing; ROI and total cost of ownership; human escalation.  
**Practical evidence:** map a process, calculate expected benefit, identify failure modes and define controls.  
**Mini-capstone:** propose controlled automation for invoice intake and exception handling.

### GFPA-07 — Agile & Scrum Master Professional Journey
**Scope:** Agile values and principles; Scrum framework; accountabilities and events; product goal; backlog refinement; user stories; acceptance criteria; estimation; sprint planning and review; retrospectives; Kanban; WIP limits; flow; Lean; root-cause analysis; metrics; Jira/Confluence concepts; stakeholder facilitation; impediment removal; scaling and change leadership.  
**Practical evidence:** create an ordered backlog, sprint goal, definition of done and improvement experiment.  
**Mini-capstone:** deliver a small finance-operations improvement using iterative feedback.

### GFPA-08 — Finance Transformation
**Scope:** current/future-state mapping; value-stream analysis; waste and bottlenecks; Lean and Six Sigma basics; DMAIC; root-cause tools; control plans; change impact; stakeholder mapping; operating models; process ownership; product/technology collaboration; governance; adoption; benefit realisation; risk-adjusted prioritisation.  
**Practical evidence:** create a process map, fishbone/5 Whys analysis, control plan and measurable benefits case.  
**Mini-capstone:** transform a reconciliations process from diagnosis through adoption.

### GFPA-09 — Risk, Controls, Compliance & Cyber
**Scope:** control objectives; preventive/detective controls; segregation of duties; evidence and audit trails; access management; fraud indicators; third-party risk; operational resilience; data protection; cyber hygiene; incident escalation; compliance monitoring; audit readiness; control testing; issue remediation; risk registers.  
**Practical evidence:** write a control matrix with risk, control, owner, frequency, evidence and test procedure.  
**Mini-capstone:** assess controls for an automated supplier-payment workflow.

### GFPA-10 — Global Credentials
**Scope:** role-based orientation to US CMA, CIA, EA/US taxation, CPA pathways, IFRS and selected risk/CRMP pathways. Cover exam structure, eligibility, ethics, study planning, official candidate handbooks, fees and syllabus changes only from current official credential bodies. Do not imply affiliation or guarantee eligibility.  
**Practical evidence:** compare credential pathways against a target role and build a dated study plan.  
**Mini-capstone:** produce a defensible credential roadmap with official links and assumptions.

### GFPA-11 — GCC + Product Engineering + Digital Business
**Scope:** GCC finance operating models; product lifecycle; product/engineering/finance collaboration; business requirements; APIs and integrations; data contracts; payment rails and settlement concepts; digital business models; AI infrastructure economics; cloud cost drivers; product metrics; risk and reliability; Hyderabad/GCC context as illustrative case material, not a universal rule.  
**Practical evidence:** write a finance-friendly product brief and map data/transaction flows.  
**Mini-capstone:** design controls and KPIs for a digital payments product launch.

### GFPA-12 — Career & Professional School
**Scope:** CV and LinkedIn; portfolio design; case interviews; STAR stories; technical and behavioural interviews; stakeholder writing; executive summaries; presentation and data storytelling; job search; networking; professional ethics; career strategy; negotiation basics; evidence-based personal branding.  
**Practical evidence:** create a role-targeted CV, project case study and interview answer bank.  
**Mini-capstone:** present an interview-ready finance transformation case.

### GFPA-13 — GFPA Integrated Capstone
**Scope:** combine accounting, operations, analytics, FP&A, controls, automation, Agile delivery, change and communication.  
**Required outputs:** problem statement; baseline and assumptions; current-state map; cleaned dataset and data dictionary; root-cause analysis; control/risk matrix; future-state design; prioritised backlog; sprint/release plan; dashboard and KPI dictionary; automation/AI decision with human controls; benefits model; change/adoption plan; executive recommendation; reflection and interview story.  
**Assessment:** problem framing 10%; data and analysis 15%; finance correctness 15%; controls and risk 15%; solution feasibility 15%; delivery plan 10%; measured value 10%; communication and evidence 10%.

## 4. Fintech Kalp focused pathway
Fintech Kalp draws selected learning outcomes from GFPA, rather than reproducing every GFPA domain. Its initial six pathways:
1. Finance Foundations — statements, journals, working capital, close and controls.
2. Finance Operations — P2P, O2C, R2R, service delivery, SLAs/KPIs and reconciliations.
3. Data for Finance — Excel, Power Query, Power BI, SQL, Python and data quality.
4. Automation & AI — RPA, OCR/IDP, workflow, AI evaluation and human oversight.
5. Fintech Systems — payment lifecycle, ledgers, APIs, settlement, fraud, security and applicable regulation.
6. Agile & Transformation — process maps, Lean/Six Sigma, root cause, user stories, delivery and benefit realisation.

Each pathway should be mapped to GFPA source IDs. A shared learning record should point to the canonical lesson ID so progress is not duplicated across products.

## 5. Running case and cumulative capstone
Use one original fictional company case throughout: supplier invoices are paid late, cash forecasts are unreliable, and month-end reconciliation exceptions are rising. AP investigates blocked/overdue/duplicate invoices; Procurement checks purchase orders, terms and supplier master data; Receiving confirms goods/service receipts; Treasury models cash needs; GL/R2R validates liabilities, GR/IR and accruals; AR informs cash inflows; FP&A models cost and cash; IT/Data checks interfaces and data quality; Risk/Audit tests approvals, segregation of duties and evidence; leadership prioritises measurable fixes. All data and company details must be invented for teaching.

## 6. Assessment and learner-answer records
- Save an attempt with stable lesson/assessment ID, question version, selected answer, submission timestamp, score, feedback version and optional learner notes.
- Never overwrite a prior attempt silently; allow a new attempt and retain history.
- Keep answer keys separate from learner-facing questions until submission.
- After submission, provide score, rationale for each answer, remediation links and a downloadable/printable attempt report.
- Capstone submissions should support draft, submitted and reviewed states, with rubric feedback and revision history.
- Export must include only the user's selected records and clearly label draft/final, dates and version.

## 7. Online/offline and export requirements
**Online:** responsive web/PWA, keyboard access, accessible contrast, searchable lessons, stable deep links, versioned content and source links.  
**Offline:** service worker precaches app shell and selected curriculum packs; lessons, local datasets, saved answers and drafts remain usable without network. Show an offline/online indicator, sync status, last-updated date and conflicts. Official links may require internet; cache only content permitted by license.  
**Persistence:** local-first save with clear export/backup and restore; optional cloud sync only when explicitly configured. Do not promise sync across devices unless an authenticated sync service exists.  
**Export/print:** lesson to print-friendly HTML/PDF; chapter notes; formula sheets; flashcards; blank assignment worksheet; completed answers and feedback; capstone brief; capstone submission; rubric and reviewer comments; full portfolio ZIP when supported. Exports should have title, stable ID, version, generated date, source list, page numbers where PDF supports them, and a draft/final watermark. Use browser print as a reliable fallback.  
**Data safety:** include export selected/all data, import/restore with validation, delete local data with confirmation, and never include hidden answer keys in pre-submission exports.

## 8. Copyright and licensing rules
- Write explanations, examples, case studies, questions, rubrics and datasets from scratch.
- Do not copy textbooks, paid course materials, exam-bank questions, proprietary slides, or substantial passages from websites.
- Facts, formulas and legal requirements can be explained independently; wording, diagrams, selection and arrangement can still be protected.
- Link to official sources and quote only short, necessary excerpts where legally appropriate; summarise in original words and cite the source.
- For third-party assets, record license and attribution; prefer public-domain, CC0 or compatible Creative Commons materials and follow their conditions.
- Do not imply endorsement or affiliation with credential bodies, vendors or regulators.
- Include a content provenance field: original / public-domain / licensed / linked reference, authoring date, reviewer, source URL and license/permission.
- Copyright-safe does not mean law-free: jurisdiction-specific legal questions require authoritative source review and, where appropriate, professional advice.

## 9. Regulatory update lifecycle
Use a change register with: item ID; jurisdiction; topic; official issuing body; source URL; publication date; effective date; status; summary in original words; affected lesson IDs; reviewer; verification date; next review date; superseded version; and action taken. Distinguish proposed, enacted/published, effective and repealed. Patch only affected lessons and assessments; retain prior versions for historical context. If no authoritative source confirms a claim, mark it unverified and do not change the syllabus.

## 10. Content QA and release gates
A lesson is not “published” until it passes: factual review; calculation check; chapter/assessment alignment; answer-key test; accessibility and mobile layout; source/license check; offline test; export/print test; persistence and restore test; stable-link test; version/date display; and deployment smoke test. A successful code build alone is not proof that lesson content is complete.

## 11. Suggested delivery sequence
**Phase 1 — Foundation:** canonical IDs, 13-domain map, content schema, copyright/source policy, version/change log.  
**Phase 2 — Delivery reliability:** offline app shell, selected lesson packs, local autosave, export/restore, print-friendly templates.  
**Phase 3 — Authored pilot:** fully author one complete chapter in Accounting Core, one in Data & Analytics, and one in Finance Operations; test the whole learning/assessment/export journey.  
**Phase 4 — Pathway expansion:** author the six Fintech Kalp pathways chapter by chapter, then fill remaining GFPA domains.  
**Phase 5 — Capstones and review:** cumulative project, portfolio exports, rubric and reviewer workflow, recurring official-source checks.

**Completion rule:** do not label a chapter complete merely because it has a title or outline. It must have the full teaching package and pass the release gates above.
