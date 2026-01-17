# Still Alive - Technical Implementation Plan

## Architecture Overview

**Approach:** Local-only storage (no backend), Android-focused implementation

**Architecture Pattern:**
- **Layered Architecture**: Data Layer → Business Logic (Providers) → Presentation Layer
- **State Management**: Flutter Riverpod for reactive state
- **Local Storage**: Hive (structured data) + SharedPreferences (simple key-value)
- **Background Processing**: Foreground Service + WorkManager + AlarmManager

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # App widget and routing
├── core/                              # Core utilities and constants
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/                              # Data layer
│   ├── models/                        # Hive models (settings, contacts, checkin_record)
│   ├── repositories/                  # Data access layer
│   └── services/                      # Background service, alert service, storage
└── presentation/                      # UI layer
    ├── providers/                     # Riverpod state management
    └── screens/                       # All app screens
```

## Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1           # State management
  hive: ^2.2.3                        # Local database
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.3
  workmanager: ^0.5.2                 # Background tasks
  flutter_foreground_task: ^8.0.0    # Foreground service
  android_alarm_manager_plus: ^4.0.2  # Exact alarms
  flutter_local_notifications: ^17.0.0
  permission_handler: ^11.3.0
  telephony: ^0.2.0                   # SMS sending
  url_launcher: ^6.2.5                # Phone calls
  intl: ^0.19.0                       # Date formatting
  table_calendar: ^3.0.9              # History calendar view
  flutter_phone_direct_caller: ^2.1.1

dev_dependencies:
  hive_generator: ^2.0.1              # Code generation
  build_runner: ^2.4.8
```

## Data Models

### 1. UserSettings (Hive, Type ID: 0)
- userName: String
- checkinWindowStart: TimeOfDay (e.g., 08:00)
- checkinWindowEnd: TimeOfDay (e.g., 10:00)
- isPaused: bool
- pausedSince: DateTime?
- notificationsEnabled: bool
- reminderBeforeWindow: bool (30 min before)
- reminderAtWindowStart: bool
- reminderBeforeDeadline: bool (15 min before end)
- onboardingCompleted: bool

### 2. EmergencyContact (Hive, Type ID: 1)
- id: String (UUID)
- name: String
- phoneNumber: String (E.164 format)
- relationship: String? (Family, Friend, etc.)
- createdAt: DateTime
- isVerified: bool

### 3. CheckinRecord (Hive, Type ID: 2)
- id: String (UUID)
- date: DateTime (normalized to midnight)
- status: CheckinStatus (enum)
- checkinTimestamp: DateTime?
- windowStart: TimeOfDay?
- windowEnd: TimeOfDay?
- alertSent: bool
- alertSentAt: DateTime?
- alertedContacts: List<String>?

### 4. CheckinStatus (Hive Enum, Type ID: 3)
- pending (before window)
- active (during window)
- completed (checked in)
- missed (window closed without check-in)
- paused (app paused)
- manualAlert (emergency button pressed)

## Critical Components

### 1. Background Service (`lib/data/services/background_service.dart`)
**Purpose:** Monitor check-in schedule 24/7

**Implementation Strategy:**
- **Foreground Service**: Runs continuously with persistent notification
- **WorkManager**: Periodic checks every 15 minutes (fallback)
- **AlarmManager**: Exact alarms at critical times (window start/end)

**Key Responsibilities:**
- Monitor current time vs check-in window
- Trigger alerts when window closes without check-in
- Schedule reminder notifications
- Survive app kills and device reboots
- Communicate with Flutter via MethodChannel

**Platform Channel:**
```dart
MethodChannel('com.stillalive/background')
  - startService()
  - stopService()
  - scheduleAlarm()
  - checkStatus()
```

### 2. Alert Service (`lib/data/services/alert_service.dart`)
**Purpose:** Send emergency alerts via SMS and phone calls

**Flow:**
1. Retrieve all active emergency contacts
2. Build alert message (missed check-in or manual emergency)
3. Send SMS to all contacts (with 2-second delay between)
4. Make phone calls to all contacts (with 5-second delay)
5. Log alert attempts and update CheckinRecord
6. Retry failed attempts

**Message Template:**
```
STILL ALIVE APP ALERT

[User Name] has missed their daily check-in.

Expected check-in: [Date], [Window]
Last successful check-in: [Timestamp]

This may indicate they need assistance.
Please contact them immediately.
```

### 3. Checkin Provider (`lib/presentation/providers/checkin_provider.dart`)
**Purpose:** Central business logic for check-in state

**State Management:**
- Calculate current check-in status (pending/active/completed/missed)
- Countdown timer until window opens/closes
- Trigger alert service when deadline passes
- Handle manual check-in button press
- Handle manual emergency button press
- Update check-in history

**CheckinState Model:**
```dart
class CheckinState {
  CheckinStatus status;
  DateTime? nextWindowStart;
  DateTime? nextWindowEnd;
  Duration? timeRemaining;
  bool isPaused;
  CheckinRecord? todayRecord;
}
```

### 4. Native Android Service (`android/.../CheckinMonitorService.kt`)
**Purpose:** Foreground service running 24/7

