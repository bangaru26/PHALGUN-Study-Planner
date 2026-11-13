# PAL — AAROH Family Scheduler

PAL is a zero-cost, local-first prototype. Open `index.html` through the repository's GitHub Pages site when published.

## Available in this prototype

- Add, edit, complete, reopen and delete reminders.
- Assign a room label and family-member name.
- Snooze a reminder by five minutes.
- Browser notification while the page/app is open and notification permission is granted.
- Voice-to-text entry where the browser supports its speech-recognition API.
- Export and restore a JSON backup.
- Export an individual reminder as an `.ics` calendar file.
- Cache the app shell for offline reopening after the first successful load.

## Data and privacy boundary

All reminder, room and member data is stored in the current browser's local storage. There is no account, authentication, secure multi-user separation, server, cloud backup or cross-device synchronisation. Room names are labels, not private access-controlled spaces. Anyone using the same browser profile may be able to see the data. Export a backup before clearing browser data or changing devices.

Voice recognition support and processing vary by browser; some implementations may use a browser vendor's online speech service. Typing is always available as an alternative.

## Reminder limitation

The page checks due reminders while it is open. Browser background throttling and operating-system policies can delay notifications. It does not provide guaranteed alarms while the app/browser is fully closed. Reliable closed-app reminders generally require a platform scheduler or push service; neither is connected here.

## Not yet implemented

- Verified email sign-in restricted to the intended learner/family account.
- Secure family member accounts and private rooms.
- Cross-device sync and conflict handling.
- Telegram or WhatsApp integration.
- SMS, voice-call or smartwatch delivery.
- Direct Google Calendar synchronisation (individual `.ics` export is available).
- Recurring reminders and shared audit history.

## Zero-budget development sequence

1. Validate the local-first task flow and backup/restore.
2. Improve reminder reliability within browser capabilities.
3. Design identity and access controls before introducing shared family data.
4. Evaluate Telegram only after a secure server-side identity and consent model is selected.
5. Add sync only if a suitable free tier can be verified without payment details or automatic billing.

No paid service, paid trial or payment method is required or configured by this prototype.
