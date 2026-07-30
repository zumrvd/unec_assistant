# Implementation Plan - Grade Calculator UI Refinement

This plan aims to refine the `GradeCalculatorScreen` and `GradeCalculatorCard` to perfectly match the provided design reference.

## Proposed Changes

### 1. Layout Integration

#### [MODIFY] [grade_calculator_screen.dart](file:///C:/src/unec_assistant/lib/screens/functions/grade_calculator_screen.dart)
- Remove the vertical gap (`SizedBox(height: 16)`) between the `GradeCalculatorButton` and `GradeCalculatorCard`.
- Adjust the `GradeCalculatorButton` and `GradeCalculatorCard` to share a common visual boundary (e.g., removing bottom radius of the header and top radius of the card).

### 2. Component Refinement

#### [MODIFY] [grade_calculator_card.dart](file:///C:/src/unec_assistant/lib/presentation/components/cards/grade_calculator_card.dart)

**A. Dropdown & Labels**
- Add a tinted background (`Color(0xFFF8F9FC)`) to the dropdown container.
- Increase font size for "CALCULATE FOR" and "I want to achieve" labels.

**B. Grade Tiles**
- Add tinted backgrounds to tiles (15% opacity of the grade color).
- Add 1dp solid borders matching the grade color when selected.
- Add horizontal spacing between tiles.
- Increase text sizes for grade letters and ranges.

**C. Current Score Container**
- Wrap the entire result section in a styled `Container` with:
    - Tinted background (`Color(0xFFF8F9FC)`).
    - 15dp border radius.
    - 1dp solid border (`#E0E4F0`).
    - Internal padding (16dp).
- Increase font sizes for "Current Score" and the score numbers.

**D. Progress Line (Dual Segment)**
- Implement a three-layered progress bar:
    - Layer 1 (Background): Gray (`#E0E4F0`).
    - Layer 2 (Green - Needed): Segment from `currentScore` to `targetMinScore`.
    - Layer 3 (Blue - Have): Segment from 0 to `currentScore`.
- Update text colors: "Have: X" in Blue (`#0569FF`), "Need: Y" in Green (`#0F6E11`).

**E. Result Highlight**
- Refine the green circle:
    - Background: Faded green (`#0F6E11` at 15% opacity).
    - Border: 1dp solid matching the circle color.
    - Text: Dark green (`#0F6E11`), font size 18-20.
- Update the bottom explanation text to be right-aligned and more prominent.

## Verification Plan

### Manual Verification
- Verify that the header and card look like a single unit.
- Check that selecting a grade updates the tile border and background.
- Confirm that the progress bar shows two distinct colored segments (Blue and Green).
- Ensure the result box at the bottom is tinted and clearly separated.
- Verify text scaling against the reference photo.
