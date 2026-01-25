# Phase 2 Implementation Plan: Still Alive App UI Development

## Overview
Build complete UI layer for the Still Alive app with 5 main screens, navigation system, and state management. Phase 1 foundation (models, repositories, storage) is complete.

## Navigation Architecture
**Bottom Navigation Bar** with 4 tabs: Home | Contacts | History | Settings
- One-time onboarding flow shown before main navigation
- Simple, quick access to all features (critical for safety app)

## Implementation Order

### Stage 1: State Management Foundation (Build First)
Create StateNotifiers to connect UI to data layer:

1. **`lib/presentation/providers/checkin_notifier.dart`**
   - `CheckinState`: todayRecord, currentStatus, timeRemaining, nextWindow
   - `CheckinNotifier`: Calculate status (pending/active/completed/missed), countdown timer
   - Core logic: `CheckinStatus calculateStatus(DateTime now, UserSettings settings)`

2. **`lib/presentation/providers/settings_notifier.dart`**
   - `SettingsNotifier extends StateNotifier<UserSettings>`
   - Expose settings CRUD, pause/resume, window time updates

3. **`lib/presentation/providers/contacts_notifier.dart`**
   - `ContactsNotifier extends StateNotifier<List<EmergencyContact>>`
   - Expose add/edit/delete, validation logic

4. **`lib/presentation/providers/home_notifier.dart`**
   - `HomeScreenState`: aggregates checkin state + pause status + streak
   - Combines data from multiple sources for home screen

5. **`lib/presentation/providers/history_notifier.dart`**
   - `HistoryState`: records, viewMode (calendar/list), dateRange, stats
   - Calculate completion rate, streaks

6. **Update `lib/presentation/providers/providers.dart`**
   - Add new StateNotifierProviders for all notifiers above

### Stage 2: Navigation Shell
7. **`lib/presentation/screens/main_navigation_screen.dart`**
   - Scaffold with BottomNavigationBar (4 tabs)
   - Switch between Home/Contacts/History/Settings screens
   - Initial placeholders for each screen

8. **Update `lib/main.dart`**
   - Check `onboardingCompleted` flag
   - Route to onboarding OR main navigation

### Stage 3: Onboarding Flow
9. **`lib/presentation/screens/onboarding/onboarding_screen.dart`**
   - PageView with 5 pages + progress indicators
   - Next/Back navigation with validation

10. **`lib/presentation/screens/onboarding/pages/welcome_page.dart`**
    - App intro, purpose explanation
    - "Get Started" button

11. **`lib/presentation/screens/onboarding/pages/permissions_page.dart`**
    - Request SMS, Phone, Notifications permissions
    - Use `permission_handler` package
    - Show status for each permission

12. **`lib/presentation/screens/onboarding/pages/time_window_page.dart`**
    - Time pickers for window start/end
    - Validate 30-240 minute duration
    - Default: 8:00 AM - 10:00 AM

13. **`lib/presentation/screens/onboarding/pages/contacts_page.dart`**
    - Mini contact form (reuse contact form widget)
    - Must add 2+ contacts to proceed
    - Show count and minimum requirement

14. **`lib/presentation/screens/onboarding/pages/completion_page.dart`**
    - Optional "Send Test SMS" button
    - "Get Started" button → save `onboardingCompleted = true`
    - Navigate to main app

15. **`lib/presentation/screens/onboarding/widgets/` (as needed)**
    - `contact_form.dart` - Reusable form for add/edit contacts
    - `onboarding_page_indicator.dart` - Progress dots
    - `time_picker_widget.dart` - Time selection widget

### Stage 4: Contacts Screen
16. **`lib/presentation/screens/contacts/contacts_screen.dart`**
    - ListView of contact cards
    - FAB to add contact (disabled if 5 reached)
    - Warning banner if < 2 contacts

17. **`lib/presentation/screens/contacts/add_contact_screen.dart`**
    - Form: name, phone, relationship, optional test SMS
    - Phone validation (E.164 format)
    - Save to ContactsRepository

18. **`lib/presentation/screens/contacts/edit_contact_screen.dart`**
    - Same form as add, pre-filled with contact data
    - Update existing contact

19. **`lib/presentation/screens/contacts/widgets/contact_list_item.dart`**
    - Card showing name, phone, relationship
    - "Verified" badge if test sent
    - Swipe to delete, tap to edit

20. **`lib/presentation/screens/contacts/widgets/minimum_contacts_warning.dart`**
    - Red banner: "You need at least 2 emergency contacts"

### Stage 5: Home Screen
21. **`lib/presentation/screens/home/home_screen.dart`**
    - Main scaffold with all widgets
    - Consumer for HomeNotifier

22. **`lib/presentation/screens/home/widgets/checkin_button.dart`**
    - Large circular button (200x200px)
    - Color by status: gray (pending), blue (active), green (completed)
    - Disabled when not active
    - OnPressed: create completed check-in record

23. **`lib/presentation/screens/home/widgets/status_indicator.dart`**
    - Chip showing current status with color coding

24. **`lib/presentation/screens/home/widgets/countdown_timer.dart`**
    - Show time remaining in window (when active)
    - Update every minute using Timer.periodic
    - Format: "2h 15m remaining"

25. **`lib/presentation/screens/home/widgets/pause_toggle.dart`**
    - Switch to pause/resume check-ins
    - Confirmation dialog before pausing
    - Show "Paused since [date]" when active

26. **`lib/presentation/screens/home/widgets/emergency_button.dart`**
    - Red button at bottom
    - Confirmation dialog
    - Disabled if < 2 contacts
    - Creates manualAlert check-in record

