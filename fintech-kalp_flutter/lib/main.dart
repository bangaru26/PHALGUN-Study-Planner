import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool lessonOpened = false;
  final Set<int> completed = {};
  final Map<int, int> answers = {};
  bool submitted = false;
  int? lessonAnswer1, lessonAnswer2;
  final TextEditingController assignment = TextEditingController();
  bool stateLoaded = false;
  static const _storageKey = 'fintech_kalp_local_v1';

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        final saved = jsonDecode(raw) as Map<String, dynamic>;
        completed.addAll((saved['completed'] as List? ?? []).whereType<num>().map((n) => n.toInt()));
        assignment.text = (saved['capstoneDraft'] as String?) ?? '';
        final savedAnswers = saved['quizAnswers'];
        if (savedAnswers is Map) {
          for (final entry in savedAnswers.entries) {
            final key = int.tryParse(entry.key.toString());
            final value = entry.value;
            if (key != null && value is num) answers[key] = value.toInt();
          }
        }
        submitted = saved['quizSubmitted'] == true;
      }
    } catch (_) {
      // Keep the learning app usable if local browser storage is unavailable.
    }
    if (mounted) setState(() => stateLoaded = true);
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode({
        'completed': completed.toList(),
        'capstoneDraft': assignment.text,
        'quizAnswers': answers.map((key, value) => MapEntry(key.toString(), value)),
        'quizSubmitted': submitted,
        'updatedAt': DateTime.now().toIso8601String(),
      }));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save locally in this browser. Check browser storage settings.')),
        );
      }
    }
  }

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
    if (lessonOpened) return lessonDetail();
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
        trailing: const Icon(Icons.chevron_right), onTap: () => setState(() { selectedChapter = e.key; lessonOpened = true; }),
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
        FilledButton.icon(onPressed: () => setState(() { selectedChapter = 0; lessonOpened = true; }), icon: const Icon(Icons.menu_book), label: const Text('Open first lesson')),
        const SizedBox(height: 6), const Text('This first release is a working navigation and learning-flow prototype. Full authored chapter lessons and synced progress are not yet connected.', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.45)),
      ]))),
    ]);
  }

  Widget lessonDetail() {
    final path = paths[selectedPath];
    final title = path.chapters[selectedChapter];
    final id = 'FK-${path.code}-C${(selectedChapter + 1).toString().padLeft(2, '0')}';
    final lessons = <String, Map<String, String>>{
      'CORE': {
        'concept': 'Financial information turns business activity into decisions. The three core statements answer different questions: the income statement reports performance over a period; the balance sheet shows assets, liabilities and equity at a point in time; the cash-flow statement explains cash movement across operating, investing and financing activities.',
        'example': 'A distributor reports a profit of ₹12 lakh but has only ₹1 lakh in its bank account. Profit is not cash: customers may still owe money, inventory may have increased, or suppliers may have been paid. Reconcile profit to operating cash before concluding that the business is financially healthy.',
        'steps': '1. Confirm the reporting period and source systems.\n2. Reconcile subledgers to the general ledger.\n3. Separate timing differences from genuine errors.\n4. Explain movements using volume, price, mix and timing.\n5. Record evidence, owner and resolution date for each exception.',
        'cross': 'AP explains unpaid supplier liabilities; AR explains collection delays; Treasury analyses available cash; FP&A explains budget variances; GL/R2R confirms account integrity; Risk/Audit checks evidence and approvals.',
        'assignment': 'Using a fictional month-end, explain why a profitable business can have a cash shortage. List five data points you would request and three controls you would test.',
        'capstone': 'Create a one-page finance health note covering profit, cash, working capital, reconciliation exceptions, risks and actions.',
        'formula': 'Working capital = Current assets − Current liabilities. Current ratio = Current assets ÷ Current liabilities. These ratios need context; a high ratio does not automatically mean cash is available.'
      },
      'OPS': {
        'concept': 'Procure-to-Pay (P2P) begins with a business need and ends with a correctly recorded supplier payment. Typical stages are requisition, purchase order, receipt confirmation, invoice capture, validation/matching, approval, payment proposal, payment release and ledger reconciliation. Exceptions should be routed to an accountable owner rather than hidden in email.',
        'example': 'A supplier invoice for ₹2,40,000 arrives, but the purchase order is ₹2,20,000 and the receipt confirms only 90 units. Do not force the invoice through. Compare quantities, price, tax and contract terms, then route the mismatch to Procurement or Receiving with evidence.',
        'steps': '1. Validate supplier identity and invoice fields.\n2. Check duplicate risk using supplier, invoice number, date and amount.\n3. Match invoice to purchase order and goods/service receipt where applicable.\n4. Apply approval limits and segregation of duties.\n5. Track blocked invoices, ageing, root cause and resolution.\n6. Reconcile AP subledger, payments and bank/GL records.',
        'cross': 'Procurement owns PO and commercial terms; Receiving confirms delivery; AP validates invoices; Treasury manages liquidity and payment timing; GL/R2R reconciles liabilities and GR/IR; IT supports interfaces; Audit tests approvals and segregation of duties.',
        'assignment': 'Design an exception log with columns for supplier, invoice, amount, PO, receipt status, exception reason, owner, age, next action and target resolution date.',
        'capstone': 'Propose a 30-day improvement to reduce overdue invoices without bypassing controls. Define baseline, target, owner, risk and weekly review cadence.',
        'formula': 'Overdue rate = Overdue unpaid invoices ÷ Total unpaid invoices × 100%. First-time match rate = Invoices matched without manual correction ÷ Invoices processed × 100%. Define the denominator consistently.'
      },
      'DATA': {
        'concept': 'Reliable analytics starts with a clear question, defined metrics and trustworthy data. Excel is useful for inspection and ad-hoc analysis; Power Query automates repeatable cleaning and combining; Power BI models relationships and communicates trends; SQL retrieves structured records. Validate source completeness before interpreting charts.',
        'example': 'Three monthly AP files use different supplier-name spellings and date formats. Standardise column names and types, trim whitespace, map supplier IDs, remove only verified duplicates, document exceptions and reconcile row counts and totals to the source.',
        'steps': '1. State the business question and grain of the dataset.\n2. Profile blanks, duplicates, types, ranges and totals.\n3. Clean with repeatable transformations.\n4. Preserve source fields and transformation notes.\n5. Reconcile counts and monetary totals.\n6. Build a metric definition and communicate the action it supports.',
        'cross': 'AP validates invoice statuses; Procurement validates supplier and PO master data; Treasury uses due dates for cash forecasts; FP&A compares trends to budget; IT/Data owns pipelines and access; Audit needs traceability from dashboard to source.',
        'assignment': 'Create a data-quality checklist for an AP ageing report. Include at least six checks and explain what action follows if each check fails.',
        'capstone': 'Design a dashboard specification with overdue value, ageing bands, blocked-invoice reasons, top suppliers, trend and owner-level actions.',
        'formula': 'Ageing days = Report date − Due date for overdue items (or use the agreed ageing convention). Overdue value = Sum of outstanding amounts where due date is before the report date and status is unpaid.'
      },
      'AI': {
        'concept': 'Automation should start with a stable, rules-understood process. RPA is suited to repeatable user-interface tasks; workflow tools route work and approvals; OCR/IDP extracts fields from documents; AI can classify or flag unusual cases. Automation does not remove accountability, access controls, audit trails or exception handling.',
        'example': 'An invoice-reading model extracts supplier, invoice number and amount. A validation layer checks mandatory fields, duplicate risk and PO match. Low-confidence extraction or a policy breach goes to a trained reviewer; approved data is then passed to the ERP with an audit record.',
        'steps': '1. Map the current process and baseline time/error rates.\n2. Separate stable rules from judgement-heavy exceptions.\n3. Assess data access, privacy, failure modes and fallback.\n4. Pilot with human review and logging.\n5. Monitor accuracy, override rates, exceptions and benefits.\n6. Keep a manual recovery route and named process owner.',
        'cross': 'AP defines acceptable invoice outcomes; IT secures integrations; Risk/Audit validates controls; Procurement resolves supplier data; Treasury protects payment release; process owners approve changes and monitor benefits.',
        'assignment': 'Select one repetitive finance task. Document inputs, decision rules, exceptions, control risks, human approval points and a measurable success metric.',
        'capstone': 'Prepare a responsible automation proposal including process map, ROI assumptions, access controls, test plan, fallback and post-launch monitoring.',
        'formula': 'Net annual benefit = Annual measurable savings − Annual run/support cost. Payback period (months) = Initial investment ÷ Monthly net benefit. State assumptions and do not count theoretical time savings as cash savings unless capacity is actually redeployed.'
      },
      'TECH': {
        'concept': 'Fintech connects financial services with software, data and regulated operations. A payment journey can include initiation, authentication, authorisation, clearing, settlement, reconciliation, dispute handling and reporting. An API is a defined interface for systems to exchange requests and responses; an API call is not itself proof that money settled.',
        'example': 'A payment dashboard shows “accepted” but the bank statement has no debit. Treat accepted, authorised, processed and settled as distinct states. Use transaction IDs, timestamps, bank/processor reports and reconciliation rules to identify whether the item is pending, rejected, duplicated or settled.',
        'steps': '1. Identify parties, systems and transaction identifiers.\n2. Distinguish authorisation, processing and settlement states.\n3. Protect credentials and sensitive data.\n4. Apply idempotency and duplicate-handling rules.\n5. Reconcile platform records to bank/ledger records.\n6. Escalate fraud signals and unresolved breaks through controlled procedures.',
        'cross': 'Product defines the customer journey; Engineering maintains APIs and reliability; Finance reconciles fees and settlement; Treasury monitors liquidity; Compliance interprets applicable rules; Security manages access and incident response.',
        'assignment': 'Draw a payment lifecycle and list the evidence needed to investigate a transaction marked successful in one system but missing in another.',
        'capstone': 'Specify a safe payment-reconciliation service with transaction IDs, exception states, access controls, audit logging, alerts and operational ownership.',
        'formula': 'Reconciliation break = Internal recorded amount − External confirmed amount. A non-zero break is an investigation signal, not permission to post a plug journal.'
      },
      'CHANGE': {
        'concept': 'Process transformation improves an outcome by addressing root causes rather than automating waste. Agile delivery breaks work into small, testable increments. A useful user story describes a user need and business value; acceptance criteria define observable conditions for completion.',
        'example': 'Instead of a vague request to “automate AP”, write: “As an AP analyst, I want blocked invoices grouped by reason and owner so that I can prioritise resolution and reduce overdue value.” Acceptance criteria define valid reasons, owner mapping, refresh timing, totals reconciliation and exception visibility.',
        'steps': '1. Define the customer/business problem and baseline.\n2. Map the as-is process and quantify waste or rework.\n3. Validate root causes with process data and staff.\n4. Prioritise a small change with clear acceptance criteria.\n5. Pilot, test controls and gather feedback.\n6. Measure results and decide whether to scale.',
        'cross': 'Finance owns business outcomes; Operations validates usability; Product prioritises value; Engineering estimates and builds; Data validates measurement; Risk/Audit checks control impacts; leaders remove blockers and fund scale-up.',
        'assignment': 'Write one user story and at least five testable acceptance criteria for reducing blocked invoices. Include a control requirement and a measurable business outcome.',
        'capstone': 'Create a 30/60/90-day transformation plan with work items, owners, dependencies, risks, adoption actions and outcome measures.',
        'formula': 'Improvement % = (Baseline − New result) ÷ Baseline × 100% for metrics where lower is better. For higher-is-better metrics, reverse the numerator and clearly state the direction.'
      }
    };
    final d = lessons[path.code]!;
    final check1 = <String, Map<String, Object>>{
      'CORE': {'q': 'A profitable company has very little cash. What should you investigate first?', 'o': ['Assume the profit is wrong', 'Review receivables, inventory, payables and cash-flow movements', 'Ignore working capital'], 'a': 1, 'e': 'Profit and cash differ because of working-capital movements, non-cash items and timing. Reconcile the movement using evidence.'},
      'OPS': {'q': 'An invoice exceeds its purchase order and receipt quantity. What is the safest action?', 'o': ['Force it through payment', 'Split the invoice to bypass the tolerance', 'Hold and route the mismatch to an accountable owner'], 'a': 2, 'e': 'A mismatch is an exception. Investigate quantity, price, tax and receipt evidence; do not bypass approval controls.'},
      'DATA': {'q': 'Before publishing an AP ageing dashboard, what should you do?', 'o': ['Reconcile row counts and monetary totals to source data', 'Hide missing dates', 'Remove every repeated supplier name'], 'a': 0, 'e': 'Data-quality checks and source reconciliation help establish completeness and accuracy before interpreting the dashboard.'},
      'AI': {'q': 'An invoice-reading model has low confidence on the amount. What should happen?', 'o': ['Automatically approve payment', 'Route the item to an authorised human reviewer', 'Delete the audit trail'], 'a': 1, 'e': 'Low-confidence or high-risk cases need human review, logged decisions and controlled exception handling.'},
      'TECH': {'q': 'A payment API says accepted, but no bank settlement is visible. What is the next step?', 'o': ['Assume settlement is complete', 'Post a balancing journal without evidence', 'Trace transaction IDs and reconcile processor and bank records'], 'a': 2, 'e': 'Accepted, processed and settled are different states. Use identifiers, timestamps and independent records to investigate.'},
      'CHANGE': {'q': 'What makes an Agile user story ready to test?', 'o': ['Clear acceptance criteria and an observable outcome', 'A vague request to automate everything', 'A deadline with no definition of done'], 'a': 0, 'e': 'Acceptance criteria define observable behaviour and help the team test value, controls and completion.'},
    }[path.code]!;
    final check2 = <String, Map<String, Object>>{
      'CORE': {'q': 'Which statement shows assets, liabilities and equity at a point in time?', 'o': ['Income statement', 'Balance sheet', 'Cash-flow statement'], 'a': 1, 'e': 'The balance sheet presents the entity’s financial position at a reporting date.'},
      'OPS': {'q': 'Which KPI best measures invoices paid late?', 'o': ['Overdue unpaid invoices divided by total unpaid invoices, using a consistent definition', 'Total number of suppliers in the master file', 'Number of emails sent'], 'a': 0, 'e': 'A useful KPI has a defined numerator, denominator, reporting date and owner.'},
      'DATA': {'q': 'What is Power Query primarily useful for?', 'o': ['Approving payments', 'Repeatable data cleaning and transformation', 'Replacing source-system controls'], 'a': 1, 'e': 'Power Query lets analysts record repeatable transformation steps for refreshable data preparation.'},
      'AI': {'q': 'What should be monitored after finance automation launches?', 'o': ['Only the number of bots', 'Accuracy, exceptions, overrides, controls and realised benefits', 'Nothing once it works once'], 'a': 1, 'e': 'Production monitoring detects drift and failures and tests whether expected business value is being realised.'},
      'TECH': {'q': 'What is a reconciliation break?', 'o': ['A difference between independent records that needs investigation', 'Proof of fraud by itself', 'Permission to post an unsupported journal'], 'a': 0, 'e': 'A break is an investigation signal; resolve it with evidence and the approved accounting process.'},
      'CHANGE': {'q': 'Why measure a baseline before changing a process?', 'o': ['To avoid defining a target', 'To make the project longer', 'To compare outcomes and test whether the change helped'], 'a': 2, 'e': 'A credible baseline supports measurable outcomes and helps distinguish real improvement from assumption.'},
    }[path.code]!;
    final resources = <String, String>{
      'CORE': 'https://www.ifrs.org/issued-standards/list-of-standards/ | https://www.accountingcoach.com/',
      'OPS': 'https://www.accountingcoach.com/ | https://learn.microsoft.com/training/',
      'DATA': 'https://support.microsoft.com/excel | https://learn.microsoft.com/training/powerplatform/power-bi/ | https://sqlbolt.com/',
      'AI': 'https://learn.microsoft.com/training/ | https://www.nist.gov/itl/ai-risk-management-framework',
      'TECH': 'https://www.rbi.org.in/ | https://www.bis.org/cpmi/',
      'CHANGE': 'https://scrumguides.org/scrum-guide.html | https://www.atlassian.com/agile',
    };
    return ListView(padding: const EdgeInsets.all(22), children: [
      Row(children: [IconButton(onPressed: () => setState(() => lessonOpened = false), icon: const Icon(Icons.arrow_back)), const SizedBox(width: 4), Expanded(child: Text('$id · LESSON', style: const TextStyle(color: teal, fontWeight: FontWeight.w900, letterSpacing: 1.1)))]),
      Text(title, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: ink)),
      const SizedBox(height: 6), Text('Path: ${path.title} · Learn at your pace; complete the practice before viewing feedback.', style: const TextStyle(color: Colors.black54, height: 1.4)),
      const SizedBox(height: 16),
      lessonCard('01 · Learning objectives', 'By the end of this lesson, you should be able to explain the core process, apply it to a realistic finance scenario, identify cross-functional responsibilities, and propose evidence-based controls or improvements.'),
      lessonCard('02 · Core lesson', d['concept']!),
      lessonCard('03 · Real-world worked example', d['example']!),
      lessonCard('04 · Practical method', d['steps']!),
      lessonCard('05 · Cross-department perspective', d['cross']!),
      lessonCard('06 · Important formula / concept', d['formula']!),
      lessonCard('07 · Assignment (attempt first)', d['assignment']!),
      lessonCard('08 · Mini-capstone', d['capstone']!),
      lessonCard('09 · Revision gist', 'Recall the process flow, the evidence needed, the responsible owner, the key control, and the metric that proves improvement. Connect this lesson to earlier topics rather than memorising definitions in isolation.'),
      lessonCard('10 · Books, free learning and references', 'Explore these starting points (availability and access terms may vary):\n${resources[path.code]}\n\nUse official documentation first. Record the page or module used, the date accessed and one practical takeaway.'),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Knowledge check · answers hidden until submission', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: ink)),
        const SizedBox(height: 8), Text('1. ${check1['q']}', style: const TextStyle(fontWeight: FontWeight.w700)),
        ...(check1['o'] as List<String>).asMap().entries.map((e) => RadioListTile<int>(dense: true, contentPadding: EdgeInsets.zero, value: e.key, groupValue: lessonAnswer1, title: Text(e.value), onChanged: submitted ? null : (v) => setState(() => lessonAnswer1 = v))),
        const SizedBox(height: 8), Text('2. ${check2['q']}', style: const TextStyle(fontWeight: FontWeight.w700)),
        ...(check2['o'] as List<String>).asMap().entries.map((e) => RadioListTile<int>(dense: true, contentPadding: EdgeInsets.zero, value: e.key, groupValue: lessonAnswer2, title: Text(e.value), onChanged: submitted ? null : (v) => setState(() => lessonAnswer2 = v))),
        const SizedBox(height: 12),
        if (!submitted) FilledButton(onPressed: lessonAnswer1 == null || lessonAnswer2 == null ? null : () => setState(() { submitted = true; }), child: const Text('Submit answers and reveal feedback'))
        else ...[
          Text('Score: ${(lessonAnswer1 == check1['a'] ? 1 : 0) + (lessonAnswer2 == check2['a'] ? 1 : 0)} / 2', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: ink)),
          const SizedBox(height: 6),
          Text('1. ${lessonAnswer1 == check1['a'] ? 'Correct' : 'Not quite'} — ${check1['e']}', style: const TextStyle(height: 1.5)),
          const SizedBox(height: 6),
          Text('2. ${lessonAnswer2 == check2['a'] ? 'Correct' : 'Not quite'} — ${check2['e']}', style: const TextStyle(height: 1.5)),
          OutlinedButton(onPressed: () => setState(() { submitted = false; lessonAnswer1 = null; lessonAnswer2 = null; }), child: const Text('Reset attempt')),
        ],
        const SizedBox(height: 8), FilledButton.icon(onPressed: () => setState(() { completed.add(selectedChapter + selectedPath * 10); lessonOpened = false; _saveState(); }), icon: const Icon(Icons.check_circle_outline), label: const Text('Mark lesson reviewed')),
      ]))),
      const SizedBox(height: 12),
      OutlinedButton.icon(onPressed: () => setState(() { selectedChapter = (selectedChapter + 1) % path.chapters.length; submitted = false; lessonAnswer1 = null; lessonAnswer2 = null; answers.clear(); }), icon: const Icon(Icons.skip_next), label: const Text('Open next chapter')),
      const SizedBox(height: 8), const Text('Progress is saved locally in this browser on this device. It is not synced across devices or accounts.', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.4)),
    ]);
  }

  Widget lessonCard(String title, String body) => Card(margin: const EdgeInsets.only(bottom: 10), child: Padding(padding: const EdgeInsets.all(17), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ink)),
    const SizedBox(height: 8), SelectableText(body, style: const TextStyle(fontSize: 14, height: 1.6)),
  ])));

  Widget practice() => ListView(padding: const EdgeInsets.all(22), children: [
    const SectionHeading('Knowledge check', 'Choose your answers and submit. Explanations stay hidden until you attempt the quiz.'),
    const SizedBox(height: 14),
    ...quiz.asMap().entries.map((entry) {
      final i = entry.key; final q = entry.value;
      return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('QUESTION ${i + 1} OF ${quiz.length}', style: const TextStyle(color: teal, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 8), Text(q.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink)),
        const SizedBox(height: 8),
        ...q.options.asMap().entries.map((option) => RadioListTile<int>(contentPadding: EdgeInsets.zero, dense: true, value: option.key, groupValue: answers[i], onChanged: submitted ? null : (v) { setState(() => answers[i] = v!); _saveState(); }, title: Text(option.value))),
        if (submitted) Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: answers[i] == q.correct ? const Color(0xFFE2F7ED) : const Color(0xFFFFF0E8), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(answers[i] == q.correct ? 'Correct' : 'Review this answer', style: TextStyle(fontWeight: FontWeight.w800, color: answers[i] == q.correct ? const Color(0xFF146C43) : const Color(0xFF9B4518))),
            const SizedBox(height: 4), Text('Answer: ${q.options[q.correct]}'), const SizedBox(height: 4), Text(q.explanation),
          ])),
      ])));
    }),
    const SizedBox(height: 8),
    if (!submitted) FilledButton.icon(onPressed: answers.length == quiz.length ? () { setState(() => submitted = true); _saveState(); } : null, icon: const Icon(Icons.task_alt), label: const Text('Submit answers and reveal feedback'))
    else Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Score: ${quiz.asMap().entries.where((e) => answers[e.key] == e.value.correct).length} / ${quiz.length}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: ink)),
      const SizedBox(height: 8), const Text('Review the explanations above. Your quiz attempt is saved locally in this browser on this device.'),
      const SizedBox(height: 12), OutlinedButton.icon(onPressed: () { setState(() { answers.clear(); submitted = false; }); _saveState(); }, icon: const Icon(Icons.refresh), label: const Text('Try again')),
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
      TextField(controller: assignment, maxLines: 7, onChanged: (_) => _saveState(), decoration: const InputDecoration(hintText: 'Write your diagnosis, root causes, controls, proposed solution and KPIs…', border: OutlineInputBorder(), alignLabelWithHint: true)),
      const SizedBox(height: 10), FilledButton.icon(onPressed: () async { await _saveState(); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Capstone draft and learning progress saved in this browser on this device.'))); }, icon: const Icon(Icons.save_outlined), label: const Text('Save capstone draft')),
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
    const SizedBox(height: 10), const Text('Learning progress, quiz attempts and capstone drafts are saved locally in this browser on this device. There is no account/cloud sync, official certification or financial transaction functionality.', style: TextStyle(color: Colors.black54, height: 1.5)),
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
