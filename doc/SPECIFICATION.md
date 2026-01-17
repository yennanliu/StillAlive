# Still Alive - Daily Check-In Safety App

## App Specification

### Executive Summary

**Still Alive** is a safety-focused Android application designed for people living alone. The app ensures their wellbeing through a daily check-in system. If a user fails to check in during their designated time window, the app automatically alerts their emergency contacts via SMS and phone call.

---

## Core Concept

**Target Users:** Individuals living alone who want peace of mind for themselves and their loved ones

**Primary Value:** Automated safety monitoring without requiring constant communication

**Key Differentiator:** Proactive emergency notification triggered by absence, not presence

---

## Feature Requirements

### 1. Daily Check-In System

**Time Window Configuration**
- Users set a specific daily check-in window (e.g., 8:00 AM - 10:00 AM)
- Window must be at least 30 minutes, maximum 4 hours
- Time window can be customized by user in settings
- Same window applies every day (future: day-specific windows)

**Check-In Process**
- Simple one-tap check-in button on home screen
- Visual confirmation when check-in is successful
- Display time remaining until deadline
- Show countdown timer when approaching deadline (last 30 minutes)

**Check-In States**
- **Pending:** Before check-in window opens
- **Active:** During check-in window
- **Completed:** Check-in successful for today
- **Missed:** Window closed without check-in → triggers alerts

### 2. Emergency Contact Management

**Contact Configuration**
- Users can add 2-5 emergency contacts
- Each contact requires:
  - Full name
  - Phone number (validated format)
  - Relationship (optional: Family, Friend, Neighbor, etc.)
- All contacts are notified simultaneously (no priority ordering)
- Contacts can be added, edited, or removed anytime

**Contact Verification**
- Phone number validation (E.164 format recommended)
- Optional: Send verification SMS when contact is added
- Warning if no contacts are configured

### 3. Emergency Alert System

**Trigger Conditions**
- Missed check-in: Alert sent immediately after check-in window closes
- Manual trigger: User can manually send emergency alert (panic button)

**Alert Methods**
1. **SMS Message**
   - Sent to all configured emergency contacts
   - Message template: "[User Name] has missed their daily check-in. Last check-in was [timestamp]. This may indicate they need assistance. Please contact them immediately."
   - Include user's last known location (if permission granted)

2. **Phone Call**
   - Automated phone call to all emergency contacts
   - Pre-recorded or text-to-speech message
   - Message: "This is an automated alert from the Still Alive app. [User Name] has missed their daily check-in and may need assistance. Please contact them immediately."

**Alert Timing**
- Both SMS and phone call sent simultaneously
- Immediate trigger (no grace period or delay)
- Retry mechanism if first attempt fails

### 4. Pause/Disable Feature

**Temporary Disable**
- Simple toggle switch to pause check-ins
- When paused:
  - No check-ins required
  - No alerts will be sent
  - Emergency contacts NOT notified about pause status
- Prominently displayed pause status on home screen
- Users can re-enable anytime

**Use Cases**
- Extended hospital stays
- Traveling with limited connectivity
- Staying with friends/family
- Any situation where check-ins aren't feasible

### 5. Reminder Notifications

**Pre-Check-In Reminders**
- Notification 30 minutes before check-in window opens
  - "Your check-in window opens in 30 minutes (8:00 AM - 10:00 AM)"
- Notification when check-in window opens
  - "Time to check in! You have until 10:00 AM"
- Notification 15 minutes before window closes (if not checked in)
  - "Reminder: Check in within 15 minutes to avoid alerting emergency contacts"

**Notification Behavior**
- Sound and vibration
- Persistent notification until dismissed or check-in completed
- High priority for approaching-deadline reminders

### 6. Check-In History

**History View**
- Calendar view showing check-in status for past days
- List view with detailed timestamps
- Visual indicators:
  - ✅ Green: Successful check-in
  - ❌ Red: Missed check-in (alert sent)
  - ⏸️ Gray: Paused (no check-in required)
- Date range filter (last 7/30/90 days, or custom range)

**History Details**
- Each entry shows:
  - Date
  - Check-in timestamp (if successful)
  - Check-in window for that day
  - Status (completed, missed, paused)

### 7. Manual Emergency Trigger

**Panic Button**
- Prominent button accessible from home screen
- Confirmation dialog to prevent accidental triggers
- When activated:
  - Immediately sends emergency alerts to all contacts
  - Records incident in history
  - Message: "[User Name] has manually triggered an emergency alert from the Still Alive app. Please contact them immediately or check on their wellbeing."

---

## User Interface Design

### Screen Structure