27. **`lib/presentation/screens/home/widgets/today_summary_card.dart`** (optional)
    - Show today's window, check-in time, streak

### Stage 6: Settings Screen
28. **`lib/presentation/screens/settings/settings_screen.dart`**
    - ListView with sections
    - Consumer for SettingsNotifier

29. **`lib/presentation/screens/settings/widgets/time_window_setting.dart`**
    - Display current window
    - Tap to edit with time pickers
    - Validate duration

30. **`lib/presentation/screens/settings/widgets/notification_settings.dart`**
    - Toggle switches for each notification type
    - Disabled if permission denied

31. **`lib/presentation/screens/settings/widgets/permission_status_card.dart`**
    - Show status for SMS, Phone, Notifications
    - "Open Settings" button for denied permissions

32. **`lib/presentation/screens/settings/widgets/about_section.dart`** (optional)
    - App version, privacy policy

### Stage 7: History Screen
33. **`lib/presentation/screens/history/history_screen.dart`**
    - SegmentedButton: Calendar | List view
    - Date range selector
    - Consumer for HistoryNotifier

34. **`lib/presentation/screens/history/widgets/calendar_view.dart`**
    - TableCalendar integration
    - Color-code dates by status
    - Tap to show details

35. **`lib/presentation/screens/history/widgets/list_view.dart`**
    - Scrollable list of CheckinRecords
    - Most recent first

36. **`lib/presentation/screens/history/widgets/history_list_item.dart`**
    - Card showing date, status, window, check-in time

37. **`lib/presentation/screens/history/widgets/stats_summary.dart`**
    - Completion rate, current streak, longest streak
    - Calculate from filtered records

38. **`lib/presentation/screens/history/widgets/status_legend.dart`** (optional)
    - Color legend for calendar view

## Key Technical Details

### Check-in Status Logic
```dart
CheckinStatus calculateStatus(DateTime now, UserSettings settings, CheckinRecord? todayRecord) {
  if (settings.isPaused) return CheckinStatus.paused;
  if (todayRecord?.status == CheckinStatus.completed) return CheckinStatus.completed;

  final currentMinutes = now.hour * 60 + now.minute;
  if (currentMinutes < settings.checkinWindowStartMinutes) return CheckinStatus.pending;
  if (currentMinutes <= settings.checkinWindowEndMinutes) return CheckinStatus.active;
  return CheckinStatus.missed;
}
```

### Phone Number Validation
- E.164 format: `+[country code][number]` (e.g., +12345678901)
- Regex: `^\+[1-9]\d{1,14}$`
- Show format hint in form

### Permission Handling
- Use `permission_handler` package
- Request: SMS, Phone, Notifications
- Graceful degradation if denied
- "Open Settings" buttons for denied permissions

### Real-time Updates
- Countdown timer: `Timer.periodic(Duration(minutes: 1), callback)`
- Status check: recalculate on each timer tick
- Dispose timers in widget dispose()

### Form Validation Rules
- Contact name: non-empty, max 50 chars
- Phone: E.164 format
- Time window: end > start, duration 30-240 minutes
- Minimum 2 contacts before completion

## Critical Files to Create
1. `/lib/presentation/providers/checkin_notifier.dart` - Core status logic
2. `/lib/presentation/screens/main_navigation_screen.dart` - Navigation shell
3. `/lib/presentation/screens/onboarding/onboarding_screen.dart` - First-time setup
4. `/lib/presentation/screens/home/home_screen.dart` - Primary check-in UI
5. `/lib/presentation/screens/onboarding/widgets/contact_form.dart` - Reusable contact form

## Verification Checklist

### Onboarding
- [ ] All 5 pages display correctly
- [ ] Permissions requested and status shown
- [ ] Cannot proceed without 2+ contacts
- [ ] Time window validates duration
- [ ] Completion sets `onboardingCompleted = true`
- [ ] App opens to home screen after onboarding

### Home Screen
- [ ] Status indicator shows correct color/text
- [ ] Countdown timer updates every minute
- [ ] Check-in button only enabled during active window
- [ ] Check-in creates completed record
- [ ] Pause toggle works with confirmation
- [ ] Emergency button requires confirmation
- [ ] Emergency disabled if < 2 contacts

### Contacts
- [ ] List displays all contacts
- [ ] Warning shown when < 2 contacts
- [ ] Add disabled at 5 contacts
- [ ] Phone validation works
- [ ] Edit saves changes
- [ ] Delete requires confirmation
- [ ] Delete warns if < 2 contacts

### Settings
- [ ] Window displays correctly
- [ ] Time picker validates duration
- [ ] Notification toggles persist
- [ ] Permission status accurate
- [ ] Changes persist after restart

### History
- [ ] Calendar colors dates correctly
- [ ] List shows chronological order
- [ ] Date range filtering works
- [ ] Stats calculated correctly
- [ ] Empty state displays

### Navigation
- [ ] Bottom nav switches between screens
- [ ] State preserved when switching tabs
- [ ] Back button behavior correct

## Out of Scope for Phase 2
- Background services / WorkManager (Phase 3)
- Actual SMS/call sending (Phase 3)
- Alert triggering logic (Phase 3)
- Notification scheduling (Phase 3)
- Advanced error handling (Phase 3)

## Success Criteria
Phase 2 complete when:
- All 5 screens functional
- Onboarding saves data correctly
- Home screen check-in works end-to-end
- Contacts CRUD operations work
- Settings persist
- History displays records
- Navigation flows smoothly
- All verification tests pass
- App usable for daily check-ins (UI only, no background alerts)
