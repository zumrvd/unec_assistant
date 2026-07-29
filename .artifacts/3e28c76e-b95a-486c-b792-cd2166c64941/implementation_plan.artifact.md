# Implementation Plan - Component UI Refinement

This plan details the refinements needed to make the Subject Detail screen components identical to the provided design.

## Proposed Changes

### [MODIFY] [ClassLoadCard](file:///C:/src/unec_assistant/lib/presentation/components/cards/class_load_card.dart)
- **Icon Update**: Change `Icons.schedule_rounded` to `Icons.access_time_filled_rounded`.
- **Icon Background**: Wrap the header icon in a styled container (30x30, 8dp radius, 15% opacity background).
- **Full-width Divider**: Remove card padding and apply horizontal padding (16dp) only to the header and the boxes row, allowing the `Divider` to touch the edges.
- **Info Boxes**: Add a 1dp solid border (`Color(0xFFE0E4F0)`) to the `_loadBox` containers.

### [MODIFY] [SubjectHoursCard](file:///C:/src/unec_assistant/lib/presentation/components/cards/subject_hours_card.dart)
- **Icon Background**: Wrap the header icon in a styled container (30x30, 8dp radius, 15% opacity background).
- **Full-width Dividers**: Remove card padding and apply horizontal padding (16dp) to content rows.
- **Breakdown Section**:
    - Add a background `Container` for the breakdown section with a light gray tint (`Color(0xFFF8F9FC)`).
    - Apply padding (16dp) inside this tinted container.
    - Ensure the breakdown section spans the full width of the card.

### [MODIFY] [SubjectCreditCard](file:///C:/src/unec_assistant/lib/presentation/components/cards/subject_credit_card.dart)
- **Icon Update**: Change `Icons.diamond_rounded` to `Icons.diamond` (filled).
- **Icon Background**: Wrap the header icon in a styled container (30x30, 8dp radius, 15% opacity background).
- **Icon Color**: Change the "info" icon color to gray (`Color(0xFF838A97)`).
- **Full-width Divider**: Remove card padding and apply horizontal padding (16dp) to content.
- **Credit Info Background**: Wrap the credit explanation text section in a styled `Container` with a light gray background (`Color(0xFFF8F9FC)`) and 12dp border radius.

### [MODIFY] [SemesterInfoCard](file:///C:/src/unec_assistant/lib/presentation/components/cards/semester_info_card.dart)
- **Icon Backgrounds**: Apply the 15% opacity background container to all icons in the `_infoRow` and header.
- **Full-width Divider**: Remove card padding and apply horizontal padding to items.
- **Breakdown Section**: Similar to `SubjectHoursCard`, wrap the breakdown in a tinted full-width container.

### [MODIFY] [TeacherCard](file:///C:/src/unec_assistant/lib/presentation/components/cards/teacher_card.dart)
- **Consistency**: While not explicitly mentioned for this card, I will ensure it follows the same padding/border style as the other refined cards.

## Verification Plan

### Manual Verification
- Review each card in the Subject Detail screen to ensure:
    - Dividers touch the card edges.
    - Icons are inside rounded rectangular tinted boxes.
    - Breakdown and credit info sections have the correct background tint.
    - Info boxes in Class Load have borders.
    - Icons are correctly filled/colored as requested.
