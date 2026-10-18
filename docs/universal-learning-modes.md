# PHALGUN Universal Learning Modes — Design Specification

Status: Design specification committed on a feature branch. This document does not imply that the UI or runtime behavior is implemented or deployed.

## 1. Universal requirement

All five learning modes must be available for every subject, topic, and relevant subtopic in PHALGUN, including GFPA and future subject areas. Examples include accounting, finance, treasury, SAP FICO, SAP HANA, Excel, Power BI, Tableau, SQL, Python, VBA, RPA, AI, risk management, internal audit, languages, shorthand, music theory, flute, veena, guitar, piano, and future additions.

A new subject must inherit the five-mode capability by default. No subject should be excluded simply because it is outside finance or technology.

## 2. The five modes

1. **Executive Summary** — key ideas, terminology, essential facts, formulas or rules, and concise examples for orientation and revision.
2. **Comprehensive** — systematic coverage from prerequisites and fundamentals through advanced concepts, including examples, practice, exceptions, and assessment.
3. **Detailed** — granular, step-by-step explanations of relevant concepts, reasoning, calculations, edge cases, common errors, and worked examples.
4. **Filtered** — content selection by topic/subtopic, proficiency, difficulty, role, industry, certification, learning objective, content type, or practice need. Filtering is a selection layer, not a depth level; it must be combinable with the other four modes.
5. **Technical** — subject-appropriate specialist mechanics, methods, implementation, diagnostics, and validation. Examples: SAP configuration and process flows; accounting entries and reconciliations; SQL queries and Python code; music notation, fingering, tuning, acoustics and technique; shorthand symbols, rules and transcription conventions.

## 3. Mode behavior and subject adaptation

- The selected mode applies to the current lesson/topic and remains consistent while navigating its content.
- The same mode controls must be discoverable and behave consistently throughout the platform.
- Mode content must be adapted to the discipline. Do not force every subject into a software-centric lesson template.
- Practical disciplines must include appropriate practice: audio/listening and guided performance for music when available; drills and transcription for shorthand; calculations and business cases for accounting; code, configuration exercises, and troubleshooting for technical systems.
- Technical mode is not synonymous with programming. It means the underlying specialist mechanics appropriate to the subject.
- Filter choices should combine, be visible to the learner, and be easy to clear. Changing filters must not silently change the selected depth mode.
- If a selected filter has no matching content, explain that clearly and provide a way to adjust or clear filters.

## 4. Minimum lesson structure

Where relevant to the subject, each topic should support:
- learning objectives and prerequisites;
- definitions and terminology;
- explanations and conceptual reasoning;
- worked examples and real-world scenarios;
- procedures, calculations, rules, or workflows;
- exceptions, limitations, common mistakes, and troubleshooting;
- practice exercises and knowledge checks with explanations;
- recap and references/source provenance where applicable.

Not every item applies identically to every discipline. Use a subject-specific lesson schema while preserving the universal five-mode interface.

## 5. Subject and content architecture

- Treat subjects, topics, and subtopics as structured curriculum records rather than hard-coded one-off pages.
- New subject records inherit all five modes by default.
- Keep curriculum coverage separate from presentation mode: selecting Executive Summary must not mean the underlying topic is absent from the full curriculum.
- Support source attribution, last-reviewed dates, and versioning for material that can change (for example, software versions, standards, and certification syllabi).
- Do not claim automatic updates or source verification unless a working process actually checks, records, and validates them.

## 6. Accessibility and learner control

- Learner choices override automatic suggestions.
- Preserve selected subject, topic, mode, filters, and progress when navigating, where persistence is available.
- Provide keyboard-accessible controls, readable labels, and responsive layouts.
- Keep the learning-mode controls compact and consistent with the existing Study Desk layout; avoid redesigning already-frozen areas without a clear need.

## 7. Acceptance criteria

A release is not complete until tests demonstrate:
1. All five modes appear for representative topics in every subject family.
2. Adding a new subject exposes all five modes without bespoke UI work.
3. Filtered mode supports multiple filters and combines with each of the other modes.
4. Switching modes changes presentation depth/approach without deleting curriculum coverage or learner progress.
5. Technical mode uses discipline-appropriate methods, including non-programming subjects such as music and shorthand.
6. Lessons contain relevant examples, practice, and knowledge checks where appropriate.
7. Controls work on mobile and desktop and do not break the existing timer, progress indicators, frozen top area, navigation, notes, dictionary, or Excel Formula Practice.
8. Automated tests pass and the live application is visually and functionally verified before deployment is described as complete.

## 8. Implementation sequence

1. Inspect the current Study Desk/GFPA pages and identify reusable lesson structures.
2. Implement a shared learning-mode component and a subject-agnostic mode contract.
3. Implement composable filters separately from the four depth/presentation modes.
4. Add representative tests for finance, enterprise software, music, and shorthand.
5. Integrate incrementally without redesigning frozen layout elements.
6. Run automated checks, review mobile/desktop behavior, and verify the deployed app before reporting completion.

## 9. Honest status reporting

This file records the agreed requirements and acceptance criteria only. The feature is not considered implemented until the code, tests, and running application demonstrate it.