1. **Home Screen** (Primary Interface)
   - Large check-in button (center)
   - Current status indicator
   - Countdown timer (when in active window)
   - Next check-in window display
   - Pause toggle switch
   - Manual emergency button (bottom)

2. **Emergency Contacts Screen**
   - List of configured contacts
   - Add new contact button
   - Edit/delete options for each contact
   - Warning if fewer than 2 contacts

3. **Settings Screen**
   - Check-in window configuration
   - Notification preferences
   - Alert message customization (optional)
   - App permissions (SMS, Phone, Notifications, Location)

4. **History Screen**
   - Calendar or list view toggle
   - Date range selector
   - Check-in records with status

5. **Onboarding Flow**
   - Welcome screen explaining app purpose
   - Permission requests (SMS, Phone, Notifications)
   - Set check-in time window
   - Add emergency contacts (minimum 2 required)
   - Test alert option (send test SMS to verify setup)

### Design Principles

- **Clarity:** Large, obvious check-in button
- **Urgency:** Visual cues for approaching deadlines
- **Simplicity:** Minimal steps to complete check-in
- **Reassurance:** Clear confirmation when check-in successful
- **Accessibility:** High contrast, large text, voice feedback options

---

## Technical Requirements

### Platform
- **Primary:** Android (API Level 24+ / Android 7.0+)
- **Framework:** Flutter
- **Language:** Dart

### Permissions Required

1. **SMS (SEND_SMS):** Send alert messages
2. **Phone (CALL_PHONE):** Make automated calls
3. **Notifications (POST_NOTIFICATIONS):** Display reminders
4. **Foreground Service:** Background task for check-in monitoring
5. **Wake Lock:** Ensure alerts trigger even if phone is sleeping
6. **Location (Optional):** Include location in emergency alerts

### Architecture: Local-Only (No Backend Required)

**POC Strategy:** All data stored locally on device for rapid development. Backend can be added later if needed for features like:
- Multi-device sync
- Cloud backup
- Contact response tracking
- Analytics

**Local Storage Options:**
- **SharedPreferences:** Simple key-value storage (settings, pause state)
- **Hive:** Lightweight NoSQL database (contacts, check-in history)
- **SQLite:** Relational database (alternative to Hive)

**Recommended for POC:** SharedPreferences for settings + Hive for structured data (contacts, history)

### Key Technical Components

1. **Background Service**
   - Persistent foreground service monitoring check-in schedule
   - Triggers alerts when check-in window closes
   - Handles reminder notifications
   - No network required (operates fully offline)

2. **Local Storage (Hive + SharedPreferences)**
   - User settings: check-in window, notification preferences
   - Emergency contacts: name, phone number, relationship
   - Check-in history: timestamps, status, dates
   - Pause state: enabled/disabled, start date
   - No server, no cloud, no authentication needed

3. **Scheduling System (Android WorkManager + AlarmManager)**
   - Daily alarm for check-in window
   - Notification scheduler
   - Alert trigger mechanism
   - Survives app restarts and device reboots

4. **Communication Module**
   - SMS sender (SmsManager API)
   - Phone call initiator (Intent.ACTION_CALL)
   - Retry logic for failed attempts
   - No backend API calls required

5. **State Management (Provider or Riverpod)**
   - Check-in state tracking
   - UI updates based on time/status
   - Reactive UI updates when data changes

---

## User Stories

### Story 1: Daily Routine
**As** a user living alone,
**I want** to check in once per day during my morning routine,
**So that** my loved ones know I'm okay without daily calls.

**Acceptance Criteria:**
- Can check in with single tap
- Receive confirmation immediately
- No further action required for the day

### Story 2: Missed Check-In
**As** an emergency contact,
**I want** to be notified if my loved one misses their check-in,
**So that** I can check on them if something is wrong.

**Acceptance Criteria:**
- Receive SMS immediately after missed check-in
- Receive phone call with clear message
- Message includes last check-in timestamp

### Story 3: Traveling
**As** a user going on vacation,
**I want** to temporarily pause check-ins,
**So that** I don't trigger false alarms while away.

**Acceptance Criteria:**
- Can pause with single toggle
- No check-ins required while paused
- Can easily resume when returning

### Story 4: Running Late
**As** a user who is running late,
**I want** to receive reminders before my check-in deadline,
**So that** I don't forget and accidentally alert my contacts.

**Acceptance Criteria:**
- Receive reminder 15 minutes before deadline
- Reminder includes time remaining
- Can check in directly from notification

---

## Edge Cases & Error Handling

### Network Connectivity
- **No Internet:** SMS/calls should still work (carrier network)
- **Offline Check-In:** Check-in recorded locally, validated when online
- **Failed Alert Send:** Retry mechanism with exponential backoff

