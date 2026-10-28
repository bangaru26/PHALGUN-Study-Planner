import 'package:flutter/material.dart';

void main() => runApp(const FintechKalpApp());

const ink = Color(0xFF10233F);
const teal = Color(0xFF087E8B);
const canvas = Color(0xFFF4F7FB);

class FintechKalpApp extends StatelessWidget {
  const FintechKalpApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Fintech Kalp', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal), scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(backgroundColor: canvas, foregroundColor: ink, elevation: 0),
      cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE4EAF2))))),
    home: const LearningHome());
}

class LearningHome extends StatefulWidget {
  const LearningHome({super.key});
  @override
  State<LearningHome> createState() => _LearningHomeState();
}

class _LearningHomeState extends State<LearningHome> {
  int section = 0, selectedPath = 0, selectedChapter = 0;
  final Set<int> completed = {};
  final Map<int, int> answers = {};
  bool submitted = false;
  final TextEditingController assignment = TextEditingController();

  final paths = const [
    LearningPath('Finance foundations', 'Accounting, statements, working capital and controls', Icons.account_balance, 'CORE', ['Financial statements in practice', 'Working capital and cash conversion', 'Internal controls and reconciliations']),
    LearningPath('Finance operations', 'AP/P2P, AR/O2C, GL/R2R and shared services', Icons.sync_alt, 'OPS', ['Invoice-to-pay lifecycle', 'Order-to-cash and collections', 'Month-end close and reconciliations']),
    LearningPath('Data for finance', 'Excel, Power Query, BI, SQL and data quality', Icons.query_stats, 'DATA', ['Excel analysis for AP ageing', 'Power Query: clean and combine files', 'Build a finance KPI dashboard']),
    LearningPath('Automation & AI', 'RPA, document intelligence and human oversight', Icons.auto_awesome, 'AI', ['Identify automation candidates', 'OCR and invoice exception handling', 'Human-in-the-loop AI controls']),
    LearningPath('Fintech systems', 'Payments, digital banking, APIs, cybersecurity and regulation', Icons.account_tree, 'TECH', ['Digital payments and settlement', 'APIs, ledgers and system integration', 'Fraud, privacy and security basics']),
    LearningPath('Agile & transformation', 'Process improvement, delivery and measurable business value', Icons.rocket_launch, 'CHANGE', ['Map a process and find root causes', 'Write a user story and acceptance criteria', 'Measure benefits and manage change']),
  ];
  final quiz = const [
    QuizQuestion('A team wants to reduce duplicate supplier payments. What is the best first control?', ['Pay every invoice immediately', 'Match invoice identifiers and check duplicates before payment', 'Remove approval steps', 'Keep a manual list with no owner'], 1, 'A duplicate check using invoice identifiers, supplier and amount is a preventive/detective control. It should work alongside approvals and exception handling.'),
    QuizQuestion('Which tool is most suitable for repeatedly cleaning and combining monthly Excel files?', ['Power Query', 'A screenshot editor', 'A presentation theme', 'A calendar reminder'], 0, 'Power Query records repeatable data transformation steps, making monthly refreshes more consistent and auditable.'),
    QuizQuestion('For an AI system that flags suspicious invoices, what is a sound control?', ['Let AI approve every payment', 'Hide the model output', 'Route uncertain or high-risk cases to an authorised human reviewer', 'Disable audit logs'], 2, 'Human review, clear approval authority, audit evidence and monitored exceptions reduce the risk of blindly accepting AI outputs.'),
  ];

