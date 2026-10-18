# PHALGUN Universal Learning Modes — Design Specification

Status: Design specification committed on a feature branch. This document does not imply that the UI or runtime behavior is implemented or deployed.

## 1. Universal requirement

All five learning modes must be available for every subject, topic, and relevant subtopic in PHALGUN, including GFPA and future subject areas. Examples include accounting, finance, treasury, SAP FICO, SAP HANA, Excel, Power BI, Tableau, SQL, Python, VBA, RPA, AI, risk management, internal audit, languages, shorthand, music theory, flute, veena, guitar, piano, and future additions.

A new subject must inherit the five-mode capability by default. No subject should be excluded simply because it is outside finance or technology.

**Child Mode is an additional cross-cutting learner experience available across every subject.** It does not replace the five learning modes: children can use Executive Summary, Comprehensive, Detailed, Filtered, and Technical within age-appropriate, child-oriented teaching. Child Mode adapts pedagogy, language, examples, pacing, activities, and safeguards to the learner.

## 2. The five learning modes

1. **Executive Summary** — key ideas, terminology, essential facts, formulas or rules, and concise examples for orientation and revision.
2. **Comprehensive** — systematic coverage from prerequisites and fundamentals through advanced concepts, including examples, practice, exceptions, and assessment.
3. **Detailed** — granular, step-by-step explanations of relevant concepts, reasoning, calculations, edge cases, common errors, and worked examples.
4. **Filtered** — content selection by topic/subtopic, proficiency, difficulty, role, industry, certification, learning objective, content type, or practice need. Filtering is a selection layer, not a depth level; it must be combinable with the other four modes.
5. **Technical** — subject-appropriate specialist mechanics, methods, implementation, diagnostics, and validation. Examples: SAP configuration and process flows; accounting entries and reconciliations; SQL queries and Python code; music notation, fingering, tuning, acoustics and technique; shorthand symbols, rules and transcription conventions.

## 3. Child Mode — universal child-friendly teaching

Child Mode must be available for every subject and topic, including topics commonly considered adult or technical. It teaches appropriate foundations without exposing children to unsuitable detail, risk, or authority.

### Teaching approach

- Adapt vocabulary, sentence length, pacing, examples, visual explanations, activities, and practice to the child's age, demonstrated understanding, interests, and readiness.
- Prefer curiosity-driven learning through stories, play, hands-on activities, exploration, experiments, music, puzzles, and joyful repetition where suitable.
- Use familiar, concrete examples before abstract concepts; introduce specialist vocabulary gradually and explain it clearly.
- Break complex tasks into small achievable steps. Offer encouragement and constructive feedback without shame, pressure, or manipulative streaks/rewards.
- Include short checks for understanding and let the child ask questions, revisit concepts, or choose among appropriate learning activities.
- Respect the learner's interests and choices within parent-configured permissions and safety boundaries. Learner choice should guide learning; explicit preferences and goals come before curriculum context and other inferred signals.
- Do not assume all children of the same age learn alike. Adjust based on demonstrated competency and explicit learner feedback, without diagnosing or labeling the child.
- Keep subject-specific teaching authentic: music uses listening, rhythm, instrument exploration and guided practice; shorthand uses patterns, symbols and short transcription drills; accounting uses toy-shop or pocket-money examples; programming uses safe, age-appropriate puzzles and projects.

### Five modes within Child Mode

All five modes remain available, but their presentation adapts to the child:
- **Executive Summary:** a short, friendly explanation with a few memorable ideas.
- **Comprehensive:** a complete age-appropriate learning journey, using small steps, examples and activities without omitting the curriculum from the overall learning path.
- **Detailed:** patient explanations, worked examples, visual or concrete analogies, and guided practice at a suitable pace.
- **Filtered:** child-friendly choices such as interests, topic, skill level, activity type, time available, and learning goal; filters must not expose content outside permissions.
- **Technical:** safe, age-appropriate introductions to the real mechanics of a subject, with advanced or hazardous operations gated until suitable readiness, training, and supervision are present.

Child Mode changes the teaching approach, not the truthfulness or accuracy of the subject. It must not silently falsify or oversimplify facts; explain limitations honestly and build toward the accurate concept.

### Progression and safety

- Use a gradual progression where relevant: **Observe → Assist → Practise → Perform with supervision → Perform independently when appropriate → Teach someone else.**
- Decide progression by age, readiness, demonstrated competency, task risk, and required supervision—not age alone.
- Activities involving heat, knives, appliances, chemicals, physical hazards, medical procedures, financial transactions, public posting, accounts, or external communication require appropriate restrictions and adult supervision or approval.
- Teach children how to recognize unsafe situations and when to stop and seek help from a trusted adult or qualified professional.
- Child Mode must not grant unrestricted financial, administrative, technical, or Founder-level authority merely because the learner is part of the family.
- Keep child data privacy fundamental: collect the minimum necessary data, make permissions clear to guardians, and do not expose a child's personal information or learning records to unauthorized people.
- Parent/guardian controls must set age-appropriate content, permissions, and supervision boundaries. Children should retain meaningful choices within those boundaries.
- Keep learning educational and non-diagnostic. Do not present PHALGUN as diagnosing developmental, learning, or health conditions.

