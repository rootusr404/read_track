# ReadTrack 📚

[![CI](https://github.com/<TON_USER>/read_track/actions/workflows/ci.yml/badge.svg)](https://github.com/<TON_USER>/read_track/actions/workflows/ci.yml)

Tracker de bibliothèque personnelle (livres à lire / lus / favoris) — projet Flutter production-ready (tests, performance, accessibilité, internationalisation).

> ⚠️ Ce README est un squelette de Sprint 0. Les sections marquées `TODO` seront complétées au fil des sprints (captures d'écran au Sprint 6, détails des tests aux Sprints 7-9).

## Sommaire
- [Fonctionnalités](#fonctionnalités)
- [Architecture](#architecture)
- [Tableau exigence → fichier](#tableau-exigence--fichier)
- [Setup](#setup)
- [Tests](#tests)
- [Captures d'écran](#captures-décran) *(TODO)*

## Fonctionnalités
- 5 écrans : Bibliothèque, Détail livre, Ajouter un livre, Ma liste, Réglages
- Données mockées (JSON en asset) + persistance locale des favoris/lus via Hive
- Thème clair/sombre, support FR/EN
- Suite de tests complète (unitaires, widgets, intégration)

## Architecture
Architecture en couches par responsabilité (pas de dossier "flat") :

```
lib/
├── main.dart
├── l10n/            # Fichiers .arb (FR/EN) + gen-l10n
├── theme/           # Thème clair/sombre
├── models/          # Entités de données (Book)
├── data/            # Repository<T>, BookRepository, MyListStorage (Hive)
├── providers/       # Riverpod : catalogue, filtre/recherche, ma liste, locale
├── router/          # GoRouter, 5 routes nommées
├── screens/         # Les 5 écrans de l'application
├── widgets/         # Widgets réutilisables (BookCard, SearchBarWidget, ...)
└── utils/           # Utilitaires (responsive, etc.)
```

## Tableau exigence → fichier

| Exigence de la consigne | Fichier(s) concerné(s) | Statut |
|---|---|---|
| Au moins 5 écrans | `lib/screens/*.dart` | TODO (Sprints 3-5) |
| ≥ 10 tests unitaires | `test/models/`, `test/data/`, `test/providers/` | TODO (Sprint 7) |
| ≥ 5 tests de widgets | `test/widgets/`, `test/screens/` | TODO (Sprint 8) |
| ≥ 2 tests d'intégration | `integration_test/*.dart` | TODO (Sprint 9) |
| Images optimisées / lazy-loadées | `cached_network_image` dans `widgets/book_card.dart` | TODO (Sprint 3) |
| Pas de rebuilds inutiles | `const` partout + `flutter_hooks` dans `add_book_screen.dart` | TODO (Sprint 4) |
| Accessibilité (semantic labels) | `Semantics`/`tooltip` sur tous les écrans, audit détaillé dans `ACCESSIBILITY.md` | ✅ Fait (Sprint 6) |
| Internationalisation FR/EN | `lib/l10n/app_fr.arb`, `lib/l10n/app_en.arb`, `settings_screen.dart` | ✅ Fait (Sprint 5) |
| CI/CD (lint + tests) | `.github/workflows/ci.yml` | ✅ Fait (Sprint 0) |
| `flutter analyze` propre | `analysis_options.yaml` | ✅ Fait (Sprint 0) |
| README professionnel | ce fichier | 🚧 En cours |
| CHANGELOG (≥ 3 versions) | `CHANGELOG.md` | 🚧 En cours (1/4 versions) |

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # génère les adapters Hive
flutter gen-l10n                                            # génère les classes de traduction
flutter run
```

## Tests

```bash
flutter test --coverage        # tests unitaires + widgets
flutter test integration_test/ # tests d'intégration
```

## Captures d'écran
*(TODO — à ajouter par toi : lance `flutter run`, capture les 5 écrans en clair et en sombre, place-les dans `docs/screenshots/`, puis remplace ce paragraphe par les images, ex. `![Bibliothèque](docs/screenshots/library.png)`. Je n'ai pas d'émulateur dans cet environnement pour les générer moi-même.)*