  @override
  void dispose() { assignment.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final pages = [dashboard(), curriculum(), practice(), capstone(), resources()];
    return Scaffold(
      appBar: AppBar(title: const Row(children: [
        CircleAvatar(backgroundColor: ink, child: Icon(Icons.account_balance, color: Colors.white, size: 19)),
        SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('FINTECH KALP', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3, fontSize: 15)),
          Text('A focused pathway within GFPA · PHALGUN', style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]),
      ]), actions: [Padding(padding: const EdgeInsets.only(right: 14), child: Chip(avatar: const Icon(Icons.school, size: 16), label: const Text('LEARNING LAB')))]),
      body: Row(children: [
        if (wide) NavigationRail(selectedIndex: section, onDestinationSelected: (v) => setState(() => section = v), labelType: NavigationRailLabelType.all, destinations: const [
          NavigationRailDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: Text('Home')),
          NavigationRailDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: Text('Curriculum')),
          NavigationRailDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check), label: Text('Practice')),
          NavigationRailDestination(icon: Icon(Icons.rocket_launch_outlined), selectedIcon: Icon(Icons.rocket_launch), label: Text('Capstone')),
          NavigationRailDestination(icon: Icon(Icons.library_books_outlined), selectedIcon: Icon(Icons.library_books), label: Text('Resources')),
        ]),
        Expanded(child: IndexedStack(index: section, children: pages)),
      ]),
      bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: section, onDestinationSelected: (v) => setState(() => section = v), destinations: const [
        NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Learn'),
        NavigationDestination(icon: Icon(Icons.fact_check_outlined), label: 'Practice'),
        NavigationDestination(icon: Icon(Icons.rocket_launch_outlined), label: 'Capstone'),
        NavigationDestination(icon: Icon(Icons.library_books_outlined), label: 'Resources'),
      ]),
    );
  }

  Widget dashboard() => ListView(padding: const EdgeInsets.all(22), children: [
    Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: const LinearGradient(colors: [ink, Color(0xFF174E69)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('LEARN FINANCE. BUILD WHAT MATTERS.', style: TextStyle(color: Color(0xFF7EE7D5), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
        const SizedBox(height: 12), const Text('From finance operations\nto intelligent finance.', style: TextStyle(color: Colors.white, fontSize: 29, height: 1.12, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12), const Text('A practical pathway connecting accounting, finance operations, data, automation, fintech systems and transformation.', style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        const SizedBox(height: 20), Wrap(spacing: 10, runSpacing: 8, children: [
          FilledButton.icon(onPressed: () => setState(() => section = 1), icon: const Icon(Icons.play_arrow), label: const Text('Explore curriculum')),
          OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)), onPressed: () => setState(() => section = 2), icon: const Icon(Icons.quiz_outlined), label: const Text('Try practice quiz')),
        ]),
      ])),
    const SizedBox(height: 18),
    LayoutBuilder(builder: (context, box) {
      final count = box.maxWidth > 800 ? 4 : 2;
      final items = [
        StatCard('Learning paths', '${paths.length}', Icons.route, teal),
        StatCard('Chapters completed', '${completed.length}', Icons.check_circle_outline, const Color(0xFF4C6FFF)),
        StatCard('Quiz status', submitted ? 'Attempted' : 'Not started', Icons.fact_check_outlined, const Color(0xFFB76E00)),
        StatCard('Progress', '${(completed.length / 18 * 100).round().clamp(0, 100)}%', Icons.trending_up, const Color(0xFF7655C5)),
      ];
      return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: count, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.8, children: items);
    }),
    const SizedBox(height: 22), const SectionHeading('Your learning pathways', 'Select a path to explore its chapters.'),
    const SizedBox(height: 10), ...paths.asMap().entries.map((entry) => PathCard(path: entry.value, onTap: () => setState(() { selectedPath = entry.key; section = 1; }))),
    const SizedBox(height: 12), const Text('GFPA remains the broader academy. Fintech Kalp focuses on finance and related technologies. PHALGUN is the wider learning ecosystem.', style: TextStyle(color: Colors.black54, height: 1.5)),
  ]);

  Widget curriculum() {
    final path = paths[selectedPath];
    return ListView(padding: const EdgeInsets.all(22), children: [
      const SectionHeading('Curriculum explorer', 'Choose a learning path, then select a chapter when you are ready.'),
      const SizedBox(height: 14),
      DropdownButtonFormField<int>(value: selectedPath, decoration: const InputDecoration(labelText: 'Learning path', border: OutlineInputBorder()),
        items: paths.asMap().entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value.title))).toList(),
        onChanged: (v) => setState(() { selectedPath = v ?? 0; selectedChapter = 0; })),
      const SizedBox(height: 16),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(path.code, style: const TextStyle(color: teal, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const SizedBox(height: 6), Text(path.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 6), Text(path.description),
      ]))),
      const SizedBox(height: 12),
      ...path.chapters.asMap().entries.map((e) => Card(child: ListTile(
        leading: CircleAvatar(backgroundColor: completed.contains(e.key + selectedPath * 10) ? const Color(0xFFD9F5EB) : const Color(0xFFE8EEF7), child: Icon(completed.contains(e.key + selectedPath * 10) ? Icons.check : Icons.menu_book, color: ink)),
        title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('FK-${path.code}-C${(e.key + 1).toString().padLeft(2, '0')} · Lesson → example → practice → assignment'),
        trailing: const Icon(Icons.chevron_right), onTap: () => setState(() => selectedChapter = e.key),
      ))),
      const SizedBox(height: 12),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Selected lesson format', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 8),
        const LessonStep('01', 'Learning objectives and prerequisites'),
        const LessonStep('02', 'Real-world scenario and detailed teaching'),
        const LessonStep('03', 'Cross-department perspectives and demonstration'),
        const LessonStep('04', 'MCQs and practical assignment — attempt first'),
        const LessonStep('05', 'Mini-capstone, revision gist and free resources'),
        const LessonStep('06', 'Results and explanations only after submission'),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => setState(() { completed.add(selectedChapter + selectedPath * 10); section = 2; submitted = false; answers.clear(); }), icon: const Icon(Icons.play_arrow), label: const Text('Select lesson & open practice')),
        const SizedBox(height: 6), const Text('This first release is a working navigation and learning-flow prototype. Full authored chapter lessons and synced progress are not yet connected.', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.45)),
      ]))),
    ]);
  }

  Widget practice() => ListView(padding: const EdgeInsets.all(22), children: [
    const SectionHeading('Knowledge check', 'Choose your answers and submit. Explanations stay hidden until you attempt the quiz.'),
    const SizedBox(height: 14),
    ...quiz.asMap().entries.map((entry) {
      final i = entry.key; final q = entry.value;
      return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('QUESTION ${i + 1} OF ${quiz.length}', style: const TextStyle(color: teal, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 8), Text(q.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink)),
        const SizedBox(height: 8),
        ...q.options.asMap().entries.map((option) => RadioListTile<int>(contentPadding: EdgeInsets.zero, dense: true, value: option.key, groupValue: answers[i], onChanged: submitted ? null : (v) => setState(() => answers[i] = v!), title: Text(option.value))),
        if (submitted) Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: answers[i] == q.correct ? const Color(0xFFE2F7ED) : const Color(0xFFFFF0E8), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(answers[i] == q.correct ? 'Correct' : 'Review this answer', style: TextStyle(fontWeight: FontWeight.w800, color: answers[i] == q.correct ? const Color(0xFF146C43) : const Color(0xFF9B4518))),
            const SizedBox(height: 4), Text('Answer: ${q.options[q.correct]}'), const SizedBox(height: 4), Text(q.explanation),
          ])),
      ])));
    }),
    const SizedBox(height: 8),
    if (!submitted) FilledButton.icon(onPressed: answers.length == quiz.length ? () => setState(() => submitted = true) : null, icon: const Icon(Icons.task_alt), label: const Text('Submit answers and reveal feedback'))
    else Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Score: ${quiz.asMap().entries.where((e) => answers[e.key] == e.value.correct).length} / ${quiz.length}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: ink)),
      const SizedBox(height: 8), const Text('Review the explanations above. In this prototype, quiz answers are held only in this open browser session.'),
      const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => setState(() { answers.clear(); submitted = false; }), icon: const Icon(Icons.refresh), label: const Text('Try again')),
    ]))),
  ]);

  Widget capstone() => ListView(padding: const EdgeInsets.all(22), children: [
    const SectionHeading('Mini-capstone lab', 'A practical, end-to-end finance operations case.'), const SizedBox(height: 14),
    Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('CASE FK-CAPSTONE-01', style: TextStyle(color: teal, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 11)),
      const SizedBox(height: 8), const Text('Late supplier payments and rising exceptions', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
      const SizedBox(height: 8), const Text('A shared-services team has overdue invoices, unreliable cash forecasts and a rise in month-end reconciliation exceptions. Build a practical improvement proposal using evidence, controls and measurable outcomes.'),
      const SizedBox(height: 18), const SectionHeading('Deliverables', ''),
      const LessonStep('1', 'Map the current AP/P2P process and identify bottlenecks.'),
      const LessonStep('2', 'Define data needed: ageing, duplicates, blocked invoices, PO/receipt match and payment dates.'),
      const LessonStep('3', 'Show how AP, Procurement, Receiving, Treasury, GL/R2R, FP&A, IT/Data and Risk/Audit each contribute.'),
      const LessonStep('4', 'Recommend controls, workflow or automation with human review for exceptions.'),
      const LessonStep('5', 'Define baseline, target KPIs, owner, risk and a 30/60/90-day rollout.'),
      const SizedBox(height: 16), const Text('Your draft', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 8),
      TextField(controller: assignment, maxLines: 7, decoration: const InputDecoration(hintText: 'Write your diagnosis, root causes, controls, proposed solution and KPIs…', border: OutlineInputBorder(), alignLabelWithHint: true)),
      const SizedBox(height: 10), FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft is in this browser session only. Cloud saving is not configured yet.'))), icon: const Icon(Icons.save_outlined), label: const Text('Check draft status')),
    ]))),
  ]);

  Widget resources() => ListView(padding: const EdgeInsets.all(22), children: [
    const SectionHeading('Learning resources', 'Official documentation and free learning starting points. Verify course availability before enrolling.'),
    const SizedBox(height: 12),
    const ResourceCard('Flutter', 'Open-source framework used for this app.', 'https://flutter.dev/', Icons.phone_android),
    const ResourceCard('Dart', 'Programming language used by Flutter.', 'https://dart.dev/', Icons.code),
    const ResourceCard('Microsoft Learn: Power BI', 'Free guided learning for data modelling and reports.', 'https://learn.microsoft.com/training/powerplatform/power-bi/', Icons.bar_chart),
    const ResourceCard('Microsoft Support: Excel', 'Start with official Excel help and learning resources.', 'https://support.microsoft.com/excel', Icons.table_chart),
    const ResourceCard('The Scrum Guide', 'Official Scrum framework guide.', 'https://scrumguides.org/scrum-guide.html', Icons.groups),
    const ResourceCard('World Bank: Financial Inclusion', 'Explore digital finance and financial inclusion resources.', 'https://www.worldbank.org/en/topic/financialinclusion', Icons.payments),
    const SizedBox(height: 10), const Text('Progress and drafts in this first release are session-local. No sign-in, cloud synchronisation, official certification or financial transaction functionality is enabled.', style: TextStyle(color: Colors.black54, height: 1.5)),
  ]);
}

