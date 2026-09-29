# Bilan de la suite de tests — Sprint 7

## Tests unitaires (objectif brief : ≥ 10)

| Fichier | Nombre de `test()` | Couvre |
|---|---|---|
| `test/models/book_test.dart` | 5 | Égalité par valeur, `fromJson`/`toJson`, valeurs par défaut |
| `test/models/my_list_entry_test.dart` | 3 | Valeurs par défaut, `copyWith`, round-trip JSON |
| `test/utils/book_filter_test.dart` | 9 | Recherche, catégorie, chaque statut, combinaisons |
| `test/data/book_repository_test.dart` | 7 | Chargement, cache, erreur JSON, `getById`, `add` (succès + doublon) |
| `test/data/my_list_storage_test.dart` | 5 | Lecture vide, sauvegarde, écrasement, suppression, vidage |
| `test/data/settings_storage_test.dart` (Sprint 5) | 3 | Valeurs par défaut, persistance thème, persistance langue |
| **Total unitaires** | **32** | ✅ largement au-dessus de l'objectif (≥10) |

## Tests de widgets (objectif brief : ≥ 5)

| Fichier | Nombre de tests | Couvre |
|---|---|---|
| `test/widgets/add_book_form_test.dart` (Sprint 4) | 2 | Validation par champ |
| `test/widgets/book_card_test.dart` | 4 | Rendu, icônes conditionnelles, tap |
| `test/screens/library_screen_test.dart` | 4 | Liste, recherche, état vide, effacement |
| `test/screens/settings_screen_test.dart` | 3 | État initial, bascule thème, changement de langue |
| `test/widgets/my_list_tile_test.dart` | 2 | Suppression confirmée / annulée |
| **Total widgets** | **15** | ✅ largement au-dessus de l'objectif (≥5) |

Ces tests réutilisent `FakeAssetBundle` (Sprint 7) pour `LibraryScreen`, et un vrai `Box<String>` Hive sur répertoire temporaire (`Hive.init(tempDir.path)`) pour `MyListStorage`/`SettingsStorage` — même pattern que les tests unitaires, plutôt que de mocker ces classes.

## Tests d'intégration (objectif brief : ≥ 2)

| Fichier | Parcours couvert |
|---|---|
| `integration_test/add_and_track_book_test.dart` | Ajouter un livre -> le retrouver dans la Bibliothèque -> ouvrir sa fiche -> l'ajouter à "Ma liste" -> le retrouver dans l'onglet "Ma liste" |
| `integration_test/search_and_filter_test.dart` | Recherche par titre -> filtre "Favoris" vide -> marquer un livre favori depuis sa fiche -> retour à la Bibliothèque -> le filtre "Favoris" le montre |

**Total : 2 tests d'intégration** — ✅ atteint l'objectif (≥2).

Ces deux tests utilisent l'app réelle (`ReadTrackApp`, y compris `GoRouter`) plutôt qu'un écran isolé — c'est ce qui les distingue des tests de widgets du Sprint 8. `Hive.init()` est appelé manuellement sur un répertoire temporaire (pas `Hive.initFlutter()`), car `path_provider` n'a pas d'implémentation native disponible sous le runner `flutter test` sans device.

## Pourquoi un `FakeAssetBundle` plutôt que `rootBundle` dans les tests

`BookRepository` prend un `AssetBundle` en paramètre optionnel (constructeur, voir Sprint 1) précisément pour permettre ce genre de test : `test/support/fake_asset_bundle.dart` sert un JSON fourni en mémoire, sans dépendre du vrai fichier `assets/data/books.json` ni du moteur Flutter pour charger un asset. Ça permet aussi de tester le cas d'erreur (JSON malformé) sans avoir à casser le vrai fichier d'assets.

## Bilan global

32 tests unitaires + 15 tests de widgets + 2 tests d'intégration = **49 tests**, sur les 3 catégories requises par le brief (≥10 / ≥5 / ≥2). Reste au Sprint 10 : passe finale (README, CHANGELOG, vérification GitHub complète).
