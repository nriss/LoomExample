# LoomExample

Exemple de connecteurs Loom pour un DPI (Dossier Patient Informatisé) fictif.

## Structure

```
connectors/
  dpi-patient-to-frcore-patient/
    connector.yaml    # Export patients → FR Core Patient
  dpi-sejour-to-fhir-encounter/
    connector.yaml    # Export séjours → FHIR Encounter
db/
  01_schema.sql       # Schéma de la base DPI de test
  02_seed.sql         # Données de test
```

## Convention

Tout fichier `connector.yaml` dans un sous-dossier de `connectors/` est automatiquement détecté par Loom lors de l'import depuis GitHub.

## Utilisation avec Loom Engine

1. Lancer Loom Engine (`docker compose up -d`)
2. Dans l'éditeur, cliquer sur **Importer depuis GitHub**
3. Entrer `nriss/LoomExample`
4. Sélectionner un connecteur et l'importer dans l'éditeur