class LearningPath {
  final String title, description, code; final IconData icon; final List<String> chapters;
  const LearningPath(this.title, this.description, this.icon, this.code, this.chapters);
}
class QuizQuestion {
  final String question; final List<String> options; final int correct; final String explanation;
  const QuizQuestion(this.question, this.options, this.correct, this.explanation);
}
class SectionHeading extends StatelessWidget {
  final String title, subtitle;
  const SectionHeading(this.title, this.subtitle, {super.key});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
    if (subtitle.isNotEmpty) ...[const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: Colors.black54, height: 1.45))],
  ]);
}
class StatCard extends StatelessWidget {
  final String label, value; final IconData icon; final Color color;
  const StatCard(this.label, this.value, this.icon, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Icon(icon, color: color), Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: ink)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
  ])));
}
class PathCard extends StatelessWidget {
  final LearningPath path; final VoidCallback onTap;
  const PathCard({required this.path, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    leading: CircleAvatar(backgroundColor: const Color(0xFFE4F5F3), child: Icon(path.icon, color: teal)),
    title: Text(path.title, style: const TextStyle(fontWeight: FontWeight.w800, color: ink)), subtitle: Text(path.description),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: onTap));
}
class LessonStep extends StatelessWidget {
  final String number, text; const LessonStep(this.number, this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(width: 28, height: 28, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFE4F5F3), borderRadius: BorderRadius.circular(8)), child: Text(number, style: const TextStyle(color: teal, fontWeight: FontWeight.w900, fontSize: 11))),
    const SizedBox(width: 10), Expanded(child: Padding(padding: const EdgeInsets.only(top: 4), child: Text(text, style: const TextStyle(height: 1.35)))),
  ]));
}
class ResourceCard extends StatelessWidget {
  final String title, description, url; final IconData icon;
  const ResourceCard(this.title, this.description, this.url, this.icon, {super.key});
  @override
  Widget build(BuildContext context) => Card(child: ListTile(
    leading: CircleAvatar(backgroundColor: const Color(0xFFE8EEF7), child: Icon(icon, color: ink)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text('$description\n$url'), isThreeLine: true, trailing: const Icon(Icons.open_in_new, size: 18),
    onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open resource: $url')))));
}
