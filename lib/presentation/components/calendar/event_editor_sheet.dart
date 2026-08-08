import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/models/calendar_event.dart';
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

class _EventEditorSheet extends StatefulWidget {
  const _EventEditorSheet({
    required this.initialDay,
    this.existing,
  });

  final CalendarEvent? existing;
  final DateTime initialDay;

  @override
  State<_EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends State<_EventEditorSheet> {
  static const _border = Color(0xFFE0E4F0);
  static const _blue = Color(0xFF0569FF);
  static const _grey = Color(0xFF838A97);
  static const _dark = Color(0xFF1F1F1F);

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

    var start = DateTime(_day.year, _day.month, _day.day, _start.hour, _start.minute);
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
        id: widget.existing?.id ??
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

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.redditSans(color: _grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _blue),
      ),
    );
  }

  Widget _chip(String label, EventType type) {
    final selected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _blue : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _border),
        ),
        child: Text(
          label,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: selected ? const Color(0xFFF8F9FC) : _grey,
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.redditSans(
                  fontSize: 11,
                  color: _grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.redditSans(
                  fontSize: 14,
                  color: _dark,
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
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final isEdit = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                    color: _border,
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
                  color: _dark,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleCtrl,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _dark,
                ),
                decoration: _fieldDecoration('Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                style: GoogleFonts.redditSans(fontSize: 14, color: _dark),
                decoration: _fieldDecoration('Description'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationCtrl,
                style: GoogleFonts.redditSans(fontSize: 14, color: _dark),
                decoration: _fieldDecoration('Location'),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _pickerTile(
                    label: 'Date',
                    value: '${_day.day}/${_day.month}/${_day.year}',
                    onTap: _pickDate,
                  ),
                  const SizedBox(width: 10),
                  _pickerTile(
                    label: 'Start',
                    value: _formatTime(_start),
                    onTap: () => _pickTime(isStart: true),
                  ),
                  const SizedBox(width: 10),
                  _pickerTile(
                    label: 'End',
                    value: _formatTime(_end),
                    onTap: () => _pickTime(isStart: false),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Category',
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _chip('Class', EventType.classEvent),
                  const SizedBox(width: 8),
                  _chip('Personal', EventType.personalEvent),
                  const SizedBox(width: 8),
                  _chip('Exam', EventType.exam),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _blue,
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
