# Changelog

Toutes les modifications notables de ce projet sont documentées ici.
Format inspiré de [Keep a Changelog](https://keepachangelog.com/fr/).

## [1.0.0] - Version production-ready
- **5 écrans** : Bibliothèque, Détail livre, Ajouter un livre, Ma liste, Réglages, reliés par `GoRouter` (navigation par onglets + routes empilées)
- **Persistance locale** (Hive) pour "Ma liste" et les réglages (thème, langue) — survit à la fermeture de l'app
- **Internationalisation complète** FR/EN via `gen-l10n`, bascule immédiate depuis les Réglages
- **Thème clair/sombre** (Material 3), également persisté
- **Accessibilité** : audit dédié (`ACCESSIBILITY.md`), actions sémantiques pour les interactions qui dépendent normalement d'un geste (balayage), annonces `liveRegion` pour le contenu asynchrone
- **Performance** : images en cache et redimensionnées à l'affichage (`cached_network_image`), `flutter_hooks` pour éviter les rebuilds inutiles liés aux contrôleurs de formulaire
- **49 tests** : 32 unitaires, 15 widgets, 2 intégration (bilan détaillé dans `TEST_COVERAGE.md`)
- **CI/CD** : lint, format, tests unitaires/widgets et tests d'intégration sur chaque push (`.github/workflows/ci.yml`)

## [0.1.9] - Tests d'intégration
- 2 tests d'intégration : ajout et suivi d'un livre de bout en bout ; recherche et filtre par favori à travers plusieurs écrans

## [0.1.8] - Tests de widgets
- 15 tests de widgets : `BookCard`, `LibraryScreen`, `SettingsScreen`, `MyListTile`

## [0.1.7] - Tests unitaires
- 32 tests unitaires : modèles, filtre de recherche, `BookRepository`, `MyListStorage`, `SettingsStorage`

## [0.1.6] - Accessibilité
- Audit d'accessibilité des 5 écrans (`ACCESSIBILITY.md`)
- Annonces `liveRegion` pour les résultats de recherche et les erreurs
- Action de suppression accessible sans geste de balayage sur "Ma liste"

## [0.1.5] - Réglages
- Écran Réglages : thème clair/sombre et langue FR/EN, tous deux persistés (Hive)

## [0.1.4] - Formulaire d'ajout et Ma liste
- Écran "Ajouter un livre" avec validation de formulaire (`flutter_hooks`)
- Finalisation de l'écran "Ma liste" (suppression par balayage avec confirmation)

## [0.1.3] - Navigation et premiers écrans
- App shell, thème Material 3, `GoRouter` (navigation par onglets)
- Écrans Bibliothèque et Détail livre fonctionnels
- Images en cache (`cached_network_image`)

## [0.1.2] - Gestion d'état
- Providers Riverpod : catalogue, recherche, filtres, "Ma liste", thème, langue

## [0.1.1] - Couche de données
- Modèle `Book`, données mockées (12 livres), `Repository<T>`, `BookRepository`, `MyListStorage`

## [0.1.0] - Mise en place du projet
- Architecture du projet, configuration `gen-l10n`, `.gitignore`, `analysis_options.yaml`
- CI GitHub Actions (lint + tests) dès la base