### Device States
- **Phone Off:** Alert triggers when device powers on
- **Airplane Mode:** Alert queued until connectivity restored
- **App Killed:** Foreground service keeps running
- **Battery Saver Mode:** Request exemption from battery optimization

### User Scenarios
- **First-Time Setup:** Require minimum 2 contacts before activation
- **Time Zone Changes:** Adjust check-in window to local time
- **Daylight Saving Time:** Handle time transitions gracefully
- **Multiple Missed Check-Ins:** Continue alerting daily until resumed
- **Emergency Contact Unreachable:** Log failure, attempt others

---

## Privacy & Security

### Data Storage (Local-Only, No Backend)
- **100% local storage** - all data stays on device
- No cloud backend, no servers, no database
- No user accounts or authentication required
- Encrypted storage for sensitive data (emergency contacts)
- No personal data shared with third parties
- No network connection required for core functionality
- Data lost if app is uninstalled (acceptable for POC)

### Permissions Transparency
- Clear explanation for each permission request
- Ability to review/revoke permissions in settings
- Graceful degradation if optional permissions denied

### Emergency Contact Privacy
- Contacts not notified when they're added
- No tracking of contact responses
- Contacts can't access user's app data

---

## Success Metrics

### User Engagement
- Daily check-in completion rate (target: >95%)
- Average check-in time within window
- Active users (checking in regularly)

### Safety Metrics
- Number of missed check-ins
- False alarm rate (missed check-ins that weren't emergencies)
- Emergency contact response rate (via optional feedback)

### Technical Metrics
- Alert delivery success rate (target: >99%)
- Notification delivery rate
- App crash rate
- Background service uptime

---

## Future Enhancements (Out of Scope for V1)

1. **Smart Check-In Detection**
   - Auto-check-in based on phone usage/activity
   - Integration with smart home devices

2. **Day-Specific Schedules**
   - Different check-in windows for weekdays/weekends
   - Multiple check-ins per day

3. **Contact Escalation**
   - Priority ordering of emergency contacts
   - Escalate to next contact if first doesn't respond

4. **Health Integration**
   - Connect with health monitoring devices
   - Include health data in emergency alerts

5. **Two-Way Communication**
   - Allow emergency contacts to mark alert as resolved
   - In-app messaging with contacts

6. **Multi-User Support**
   - Family accounts where contacts can see status
   - Mutual check-in groups

7. **Location Tracking**
   - Include current location in alerts
   - Geofencing (alert if user leaves safe zone)

8. **Voice Check-In**
   - Voice command support
   - Phone call-based check-in (call app to check in)

---

## Development Phases

### Phase 1: MVP (Minimum Viable Product)
- Daily check-in with time window
- Emergency contact management (2-5 contacts)
- SMS alerts on missed check-in
- Basic reminder notifications
- Simple pause toggle

### Phase 2: Enhanced Experience
- Phone call alerts
- Check-in history view
- Manual emergency trigger
- Onboarding flow
- Settings customization

### Phase 3: Polish & Reliability
- Comprehensive error handling
- Battery optimization
- Network resilience
- UI/UX refinements
- Accessibility features

---

## Appendix

### Sample Alert Messages

**SMS Alert (Missed Check-In):**
```
STILL ALIVE APP ALERT

[User Name] has missed their daily check-in.

Last successful check-in: [Date, Time]
Expected check-in: [Today's Date, Time Window]

This may indicate they need assistance. Please contact them immediately or check on their wellbeing.

If this is a false alarm, ask them to open the Still Alive app.
```

**Phone Call Script:**
```
"This is an automated safety alert from the Still Alive application.

[User Name] has missed their scheduled daily check-in today.

Their last check-in was on [Date] at [Time].

This may indicate they need assistance.

Please contact [User Name] immediately or check on their wellbeing.

Thank you."
```

**Manual Emergency Alert:**
```
STILL ALIVE APP - EMERGENCY

[User Name] has manually triggered an emergency alert.

Timestamp: [Date, Time]
Location: [Address if available]

Please contact them immediately or check on their wellbeing.

This alert was sent from the Still Alive app.
```

---

## Questions for Stakeholder Review

1. Should emergency contacts be notified when they're added to someone's list?
2. What should happen after multiple consecutive missed check-ins?
3. Should there be a "snooze" option to extend the check-in window by 30-60 minutes?
4. Should the app require a PIN/biometric lock to prevent tampering?
5. How should the app handle users in different time zones (travelers)?
6. Should there be an optional cloud backup for check-in history?
7. What's the desired behavior if a user manually dismisses reminder notifications?

---

**Document Version:** 1.0
**Last Updated:** 2026-01-17
**Status:** Approved for Development
