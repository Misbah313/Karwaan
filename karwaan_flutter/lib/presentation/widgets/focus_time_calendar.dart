import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class FocusTimeCalendar extends StatefulWidget {
  const FocusTimeCalendar({super.key});

  @override
  State<FocusTimeCalendar> createState() => _FocusTimeCalendarState();
}

class _FocusTimeCalendarState extends State<FocusTimeCalendar> {
  final DateTime _selectedDate = DateTime.now();
  final Map<String, List<FocusSession>> _scheduledSessions = {};
  TimerSession? _currentSession;

  @override
  Widget build(BuildContext context) {
    final todaySessions = _scheduledSessions[_dateKey(_selectedDate)] ?? [];
    final totalFocusTime = _calculateTotalFocusTime(todaySessions);

    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and stats
              _buildHeader(context, totalFocusTime),
              const SizedBox(height: 20),

              // Today's Focus Summary
              _buildFocusSummary(totalFocusTime),
              const SizedBox(height: 20),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 15),

              // Scheduled Sessions
              _buildSessionsList(todaySessions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Duration totalFocusTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('EEEE, MMM d').format(_selectedDate),
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Focus Time Tracker',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        _buildTimerButton(),
      ],
    );
  }

  Widget _buildTimerButton() {
    final isRunning = _currentSession != null;

    return Material(
      color: isRunning ? Colors.red : Colors.green,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: _toggleTimer,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isRunning ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isRunning ? 'STOP' : 'FOCUS',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusSummary(Duration totalFocusTime) {
    final hours = totalFocusTime.inHours;
    final minutes = totalFocusTime.inMinutes.remainder(60);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Planned',
              '${_scheduledSessions[_dateKey(_selectedDate)]?.length ?? 0}',
              Icons.schedule,
              Colors.blue),
          _buildStatItem(
              'Focus', '${hours}h ${minutes}m', Icons.timer, Colors.green),
          _buildStatItem('Completed', '${_getCompletedSessions()}',
              Icons.check_circle, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Schedule Session',
            Icons.add,
            Colors.blue,
            _showScheduleDialog,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            'Quick Focus',
            Icons.timer,
            Colors.green,
            _startQuickFocus,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsList(List<FocusSession> sessions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: sessions.isEmpty
          ? _buildEmptyState()
          : _buildSessionsContent(sessions),
    );
  }

  Widget _buildEmptyState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('No focus sessions scheduled\nTap "Schedule Session" to add one',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSessionsContent(List<FocusSession> sessions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Sessions',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        ...sessions.map((session) => _buildSessionCard(session)),
      ],
    );
  }

  Widget _buildSessionCard(FocusSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.onSecondary
        ]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Color indicator
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: session.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),

          // Session info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                    '${_formatTime(session.startTime)} - ${_formatTime(session.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),

          // Play button
          Container(
            decoration: BoxDecoration(
              color: session.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.play_arrow, size: 18, color: session.color),
              onPressed: () => _startSession(session),
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  void _toggleTimer() {
    setState(() {
      if (_currentSession == null) {
        _currentSession = TimerSession(startTime: DateTime.now());
      } else {
        _currentSession = null;
      }
    });
  }

  void _startQuickFocus() {
    final now = TimeOfDay.now();
    final endTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);

    final session = FocusSession(
      title: 'Quick Focus',
      startTime: now,
      endTime: endTime,
      color: Colors.green,
    );

    final key = _dateKey(_selectedDate);
    setState(() {
      _scheduledSessions[key] = [..._scheduledSessions[key] ?? [], session];
    });

    _startSession(session);
  }

  Duration _calculateTotalFocusTime(List<FocusSession> sessions) {
    Duration total = Duration.zero;
    for (final session in sessions) {
      final start = session.startTime;
      final end = session.endTime;
      final duration = Duration(
        hours: end.hour - start.hour,
        minutes: end.minute - start.minute,
      );
      total += duration;
    }
    return total;
  }

  int _getCompletedSessions() {
    // This would integrate with your actual completion logic
    return _scheduledSessions[_dateKey(_selectedDate)]?.length ?? 0;
  }

  // ... Keep your existing helper methods (_showScheduleDialog, _dateKey, _isSameDay, etc.)
  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Schedule Focus Time',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: FocusSessionForm(
          onSave: (session) {
            final key = _dateKey(_selectedDate);
            setState(() {
              _scheduledSessions[key] = [
                ..._scheduledSessions[key] ?? [],
                session
              ];
            });
          },
        ),
      ),
    );
  }

  void _startSession(FocusSession session) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${session.title}'),
        backgroundColor: Colors.green,
      ),
    );
    // Start the timer when session begins
    _toggleTimer();
  }

  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

// Add the missing classes
class TimerSession {
  final DateTime startTime;
  TimerSession({required this.startTime});
}

class FocusSession {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Color color;

  FocusSession({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.color = Colors.green,
  });
}

class FocusSessionForm extends StatefulWidget {
  final Function(FocusSession) onSave;
  const FocusSessionForm({super.key, required this.onSave});
  @override
  State<FocusSessionForm> createState() => _FocusSessionFormState();
}

class _FocusSessionFormState extends State<FocusSessionForm> {
  final _titleController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  void _showCustomTimePicker(BuildContext context, bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      if (isStartTime) {
        setState(() => _startTime = selectedTime);
      } else {
        setState(() => _endTime = selectedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Textfield(
              text: 'Session Title',
              obsecureText: false,
              controller: _titleController),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                    title: Text(
                      'Start Time',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      _startTime.format(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _showCustomTimePicker(context, true)),
              ),
              Expanded(
                child: ListTile(
                    title: Text(
                      'End Time',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      _endTime.format(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () => _showCustomTimePicker(context, false)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: _saveSession,
                  child: Text(
                    'Save',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveSession() {
    if (_titleController.text.trim().isEmpty) return;
    final session = FocusSession(
      title: _titleController.text,
      startTime: _startTime,
      endTime: _endTime,
    );
    widget.onSave(session);
    Navigator.pop(context);
  }
}
