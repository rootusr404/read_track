# Sprint 0 — À exécuter de ton côté

Je ne peux pas exécuter `flutter create` ni pousser sur GitHub depuis cet environnement (pas de SDK Flutter installé ici, et pas d'accès réseau à pub.dev). Voici comment intégrer ce squelette dans un vrai projet Flutter :

## 1. Bootstrap du projet
Dans un dossier vide sur ta machine :
```bash
flutter create --org com.readtrack --project-name read_track .
```
Cela génère `android/`, `ios/`, `web/`, etc. **Ne lance pas encore de commit.**

## 2. Fusionner le contenu livré ici
Copie/écrase dans ton projet fraîchement créé :
- `pubspec.yaml` (remplace celui généré)
- `analysis_options.yaml` (remplace celui généré)
- `.gitignore` (remplace celui généré)
- Tout le dossier `lib/` (remplace le `lib/main.dart` par défaut)
- Tout le dossier `test/` (remplace `test/widget_test.dart` par défaut — **supprime-le explicitement s'il subsiste**, leçon n°5 du brief)
- Le dossier `integration_test/`
- Le dossier `assets/`
- `l10n.yaml`
- `.github/workflows/ci.yml`
- `README.md`, `CHANGELOG.md`

## 3. Installer les dépendances
```bash
flutter pub get
```
> Le `pubspec.yaml` livré liste déjà toutes les dépendances comme si elles avaient été ajoutées via `flutter pub add` (leçon n°11). Si tu préfères les ajouter toi-même commande par commande pour que l'historique de résolution soit "propre", tu peux repartir d'un `pubspec.yaml` vierge et lancer :
> ```bash
> flutter pub add flutter_riverpod hooks_riverpod flutter_hooks go_router hive hive_flutter cached_network_image intl path_provider equatable
> flutter pub add --dev flutter_lints mocktail hive_generator build_runner integration_test
> ```

## 4. Init Git + premier commit
```bash
git init
git add .
git commit -m "chore: sprint 0 - project setup, architecture, CI, i18n config"
git branch -M main
git remote add origin https://github.com/<TON_USER>/read_track.git
git push -u origin main
```
⚠️ Rappel leçon n°2 : ne colle jamais une sortie de `flutter analyze`/`flutter test` dans un message de commit.

## 5. Vérification
- Vérifie sur l'interface web GitHub (pas seulement en local) que tous les fichiers sont bien présents (leçon n°7).
- L'onglet **Actions** doit se déclencher sur le push et lancer `ci.yml`. À ce stade, le job `analyze-and-test` devrait passer (rien à tester encore) ; `integration-tests` passera aussi (dossier vide toléré par `flutter test`).

## 6. Optionnel — tag Git
```bash
git tag -a v0.1.0 -m "Sprint 0 - setup initial"
git push origin v0.1.0
```

---

Une fois que c'est fait et vérifié sur GitHub, dis-moi et on enchaîne sur le **Sprint 1** : modèle `Book`, données mockées JSON, `Repository<T>` générique, `BookRepository`, `MyListStorage` (Hive).
