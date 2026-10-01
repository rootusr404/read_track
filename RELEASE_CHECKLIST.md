# Checklist avant publication

À vérifier une fois, directement sur `github.com/<TON_USER>/read_track` (pas seulement en local).

## 1. Contenu du dépôt
- [ ] `lib/`, `test/`, `integration_test/`, `assets/`, `.github/workflows/ci.yml` sont bien visibles
- [ ] Aucun fichier généré n'a été commité par erreur (`*.g.dart`, `lib/l10n/generated/`, `build/` — couvert par `.gitignore`)
- [ ] `README.md` s'affiche correctement (tableaux, liens vers `ACCESSIBILITY.md`/`TEST_COVERAGE.md` cliquables)

## 2. Historique
- [ ] Historique de commits clair, messages explicites (`feat:`, `test:`, `fix:`, `chore:`)
- [ ] Tags de version présents (`git tag`)
- [ ] Pas de sortie de terminal collée dans un message de commit

## 3. CI
- [ ] Onglet **Actions** : le dernier run sur `main` est vert
- [ ] Les jobs de lint/tests et de tests d'intégration passent tous les deux
- [ ] Si un job de tests d'intégration échoue avec *"Web devices are not supported for integration tests yet"* : vérifier que le workflow appelle bien `flutter test integration_test/` (device `flutter-tester` par défaut) et non une variante ciblant Chrome/web

## 4. Description du dépôt
- [ ] Description courte ajoutée (icône ⚙️ à côté de "About")
- [ ] Topics ajoutés : `flutter`, `dart`, `riverpod`, `hive`, `mobile-app`

## 5. Release (optionnel)
```bash
gh release create v1.0.0 --title "v1.0.0 - Production ready" --notes-file <(sed -n '/## \[1.0.0\]/,/## \[0.1.9\]/p' CHANGELOG.md | sed '$d')
```
Ou manuellement : onglet **Releases** → **Draft a new release** → tag `v1.0.0` → coller la section correspondante du `CHANGELOG.md`.

## 6. Relecture finale
- [ ] Relire `README.md` de bout en bout comme si on découvrait le projet pour la première fois : les instructions de `SETUP.md` suffisent-elles à faire tourner l'app ?
- [ ] Captures d'écran ajoutées dans `docs/screenshots/` et référencées dans le README