**Implementation:**
```kotlin
class CheckinMonitorService : Service() {
  override fun onStartCommand(...): Int {
    // Create persistent notification
    startForeground(NOTIFICATION_ID, notification)

    // Start monitoring loop (check every minute)
    startMonitoring()

    return START_STICKY // Auto-restart if killed
  }

  private fun startMonitoring() {
    // Check time vs window
    // Communicate with Flutter
    // Trigger alerts if needed
  }
}
```

**Required Receivers:**
- `AlarmReceiver.kt`: Handle alarm triggers
- `BootReceiver.kt`: Restart service after device reboot

## Required Permissions

**AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

**Permission Request Flow:**
1. Onboarding: SMS, CALL_PHONE, POST_NOTIFICATIONS
2. Settings intent: SCHEDULE_EXACT_ALARM (Android 12+)
3. Request battery optimization exemption

## Implementation Phases

### Phase 1: Foundation Setup
**Tasks:**
1. Update pubspec.yaml with all dependencies
2. Create folder structure (core/, data/, presentation/)
3. Initialize Hive with adapters
4. Create all data models (UserSettings, EmergencyContact, CheckinRecord)
5. Run build_runner to generate Hive type adapters
6. Create repositories (SettingsRepository, ContactsRepository, CheckinRepository)
7. Set up Riverpod providers
8. Create app theme and constants

**Files to create:**
- `lib/data/models/*.dart` (4 model files)
- `lib/data/repositories/*.dart` (3 repository files)
- `lib/data/services/storage_service.dart`
- `lib/core/constants/*.dart`
- `lib/core/theme/app_theme.dart`

### Phase 2: Core UI
**Tasks:**
1. Build onboarding flow (welcome, permissions, time setup, contacts setup)
2. Build home screen with check-in button
3. Build contacts screen (list, add/edit contact)
4. Build settings screen (time window, notifications)
5. Build history screen (list view, then calendar)
6. Set up navigation (bottom nav or drawer)

**Files to create:**
- `lib/presentation/screens/onboarding/*.dart`
- `lib/presentation/screens/home/home_screen.dart`
- `lib/presentation/screens/contacts/*.dart`
- `lib/presentation/screens/settings/*.dart`
- `lib/presentation/screens/history/*.dart`

### Phase 3: Background Services (Most Complex)
**Tasks:**
1. Implement permission helper utilities
2. Create background_service.dart (Flutter side)
3. Write native Android foreground service (CheckinMonitorService.kt)
4. Set up MethodChannel communication
5. Implement WorkManager periodic tasks
6. Implement AlarmManager scheduling
7. Create AlarmReceiver.kt and BootReceiver.kt
8. Update AndroidManifest.xml with services and receivers
9. Test service survival (kill app, reboot device)

**Files to create:**
- `lib/data/services/background_service.dart`
- `lib/data/services/scheduler_service.dart`
- `lib/core/utils/permission_helper.dart`
- `android/app/src/main/kotlin/.../CheckinMonitorService.kt`
- `android/app/src/main/kotlin/.../AlarmReceiver.kt`
- `android/app/src/main/kotlin/.../BootReceiver.kt`
- Update `android/app/src/main/kotlin/.../MainActivity.kt`

### Phase 4: Alert System
**Tasks:**
1. Implement SMS sending using telephony package
2. Implement phone call using flutter_phone_direct_caller
3. Build alert service with retry logic
4. Create alert message templates
5. Test alert delivery on real device
6. Handle edge cases (no network, permission denied)

**Files to create:**
- `lib/data/services/alert_service.dart`
- `lib/core/constants/alert_messages.dart`

### Phase 5: Check-in Logic
**Tasks:**
1. Implement time window calculations
2. Build check-in state machine in CheckinProvider
3. Handle daily check-in flow (button press → update state → save history)
4. Implement pause/resume functionality
5. Handle manual emergency trigger
6. Connect UI to state changes

**Files to create:**
- `lib/presentation/providers/checkin_provider.dart`
- `lib/core/utils/time_utils.dart`

### Phase 6: Notifications
**Tasks:**
1. Set up flutter_local_notifications
2. Schedule reminder notifications (30 min before, at start, 15 min before end)
3. Handle notification taps (open app, quick check-in)
4. Test notification timing accuracy

**Files to create:**
- `lib/core/utils/notification_helper.dart`

### Phase 7: Polish & Testing
**Tasks:**
1. Edge case handling (timezone changes, DST, multiple missed check-ins)
2. Battery optimization exemption request
3. Error handling and logging throughout app
4. UI polish (animations, loading states, error messages)
5. Accessibility (screen readers, high contrast)
6. End-to-end testing on physical device
7. Build release APK

## Critical Files Summary

**Top 5 Critical Files:**

1. **`lib/data/services/background_service.dart`**
   - Orchestrates foreground service, WorkManager, AlarmManager
   - Most complex component
   - Core reliability mechanism

2. **`lib/data/services/alert_service.dart`**
   - Emergency alert triggering
   - SMS and phone call implementation
   - Primary safety function

