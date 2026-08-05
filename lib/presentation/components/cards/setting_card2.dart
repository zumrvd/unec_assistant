import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsCard2 extends StatefulWidget {
  const SettingsCard2({
    required this.onAboutAppTap,
    super.key,
  });

  final VoidCallback onAboutAppTap;

  @override
  State<SettingsCard2> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard2> {
  String _selectedTheme = 'System';
  bool _notificationsOn = true;
  String _selectedLanguage = 'English';

  static const _borderColor = Color(0xFFE0E4F0);
  static const _labelGrey = Color(0x80838A97);
  static const _subtitleColor = Color(0xFF838A97);
  static const _primaryBlue = Color(0xFF0569FF);
  static const _themeOptions = ['System', 'Light', 'Dark'];
  static const _languageOptions = ['English', 'Azərbaycan dili', 'Русский язык'];

  Widget _iconBox(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
    );
  }

  TextStyle _labelStyle() {
    return GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 13,
      color: const Color(0xFF000000),
    );
  }

  Widget _themeToggle(String option) {
    final isSelected = _selectedTheme == option;
    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2C415C)
              : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _borderColor,
            width: 1,
          ),
        ),
        child: Text(
          option,
          style: GoogleFonts.redditSans(
            fontWeight: FontWeight.w700,
            fontSize: 9,
            color: isSelected
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF838A97),
          ),
        ),
      ),
    );
  }

  Widget _languageDropdown() {
    final textStyle = GoogleFonts.redditSans(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: const Color(0xFFFFFFFF),
    );

    return Container(
      decoration: BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 37,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          onChanged: (val) => setState(() => _selectedLanguage = val!),
          dropdownColor: _primaryBlue,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: Color(0xFFFFFFFF),
            size: 25,
          ),
          style: textStyle,
          selectedItemBuilder: (context) {
            return _languageOptions
                .map(
                  (option) => Align(
                alignment: Alignment.centerLeft,
                child: Text(option, style: textStyle),
              ),
            )
                .toList();
          },
          items: _languageOptions
              .map(
                (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: textStyle),
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.palette_rounded,
                      const Color(0x26E3993C),
                      const Color(0xFF854F0B),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text('App Theme', style: _labelStyle())),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  _themeToggle(_themeOptions[0]),
                  const SizedBox(width: 7),
                  _themeToggle(_themeOptions[1]),
                  const SizedBox(width: 7),
                  _themeToggle(_themeOptions[2]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.notifications_rounded,
                      const Color(0x26534AB7),
                      const Color(0xFF534AB7),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Notifications', style: _labelStyle())),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: _notificationsOn,
                onChanged: (val) => setState(() => _notificationsOn = val),
                activeThumbColor: const Color(0xFFFFFFFF),
                activeTrackColor: const Color(0xFF0569FF),
                inactiveThumbColor: const Color(0xFFFFFFFF),
                inactiveTrackColor: const Color(0x80838A97),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: widget.onAboutAppTap,
            behavior: HitTestBehavior.opaque,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _iconBox(
                        Icons.info_rounded,
                        const Color(0x26DA4979),
                        const Color(0xFFDA4979),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About App', style: _labelStyle()),
                            const SizedBox(height: 2),
                            Text(
                              'v 1.1.0 IT team inc.',
                              style: GoogleFonts.redditSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 9,
                                color: _subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0x26838A97),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    size: 25,
                    color: _labelGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          const Divider(
            color: _borderColor,
            thickness: 1,
            height: 1,
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconBox(
                      Icons.language_rounded,
                      const Color(0x260569FF),
                      const Color(0xFF0569FF),
                    ),

                    const SizedBox(width: 12),

                    Expanded(child: Text('Language', style: _labelStyle())),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _languageDropdown(),
            ],
          ),
        ],
      ),
    );
  }
}
