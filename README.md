# HAI912I — TP 1 : Fondamentaux de Dart et Flutter

Dossier complet du **TP 1** pour l'UE **HAI912I** (Développement mobile avancé, IoT et embarqué — Master 2, Université de Montpellier, 2026–2027).

---

## 📂 Contenu du dossier

```text
TP1/
├── sujet/                                   # Documents officiels du TP
│   ├── HAI912I_TP1_Sujet_2026-2027.pdf      # Sujet du TP (consignes et barème sur 20)
│   └── HAI912I_TP1_Annexe_Flutter_2026.pdf  # Fiches pratiques (navigation, formulaires, tests)
│
├── mes_taches/                              # PROJET ÉVALUÉ (application Flutter complète)
│   ├── lib/                                 # Code source Dart / Flutter (modèle, écrans, widgets)
│   ├── test/                                # Tests unitaires et tests de widgets (32 tests au vert)
│   └── README.md                            # Documentation détaillée du projet
│
├── biblio_flutter/                          # Exemple de démonstration fourni (CM 01)
└── exemples_annexe/                         # Exemples d'illustration fournis (navigation, contraintes)
```

---

## 🚀 Démarrer le projet `mes_taches`

Pour exécuter l'application sur Chrome :

```bash
cd mes_taches
flutter pub get
flutter run -d chrome
```

---

## ✅ Vérification et Tests

Toutes les exigences de qualité et de tests sont validées :

```bash
cd mes_taches
flutter analyze   # 0 avertissement
flutter test      # 32/32 tests passés
flutter build web # compilation web
```
