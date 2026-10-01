# Mise en place du projet en local

Instructions pour partir de zéro : créer le projet Flutter, y intégrer le code source, et le pousser sur GitHub.

## 1. Créer le projet Flutter

```bash
flutter create --org com.readtrack --project-name read_track read_track
cd read_track
```

Cela génère `android/`, `ios/`, `web/`, ainsi qu'un `lib/main.dart` et un `test/widget_test.dart` par défaut (à remplacer par le contenu du dépôt).

## 2. Créer le dépôt GitHub

Avec GitHub CLI :
```bash
gh repo create read_track --public --source=. --remote=origin
```

Sans GitHub CLI : crée le dépôt vide sur github.com, puis :
```bash
git remote add origin https://github.com/<TON_USER>/read_track.git
```

## 3. Nettoyage des fichiers par défaut

```bash
rm -f test/widget_test.dart
```
Ce fichier référence le `MyApp` du compteur par défaut de `flutter create` — inutile ici et source d'erreur de compilation.

## 4. Installer les dépendances et générer le code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # adapters Hive
flutter gen-l10n                                            # classes de traduction FR/EN
```

## 5. Vérification avant le premier commit

```bash
flutter analyze
flutter test
```

## 6. Premier commit et push

```bash
git add .
git commit -m "chore: project setup, architecture, CI, i18n config"
git branch -M main
git push -u origin main
```

## 7. Vérification finale

Va sur `github.com/<TON_USER>/read_track` et vérifie que tous les fichiers sont bien présents, et que l'onglet **Actions** a déclenché le workflow CI avec succès.