## 4. Mode behavior and subject adaptation

- The selected mode applies to the current lesson/topic and remains consistent while navigating its content.
- The same mode controls must be discoverable and behave consistently throughout the platform.
- Child Mode is a learner/pedagogy layer and can be combined with any of the five modes. It is not a sixth mutually exclusive depth level.
- Mode content must be adapted to the discipline. Do not force every subject into a software-centric lesson template.
- Practical disciplines must include appropriate practice: audio/listening and guided performance for music when available; drills and transcription for shorthand; calculations and business cases for accounting; code, configuration exercises, and troubleshooting for technical systems.
- Technical mode is not synonymous with programming. It means the underlying specialist mechanics appropriate to the subject.
- Filter choices should combine, be visible to the learner, and be easy to clear. Changing filters must not silently change the selected depth mode.
- If a selected filter has no matching content, explain that clearly and provide a way to adjust or clear filters.

## 5. Minimum lesson structure

Where relevant to the subject, each topic should support:
- learning objectives and prerequisites;
- definitions and terminology;
- explanations and conceptual reasoning;
- worked examples and real-world scenarios;
- procedures, calculations, rules, or workflows;
- exceptions, limitations, common mistakes, and troubleshooting;
- practice exercises and knowledge checks with explanations;
- recap and references/source provenance where applicable.

Not every item applies identically to every discipline. Use a subject-specific lesson schema while preserving the universal five-mode interface and Child Mode.

## 6. Subject and content architecture

- Treat subjects, topics, and subtopics as structured curriculum records rather than hard-coded one-off pages.
- New subject records inherit all five modes and Child Mode by default.
- Keep curriculum coverage separate from presentation mode: selecting Executive Summary must not mean the underlying topic is absent from the full curriculum.
- Support source attribution, last-reviewed dates, and versioning for material that can change (for example, software versions, standards, and certification syllabi).
- Do not claim automatic updates or source verification unless a working process actually checks, records, and validates them.

## 7. Accessibility and learner control

- Learner choices override automatic suggestions within configured safety boundaries.
- Preserve selected subject, topic, mode, filters, learner profile, and progress when navigating, where persistence is available.
- Provide keyboard-accessible controls, readable labels, and responsive layouts.
- Keep the learning-mode controls compact and consistent with the existing Study Desk layout; avoid redesigning already-frozen areas without a clear need.
- Clearly distinguish child and adult experiences and apply the appropriate permissions consistently across navigation and subject pages.

## 8. Acceptance criteria

A release is not complete until tests demonstrate:
1. All five modes appear for representative topics in every subject family.
2. Child Mode is available across all subjects and adapts examples, language, pacing, activities, and safety to the learner.
3. Children can use all five modes within Child Mode; Child Mode is not a mutually exclusive depth mode.
4. Adding a new subject exposes all five modes and Child Mode without bespoke UI work.
5. Filtered mode supports multiple filters and combines with each of the other four modes.
6. Switching modes changes presentation depth/approach without deleting curriculum coverage or learner progress.
7. Technical mode uses discipline-appropriate methods, including non-programming subjects such as music and shorthand.
8. Child progression and hazardous/high-impact activities respect supervision, permission, and demonstrated readiness requirements.
9. Child data and permissions follow privacy-minimizing principles; Child Mode is non-diagnostic and does not confer privileged authority.
10. Lessons contain relevant examples, practice, and knowledge checks where appropriate.
11. Controls work on mobile and desktop and do not break the existing timer, progress indicators, frozen top area, navigation, notes, dictionary, or Excel Formula Practice.
12. Automated tests pass and the live application is visually and functionally verified before deployment is described as complete.

## 9. Implementation sequence

1. Inspect the current Study Desk/GFPA pages and identify reusable lesson structures.
2. Implement a shared learning-mode component and a subject-agnostic mode contract.
3. Implement Child Mode as a learner/pedagogy and permission layer that composes with any learning mode.
4. Implement composable filters separately from the four depth/presentation modes.
5. Add representative tests for finance, enterprise software, music, shorthand, and child-friendly versions of these subjects.
6. Integrate incrementally without redesigning frozen layout elements.
7. Run automated checks, review mobile/desktop behavior, and verify the deployed app before reporting completion.

## 10. Honest status reporting

This file records the agreed requirements and acceptance criteria only. The feature is not considered implemented until the code, tests, and running application demonstrate it.
