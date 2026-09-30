# Audit d'accessibilité

Passage en revue des 5 écrans de l'application.

| Écran | Point vérifié | Statut |
|---|---|---|
| Bibliothèque | Carte livre : un seul élément focusable (`Semantics(button: true, label: "titre, de auteur")`), pas de double-annonce de la couverture (`ExcludeSemantics`) | ✅ |
| Bibliothèque | Bouton d'ajout (FAB) : `tooltip` explicite | ✅ |
| Bibliothèque | Champ de recherche : bouton d'effacement avec `tooltip`, label porté par le `hintText` du `TextField` | ✅ |
| Bibliothèque | Changement de filtre/recherche : annonce du nombre de résultats pour les lecteurs d'écran (`ResultsAnnouncer`, `liveRegion`) | ✅ |
| Bibliothèque | État vide : annoncé comme changement de contenu (`Semantics(liveRegion: true)`) | ✅ |
| Détail livre | Bouton favori : `tooltip` qui change selon l'état (ajouter/retirer) | ✅ |
| Détail livre | Titre de section "Description" : annoncé comme en-tête (`Semantics(header: true)`) | ✅ |
| Détail livre | Erreur de chargement : annoncée via `liveRegion` dès son apparition (l'erreur survient de façon asynchrone, aucun focus ne s'y déplace naturellement) | ✅ |
| Ajouter un livre | Champs de formulaire : label porté par `labelText`, message d'erreur lu automatiquement par `TextFormField` | ✅ |
| Ajouter un livre | Bouton de soumission : `Semantics` annonce toujours un état actionnable, y compris pendant le chargement | ✅ |
| Ma liste | Suppression : le balayage seul (`Dismissible`) n'est pas praticable pour un utilisateur de lecteur d'écran (le swipe horizontal sert à la navigation, pas à déclencher une action). Action équivalente exposée via `customSemanticsActions`, disponible dans le rotor/menu d'actions | ✅ |
| Ma liste | État vide : même traitement que Bibliothèque | ✅ |
| Réglages | Bascule thème : `SwitchListTile` (label + sous-titre + état lu automatiquement) | ✅ |
| Réglages | Sélecteur de langue : `SegmentedButton` (état sélectionné annoncé nativement) | ✅ |
| Global | Taille de cible tactile : boutons icône (favori, effacer recherche, FAB) ≥ 48×48 (comportement par défaut de `IconButton`/`FilledButton`) | ✅ |
| Global | Contraste : `ColorScheme.fromSeed` (Material 3) garantit un contraste AA sur les combinaisons de rôles de couleur standard, en clair comme en sombre | ✅ |
| Global | Mise à l'échelle du texte (jusqu'à 200%) | ⚠️ À vérifier manuellement (voir ci-dessous) |

## Vérifications manuelles restantes

Ces points nécessitent un appareil ou un émulateur réel :

1. **Lecteur d'écran** : active TalkBack (Android) ou VoiceOver (iOS), navigue les 5 écrans au doigt/swipe. Vérifie en particulier que l'action "Retirer de ma liste" apparaît bien dans le menu d'actions sur l'écran Ma liste.
2. **Mise à l'échelle du texte** : Réglages système → Affichage → Taille de police à 200%, puis relance l'app. Vérifie qu'aucun texte n'est coupé (attention particulière à `BookCard` : titre sur 2 lignes max, le reste peut déborder si la carte est trop contrainte).
3. **Contraste en conditions réelles** : vérifie le mode sombre sur un écran OLED en extérieur.

## Fichiers concernés

- `lib/widgets/results_announcer.dart`
- `lib/widgets/error_view.dart`
- `lib/widgets/my_list_tile.dart`
- `lib/screens/library_screen.dart`
- `lib/l10n/app_en.arb`, `app_fr.arb` (clés `libraryResultsCount`, `myListRemoveAction`)
