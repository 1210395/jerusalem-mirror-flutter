# Jerusalem Heritage AI Mirror

A Flutter rebuild of the Stitch "Jerusalem Heritage AI Mirror" installation: a
museum-style temporal mirror that lets a visitor pick a historical Palestinian
costume, take a photo, and see themselves rendered in that heritage garment via
the FAL AI image-edit API.

Architecture mirrors the sister project `bosalati-flutter`:
single `ChangeNotifier` for global state, one screen at a time driven by a
`currentScreen` index, FAL AI service for image generation.

## Flow (7 screens)

| # | Screen | Purpose |
|---|---|---|
| 0 | Welcome | "Temporal Mirror" hero, "Start the Journey" CTA |
| 1 | Profile | Gender selection (tailors costume prompts) |
| 2 | Costume Select | Grid of 8 historical Palestinian garments |
| 3 | Garment Detail | Era / region / significance / Tatreez heritage fact |
| 4 | Capture | Camera preview + 3-sec countdown with body silhouette guide |
| 5 | Processing | Calls FAL AI, status cycling, processing video loop |
| 6 | Souvenir | Final reveal with QR code placeholder + share |

## Setup

```bash
cd jerusalem-mirror-flutter
flutter create --project-name jerusalem_mirror .   # generates android/ ios/ scaffold
flutter pub get
flutter run
```

The first `flutter create .` only generates the missing native folders — it
will not overwrite the existing `lib/`, `pubspec.yaml`, or `assets/`.

## Optional assets

The app renders entirely from Material icons + gradients out of the box. Drop
these in `assets/` to enrich it:

- `assets/images/hero.webp` — used by the Welcome screen background
- `assets/video/processing.mp4` — looping pattern shown during AI generation

## API key

The FAL key is hardcoded in `lib/services/fal_ai.dart` to mirror the bosalati
pattern. Replace it with your own key, or move it behind `--dart-define` /
a backend proxy before publishing.
