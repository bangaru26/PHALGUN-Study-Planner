# Fintech Kalp — Software & System Requirements
**Study Desk tab specification** · **Version 1.0** · **3 November 2026**

## Purpose
A dedicated Study Desk tab named **Software & System Requirements** helps learners check whether their device and software are ready for each Fintech Kalp lesson and lab.

## Tab structure
1. **My Device** — operating system/version, processor architecture, RAM, available storage, screen, internet connection, browser and permissions.
2. **Hardware Requirements** — verified minimum requirements where the vendor publishes them; recommended learner configuration shown separately.
3. **Software Prerequisites** — required applications, runtimes, browser extensions (only when necessary), drivers and dependencies.
4. **Install & Setup** — safe, stepwise installation and configuration guide with official vendor download/documentation links.
5. **Compatibility & Access** — Windows, Android and browser/PWA support; online/offline behavior and known limitations.
6. **Cost & License** — free/open-source, free-tier, paid, trial or institution-only; license caveats and date checked.
7. **Troubleshooting** — common installation, memory, permission, browser, PATH and connectivity issues.
8. **Readiness Checklist** — learner can mark each prerequisite checked; completion is separate from course quiz completion.

## Tool coverage
- Microsoft Excel (desktop/web) and Power Query
- Power BI Desktop and Power BI Service
- SQL practice environment and database engine options
- Python, pip/venv and pandas
- SAP FICO / ERP: training or demonstration access only; distinguish concepts from access to licensed SAP systems
- Tableau
- Jira and Agile/Scrum documentation workflow
- ChatGPT, Claude, Gemini, Microsoft Copilot, Perplexity, NotebookLM
- Git and GitHub; GitHub Copilot as optional
- Automation: n8n, Make, Zapier and RPA options
- Finance modeling, presentation and portfolio tools

## Evidence and accuracy rules
- Vendor-published minimums must be linked to official documentation and include the date checked and applicable product/version.
- Keep **Minimum**, **Recommended for comfortable study**, and **Optional** visibly distinct.
- Never infer or fabricate a RAM, CPU, storage, OS, GPU, browser or internet requirement. If no official minimum is published, state “not specified by vendor” and provide a clearly labeled practical recommendation only after testing.
- Mark tools that require account registration, institutional access, a paid license, cloud connectivity or data upload.
- Identify whether the learner's files/data stay local or are sent to a cloud service. Use fictional finance data in labs; do not upload confidential employer/client data.
- Avoid suggesting bypasses of security controls, license terms or organizational policies.
- Keep non-Chinese-origin options prioritized in accordance with project preference; disclose origin where verified and relevant.

## Integration requirements
- Each relevant lesson and lab links to its corresponding prerequisite entry.
- Search/filter by subject, tool, operating system, license and online/offline support.
- Show source, version and “last verified” date for each entry.
- The readiness checklist is portable in the learner's local backup/export.
- Android/PWA should present mobile-compatible alternatives where desktop-only tools (for example, Power BI Desktop) cannot run locally.
- Tab should not block lessons when a tool is optional; explain alternate learning paths.

## Release acceptance criteria
- Tab reachable from Study Desk navigation and usable on mobile and desktop.
- No dead internal links; vendor links resolve to official source pages.
- Minimum/recommended values are traceable to cited vendor sources or explicitly labeled practical tested recommendations.
- Tool entries show license/cost and data-handling cautions.
- Prerequisite links resolve from lessons; checklist state survives reload and participates in backup/restore.
- Test on Android Chrome and Windows browser; record results before handover.
