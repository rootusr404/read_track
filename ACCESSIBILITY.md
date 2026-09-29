# Audit d'accessibilité — Sprint 6

Passage en revue des 5 écrans. Colonne "Statut" : ✅ déjà couvert (sprints précédents), 🆕 corrigé ce sprint.

| Écran | Point vérifié | Statut |
|---|---|---|
| Bibliothèque | Carte livre : un seul élément focusable (`Semantics(button: true, label: "titre, de auteur")`), pas de double-annonce de la couverture (`ExcludeSemantics`) | ✅ Sprint 3 |
| Bibliothèque | Bouton d'ajout (FAB) : `tooltip` explicite | ✅ Sprint 3 |
| Bibliothèque | Champ de recherche : bouton d'effacement avec `tooltip`, label porté par le `hintText` du `TextField` | ✅ Sprint 3 |
| Bibliothèque | Changement de filtre/recherche : le nombre de résultats n'était annoncé nulle part (l'utilisateur voyant le voit, pas l'utilisateur de lecteur d'écran) | 🆕 `ResultsAnnouncer` (liveRegion) |
| Bibliothèque | État vide : le texte existait mais n'était pas annoncé comme changement de contenu | 🆕 `Semantics(liveRegion: true)` |
| Détail livre | Bouton favori : `tooltip` qui change selon l'état (ajouter/retirer) | ✅ Sprint 3 |
| Détail livre | Titre de section "Description" : annoncé comme en-tête (`Semantics(header: true)`) | ✅ Sprint 3 |
| Détail livre | Erreur de chargement : pas de mécanisme d'annonce (l'erreur survient de façon asynchrone, aucun focus ne s'y déplace naturellement) | 🆕 `ErrorView` en `liveRegion` |
| Ajouter un livre | Champs de formulaire : label porté par `labelText`, message d'erreur lu automatiquement par `TextFormField` | ✅ Sprint 4 |
| Ajouter un livre | Bouton de soumission : état de chargement remplace le texte par un indicateur — vérifié que `Semantics` annonce toujours un état actionnable | ✅ Sprint 4 |
| Ma liste | Suppression uniquement par balayage (`Dismissible`) : geste impossible à réaliser pour un utilisateur de lecteur d'écran (TalkBack/VoiceOver désactivent le balayage horizontal simple, réservé à la navigation) | 🆕 Action équivalente exposée via `customSemanticsActions`, disponible dans le rotor/menu d'actions |
| Ma liste | État vide : même traitement que Bibliothèque | ✅ Hérite du même widget |
| Réglages | Bascule thème : `SwitchListTile` (label + sous-titre + état lu automatiquement) | ✅ Sprint 5 |
| Réglages | Sélecteur de langue : `SegmentedButton` (état sélectionné annoncé nativement) | ✅ Sprint 5 |
| Global | Taille de cible tactile : boutons icône (favori, effacer recherche, FAB) ≥ 48×48 (comportement par défaut de `IconButton`/`FilledButton`) | ✅ Par défaut Flutter |
| Global | Contraste : `ColorScheme.fromSeed` (Material 3) garantit un contraste AA sur les combinaisons de rôles de couleur standard, en clair comme en sombre | ✅ Sprint 3 |
| Global | Mise à l'échelle du texte (jusqu'à 200%) | ⚠️ À vérifier manuellement (voir ci-dessous) |

## Non automatisable depuis cet environnement

Je n'ai pas de device/émulateur ici pour vérifier visuellement. À tester de ton côté avant le Sprint 10 :

1. **Lecteur d'écran** : active TalkBack (Android) ou VoiceOver (iOS), navigue les 5 écrans au doigt/swipe. Vérifie en particulier que l'action "Retirer de ma liste" apparaît bien dans le menu d'actions sur l'écran Ma liste.
2. **Mise à l'échelle du texte** : Réglages système → Affichage → Taille de police à 200%, puis relance l'app. Vérifie qu'aucun texte n'est coupé (attention particulière à `BookCard` : titre sur 2 lignes max, le reste peut déborder si la carte est trop contrainte).
3. **Contraste en conditions réelles** : vérifie le mode sombre sur un écran OLED en extérieur.

## Fichiers modifiés

- `lib/widgets/results_announcer.dart` (nouveau)
- `lib/widgets/error_view.dart`
- `lib/widgets/my_list_tile.dart`
- `lib/screens/library_screen.dart`
- `lib/l10n/app_en.arb`, `app_fr.arb` (clés `libraryResultsCount`, `myListRemoveAction`)
