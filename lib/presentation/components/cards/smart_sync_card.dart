import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/smart_sync_provider.dart';

class SmartSyncCard extends StatefulWidget {
  final SmartSyncPreferences prefs;

  const SmartSyncCard({
    required this.prefs,
    super.key,
  });

  @override
  State<SmartSyncCard> createState() => _SmartSyncCardState();
}

class _SmartSyncCardState extends State<SmartSyncCard> {
  Widget _prefCheckboxRow({
    required bool checked,
    required bool enabled,
    required String title,
    String? badge,
    String? description,
    required ValueChanged<bool> onChanged,
  }) {
    final Color mainColor = enabled ? const Color(0xFF1F1F1F) : const Color(0x801F1F1F);
    final Color subColor = enabled ? const Color(0xFF838A97) : const Color(0x80838A97);

    return GestureDetector(
      onTap: enabled ? () => onChanged(!checked) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? const Color(0xFF0569FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: checked ? const Color(0xFF0569FF) : const Color(0xFFE0E4F0),
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
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0x80838A97),
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
    return ListenableBuilder(
      listenable: widget.prefs,
      builder: (context, child) {
        final prefs = widget.prefs;
        final isEnabled = prefs.isEnabled;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE0E4F0),
              width: 1,
            ),
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
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0x260569FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cloud_sync_rounded,
                          size: 20,
                          color: Color(0xFF0569FF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Smart Sync",
                        style: GoogleFonts.redditSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: const Color(0xFF0569FF),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isEnabled,
                    activeThumbColor: const Color(0xFF0569FF),
                    onChanged: (v) => prefs.toggleEnabled(v),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Automatically download and update your class files so you're always prepared.",
                softWrap: true,
                style: GoogleFonts.redditSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: isEnabled ? const Color(0xFF838A97) : const Color(0x80838A97),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFFE0E4F0), thickness: 1),
              const SizedBox(height: 8),

              // Tercihler Bölümü
              IgnorePointer(
                ignoring: !isEnabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Download Preferences",
                      style: GoogleFonts.redditSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isEnabled ? const Color(0xFF1F1F1F) : const Color(0x801F1F1F),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 1. BAŞLIK: Hangi Dosyalar (Which Files)
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isEnabled ? const Color(0x26E3993C) : const Color(0xFFE0E4F0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: isEnabled ? const Color(0xFFE3993C) : const Color(0xFF838A97),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Select which files you want to keep up-to-date:",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isEnabled ? const Color(0xFFE3993C) : const Color(0x80838A97),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Hangi Dosyalar Altındaki Seçenekler
                    _prefCheckboxRow(
                      checked: prefs.downloadCurrentClass,
                      enabled: isEnabled,
                      title: "Current Class",
                      badge: "(Highly Recommended)",
                      description: "Always be prepared for class. Downloads essential files 30 minutes before lesson.",
                      onChanged: (v) => prefs.updateCurrentClass(v),
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadUpcomingClass,
                      enabled: isEnabled,
                      title: "Upcoming Class",
                      description: "Get a head start on next class's materials.",
                      onChanged: (v) => prefs.updateUpcomingClass(v),
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadPreviousClass,
                      enabled: isEnabled,
                      title: "Previous Class",
                      description: "Keep last class's file for quick review.",
                      onChanged: (v) => prefs.updatePreviousClass(v),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE0E4F0), thickness: 0.5),
                    const SizedBox(height: 12),

                    // 2. BAŞLIK: Dosya Türleri (Types of Files)
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isEnabled ? const Color(0x26E16890) : const Color(0xFFE0E4F0),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "2",
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: isEnabled ? const Color(0xFFE16890) : const Color(0xFF838A97),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Select types of files to download:",
                            style: GoogleFonts.redditSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isEnabled ? const Color(0xFFE16890) : const Color(0x80838A97),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadLecture,
                      enabled: isEnabled,
                      title: "Lecture",
                      onChanged: (v) => prefs.updateLecture(v),
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadPresentation,
                      enabled: isEnabled,
                      title: "Presentation",
                      onChanged: (v) => prefs.updatePresentation(v),
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadSeminar,
                      enabled: isEnabled,
                      title: "Seminar",
                      onChanged: (v) => prefs.updateSeminar(v),
                    ),
                    const SizedBox(height: 10),
                    _prefCheckboxRow(
                      checked: prefs.downloadOther,
                      enabled: isEnabled,
                      title: "Other Files",
                      onChanged: (v) => prefs.updateOther(v),
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