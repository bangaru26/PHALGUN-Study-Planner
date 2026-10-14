import { chromium } from 'playwright';

const base = (process.env.PHALGUN_BASE_URL || 'https://bangaru26.github.io/PHALGUN-Study-Planner').replace(/\/$/, '');
const failures = [];
const passed = [];
const check = (condition, label, detail = '') => {
  if (condition) { passed.push(label); console.log('PASS:', label); }
  else { failures.push(label + (detail ? ' — ' + detail : '')); console.error('FAIL:', label, detail); }
};
const visible = async (page, selector) => page.locator(selector).first().isVisible().catch(() => false);
const count = async (page, selector) => page.locator(selector).count().catch(() => 0);
const wait = ms => new Promise(resolve => setTimeout(resolve, ms));
const timerLayout = async (page, containerSelector, viewportWidth) => page.locator(containerSelector).evaluate(el => {
  const css = getComputedStyle(el);
  const buttons = [...el.querySelectorAll('button')].map(b => {
    const r = b.getBoundingClientRect();
    return {x:r.x,y:r.y,width:r.width,height:r.height,visible:r.width>0&&r.height>0};
  });
  const cols = css.gridTemplateColumns.trim().split(/\s+/).length;
  const rows = [...new Set(buttons.map(b => Math.round(b.y)))].length;
  const widths = buttons.map(b => b.width);
  return {display:css.display,cols,rows,buttons,widthSpread:widths.length?Math.max(...widths)-Math.min(...widths):Infinity};
}).then(layout => ({...layout,expectedCols:viewportWidth<=650?2:4,
  ok:layout.display==='grid'&&layout.buttons.length===4&&layout.buttons.every(b=>b.visible)&&
      layout.cols===(viewportWidth<=650?2:4)&&layout.rows===(viewportWidth<=650?2:1)&&layout.widthSpread<=2
})).catch(error=>({ok:false,error:String(error)}));

