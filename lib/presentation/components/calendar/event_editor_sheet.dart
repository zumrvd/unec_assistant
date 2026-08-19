import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import 'package:unec_assistant/utils/subject_event_link.dart';

Future<CalendarEvent?> showEventEditorSheet(
  BuildContext context, {
  CalendarEvent? existing,
  DateTime? initialDay,
}) {
  return showModalBottomSheet<CalendarEvent>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _EventEditorSheet(
        existing: existing,
        initialDay: initialDay ?? DateTime.now(),
      );
    },
  );
}

class _EventEditorSheet extends ConsumerStatefulWidget {
  const _EventEditorSheet({required this.initialDay, this.existing});

  final CalendarEvent? existing;
  final DateTime initialDay;

  @override
  ConsumerState<_EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends ConsumerState<_EventEditorSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _locationCtrl;
  late DateTime _day;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late EventType _type;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _locationCtrl = TextEditingController(text: e?.location ?? '');
    _day = normalizeDay(e?.startTime ?? widget.initialDay);
    _start = e != null
        ? TimeOfDay(hour: e.startTime.hour, minute: e.startTime.minute)
        : const TimeOfDay(hour: 9, minute: 0);
    _end = e != null
        ? TimeOfDay(hour: e.endTime.hour, minute: e.endTime.minute)
        : const TimeOfDay(hour: 10, minute: 20);
    _type = e?.type ?? EventType.classEvent;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _day = normalizeDay(picked));
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _start : _end;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _submit() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    var start = DateTime(
      _day.year,
      _day.month,
      _day.day,
      _start.hour,
      _start.minute,
    );
    var end = DateTime(_day.year, _day.month, _day.day, _end.hour, _end.minute);
    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }

    final subtype = switch (_type) {
      EventType.classEvent => 'Mühazirə',
      EventType.personalEvent => 'Personal',
      EventType.exam => 'Exam',
    };

    final event = withResolvedSubjectId(
      CalendarEvent(
        id:
            widget.existing?.id ??
            'evt-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subtype: widget.existing?.subtype ?? subtype,
        location: _locationCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        startTime: start,
        endTime: end,
        type: _type,
        isRecurring: widget.existing?.isRecurring ?? false,
        // Preserve existing link when the title still resolves; re-resolve below.
        subjectId: widget.existing?.subjectId,
      ),
    );
    Navigator.of(context).pop(event);
  }

  InputDecoration _fieldDecoration(String hint, AppColors appColors) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.redditSans(
        color: appColors.textSecondary,
        fontSize: 14,
      ),
      filled: true,
      fillColor: appColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appColors.primary),
      ),
    );
  }

  Widget _chip(String label, EventType type, AppColors appColors) {
    final selected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? appColors.primary : appColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: appColors.borderColor),
        ),
        child: Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: selected ? const Color(0xFFF8F9FC) : appColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required String label,
    required String value,
    required VoidCallback onTap,
    required AppColors appColors,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: appColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: appColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.redditSans(
                  fontSize: 11,
                  color: appColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  color: appColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isEdit = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: appColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit event' : 'New event',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleCtrl,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: appColors.textPrimary,
                ),
                decoration: _fieldDecoration('Title', appColors),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  color: appColors.textPrimary,
                ),
                decoration: _fieldDecoration('Description', appColors),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationCtrl,
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  color: appColors.textPrimary,
                ),
                decoration: _fieldDecoration('Location', appColors),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _pickerTile(
                    label: 'Date',
                    value: '${_day.day}/${_day.month}/${_day.year}',
                    onTap: _pickDate,
                    appColors: appColors,
                  ),
                  const SizedBox(width: 10),
                  _pickerTile(
                    label: 'Start',
                    value: _formatTime(_start),
                    onTap: () => _pickTime(isStart: true),
                    appColors: appColors,
                  ),
                  const SizedBox(width: 10),
                  _pickerTile(
                    label: 'End',
                    value: _formatTime(_end),
                    onTap: () => _pickTime(isStart: false),
                    appColors: appColors,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Category',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _chip('Class', EventType.classEvent, appColors),
                  const SizedBox(width: 8),
                  _chip('Personal', EventType.personalEvent, appColors),
                  const SizedBox(width: 8),
                  _chip('Exam', EventType.exam, appColors),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _submit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: appColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isEdit ? 'Save changes' : 'Create event',
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: const Color(0xFFF8F9FC),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
