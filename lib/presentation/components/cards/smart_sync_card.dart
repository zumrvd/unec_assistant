import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';
import '../../../providers/smart_sync_provider.dart';

class SmartSyncCard extends ConsumerStatefulWidget {
  final SmartSyncPreferences prefs;

  const SmartSyncCard({required this.prefs, super.key});

  @override
  ConsumerState<SmartSyncCard> createState() => _SmartSyncCardState();
}

class _SmartSyncCardState extends ConsumerState<SmartSyncCard> {
  Widget _prefCheckboxRow({
    required bool checked,
    required bool enabled,
    required String title,
    String? badge,
    String? description,
    required ValueChanged<bool> onChanged,
    required AppColors appColors,
  }) {
    final Color mainColor = enabled
        ? appColors.textPrimary
        : appColors.textMuted;
    final Color subColor = enabled
        ? appColors.textSecondary
        : appColors.textMuted;

    return GestureDetector(
      onTap: enabled ? () => onChanged(!checked) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? appColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: checked ? appColors.primary : appColors.borderColor,
                width: 1.5,
              ),
            ),
            child: checked
                ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    Text(
                      softWrap: true,
                      title,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: mainColor,
                      ),
                    ),

                    if (badge != null) ...[
                      Text(
                        badge,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: appColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    softWrap: true,
                    style: GoogleFonts.redditSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: subColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = ref.watch(appColorsProvider);
    final tr = ref.watch(strProvider);

    return ListenableBuilder(
      listenable: widget.prefs,
      builder: (context, child) {
        final prefs = widget.prefs;
        final isEnabled = prefs.isEnabled;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: appColors.borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık ve Switch Alanı
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: appColors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.cloud_sync_rounded,
                            size: 20,
                            color: appColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tr.smartSyncTitle,
                            softWrap: true,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: appColors.primary,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: isEnabled,
                    activeThumbColor: appColors.primary,
                    onChanged: (v) => prefs.toggleEnabled(v),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tr.smartSyncDesc,
                softWrap: true,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: isEnabled
                      ? appColors.textSecondary
                      : appColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: appColors.borderColor, thickness: 1),
              const SizedBox(height: 8),

              IgnorePointer(
                ignoring: !isEnabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.smartSyncDownloadPrefs,
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isEnabled
                            ? appColors.textPrimary
                            : appColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isEnabled
                                ? appColors.attendanceOrange.withValues(
                                    alpha: 0.15,
                                  )
                                : appColors.borderColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: isEnabled
                                    ? appColors.attendanceOrange
                                    : appColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tr.smartSyncWhichFiles,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isEnabled
                                  ? appColors.attendanceOrange
                                  : appColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _prefCheckboxRow(
                      checked: prefs.downloadCurrentClass,
                      enabled: isEnabled,
                      title: tr.smartSyncCurrentClass,
                      badge: tr.smartSyncCurrentBadge,
                      description: tr.smartSyncCurrentDesc,
                      onChanged: (v) => prefs.updateCurrentClass(v),
                      appColors: appColors,
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadUpcomingClass,
                      enabled: isEnabled,
                      title: tr.smartSyncUpcomingClass,
                      description: tr.smartSyncUpcomingDesc,
                      onChanged: (v) => prefs.updateUpcomingClass(v),
                      appColors: appColors,
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadPreviousClass,
                      enabled: isEnabled,
                      title: tr.smartSyncPreviousClass,
                      description: tr.smartSyncPreviousDesc,
                      onChanged: (v) => prefs.updatePreviousClass(v),
                      appColors: appColors,
                    ),

                    const SizedBox(height: 16),
                    Divider(color: appColors.borderColor, thickness: 0.5),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isEnabled
                                ? appColors.infoPink.withValues(alpha: 0.15)
                                : appColors.borderColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "2",
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: isEnabled
                                    ? appColors.infoPink
                                    : appColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tr.smartSyncFileTypes,
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isEnabled
                                  ? appColors.infoPink
                                  : appColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadLecture,
                      enabled: isEnabled,
                      title: tr.smartSyncLecture,
                      onChanged: (v) => prefs.updateLecture(v),
                      appColors: appColors,
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadPresentation,
                      enabled: isEnabled,
                      title: tr.smartSyncPresentation,
                      onChanged: (v) => prefs.updatePresentation(v),
                      appColors: appColors,
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadSeminar,
                      enabled: isEnabled,
                      title: tr.smartSyncSeminar,
                      onChanged: (v) => prefs.updateSeminar(v),
                      appColors: appColors,
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadOther,
                      enabled: isEnabled,
                      title: tr.smartSyncOtherFiles,
                      onChanged: (v) => prefs.updateOther(v),
                      appColors: appColors,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
