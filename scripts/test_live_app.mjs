import { chromium } from 'playwright';
import { readFile } from 'node:fs/promises';

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

const browser = await chromium.launch({ headless: true, ...(process.env.CHROME_PATH ? { executablePath: process.env.CHROME_PATH } : {}) });
try {
  for (const viewport of [{name:'desktop',width:1365,height:900},{name:'mobile',width:390,height:844}]) {
    const context = await browser.newContext({ viewport: { width: viewport.width, height: viewport.height } });
    const page = await context.newPage();
    const pageErrors = [];
    page.on('pageerror', error => pageErrors.push('pageerror: ' + error.message));
    page.on('requestfailed', request => pageErrors.push('request failed: ' + request.url() + ' — ' + (request.failure()?.errorText || 'unknown')));
    page.on('response', response => { if (response.status() >= 400) pageErrors.push('HTTP ' + response.status() + ': ' + response.url()); });
    page.on('console', msg => { if (msg.type() === 'error' && !/favicon|ERR_BLOCKED_BY_CLIENT/i.test(msg.text())) pageErrors.push('console: ' + msg.text() + (msg.location()?.url ? ' @ ' + msg.location().url : '')); });

    await page.goto(base + '/index.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
    await page.locator('#lessonList .lesson').first().waitFor({ state: 'visible', timeout: 15000 }).catch(() => {});
    check(await visible(page, 'h1') && (await page.locator('h1').innerText()).includes('Study Desk'), viewport.name + ': home page loads');
    check(await count(page, '#lessonList .lesson') >= 13, viewport.name + ': thirteen finance lessons are rendered', 'found ' + await count(page, '#lessonList .lesson'));
    check((await page.locator('#courseProgress').innerText()).includes('of 13 lessons passed'), viewport.name + ': progress counter matches the 13-lesson curriculum', await page.locator('#courseProgress').innerText());
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

    await page.getByRole('tab', { name: 'Backup' }).click();
    const beforeInvalidRestore = await page.evaluate(() => {
      const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
      return {
        sessions: JSON.stringify(d.sessions || []),
        lesson: d.currentLesson,
        notes: JSON.stringify(d.notes || {}),
        myNotes: JSON.stringify(d.myNotes || []),
        results: JSON.stringify(d.results || {}),
        plan: JSON.stringify(d.plan || {})
      };
    });
    await page.locator('#importFile').setInputFiles({name:'malformed-study-desk-backup.json',mimeType:'application/json',buffer:Buffer.from(JSON.stringify({version:2,sessions:[],notes:[],results:{},plan:{}}))});
    await page.locator('#importBackup').click();
    await page.waitForFunction(() => (document.querySelector('#backupFeedback')?.innerText || '').includes('Could not restore backup:'), { timeout: 5000 }).catch(() => {});
    check((await page.locator('#backupFeedback').innerText()).includes('valid Study Desk v2 backup'), viewport.name + ': malformed backup is rejected with a clear message');
    const afterInvalidRestore = await page.evaluate(() => {
      const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
      return {
        sessions: JSON.stringify(d.sessions || []),
        lesson: d.currentLesson,
        notes: JSON.stringify(d.notes || {}),
        myNotes: JSON.stringify(d.myNotes || []),
        results: JSON.stringify(d.results || {}),
        plan: JSON.stringify(d.plan || {})
      };
    });
    check(JSON.stringify(afterInvalidRestore)===JSON.stringify(beforeInvalidRestore), viewport.name + ': rejected backup leaves existing progress unchanged', JSON.stringify({beforeInvalidRestore,afterInvalidRestore}));

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
    await lessonTiles.last().click();
    check((await page.locator('#lessonTitle').innerText()).includes('Indian Tax & Compliance'), viewport.name + ': tax and compliance lesson opens');
    check((await page.locator('#lessonBody').innerText()).includes('Income-tax Act, 2025'), viewport.name + ': tax lesson includes the current source-checking note');
    await lessonTiles.first().click();
    await wait(60);
    check(await questions.first().isVisible().catch(() => false), viewport.name + ': assessment questions are visible');
    if (await questions.count() >= 4) {
      for (let questionIndex = 0; questionIndex < await questions.count(); questionIndex++) {
        const firstRadio = questions.nth(questionIndex).locator('input[type=radio]').first();
        await firstRadio.check({ force: true }).catch(() => {});
      }
      await page.locator('#submitQuiz').click();
      check(await page.locator('#quizFeedback').isVisible().catch(() => false), viewport.name + ': assessment submits and displays feedback');
      const quizResultSaved = await page.evaluate(() => {
        try {
          const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
          const result = d.results?.['acct-equation'];
          return !!result && Number.isFinite(result.score) && result.total >= 4 &&
            Number.isFinite(result.attempts) && result.attempts >= 1;
        } catch { return false; }
      });
      check(quizResultSaved, viewport.name + ': submitted quiz score and attempt count save locally');
    }

    await page.getByRole('tab', { name: 'My Notes' }).click();
    await page.locator('#addNote').click();
    check(await count(page, '#notesList .my-note') >= 1, viewport.name + ': new note can be created');
    check(await visible(page, '#notesList .my-note-text'), viewport.name + ': note editor is visible');
    const persistenceNote = 'PHALGUN persistence check ' + viewport.name + ' ' + Date.now();
    await page.locator('#notesList .my-note-text').first().fill(persistenceNote);
    await page.waitForFunction(expected => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return Array.isArray(d.myNotes) && d.myNotes.some(n => n.text === expected);
      } catch { return false; }
    }, persistenceNote, { timeout: 5000 }).catch(() => {});
    check(await page.evaluate(expected => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return Array.isArray(d.myNotes) && d.myNotes.some(n => n.text === expected);
      } catch { return false; }
    }, persistenceNote), viewport.name + ': note text is saved to local storage');
    const sessionHistoryBeforeReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify(Array.isArray(d.sessions) ? d.sessions : []);
      } catch { return 'invalid'; }
    });
    await page.reload({ waitUntil: 'networkidle', timeout: 60000 });
    const sessionHistoryAfterReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify(Array.isArray(d.sessions) ? d.sessions : []);
      } catch { return 'invalid'; }
    });
    check(sessionHistoryBeforeReload !== 'invalid' && sessionHistoryAfterReload === sessionHistoryBeforeReload,
      viewport.name + ': study-session history survives page reload');
    const quizResultSurvivedReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        const result = d.results?.['acct-equation'];
        return !!result && Number.isFinite(result.score) && result.total >= 4 &&
          Number.isFinite(result.attempts) && result.attempts >= 1;
      } catch { return false; }
    });
    check(quizResultSurvivedReload, viewport.name + ': quiz score and attempt count survive page reload');
    await page.getByRole('tab', { name: 'My Notes' }).click();
    check(await page.locator('#notesList .my-note-text').first().inputValue().catch(() => '') === persistenceNote,
      viewport.name + ': note text survives page reload');

    // Restore a valid, isolated fixture and verify the important progress records survive import.
    const restoredNoteText = 'Restored backup note ' + viewport.name;
    const restoredSessionTopic = 'Backup restore probe ' + viewport.name;
    const validBackup = {
      version: 2,
      currentLesson: 'acct-equation',
      sessions: [{ id: 'backup-session', date: '2026-10-23', topic: restoredSessionTopic,
        lessonId: 'acct-equation', start: '09:00', end: '09:07', minutes: 7,
        status: 'Practised', notes: 'Regression fixture' }],
      notes: { 'acct-equation': 'Restored lesson note ' + viewport.name },
      myNotes: [{ id: 'backup-note', title: 'Restored test note', text: restoredNoteText, updated: 'Test fixture' }],
      results: { 'acct-equation': { score: 4, total: 4, passed: true, date: '23/10/2026', attempts: 2 } },
      plan: { dailyTarget: 330, weeklyTarget: 16, planStart: '2026-10-23', planEnd: '2026-11-30', schedule: 'Weekdays 6:00–7:00 AM' }
    };
    await page.getByRole('tab', { name: 'Backup' }).click();
    page.once('dialog', dialog => dialog.accept());
    await page.locator('#importFile').setInputFiles({
      name: 'valid-study-desk-backup.json',
      mimeType: 'application/json',
      buffer: Buffer.from(JSON.stringify(validBackup))
    });
    await page.locator('#importBackup').click();
    await page.waitForFunction(() => (document.querySelector('#backupFeedback')?.innerText || '').includes('Backup restored successfully'), { timeout: 5000 }).catch(() => {});
    check((await page.locator('#backupFeedback').innerText()).includes('Backup restored successfully'),
      viewport.name + ': valid backup restores successfully');
    const restoredState = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return { notes: d.notes || {}, myNotes: d.myNotes || [], sessions: d.sessions || [],
          results: d.results || {}, plan: d.plan || {} };
      } catch { return {}; }
    });
    check(restoredState.notes?.['acct-equation'] === validBackup.notes['acct-equation'],
      viewport.name + ': backup restores lesson notes');
    check(restoredState.myNotes?.some(n => n.text === restoredNoteText),
      viewport.name + ': backup restores personal notes');
    check(restoredState.sessions?.some(s => s.topic === restoredSessionTopic && s.minutes === 7),
      viewport.name + ': backup restores study session history');
    check(restoredState.results?.['acct-equation']?.score === 4 &&
      restoredState.results?.['acct-equation']?.passed === true,
      viewport.name + ': backup restores quiz score and pass status');
    check(restoredState.plan?.dailyTarget === 330 && restoredState.plan?.weeklyTarget === 16 &&
      restoredState.plan?.planStart === '2026-10-23' && restoredState.plan?.planEnd === '2026-11-30' &&
      restoredState.plan?.schedule === 'Weekdays 6:00–7:00 AM',
      viewport.name + ': backup restores study targets, dates, and timetable');

    const restoredPlanBeforeReload = JSON.stringify(restoredState.plan);
    await page.reload({ waitUntil: 'networkidle', timeout: 60000 });
    const restoredPlanAfterReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify(d.plan || {});
      } catch { return 'invalid'; }
    });
    check(restoredPlanAfterReload !== 'invalid' && restoredPlanAfterReload === restoredPlanBeforeReload,
      viewport.name + ': study-plan targets, dates, and timetable survive page reload');

    const fullBackupBeforeReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify({
          sessions: d.sessions || [],
          notes: d.notes || {},
          myNotes: d.myNotes || [],
          results: d.results || {},
          plan: d.plan || {},
          currentLesson: d.currentLesson
        });
      } catch { return 'invalid'; }
    });
    await page.reload({ waitUntil: 'networkidle', timeout: 60000 });
    const fullBackupAfterReload = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify({
          sessions: d.sessions || [],
          notes: d.notes || {},
          myNotes: d.myNotes || [],
          results: d.results || {},
          plan: d.plan || {},
          currentLesson: d.currentLesson
        });
      } catch { return 'invalid'; }
    });
    check(fullBackupBeforeReload !== 'invalid' && fullBackupAfterReload === fullBackupBeforeReload,
      viewport.name + ': complete learning progress snapshot survives page reload');

    const backupStateBeforeTabNavigation = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify({
          sessions: d.sessions || [],
          notes: d.notes || {},
          myNotes: d.myNotes || [],
          results: d.results || {},
          plan: d.plan || {},
          currentLesson: d.currentLesson
        });
      } catch { return 'invalid'; }
    });
    await page.getByRole('tab', { name: 'Learn & Practise' }).click();
    await page.getByRole('tab', { name: 'Backup' }).click();
    const backupStateAfterTabNavigation = await page.evaluate(() => {
      try {
        const d = JSON.parse(localStorage.getItem('aaroh-study-desk-v2') || '{}');
        return JSON.stringify({
          sessions: d.sessions || [],
          notes: d.notes || {},
          myNotes: d.myNotes || [],
          results: d.results || {},
          plan: d.plan || {},
          currentLesson: d.currentLesson
        });
      } catch { return 'invalid'; }
    });
    check(backupStateBeforeTabNavigation !== 'invalid' &&
      backupStateAfterTabNavigation === backupStateBeforeTabNavigation,
      viewport.name + ': switching tabs preserves complete learning progress');


    // Export the restored state and verify the downloaded file is a portable, readable backup.
    await page.getByRole('tab', { name: /Study.*Progress.*Assess/ }).click();
    const [backupDownload] = await Promise.all([
      page.waitForEvent('download', { timeout: 10000 }),
      page.locator('#exportJson').click()
    ]);
    check(backupDownload.suggestedFilename() === 'aaroh-study-desk-backup.json',
      viewport.name + ': full progress backup downloads with expected filename', backupDownload.suggestedFilename());
    let exportedBackup = null;
    try {
      const exportedPath = await backupDownload.path();
      if (exportedPath) exportedBackup = JSON.parse(await readFile(exportedPath, 'utf8'));
    } catch {}
    check(exportedBackup?.version === 2, viewport.name + ': exported backup is valid JSON with v2 schema');
    check(exportedBackup?.notes?.['acct-equation'] === validBackup.notes['acct-equation'] &&
      exportedBackup?.myNotes?.some(n => n.text === restoredNoteText),
      viewport.name + ': exported backup includes lesson and personal notes');
    check(exportedBackup?.sessions?.some(s => s.topic === restoredSessionTopic && s.minutes === 7),
      viewport.name + ': exported backup includes restored study-session history');
    check(exportedBackup?.results?.['acct-equation']?.score === 4 &&
      exportedBackup?.results?.['acct-equation']?.passed === true,
      viewport.name + ': exported backup preserves quiz score and pass status');
    check(exportedBackup?.plan?.dailyTarget === 330 && exportedBackup?.plan?.weeklyTarget === 16 &&
      exportedBackup?.plan?.planStart === '2026-10-23' && exportedBackup?.plan?.planEnd === '2026-11-30' &&
      exportedBackup?.plan?.schedule === 'Weekdays 6:00–7:00 AM',
      viewport.name + ': exported backup preserves study targets, dates, and timetable');

    const searchBox = await page.locator('#globalSearch').boundingBox();
    const timerBox = await page.locator('.stopwatch-card').boundingBox();
    if (searchBox && timerBox) {
      const overlap = searchBox.x < timerBox.x + timerBox.width && searchBox.x + searchBox.width > timerBox.x && searchBox.y < timerBox.y + timerBox.height && searchBox.y + searchBox.height > timerBox.y;
      check(!overlap, viewport.name + ': global search does not overlap the stopwatch', JSON.stringify({searchBox,timerBox}));
    } else check(false, viewport.name + ': search and stopwatch have measurable layout boxes');

    // Verify the app shell can reopen when the browser is offline after a successful visit.
    const workerReady = await page.evaluate(async () => {
      if (!('serviceWorker' in navigator)) return false;
      try {
        const registration = await navigator.serviceWorker.ready;
        return !!registration.active;
      } catch { return false; }
    }).catch(() => false);
    check(workerReady, viewport.name + ': service worker becomes active');
    if (workerReady) {
      await page.reload({ waitUntil: 'networkidle', timeout: 60000 }).catch(() => {});
      const controlled = await page.evaluate(() => !!navigator.serviceWorker?.controller).catch(() => false);
      check(controlled, viewport.name + ': page is controlled by the service worker');
      const shellCached = await page.evaluate(async () => !!(await caches.match('./index.html'))).catch(() => false);
      check(shellCached, viewport.name + ': offline app shell is cached');
      if (controlled && shellCached) {
        await context.setOffline(true);
        let offlineLoaded = false;
        try {
          await page.goto(base + '/index.html?offline-e2e=' + Date.now(), { waitUntil: 'domcontentloaded', timeout: 15000 });
          offlineLoaded = await visible(page, 'h1') && (await page.locator('h1').innerText()).includes('Study Desk');
        } catch {}
        check(offlineLoaded, viewport.name + ': Study Desk opens from cache while offline');
        await context.setOffline(false);
        // Cache a second navigation target, then prove offline routing returns that page,
        // not the Study Desk index shell accidentally stored under every navigation.
        const dictionaryUrl = base + '/dictionary.html';
        await page.goto(dictionaryUrl, { waitUntil: 'domcontentloaded', timeout: 60000 }).catch(() => {});
        await page.locator('h1').waitFor({ state: 'visible', timeout: 10000 }).catch(() => {});
        const dictionaryHeading = await page.locator('h1').innerText().catch(() => '');
        const dictionaryOnline = dictionaryHeading.includes('Subject Dictionary');
        const dictionaryCacheDiagnostics = await page.evaluate(async () => {
          const registration = await navigator.serviceWorker.ready;
          const cacheNames = await caches.keys();
          const cache = await caches.open('study-desk-v13');
          const keys = (await cache.keys()).map(request => new URL(request.url).pathname);
          const scope = registration.scope;
          const expected = new URL('dictionary.html', scope).href;
          const match = await cache.match(expected, {ignoreSearch:true});
          const cachedText = match ? await match.clone().text() : '';
          const cachedTitle = cachedText.match(/<title[^>]*>([\s\S]*?)<\/title>/i)?.[1]?.replace(/\s+/g, ' ').trim() || null;
          const cachedH1 = cachedText.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i)?.[1]?.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim() || null;
          return {controller: navigator.serviceWorker.controller?.scriptURL || null, scope, cacheNames, dictionaryCached: !!match, dictionaryStatus: match?.status || null, cachedTitle, cachedH1, relevantKeys: keys.filter(path => /dictionary|index\\.html$/.test(path))};
        }).catch(error => ({error:String(error)}));
        console.log('DICTIONARY_CACHE_DIAGNOSTICS ' + viewport.name + ': ' + JSON.stringify(dictionaryCacheDiagnostics));
        check(dictionaryOnline, viewport.name + ': dictionary page loads online before offline test',
          JSON.stringify({ url: page.url(), heading: dictionaryHeading, body: (await page.locator('body').innerText().catch(() => '')).slice(0, 180) }));
        if (dictionaryOnline) {
          await context.setOffline(true);
          let dictionaryOffline = false;
          let offlineDictionaryEvidence = {};
          try {
            // The service worker must ignore cache-busting query strings for pre-cached pages.
            // A new query string forces a fresh navigation. The shared shell can contain
            // its own H1, so validate the document title and actual dictionary terms,
            // not the first H1 (which may belong to the shared Study Desk header).
            const offlineUrl = dictionaryUrl + '?offline-e2e=' + Date.now();
            await page.goto(offlineUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
            await page.waitForFunction(() =>
              document.title.includes('Subject Dictionary') &&
              document.querySelectorAll('.term').length > 0,
              null,
              { timeout: 5000 }
            );
            offlineDictionaryEvidence = await page.evaluate(() => ({
              title: document.title,
              termCount: document.querySelectorAll('.term').length,
              path: location.pathname,
              query: location.search
            }));
            dictionaryOffline = new URL(page.url()).pathname.endsWith('/dictionary.html') &&
              new URL(page.url()).searchParams.has('offline-e2e') &&
              offlineDictionaryEvidence.title.includes('Subject Dictionary') &&
              offlineDictionaryEvidence.termCount > 0;
          } catch (error) {
            offlineDictionaryEvidence.error = String(error);
          }
          check(dictionaryOffline, viewport.name + ': offline navigation returns cached dictionary page',
            JSON.stringify({ url: page.url(), ...offlineDictionaryEvidence }));
          await context.setOffline(false);
        }
      }
    }

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
  await page.locator('#sharedStart').click(); await wait(2200);
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
  // Cross-page continuity: an active timer must survive navigation from the dictionary to formula practice.
  await page.locator('#sharedStart').click(); await wait(1200);
  const dictionaryClockBeforeNavigation = (await page.locator('#sharedClock').innerText()).trim();
  await page.goto(base + '/excel-practice.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  const excelClockAfterNavigation = (await page.locator('#sharedClock').innerText()).trim();
  check(excelClockAfterNavigation !== '00:00:00' && await page.locator('#sharedPause').isEnabled(),
    'Excel practice: active shared timer survives navigation from dictionary',
    dictionaryClockBeforeNavigation + ' → ' + excelClockAfterNavigation);
  await wait(1200);
  const excelClockContinued = (await page.locator('#sharedClock').innerText()).trim();
  check(excelClockContinued !== excelClockAfterNavigation,
    'Excel practice: shared timer continues advancing after cross-page navigation',
    excelClockAfterNavigation + ' → ' + excelClockContinued);

  // Reverse navigation must preserve the same active session too.
  await page.goto(base + '/dictionary.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  const dictionaryClockAfterReturn = (await page.locator('#sharedClock').innerText()).trim();
  check(dictionaryClockAfterReturn !== '00:00:00' && await page.locator('#sharedPause').isEnabled(),
    'Dictionary: active shared timer survives return from Excel practice',
    excelClockContinued + ' → ' + dictionaryClockAfterReturn);
  await wait(1200);
  const dictionaryClockContinued = (await page.locator('#sharedClock').innerText()).trim();
  check(dictionaryClockContinued !== dictionaryClockAfterReturn,
    'Dictionary: shared timer continues advancing after return navigation',
    dictionaryClockAfterReturn + ' → ' + dictionaryClockContinued);
  await page.locator('#sharedPause').click();
  await page.locator('#sharedStop').click();
  await page.goto(base + '/excel-practice.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check(await visible(page, '#sharedClock') && await visible(page, '#sharedStart'), 'Excel practice: shared timer and controls are visible');
  check(await visible(page, '#globalSearch'), 'Excel practice: global search is visible');
  check(await visible(page, '#formulaTitle') && (await page.locator('#formulaTitle').innerText()).trim().length > 0, 'Excel practice: formula lesson is loaded');
  check(await count(page, '.exercise') > 0, 'Excel practice: exercises render', 'found ' + await count(page, '.exercise'));
  const formulaCount = await page.evaluate(() => Array.isArray(window.formulas) ? window.formulas.length : 0);
  check(formulaCount >= 14, 'Excel practice: at least fourteen guided formula modules are available', 'found ' + formulaCount);
  let allFormulaModulesHaveExercises = formulaCount >= 14;
  for (let formulaIndex=0; formulaIndex<formulaCount; formulaIndex++) {
    await page.evaluate(i => window.selectFormula(i), formulaIndex);
    if (await count(page, '.exercise') < 1) allFormulaModulesHaveExercises = false;
  }
  check(allFormulaModulesHaveExercises, 'Excel practice: every formula module has exercises');
  await page.evaluate(() => window.selectFormula(0));
  const excelTimerLayout = await timerLayout(page, '.shared-commandbar .shared-stopwatch>.buttons', 1365);
  check(excelTimerLayout.ok, 'Excel practice: timer controls use aligned equal-width grid', JSON.stringify(excelTimerLayout));
  await page.locator('#sharedStart').click(); await wait(1200);
  check((await page.locator('#sharedClock').innerText()).trim() !== '00:00:00', 'Excel practice: timer advances');
  await page.locator('#sharedPause').click();
  await page.locator('#sharedStop').click();
  check(await page.evaluate(() => {const d=JSON.parse(localStorage.getItem('aaroh-study-desk-v2')||'{}'); return Array.isArray(d.sessions)&&d.sessions.some(s=>s.topic==='Excel Formula Practice');}), 'Excel practice: Stop & Save records a session');

  // Pause/resume and reload should preserve the elapsed time of the current shared session.
  await page.locator('#sharedStart').click(); await wait(1200);
  await page.locator('#sharedPause').click();
  const pausedClock = (await page.locator('#sharedClock').innerText()).trim();
  check(await page.locator('#sharedStart').isEnabled() && await page.locator('#sharedPause').isDisabled(),
    'Excel practice: pause switches timer controls to paused state');
  await wait(1200);
  const stillPausedClock = (await page.locator('#sharedClock').innerText()).trim();
  check(stillPausedClock === pausedClock,
    'Excel practice: paused timer does not accrue elapsed time', pausedClock + ' → ' + stillPausedClock);
  await page.reload({ waitUntil: 'networkidle' });
  const pausedClockAfterReload = (await page.locator('#sharedClock').innerText()).trim();
  check(pausedClockAfterReload === pausedClock && await page.locator('#sharedStart').isEnabled(),
    'Excel practice: paused timer state survives reload', pausedClock + ' → ' + pausedClockAfterReload);
  await page.locator('#sharedStart').click(); await wait(1200);
  const resumedClock = (await page.locator('#sharedClock').innerText()).trim();
  check(resumedClock !== pausedClockAfterReload && await page.locator('#sharedPause').isEnabled(),
    'Excel practice: paused timer resumes and advances', pausedClockAfterReload + ' → ' + resumedClock);
  await page.locator('#sharedStop').click();
  check(await page.locator('#sharedStop').isDisabled(), 'Excel practice: resumed session can be stopped and saved');

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
  check(await count(curriculum, '#real-world-case-method') === 1, 'PHALGUN curriculum: six-business-context teaching framework is present');
  check(await count(curriculum, '#languages-communication') === 1, 'PHALGUN curriculum: seven-language learning framework is present');
  const curriculumText = (await curriculum.locator('body').innerText()).toLowerCase();
  check(curriculumText.includes('internal audit') && curriculumText.includes('risk-based'), 'PHALGUN curriculum: Internal Audit and risk-based learning coverage is present');
  check(curriculumText.includes('german') && curriculumText.includes('spanish') && curriculumText.includes('french') && curriculumText.includes('telugu') && curriculumText.includes('punjabi'), 'PHALGUN curriculum: requested language pathways are represented');
  await curriculum.locator('#q').fill('CMA USA'); await wait(300);
  check((await curriculum.locator('#catalog').innerText()).toLowerCase().includes('cma'), 'PHALGUN curriculum: subject search filters catalogue');
  for (const term of ['IRM','CIA','CRMA','CISM']) {
    await curriculum.locator('#q').fill(term); await wait(150);
    const resultText = (await curriculum.locator('#catalog').innerText()).toLowerCase();
    check(resultText.includes(term.toLowerCase()), 'GFPA certification pathway is searchable: ' + term);
  }
  await curriculum.locator('#q').fill('Internal Audit'); await wait(150);
  check((await curriculum.locator('#catalog').innerText()).toLowerCase().includes('risk-based'), 'GFPA certification catalogue exposes risk-based Internal Audit learning');

  await curriculum.close();

  const gfpa = await browser.newPage({ viewport: { width: 1365, height: 900 } });
  const gfpaErrors = [];
  gfpa.on('pageerror', e => gfpaErrors.push(e.message));
  await gfpa.goto(base + '/gfpa.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check((await gfpa.locator('h1').innerText()).includes('GFPA'), 'GFPA academy: standalone page loads');
  check(await count(gfpa, '#catalog .card') >= 35, 'GFPA academy: broad module catalogue renders', 'found ' + await count(gfpa, '#catalog .card'));
  for (const term of ['Treasury','Excel','SAP','Tableau','Power BI','CIA','IRM']) {
    await gfpa.locator('#q').fill(term); await wait(120);
    check((await gfpa.locator('#catalog').innerText()).toLowerCase().includes(term.toLowerCase()), 'GFPA academy: searchable module ' + term);
  }
  await gfpa.locator('#q').fill('');
  await gfpa.locator('#treasuryAnswer').selectOption('610000');
  await gfpa.locator('#checkTreasury').click();
  check(await gfpa.locator('#global-accounting-compare').count() === 1, 'GFPA global accounting: US UK India comparison module renders');
  await gfpa.locator('#q').fill('US vs UK vs Indian Accounting');
  check((await gfpa.locator('#catalog').innerText()).includes('US vs UK vs Indian Accounting'), 'GFPA global accounting: comparison module is searchable');
  await gfpa.locator('#q').fill('');
  await gfpa.locator('#globalFrameworkAnswer').selectOption('basis'); await gfpa.locator('#checkGlobalFramework').click();
  check((await gfpa.locator('#globalFrameworkFeedback').innerText()).includes('Correct'), 'GFPA global accounting: framework selection answer is checked');
  await gfpa.locator('#globalInventoryAnswer').selectOption('difference'); await gfpa.locator('#checkGlobalInventory').click();
  check((await gfpa.locator('#globalInventoryFeedback').innerText()).includes('Correct'), 'GFPA global accounting: LIFO comparison answer is checked');
  await gfpa.locator('#globalTaxAnswer').selectOption('no'); await gfpa.locator('#checkGlobalTax').click();
  check((await gfpa.locator('#globalTaxFeedback').innerText()).includes('Correct'), 'GFPA global accounting: book-tax distinction answer is checked');
  check(await gfpa.locator('#month-end-close-lab').count() === 1, 'GFPA month-end close: reconciliation and accrual lesson renders');
  await gfpa.locator('#closeBankAnswer').selectOption('investigate'); await gfpa.locator('#checkCloseBank').click();
  check((await gfpa.locator('#closeBankFeedback').innerText()).includes('Correct'), 'GFPA month-end close: unexplained reconciliation difference blocks sign-off');
  await gfpa.locator('#closeAccrualAnswer').selectOption('debit-expense'); await gfpa.locator('#checkCloseAccrual').click();
  check((await gfpa.locator('#closeAccrualFeedback').innerText()).includes('Correct'), 'GFPA month-end close: accrued expense journal is checked');
  await gfpa.locator('#closeStatusAnswer').selectOption('blocked'); await gfpa.locator('#checkCloseStatus').click();
  check((await gfpa.locator('#closeStatusFeedback').innerText()).includes('Correct'), 'GFPA month-end close: sign-off status decision is checked');
  check(await gfpa.locator('#internal-audit-lab').count() === 1, 'GFPA internal audit: risk and control lesson renders');
  await gfpa.locator('#auditControlAnswer').selectOption('sample'); await gfpa.locator('#checkAuditControl').click();
  check((await gfpa.locator('#auditControlFeedback').innerText()).includes('Correct'), 'GFPA internal audit: operating-effectiveness test answer is checked');
  await gfpa.locator('#auditFindingAnswer').selectOption('validate'); await gfpa.locator('#checkAuditFinding').click();
  check((await gfpa.locator('#auditFindingFeedback').innerText()).includes('Correct'), 'GFPA internal audit: evidence-led finding response is checked');
  check(await gfpa.locator('#working-capital-lab').count() === 1, 'GFPA working capital: cash conversion cycle lesson renders');
  await gfpa.locator('#cccAnswer').selectOption('62'); await gfpa.locator('#checkCcc').click();
  check((await gfpa.locator('#cccFeedback').innerText()).includes('Correct'), 'GFPA working capital: current CCC calculation is checked');
  await gfpa.locator('#cccImprovedAnswer').selectOption('49'); await gfpa.locator('#checkCccImproved').click();
  check((await gfpa.locator('#cccImprovedFeedback').innerText()).includes('Correct'), 'GFPA working capital: improvement scenario calculation is checked');
  await gfpa.locator('#cccActionAnswer').selectOption('segment'); await gfpa.locator('#checkCccAction').click();
  check((await gfpa.locator('#cccActionFeedback').innerText()).includes('Correct'), 'GFPA working capital: evidence-led AR action is checked');

  check((await gfpa.locator('#treasuryFeedback').innerText()).includes('Correct'), 'GFPA academy: treasury starter lesson checks answer');
  check(await gfpa.locator('#accounting-foundations-lab').count() === 1, 'GFPA accounting foundations: full worked lesson renders');
  await gfpa.locator('#accountingEquationAnswer').selectOption('a');
  await gfpa.locator('#accountingCashAnswer').selectOption('545000');
  await gfpa.locator('#checkAccountingFoundations').click();
  check((await gfpa.locator('#accountingFoundationsFeedback').innerText()).includes('Correct on both'), 'GFPA accounting foundations: equation and closing-cash answers are checked');
  check(await count(gfpa, '#applied-case-lab .case-card') === 4, 'GFPA applied case lab: four finance scenarios render');
  await gfpa.locator('#apCaseAnswer').selectOption('hold'); await gfpa.locator('#checkApCase').click();
  check((await gfpa.locator('#apCaseFeedback').innerText()).includes('Correct'), 'GFPA AP case: duplicate invoice control answer works');
  await gfpa.locator('#arCaseAnswer').selectOption('c'); await gfpa.locator('#checkArCase').click();
  check((await gfpa.locator('#arCaseFeedback').innerText()).includes('Correct'), 'GFPA AR case: ageing-priority answer works');
  await gfpa.locator('#bankCaseAnswer').selectOption('189400'); await gfpa.locator('#checkBankCase').click();
  check((await gfpa.locator('#bankCaseFeedback').innerText()).includes('Correct'), 'GFPA bank reconciliation case: calculation answer works');
  await gfpa.locator('#varianceCaseAnswer').selectOption('unfavourable'); await gfpa.locator('#checkVarianceCase').click();
  check((await gfpa.locator('#varianceCaseFeedback').innerText()).includes('Correct'), 'GFPA FP&A case: expense variance answer works');
  check(await count(gfpa, '#resourceCatalog .card') >= 20, 'GFPA free resources: curated library renders', 'found ' + await count(gfpa, '#resourceCatalog .card'));
  check((await gfpa.locator('#resourceCount').innerText()).includes('curated resources'), 'GFPA free resources: resource count is shown');
  await gfpa.locator('#resourceQ').fill('SQL');
  check((await gfpa.locator('#resourceCatalog').innerText()).toLowerCase().includes('sql'), 'GFPA free resources: search filters resource results');
  await gfpa.locator('#resourceQ').fill('');
  await gfpa.locator('#resourceType').selectOption('Open textbook / ebook');
  check(await count(gfpa, '#resourceCatalog .card') >= 2, 'GFPA free resources: type filter works');
  await gfpa.locator('#resourceType').selectOption('');
  check(await count(gfpa, '#resourceCatalog .card') >= 20, 'GFPA free resources: clearing filters restores resources');
  check(gfpaErrors.length === 0, 'GFPA academy: no uncaught browser errors', gfpaErrors.join(' | '));
  await gfpa.close();

  const capstone = await browser.newPage();
  await capstone.goto(base + '/gfpa-capstone-lab.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  check((await capstone.locator('h1').innerText()).includes('Finance Operations Capstone'), 'capstone lab: page loads with correct heading');
  check(await capstone.locator('#apCase').count() === 1 && await capstone.locator('#arCase').count() === 1 && await capstone.locator('#bankCase').count() === 1, 'capstone lab: AP, AR and bank reconciliation cases render');
  await capstone.locator('#apAnswer').selectOption('D');
  await capstone.locator('#checkAp').click();
  check((await capstone.locator('#apFeedback').innerText()).toLowerCase().includes('correct'), 'capstone lab: duplicate invoice answer is checked');
  await capstone.locator('#arTotal').selectOption('69500');
  await capstone.locator('#arPriority').selectOption('vijaya');
  await capstone.locator('#checkAr').click();
  check((await capstone.locator('#arFeedback').innerText()).includes('₹69,500'), 'capstone lab: AR ageing total is validated');
  await capstone.locator('#bankAnswer').selectOption('189900');
  await capstone.locator('#checkBank').click();
  check((await capstone.locator('#bankFeedback').innerText()).includes('₹1,89,900'), 'capstone lab: bank reconciliation adjusted balance is validated');
  await capstone.close();

  const monitor = await browser.newPage();
  await monitor.goto(base + '/monitoring.html?e2e=' + Date.now(), { waitUntil: 'networkidle', timeout: 60000 });
  await monitor.waitForFunction(() => document.querySelector('#summary')?.innerText.includes('Changed · review'), { timeout: 15000 }).catch(() => {});
  check((await monitor.locator('#summary').innerText()).includes('Changed · review'), 'monitoring: latest report loads into dashboard');
  check((await monitor.locator('#results').innerText()).length > 0, 'monitoring: source results render');
  const monitoredSourceCount = await monitor.evaluate(async () => {const r=await fetch('./monitoring/source-catalog.json?test='+Date.now(),{cache:'no-store'});if(!r.ok)return 0;const d=await r.json();return Array.isArray(d.sources)?d.sources.length:0;});
  check(monitoredSourceCount >= 17, 'monitoring: at least seventeen official sources are registered', 'found ' + monitoredSourceCount);
  await monitor.waitForFunction(n => document.querySelector('#sourceCount')?.innerText.includes(n + ' official sources'), monitoredSourceCount, { timeout: 10000 }).catch(() => {});
  check((await monitor.locator('#sourceCount').innerText()).includes(monitoredSourceCount + ' official sources'), 'monitoring: dashboard displays the live source count', await monitor.locator('#sourceCount').innerText());
  await monitor.close();
} catch (error) {
  failures.push('Test runner error: ' + (error?.stack || error));
  console.error(error);
} finally {
  await browser.close();
}
console.log('\nRESULT: ' + passed.length + ' passed; ' + failures.length + ' failed');
if (failures.length) { console.error(failures.map((f,i)=>(i+1)+'. '+f).join('\n')); process.exitCode = 1; }