const browser = await chromium.launch({ headless: true });
try {
  for (const viewport of [{name:'desktop',width:1365,height:900},{name:'mobile',width:390,height:844}]) {
    const context = await browser.newContext({ viewport: { width: viewport.width, height: viewport.height } });
    const page = await context.newPage();
    const pageErrors = [];
    page.on('pageerror', error => pageErrors.push(error.message));
    page.on('console', msg => { if (msg.type() === 'error' && !/favicon|ERR_BLOCKED_BY_CLIENT/i.test(msg.text())) pageErrors.push('console: ' + msg.text()); });

    await page.goto(base + '/index.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
    await page.locator('#lessonList .lesson').first().waitFor({ state: 'visible', timeout: 15000 }).catch(() => {});
    check(await visible(page, 'h1') && (await page.locator('h1').innerText()).includes('Study Desk'), viewport.name + ': home page loads');
    check(await count(page, '#lessonList .lesson') >= 12, viewport.name + ': twelve finance lessons are rendered', 'found ' + await count(page, '#lessonList .lesson'));
    const homeTimerLayout = await timerLayout(page, '#studyTopRow .stopwatch-card>.buttons', viewport.width);
    check(homeTimerLayout.ok, viewport.name + ': timer buttons share aligned equal-width grid', JSON.stringify(homeTimerLayout));
    check(await count(page, '#studyTopRow .brand-icons img') >= 2, viewport.name + ': approved AAROH and Study Desk icon assets are referenced');
    const iconStatus = await page.locator('#studyTopRow .brand-icons img').evaluateAll(imgs => imgs.map(img => ({src:img.getAttribute('src'),loaded:img.complete && img.naturalWidth > 0})));
    check(iconStatus.length >= 2 && iconStatus.every(i => i.loaded) && iconStatus.some(i => /aaroh-symbol\.jpg/.test(i.src)) && iconStatus.some(i => /study-planner-icon\.webp/.test(i.src)), viewport.name + ': approved icon images load', JSON.stringify(iconStatus));

    const search = page.locator('#globalSearch');
    await search.fill('Accounting Equation');
    await wait(350);
    check((await page.locator('#globalResults').innerText().catch(() => '')).trim().length > 0, viewport.name + ': global search returns matching content');
    await search.fill('');

    const timer = page.locator('#clock');
    const before = (await timer.innerText()).trim();
    await page.locator('#startTimer').click();
    await wait(1250);
    const after = (await timer.innerText()).trim();
    check(after !== before && await page.locator('#pauseTimer').isEnabled(), viewport.name + ': home timer starts and advances', before + ' → ' + after);
    await page.locator('#pauseTimer').click();
    const paused = (await timer.innerText()).trim();
    await wait(900);
    check((await timer.innerText()).trim() === paused, viewport.name + ': pause freezes elapsed time');
    await page.locator('#finishTimer').click();
    check(await page.locator('#finishTimer').isDisabled() && (await page.locator('#timerStatus').innerText()).toLowerCase().includes('saved'), viewport.name + ': Stop & Save completes session', await page.locator('#timerStatus').innerText().catch(() => ''));
    check(await page.evaluate(() => { const d=JSON.parse(localStorage.getItem('aaroh-study-desk-v2')||'{}'); return Array.isArray(d.sessions) && d.sessions.length > 0; }), viewport.name + ': timer session persists in local storage');

    await page.getByRole('tab', { name: /Study · Progress · Assess/ }).click();
    await page.locator('#assessmentSection').waitFor({ state: 'visible', timeout: 5000 }).catch(() => {});
    const questions = page.locator('#quiz .question');
    check(await questions.count() >= 4, viewport.name + ': lesson assessment contains at least four questions', 'found ' + await questions.count());
    let allLessonsHaveQuizzes = true;
    const lessonTiles = page.locator('#lessonList .lesson');
    for (let lessonIndex=0; lessonIndex<await lessonTiles.count(); lessonIndex++) {
      await lessonTiles.nth(lessonIndex).click();
      await wait(60);
      if (await page.locator('#quiz .question').count() < 4) allLessonsHaveQuizzes = false;
    }
    check(allLessonsHaveQuizzes, viewport.name + ': every finance lesson has at least four assessment questions');
    await lessonTiles.first().click();
    await wait(60);
    check(await questions.first().isVisible().catch(() => false), viewport.name + ': assessment questions are visible');
    if (await questions.count() >= 4) {
      const firstRadio = questions.first().locator('input[type=radio]').first();
      await firstRadio.check({ force: true }).catch(() => {});
      await page.locator('#submitQuiz').click();
      check(await page.locator('#quizFeedback').isVisible().catch(() => false), viewport.name + ': assessment submits and displays feedback');
    }

    await page.getByRole('tab', { name: 'My Notes' }).click();
    await page.locator('#addNote').click();
    check(await count(page, '#notesList .my-note') >= 1, viewport.name + ': new note can be created');
    check(await visible(page, '#notesList .my-note-text'), viewport.name + ': note editor is visible');

    const searchBox = await page.locator('#globalSearch').boundingBox();
    const timerBox = await page.locator('.stopwatch-card').boundingBox();
    if (searchBox && timerBox) {
      const overlap = searchBox.x < timerBox.x + timerBox.width && searchBox.x + searchBox.width > timerBox.x && searchBox.y < timerBox.y + timerBox.height && searchBox.y + searchBox.height > timerBox.y;
      check(!overlap, viewport.name + ': global search does not overlap the stopwatch', JSON.stringify({searchBox,timerBox}));
    } else check(false, viewport.name + ': search and stopwatch have measurable layout boxes');

    check(pageErrors.length === 0, viewport.name + ': no uncaught browser/console errors', pageErrors.join(' | '));
    await context.close();
  }

  const context = await browser.newContext({ viewport: { width: 1365, height: 900 } });
  const page = await context.newPage();
  const errors = [];
  page.on('pageerror', e => errors.push(e.message));

  await page.goto(base + '/dictionary.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check(await visible(page, '#sharedClock') && await visible(page, '#sharedStart'), 'dictionary: shared timer and controls are visible');
  check(await visible(page, '#globalSearch'), 'dictionary: global search is visible');
  check(await count(page, '.term') > 0, 'dictionary: terms render', 'found ' + await count(page, '.term'));
  const dictionaryTimerLayout = await timerLayout(page, '.shared-commandbar .shared-stopwatch>.buttons', 1365);
  check(dictionaryTimerLayout.ok, 'dictionary: timer controls use aligned equal-width grid', JSON.stringify(dictionaryTimerLayout));
  const dictStart = (await page.locator('#sharedClock').innerText()).trim();
  await page.locator('#sharedStart').click(); await wait(1200);
  const dictRunning = (await page.locator('#sharedClock').innerText()).trim();
  check(dictRunning !== dictStart && await page.locator('#sharedPause').isEnabled(), 'dictionary: timer starts and advances', dictStart + ' → ' + dictRunning);
  await page.locator('#sharedPause').click();
  await page.locator('#sharedStop').click();
  check(await page.locator('#sharedStop').isDisabled(), 'dictionary: Stop & Save resets controls');
  check(await page.evaluate(() => {const d=JSON.parse(localStorage.getItem('aaroh-study-desk-v2')||'{}'); return Array.isArray(d.sessions)&&d.sessions.some(s=>s.topic==='Subject Dictionary');}), 'dictionary: Stop & Save records a session');
  await page.setViewportSize({width:390,height:844});
  await page.reload({waitUntil:'networkidle'});
  const dictionaryMobileLayout = await timerLayout(page, '.shared-commandbar .shared-stopwatch>.buttons', 390);
  check(dictionaryMobileLayout.ok, 'dictionary: mobile timer controls remain aligned', JSON.stringify(dictionaryMobileLayout));

  await page.setViewportSize({width:1365,height:900});
  await page.goto(base + '/excel-practice.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check(await visible(page, '#sharedClock') && await visible(page, '#sharedStart'), 'Excel practice: shared timer and controls are visible');
  check(await visible(page, '#globalSearch'), 'Excel practice: global search is visible');
  check(await visible(page, '#formulaTitle') && (await page.locator('#formulaTitle').innerText()).trim().length > 0, 'Excel practice: formula lesson is loaded');
  check(await count(page, '.exercise') > 0, 'Excel practice: exercises render', 'found ' + await count(page, '.exercise'));
  const excelTimerLayout = await timerLayout(page, '.shared-commandbar .shared-stopwatch>.buttons', 1365);
  check(excelTimerLayout.ok, 'Excel practice: timer controls use aligned equal-width grid', JSON.stringify(excelTimerLayout));
  await page.locator('#sharedStart').click(); await wait(1200);
  check((await page.locator('#sharedClock').innerText()).trim() !== '00:00:00', 'Excel practice: timer advances');
  await page.locator('#sharedPause').click();
  await page.locator('#sharedStop').click();
  check(await page.evaluate(() => {const d=JSON.parse(localStorage.getItem('aaroh-study-desk-v2')||'{}'); return Array.isArray(d.sessions)&&d.sessions.some(s=>s.topic==='Excel Formula Practice');}), 'Excel practice: Stop & Save records a session');
  await page.locator('#checkAnswers').click();
  check((await page.locator('#practiceFeedback').innerText().catch(() => '')).trim().length > 0, 'Excel practice: answer checking produces feedback');
  await page.setViewportSize({width:390,height:844});
  await page.reload({waitUntil:'networkidle'});
  const excelMobileLayout = await timerLayout(page, '.shared-commandbar .shared-stopwatch>.buttons', 390);
  check(excelMobileLayout.ok, 'Excel practice: mobile timer controls remain aligned', JSON.stringify(excelMobileLayout));
  check(errors.length === 0, 'dictionary/Excel pages: no uncaught page errors', errors.join(' | '));
  await context.close();

  const curriculum = await browser.newPage({ viewport: { width: 1365, height: 900 } });
  await curriculum.goto(base + '/phalgun-curriculum.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check(await count(curriculum, '#catalog .card') >= 18, 'PHALGUN curriculum: learning catalogue renders', 'found ' + await count(curriculum, '#catalog .card'));
  await curriculum.locator('#q').fill('CMA USA'); await wait(300);
  check((await curriculum.locator('#catalog').innerText()).toLowerCase().includes('cma'), 'PHALGUN curriculum: subject search filters catalogue');
  await curriculum.close();

  const monitor = await browser.newPage();
  await monitor.goto(base + '/monitoring.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  await monitor.waitForFunction(() => !document.querySelector('#summary')?.innerText.includes('First baseline'), { timeout: 10000 }).catch(() => {});
  check((await monitor.locator('#summary').innerText()).includes('First baseline'), 'monitoring: latest report loads into dashboard');
  check((await monitor.locator('#results').innerText()).length > 0, 'monitoring: source results render');
  await monitor.close();
} catch (error) {
  failures.push('Test runner error: ' + (error?.stack || error));
  console.error(error);
} finally {
  await browser.close();
}
console.log('\nRESULT: ' + passed.length + ' passed; ' + failures.length + ' failed');
if (failures.length) { console.error(failures.map((f,i)=>(i+1)+'. '+f).join('\n')); process.exitCode = 1; }
