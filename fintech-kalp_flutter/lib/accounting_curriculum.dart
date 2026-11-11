import 'package:flutter/material.dart';

class AccountingQuestion {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;
  const AccountingQuestion(this.question, this.options, this.correct, this.explanation);
}

class AccountingChapter {
  final String title, objectives, concept, example, method, crossFunctional, formula, assignment, capstone;
  final Map<String, String> notes;
  final List<Map<String, String>> flashcards;
  final List<AccountingQuestion> questions;
  const AccountingChapter({
    required this.title, required this.objectives, required this.concept,
    required this.example, required this.method, required this.crossFunctional,
    required this.formula, required this.assignment, required this.capstone,
    required this.notes, required this.flashcards, required this.questions,
  });
}

const accountingFoundations = <AccountingChapter>[
  AccountingChapter(
    title: 'Accounting equation and double-entry bookkeeping',
    objectives: 'Explain assets, liabilities and equity; apply the accounting equation; classify common accounts; record balanced double entries; explain how transactions affect financial position.',
    concept: 'Accounting identifies, measures, records and communicates economic events. The accounting equation is Assets = Liabilities + Equity. Assets are present economic resources controlled by the entity; liabilities are present obligations; equity is the residual interest after liabilities. Every recognised transaction has equal debit and credit effects. Debit and credit describe the left and right sides of an account; they do not inherently mean increase and decrease. Assets and expenses normally increase with debits; liabilities, equity and income normally increase with credits. Drawings reduce owner equity and are not an operating expense.',
    example: 'A Hyderabad trading business starts with owner capital of ₹5,00,000 and a bank loan of ₹2,00,000. It buys equipment for ₹80,000 from the bank, purchases inventory on credit for ₹60,000, pays rent of ₹10,000 and earns cash service revenue of ₹15,000. The initial financing creates bank ₹7,00,000, capital ₹5,00,000 and loan ₹2,00,000. Equipment purchase transfers value from bank to equipment; credit inventory creates inventory and a supplier liability; rent reduces cash and equity through expense; revenue increases cash and equity through income. Each event keeps the equation balanced.',
    method: '1. Identify the reporting entity and transaction date. 2. Identify the accounts affected and classify each as asset, liability, equity, income or expense. 3. Determine whether each account increases or decreases. 4. Apply the debit/credit rules. 5. Record equal total debits and credits with a clear narration and source reference. 6. Post to the relevant ledger accounts. 7. Reconcile the resulting balances and retain supporting evidence.',
    crossFunctional: 'Procurement creates purchase commitments and receipt evidence; AP records supplier liabilities; Sales creates revenue and receivables; Treasury confirms bank movements; HR/payroll supplies salary obligations; Fixed Assets tracks equipment; GL/R2R owns the chart of accounts, journals and close; Audit tests authorisation, completeness and evidence.',
    formula: 'Assets = Liabilities + Equity. Equity = Assets − Liabilities. Profit = Income − Expenses. Closing equity = Opening equity + owner contributions + profit − drawings/distributions. Example: assets ₹7,00,000 and liabilities ₹2,00,000 imply equity ₹5,00,000.',
    assignment: 'Prepare journal entries for: (a) owner invests ₹2,00,000 in bank; (b) equipment bought by bank transfer ₹30,000; (c) inventory bought on credit ₹45,000; (d) rent paid ₹8,000; (e) cash service revenue ₹12,000; (f) customer pays ₹5,000 against an earlier receivable. For each entry state the debit, credit, account class and source document. Prove total debits equal total credits.',
    capstone: 'Create a 20-transaction journal for a fictional small business. Post to ledgers, prepare a trial balance and explain how five selected transactions affect assets, liabilities, equity, income and expenses. Include a transaction register, source references and a control-total check.',
    notes: {
      'English': 'The accounting equation states that the resources of a business are financed by obligations to others and the residual interest of owners. Every recorded transaction must preserve the equation.',
      'Telugu': 'వ్యాపార వనరులకు రుణదాతల బాధ్యతలు మరియు యజమానుల వాటా ద్వారా నిధులు సమకూరుతాయి. ఈ సంబంధాన్ని ఆస్తులు = బాధ్యతలు + యజమాని మూలధనం అనే సమీకరణం చూపిస్తుంది. ప్రతి నమోదు చేసిన లావాదేవీలో డెబిట్, క్రెడిట్ మొత్తాలు సమానంగా ఉండాలి.',
      'Hindi': 'व्यवसाय के संसाधनों का वित्तपोषण बाहरी देनदारियों और मालिकों की शेष हिस्सेदारी से होता है। इसे लेखांकन समीकरण दर्शाता है: परिसंपत्तियाँ = देनदारियाँ + स्वामित्व। हर दर्ज लेन-देन में कुल डेबिट और क्रेडिट बराबर होने चाहिए.'
    },
    flashcards: [
      {'q':'What is the accounting equation?','a':'Assets = Liabilities + Equity.'},
      {'q':'What is an asset?','a':'A present economic resource controlled by the entity as a result of past events.'},
      {'q':'What is a liability?','a':'A present obligation of the entity to transfer an economic resource.'},
      {'q':'How do assets normally increase?','a':'By a debit.'},
      {'q':'How do liabilities normally increase?','a':'By a credit.'},
      {'q':'Are drawings an operating expense?','a':'No. Drawings/distributions reduce owner equity.'}
    ],
    questions: [
      AccountingQuestion('Which equation is fundamental to double-entry accounting?', ['Assets = Liabilities + Equity','Assets = Revenue − Expenses','Equity = Assets + Liabilities','Cash = Profit'], 0, 'The equation expresses the residual claim of owners after liabilities are deducted from assets.'),
      AccountingQuestion('A business buys equipment for cash. What is the effect?', ['Equipment and cash both increase','Equipment increases and cash decreases','Liabilities increase','Revenue increases'], 1, 'Debit equipment and credit cash. One asset increases while another asset decreases.'),
      AccountingQuestion('Which account normally increases with a credit?', ['Rent expense','Cash','Accounts payable','Office equipment'], 2, 'Accounts payable is a liability; liabilities normally increase by credit.'),
      AccountingQuestion('A customer pays an amount already recorded as receivable. What is the entry?', ['Dr Cash, Cr Accounts Receivable','Dr Revenue, Cr Cash','Dr Accounts Receivable, Cr Cash','Dr Expense, Cr Payable'], 0, 'Cash increases and the receivable decreases. Do not recognise revenue a second time.'),
      AccountingQuestion('Why must total debits equal total credits?', ['It guarantees there are no errors','It preserves the double-entry structure and accounting equation','It means cash equals profit','It eliminates reconciliations'], 1, 'Equal debits and credits are necessary, but a balanced trial balance can still contain omissions or wrong-account errors.')
    ],
  ),
  AccountingChapter(
    title: 'Accounting concepts, assumptions and standards',
    objectives: 'Distinguish accounting assumptions, concepts, conventions, policies, estimates and standards; apply accrual, going concern, entity, materiality and prudence; explain the role of IFRS and Ind AS.',
    concept: 'The business entity concept separates business records from the owner’s personal affairs. Going concern assumes continued operation for the foreseeable future unless contrary facts exist. The accrual basis recognises qualifying income and expenses when the relevant recognition criteria are met, not merely when cash moves. The reporting-period concept divides the life of an entity into periods. Materiality asks whether information could reasonably influence decisions. Prudence requires caution under uncertainty without deliberate understatement or hidden reserves. Consistency supports comparability but does not prohibit a justified policy change required by standards or better information. Substance over form focuses on economic substance. Accounting standards prescribe recognition, measurement, presentation and disclosure; policies are entity choices where standards permit; estimates involve judgement about uncertain amounts.',
    example: 'A company completes eligible consulting work worth ₹40,000 in March and receives cash in April. Under accrual accounting, revenue and a receivable are generally recognised in March if the applicable revenue recognition requirements are met. A March electricity bill received in April may require an accrued expense in March. A customer advance received in March is not automatically earned revenue: the entity must assess whether the promised goods or services have been transferred.',
    method: '1. Identify the reporting entity, period and applicable framework. 2. Determine whether the event meets recognition criteria for an asset, liability, income or expense. 3. Apply the relevant standard and accounting policy. 4. Identify estimates and uncertainty, including assumptions and evidence. 5. Assess materiality and required disclosures. 6. Apply policies consistently; document any permitted change and its rationale. 7. Review subsequent events and going-concern indicators before authorising statements.',
    crossFunctional: 'Sales and Legal provide contract terms and performance evidence; Operations confirms delivery; HR provides payroll cut-off; Procurement and AP provide invoices/receipts; Treasury supplies cash and financing evidence; Tax assesses tax consequences; Finance Policy/Technical Accounting interprets standards; Audit challenges judgements and disclosures.',
    formula: 'Accrual adjustment example: Dr Expense / Cr Accrued Liability for an expense incurred but not yet invoiced, when recognition criteria are met. Prepayment consumed: Dr Expense / Cr Prepayment. Depreciation allocation: (cost − residual value) ÷ useful life, subject to the applicable standard and asset facts.',
    assignment: 'For each case, identify the concept and proposed accounting treatment: (1) owner pays a personal holiday from a business account; (2) annual insurance is paid in advance; (3) services are completed before cash collection; (4) a major customer is in financial distress; (5) management changes an estimate of useful life based on new evidence; (6) a material lawsuit is pending. Explain what evidence and standard/policy research are needed.',
    capstone: 'Write a two-page accounting policy memo for a fictional service company. Cover revenue cut-off, accrued expenses, prepayments, depreciation estimates, materiality, going-concern indicators and disclosure responsibilities. Distinguish facts, assumptions, judgement and unresolved questions.',
    notes: {
      'English': 'Accrual accounting recognises transactions in the period in which the relevant economic activity meets the recognition requirements. Cash receipt or payment may happen in a different period.',
      'Telugu': 'సంబంధిత ఆర్థిక కార్యకలాపం గుర్తింపు ప్రమాణాలను నెరవేర్చిన కాలంలోనే ఆదాయం లేదా ఖర్చును నమోదు చేయడాన్ని అక్రూవల్ అకౌంటింగ్ అంటారు. నగదు అందుకోవడం లేదా చెల్లించడం వేరే కాలంలో జరగవచ్చు.',
      'Hindi': 'उपार्जन लेखांकन में आय या व्यय को उस अवधि में मान्यता दी जाती है जिसमें संबंधित आर्थिक गतिविधि मान्यता की शर्तें पूरी करती है। नकद प्राप्ति या भुगतान किसी दूसरी अवधि में हो सकता है.'
    },
    flashcards: [
      {'q':'What does going concern mean?','a':'The entity is expected to continue operating for the foreseeable future, unless evidence indicates otherwise.'},
      {'q':'What is accrual accounting?','a':'Recognising qualifying economic events in the period they occur, rather than simply when cash moves.'},
      {'q':'What is materiality?','a':'Information is material if omitting, misstating or obscuring it could reasonably influence users’ decisions.'},
      {'q':'What is prudence?','a':'Caution when making judgements under uncertainty, without intentional bias.'},
      {'q':'What is an accounting policy?','a':'Specific principles, bases, conventions, rules and practices applied in preparing financial statements.'},
      {'q':'What is an accounting estimate?','a':'A monetary amount subject to measurement uncertainty, based on available information and judgement.'}
    ],
    questions: [
      AccountingQuestion('Which assumption supports preparing statements on the basis that operations will continue?', ['Materiality','Going concern','Consistency','Money measurement'], 1, 'Going concern assumes continued operation for the foreseeable future unless contrary evidence exists.'),
      AccountingQuestion('A service is completed in March and qualifying revenue is earned, but cash arrives in April. Under accrual accounting, when is revenue recognised?', ['Always April','March, if recognition criteria are met','Only at year end','Only when the customer pays'], 1, 'Recognition follows the applicable revenue requirements, not simply the cash receipt date.'),
      AccountingQuestion('Which statement about prudence is correct?', ['Always understate assets','Create hidden reserves','Exercise caution under uncertainty without deliberate bias','Ignore estimates'], 2, 'Prudence does not justify systematic understatement or deliberate bias.'),
      AccountingQuestion('A change in useful-life estimate based on new evidence is generally treated as:', ['A change in estimate','A prior-period error in every case','A cash transaction','A change in entity'], 0, 'Changes in estimates arising from new information are distinguished from errors and policy changes.'),
      AccountingQuestion('What does materiality assess?', ['Whether information could influence users’ decisions','Whether every item is the same size','Whether cash has moved','Whether a transaction is taxable'], 0, 'Materiality depends on the nature or magnitude of information in the context of the financial statements.')
    ],
  ),
  AccountingChapter(
    title: 'Journal entries, subsidiary books and ledger posting',
    objectives: 'Apply account classification and debit-credit rules; prepare journal entries with narrations; understand sales, purchase, cash and general journals; post to ledger accounts; distinguish source documents from accounting records.',
    concept: 'A journal is the chronological initial record of transactions. A journal entry identifies the date, accounts debited and credited, amounts and a narration. Ledgers group transactions by account so that balances can be reviewed. A chart of accounts provides the coding structure. Subsidiary books or specialised journals may capture recurring high-volume transactions such as credit purchases, credit sales, cash receipts and cash payments. The source document—invoice, receipt, contract, bank advice, goods-received note or approved expense claim—supports the entry. Posting transfers journal amounts to the relevant ledger accounts. A narration should be specific enough to explain the business purpose and source.',
    example: 'A supplier invoice shows 100 units received at ₹500 each on credit. If inventory is recognised under the entity’s applicable accounting policy, the entry may be Dr Inventory ₹50,000 / Cr Trade Payables ₹50,000. When the supplier is paid, Dr Trade Payables / Cr Bank. Payment settles the liability; it does not create a second inventory purchase. A credit sale is Dr Trade Receivables / Cr Revenue, with a separate cost-of-sales/inventory entry where applicable.',
    method: '1. Validate the source document, supplier/customer, date, entity, currency and approval. 2. Identify the economic event and accounting period. 3. Select the correct chart-of-account code and subledger. 4. Calculate tax, discounts, foreign exchange or allocations where relevant. 5. Prepare a balanced journal with narration and reference. 6. Obtain required approval and post through controlled access. 7. Post to ledger/subledger and reconcile totals. 8. Retain audit trail, attachments and reversal/correction links.',
    crossFunctional: 'Procurement raises purchase orders; Receiving records goods/services; AP validates supplier invoices; Sales and Billing issue customer invoices; AR tracks collections; Treasury confirms cash; Tax validates tax coding; GL controls journals and period posting; IT maintains interfaces and role access.',
    formula: 'Journal control: Σ Debits = Σ Credits. Ledger balance = total debits − total credits for a debit-nature account, or total credits − total debits for a credit-nature account. Example: opening payable ₹20,000 Cr + credit invoice ₹8,000 − payment ₹10,000 = closing payable ₹18,000 Cr.',
    assignment: 'Prepare journal entries and narrations for ten fictional transactions including capital, cash purchase, credit purchase, credit sale, customer receipt, supplier payment, rent, salary accrual, prepaid insurance and equipment acquisition. Identify the source document and approval evidence for each. Post at least Bank, Trade Receivables, Trade Payables, Revenue and Rent Expense to T-accounts.',
    capstone: 'Build a small-business bookkeeping pack with a chart of accounts, source-document register, general journal, sales journal, purchase journal, cash book, ledger and reconciliation checklist. Demonstrate traceability from a selected ledger balance back to original evidence.',
    notes: {
      'English': 'The journal records transactions in date order. Posting transfers those entries into ledger accounts, where activity and balances are grouped by account.',
      'Telugu': 'జర్నల్‌లో లావాదేవీలను తేదీ క్రమంలో నమోదు చేస్తారు. పోస్టింగ్ ద్వారా ఆ నమోదులను లెడ్జర్ ఖాతాలకు బదిలీ చేసి, ప్రతి ఖాతా లావాదేవీలు మరియు నిల్వలను సమూహంగా పరిశీలిస్తారు.',
      'Hindi': 'जर्नल में लेन-देन तारीख के क्रम में दर्ज होते हैं। पोस्टिंग के माध्यम से प्रविष्टियाँ लेजर खातों में स्थानांतरित की जाती हैं, जहाँ प्रत्येक खाते की गतिविधि और शेष अलग-अलग दिखाई देते हैं.'
    },
    flashcards: [
      {'q':'What is a journal?','a':'A chronological record of accounting transactions.'},
      {'q':'What is a ledger?','a':'A collection of accounts showing transaction activity and balances by account.'},
      {'q':'What is a narration?','a':'A concise explanation of the business purpose and source of a journal entry.'},
      {'q':'Name three source documents.','a':'Supplier/customer invoice, bank advice, receipt, purchase order, goods-received note or approved expense claim.'},
      {'q':'What does posting mean?','a':'Transferring journal amounts to the relevant ledger accounts.'},
      {'q':'Does paying a supplier create a new purchase expense?','a':'No. It normally settles the existing payable and reduces bank/cash.'}
    ],
    questions: [
      AccountingQuestion('Which record normally captures transactions in chronological order?', ['Ledger','Journal','Trial balance','Balance sheet'], 1, 'The journal is the chronological book of original entry.'),
      AccountingQuestion('What is the main purpose of ledger posting?', ['Group transactions by account','Replace source documents','Approve supplier master changes','Prepare a tax return automatically'], 0, 'Ledgers organise activity and balances by account.'),
      AccountingQuestion('A supplier payable of ₹20,000 is paid by bank. Which entry is correct?', ['Dr Bank, Cr Payables','Dr Payables, Cr Bank','Dr Expense, Cr Revenue','Dr Inventory, Cr Capital'], 1, 'Payment reduces the liability and bank balance.'),
      AccountingQuestion('Which is the strongest supporting source for recording a supplier invoice?', ['An unsupported verbal estimate','A valid supplier invoice with receipt/approval evidence as required','A dashboard screenshot alone','A prior month journal copied without review'], 1, 'Entries require reliable source evidence and appropriate approval/receipt support.'),
      AccountingQuestion('What should a journal narration communicate?', ['Only the preparer’s initials','Business purpose and useful source reference','A marketing slogan','A guessed account balance'], 1, 'A clear narration helps reviewers understand the nature and provenance of the entry.')
    ],
  ),
  AccountingChapter(
    title: 'Trial balance, adjustments and error correction',
    objectives: 'Prepare a trial balance from ledger balances; explain its purpose and limitations; identify errors that do and do not affect agreement; record accruals, prepayments, depreciation and closing adjustments; understand suspense accounts.',
    concept: 'A trial balance lists ledger balances at a date and checks whether total debits equal total credits. It is a useful arithmetic control, not proof that accounts are correct. Errors such as complete omission, posting to the wrong account, an error of principle or equal compensating errors can leave the trial balance balanced. One-sided posting or unequal amounts may create a difference. A suspense account may temporarily hold an unexplained difference while investigation proceeds; it is not a permanent solution. Adjusting entries support correct period cut-off for accrued expenses, accrued income, prepayments, depreciation, inventory and estimates. Each adjustment needs a calculation, evidence, approval and reversal policy where relevant.',
    example: 'A business pays ₹24,000 for 12 months of insurance on 1 January. If the policy covers the full year and the reporting date is 31 March, three months’ insurance of ₹6,000 has been consumed and ₹18,000 remains prepaid, subject to exact coverage dates. If the full amount was initially posted to prepayments, the adjustment is Dr Insurance Expense ₹6,000 / Cr Prepaid Insurance ₹6,000. A salary of ₹35,000 earned by staff but unpaid at 31 March is Dr Salary Expense ₹35,000 / Cr Accrued Salary ₹35,000.',
    method: '1. Extract all ledger balances at the same entity and reporting date. 2. Confirm debit/credit sign conventions and subledger-to-GL control accounts. 3. Total debits and credits and investigate any difference. 4. Review completeness, cut-off, unusual balances, duplicates and mapping even if totals agree. 5. Calculate supported accruals, prepayments, depreciation and estimates. 6. Prepare adjustment journals with workings and approvals. 7. Re-run the adjusted trial balance and reconcile key control accounts. 8. Clear suspense only when the underlying error is identified and corrected.',
    crossFunctional: 'Payroll confirms earned salary and deductions; Procurement/Receiving confirms goods received but not invoiced; AP supplies invoice cut-off; Sales confirms delivered services and contract terms; Fixed Assets validates commissioning and useful lives; Treasury confirms bank balances; Tax reviews tax effects; GL/R2R coordinates close and reviewers.',
    formula: 'Prepayment expense for a straight-line coverage period = total prepayment × elapsed coverage period ÷ total coverage period. Straight-line depreciation = (cost − residual value) ÷ useful life, if that method reflects consumption. Trial balance difference = total debits − total credits; investigate rather than plug.',
    assignment: 'Prepare an adjusted trial balance from these balances: Bank Dr ₹50,000; Receivables Dr ₹30,000; Equipment Dr ₹40,000; Payables Cr ₹20,000; Capital Cr ₹70,000; Revenue Cr ₹45,000; Expenses Dr ₹15,000. Record additional adjustments: salary accrued ₹5,000; insurance prepaid at period end ₹3,000 (assume currently expensed); depreciation ₹2,000. Show the unadjusted and adjusted trial balance, workings and impact on profit and balances.',
    capstone: 'Create a month-end close file with a close calendar, trial balance, reconciliation status, adjustment journal register, suspense ageing, reviewer sign-off and post-close issue log. Include examples of one balanced-but-wrong error and one error that creates a trial-balance difference.',
    notes: {
      'English': 'A trial balance checks whether ledger debit and credit totals agree. Agreement is not proof of completeness or correct classification; reconciliations and substantive checks are still required.',
      'Telugu': 'ట్రయల్ బ్యాలెన్స్ లెడ్జర్‌లోని డెబిట్, క్రెడిట్ మొత్తాలు సమానంగా ఉన్నాయా అని పరిశీలిస్తుంది. మొత్తాలు సమానంగా ఉన్నాయంటే అన్ని లావాదేవీలు పూర్తిగా, సరైన ఖాతాల్లో నమోదయ్యాయని నిర్ధారణ కాదు.',
      'Hindi': 'ट्रायल बैलेंस जाँचता है कि लेजर के डेबिट और क्रेडिट कुल बराबर हैं या नहीं। बराबरी से यह सिद्ध नहीं होता कि सभी लेन-देन पूरे और सही खातों में दर्ज हुए हैं; मिलान और अन्य जाँच भी आवश्यक हैं.'
    },
    flashcards: [
      {'q':'What does a trial balance test?','a':'Arithmetic agreement of debit and credit ledger balances at a date.'},
      {'q':'Does a balanced trial balance prove there are no errors?','a':'No. Omissions, wrong-account postings and compensating errors may remain.'},
      {'q':'What is an accrual?','a':'Recognition of an income or expense in the period it is earned/incurred, with a related receivable or liability where applicable.'},
      {'q':'What is a prepayment?','a':'A payment made before the related benefit is consumed; the unconsumed portion is an asset.'},
      {'q':'What is a suspense account?','a':'A temporary holding account for an unresolved difference, requiring investigation and timely clearance.'},
      {'q':'What evidence supports an adjustment?','a':'Calculation/workings, contract or invoice, operational evidence, policy basis, approval and audit trail.'}
    ],
    questions: [
      AccountingQuestion('What does a trial balance primarily check?', ['Whether every transaction is correct','Whether ledger debit and credit totals agree','Whether all cash has been collected','Whether profit equals cash'], 1, 'The trial balance checks arithmetic agreement, not every aspect of correctness.'),
      AccountingQuestion('Which error may not cause a trial balance difference?', ['Posting only one side','Omitting a transaction completely','Entering unequal debit and credit amounts','Adding one ledger column incorrectly'], 1, 'A complete omission removes both sides, so debit and credit totals may still agree.'),
      AccountingQuestion('Salary earned by employees but unpaid at period end is generally:', ['A prepaid asset','An accrued expense and liability','Revenue','Owner drawings'], 1, 'The expense belongs to the period in which the employees earned it, with a liability for the unpaid amount.'),
      AccountingQuestion('A suspense account should be:', ['Used permanently to force agreement','Cleared after the underlying difference is investigated and corrected','Hidden from reviewers','Treated as revenue automatically'], 1, 'Suspense is temporary and needs ownership, evidence and timely resolution.'),
      AccountingQuestion('A 12-month insurance payment has 9 months of coverage remaining at reporting date. The unconsumed portion is generally:', ['A prepaid asset','A payable','Revenue','A drawing'], 0, 'The remaining coverage is a future economic benefit and is generally carried as a prepayment.')
    ],
  ),
  AccountingChapter(
    title: 'Financial statements and the month-end close',
    objectives: 'Explain the purpose and structure of the income statement, balance sheet and cash-flow statement; distinguish profit from cash; connect ledgers to statements; understand close, cut-off, reconciliations and disclosure review.',
    concept: 'The income statement reports financial performance over a period: income less expenses produces profit or loss. The balance sheet reports assets, liabilities and equity at a reporting date. The statement of cash flows explains cash and cash-equivalent movements across operating, investing and financing activities. The statements are connected: profit affects retained earnings/equity; non-cash expenses and working-capital changes help reconcile profit to operating cash; asset purchases appear in investing cash flows and create assets subject to depreciation/impairment. Month-end close coordinates cut-off, subledger completion, reconciliations, accruals, estimates, intercompany, consolidation, review, disclosure and period lock.',
    example: 'A distributor reports net profit of ₹12 lakh but operating cash flow is negative ₹4 lakh. Possible drivers include a rise in receivables, inventory build-up, payment of prior-period suppliers, non-cash expenses and timing. The analyst should reconcile profit to operating cash and inspect ageing and inventory movement rather than assume either figure is wrong. Equipment bought for cash is generally an investing cash flow, while depreciation is a non-cash expense added back under the indirect method.',
    method: '1. Confirm reporting entity, period, currency and accounting framework. 2. Close AP, AR, inventory, payroll, fixed assets and bank subledgers. 3. Reconcile each subledger/control account to the general ledger. 4. Test revenue and expense cut-off. 5. Record supported accruals, prepayments, depreciation, impairment and tax entries. 6. Review unusual balances, estimates, related parties and subsequent events. 7. Prepare statements and cash-flow reconciliation. 8. Obtain independent review, approve disclosures and lock the period with a documented audit trail.',
    crossFunctional: 'AP and Procurement support liabilities and GR/IR; AR and Sales support revenue, receivables and collections; Inventory/Operations support stock and cost of sales; Payroll supports employee costs; Fixed Assets supports additions and depreciation; Treasury supports bank, debt and cash flows; Tax supports current/deferred tax; Legal supports contingencies; FP&A explains performance; GL/R2R coordinates reporting and Audit reviews evidence.',
    formula: 'Profit = Revenue − Expenses. Working capital = Current assets − Current liabilities. Under the indirect cash-flow method, operating cash starts with profit and adjusts for non-cash items, working-capital movements and items classified elsewhere. Cash movement = Operating + Investing + Financing cash flows, subject to the applicable reporting framework.',
    assignment: 'Using a fictional company, classify 15 items into income statement, balance sheet or cash-flow statement: sales, cost of sales, receivables, supplier payables, equipment purchase, depreciation, loan proceeds, loan repayment, owner contribution, tax paid, inventory increase, customer receipt, accrued salary, prepaid insurance and interest paid. Explain the period/date dimension and any framework-dependent classification.',
    capstone: 'Prepare a simplified monthly reporting pack: adjusted trial balance, income statement, balance sheet, cash-flow bridge, bank/AR/AP reconciliations, variance commentary, key judgements, disclosure checklist and reviewer sign-off. Demonstrate that assets equal liabilities plus equity and explain profit-to-cash differences.',
    notes: {
      'English': 'The income statement measures performance over a period, the balance sheet shows position at a date, and the cash-flow statement explains movements in cash. Read them together.',
      'Telugu': 'ఆదాయ నివేదిక ఒక కాలానికి సంబంధించిన పనితీరును చూపుతుంది; బ్యాలెన్స్ షీట్ ఒక తేదీ నాటికి ఆర్థిక స్థితిని చూపుతుంది; నగదు ప్రవాహ నివేదిక నగదు మార్పులను వివరిస్తుంది. ఈ మూడు నివేదికలను కలిపి పరిశీలించాలి.',
      'Hindi': 'आय विवरण एक अवधि का प्रदर्शन बताता है, बैलेंस शीट एक तारीख की वित्तीय स्थिति दिखाती है और नकदी प्रवाह विवरण नकदी में हुए बदलाव समझाता है। तीनों विवरणों को साथ पढ़ना चाहिए.'
    },
    flashcards: [
      {'q':'What does the income statement report?','a':'Financial performance over a period: income, expenses and profit or loss.'},
      {'q':'What does the balance sheet report?','a':'Assets, liabilities and equity at a reporting date.'},
      {'q':'What are the three cash-flow categories?','a':'Operating, investing and financing activities.'},
      {'q':'Why can profit differ from operating cash?','a':'Accruals, non-cash items and working-capital timing cause differences.'},
      {'q':'What is cut-off testing?','a':'Checking that transactions are recorded in the correct reporting period.'},
      {'q':'Why lock a reporting period?','a':'To prevent unauthorised changes after review and preserve a controlled audit trail.'}
    ],
    questions: [
      AccountingQuestion('Which statement presents assets, liabilities and equity at a specific date?', ['Income statement','Balance sheet','Cash-flow statement','Budget report'], 1, 'The balance sheet reports financial position at the reporting date.'),
      AccountingQuestion('Which is a common reason profit differs from operating cash?', ['Working-capital movements and non-cash items','The balance sheet is always cash-based','All revenue is collected immediately','Depreciation creates a cash payment'], 0, 'Accrual accounting, working-capital movements and non-cash expenses explain differences.'),
      AccountingQuestion('Purchase of equipment for cash is generally classified as:', ['Operating cash flow in every case','Investing cash flow','Financing cash flow','Revenue'], 1, 'Acquisition of long-term productive assets is generally an investing activity, subject to applicable standards and facts.'),
      AccountingQuestion('What is the purpose of period cut-off?', ['Record transactions in the correct reporting period','Delay all invoices','Make cash equal profit','Remove estimates'], 0, 'Cut-off helps ensure income, expenses, assets and liabilities are recorded in the appropriate period.'),
      AccountingQuestion('Which is an essential close control?', ['Posting unsupported journals to meet deadline','Reconciling subledgers to the GL with evidence and independent review','Deleting old reconciling items','Ignoring post-close corrections'], 1, 'A controlled close requires reconciliations, evidence, review and documented resolution of exceptions.')
    ],
  ),
];
