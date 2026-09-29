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

## Tests de widgets (objectif brief : ≥ 5 — actuel : 2, complété au Sprint 8)

| Fichier | Nombre de tests |
|---|---|
| `test/widgets/add_book_form_test.dart` (Sprint 4) | 2 |

## Tests d'intégration (objectif brief : ≥ 2 — actuel : 0, complété au Sprint 9)

Aucun pour l'instant.

## Pourquoi un `FakeAssetBundle` plutôt que `rootBundle` dans les tests

`BookRepository` prend un `AssetBundle` en paramètre optionnel (constructeur, voir Sprint 1) précisément pour permettre ce genre de test : `test/support/fake_asset_bundle.dart` sert un JSON fourni en mémoire, sans dépendre du vrai fichier `assets/data/books.json` ni du moteur Flutter pour charger un asset. Ça permet aussi de tester le cas d'erreur (JSON malformé) sans avoir à casser le vrai fichier d'assets.

## Prochaines étapes
- Sprint 8 : tests de widgets (BookCard, LibraryScreen avec overrides Riverpod, SettingsScreen, MyListTile avec l'action sémantique du Sprint 6)
- Sprint 9 : 2 tests d'intégration (parcours complet : ajouter un livre → le retrouver → l'ajouter à ma liste ; et recherche/filtre)