3. **`lib/presentation/providers/checkin_provider.dart`**
   - Check-in state machine
   - Business logic hub
   - Coordinates all services

4. **`lib/data/models/checkin_record.dart`**
   - Core data model
   - Referenced throughout app
   - Requires Hive type adapter

5. **`android/.../CheckinMonitorService.kt`**
   - Native foreground service
   - Background reliability
   - Platform channel communication

## Technical Challenges & Solutions

### Challenge 1: Background Service Reliability
**Problem:** Android aggressively kills background services
**Solutions:**
- Use foreground service with persistent notification (START_STICKY)
- Request battery optimization exemption
- Implement BOOT_COMPLETED receiver to restart after reboot
- WorkManager as fallback checker
- Test on multiple Android versions (8-14)

### Challenge 2: Exact Alarm Scheduling
**Problem:** Android 12+ restricts SCHEDULE_EXACT_ALARM
**Solutions:**
- Request permission via Settings intent (show explanation first)
- Fallback to WorkManager if permission denied (less accurate)
- Clearly explain why exact timing is critical

### Challenge 3: Phone Call Automation
**Problem:** Can't play automated voice message easily
**Solutions:**
- Use direct call API (requires CALL_PHONE permission)
- Alternative: Intent.ACTION_CALL (shows dialer)
- Future: Integrate TTS or voice API service

### Challenge 4: Multiple Missed Check-ins
**Problem:** User doesn't resume app after missing
**Solutions:**
- Continue daily monitoring automatically
- Send alert each day until app is reopened
- Persistent notification to remind user

## Build Configuration Updates

**`android/app/build.gradle.kts`:**
```kotlin
android {
    defaultConfig {
        applicationId = "com.example.still_alive"  // Already set
        minSdk = 24        // Android 7.0 (already compatible)
        targetSdk = 34     // Android 14
        compileSdk = 34
    }
}
```

**Package name:** `com.example.still_alive` (already configured)

## Local Storage Schema

**Hive Boxes:**
- `settings_box`: Single UserSettings object (lazy box)
- `contacts_box`: Map<String, EmergencyContact> keyed by contact ID
- `checkin_box`: Map<String, CheckinRecord> keyed by date string (YYYY-MM-DD)

**SharedPreferences Keys:**
- `last_checkin_date`: ISO date string
- `background_service_running`: boolean
- `last_alert_sent`: ISO datetime string

**Data Persistence:**
- All data stored locally on device
- No cloud sync (acceptable for POC)
- Data lost if app uninstalled
- No encryption by default (can add later)

## Verification & Testing

### End-to-End Test Scenarios

1. **Happy Path:**
   - Set up app with 2 contacts and time window (e.g., 8-10am)
   - Check in successfully during window
   - Verify status shows "Completed"
   - Check history shows green checkmark

2. **Missed Check-In:**
   - Set check-in window to next 5 minutes
   - Wait for window to close without checking in
   - Verify SMS sent to all contacts
   - Verify phone calls initiated
   - Verify history shows red "Missed" status

3. **Pause Feature:**
   - Enable pause toggle
   - Wait for check-in window to pass
   - Verify NO alerts sent
   - Verify history shows gray "Paused" status

4. **Manual Emergency:**
   - Press emergency button on home screen
   - Confirm alert
   - Verify SMS sent with "manually triggered" message
   - Verify phone calls initiated

5. **Background Reliability:**
   - Set up check-in for next 10 minutes
   - Force kill app
   - Wait for window to close
   - Verify alerts still sent (service continued)

6. **Device Reboot:**
   - Set up check-in
   - Reboot device
   - Verify service restarts automatically
   - Verify alarms rescheduled

7. **Permission Handling:**
   - Deny SMS permission
   - Verify warning displayed
   - Verify phone calls still work
   - Deny both SMS and CALL_PHONE
   - Verify app prevents enabling check-ins

8. **Notification Timing:**
   - Set check-in window for next 35 minutes
   - Verify reminder notification 30 min before
   - Verify notification when window opens
   - Wait 10 minutes (don't check in)
   - Verify reminder 15 min before deadline

### Manual Testing Checklist

- [ ] Add/edit/delete emergency contacts
- [ ] Change check-in time window
- [ ] Complete check-in during window
- [ ] Miss check-in (verify alerts sent)
- [ ] Pause and resume check-ins
- [ ] Trigger manual emergency alert
- [ ] Kill app and verify service continues
- [ ] Reboot device and verify service restarts
- [ ] Test on low battery mode
- [ ] Test in airplane mode (SMS queued)
- [ ] Test with invalid phone numbers
- [ ] View check-in history (last 30 days)
- [ ] Test all notification reminders
- [ ] Verify permissions can be revoked and re-granted

### Device Testing Requirements

- **Minimum:** Android 7.0 (API 24)
- **Test on:** Android 10, 12, 13, 14
- **Physical device required** (emulator can't send real SMS/calls)
- **Test on different manufacturers** (Samsung, Pixel, OnePlus - behavior varies)

---

**Document Version:** 1.0
**Last Updated:** 2026-01-17
**Status:** Ready for Implementation
