import 'package:flutter/material.dart';

import '../modele/taches.dart';

/// Formulaire de création d'une tâche (partie E).
/// Renvoie la [Tache] créée au parent via Navigator.pop(), ou ne renvoie rien
/// si l'utilisateur revient en arrière sans enregistrer.
class FormulaireTache extends StatefulWidget {
  const FormulaireTache({super.key});

  @override
  State<FormulaireTache> createState() => _FormulaireTacheState();
}

class _FormulaireTacheState extends State<FormulaireTache> {
  final _cle = GlobalKey<FormState>();

  final _ctrlTitre = TextEditingController();
  final _ctrlNote = TextEditingController();
  Priorite _priorite = Priorite.normale;
  DateTime? _echeance;

  @override
  void dispose() {
    _ctrlTitre.dispose();
    _ctrlNote.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final aujourd = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: aujourd,
      firstDate: aujourd,
      lastDate: DateTime(aujourd.year + 10),
    );
    if (date != null) setState(() => _echeance = date);
  }

  void _enregistrer() {
    if (!_cle.currentState!.validate()) return;

    final titre = _ctrlTitre.text.trim();
    final noteTexte = _ctrlNote.text.trim();

    // Identifiant unique basé sur l'horodatage
    final id = 't_${DateTime.now().microsecondsSinceEpoch}';

    final tache = Tache(
      id: id,
      titre: titre,
      priorite: _priorite,
      echeance: _echeance != null
          ? EcheanceDatee(_echeance!)
          : const SansEcheance(),
      note: noteTexte.isEmpty ? null : noteTexte,
    );

    Navigator.of(context).pop(tache);
  }

  @override
  Widget build(BuildContext context) {
    final aujourd = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle tâche')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _cle,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre
                    TextFormField(
                      controller: _ctrlTitre,
                      decoration: const InputDecoration(
                        labelText: 'Titre de la tâche *',
                        hintText: 'Ex: Rendre le rapport de stage...',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                      maxLength: 60,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Le titre est obligatoire.';
                        }
                        if (v.trim().length > 60) {
                          return 'Le titre ne doit pas dépasser 60 caractères.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Priorité
                    DropdownButtonFormField<Priorite>(
                      initialValue: _priorite,
                      decoration: const InputDecoration(
                        labelText: 'Priorité',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: [
                        for (final p in Priorite.values)
                          DropdownMenuItem(
                            value: p,
                            child: Row(
                              children: [
                                Icon(
                                  switch (p) {
                                    Priorite.haute =>
                                      Icons.keyboard_double_arrow_up,
                                    Priorite.normale => Icons.remove,
                                    Priorite.basse =>
                                      Icons.keyboard_double_arrow_down,
                                  },
                                  size: 18,
                                  color: switch (p) {
                                    Priorite.haute => Colors.deepOrange,
                                    Priorite.normale => Colors.blueGrey,
                                    Priorite.basse => Colors.teal,
                                  },
                                ),
                                const SizedBox(width: 8),
                                Text(p.libelle),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (p) => setState(() => _priorite = p!),
                    ),
                    const SizedBox(height: 16),

                    // Échéance
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _echeance == null
                                  ? 'Sans échéance'
                                  : 'Pour le ${_echeance!.day}/${_echeance!.month}/${_echeance!.year}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: _echeance != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.date_range, size: 16),
                            label: const Text('Choisir'),
                            onPressed: _choisirDate,
                          ),
                          if (_echeance != null)
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              tooltip: 'Supprimer l\'échéance',
                              onPressed: () => setState(() => _echeance = null),
                            ),
                        ],
                      ),
                    ),
                    // Validation de la date (E2)
                    if (_echeance != null &&
                        _echeance!.isBefore(
                          DateTime(aujourd.year, aujourd.month, aujourd.day),
                        ))
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 12),
                        child: Text(
                          'L\'échéance ne peut pas être antérieure à aujourd\'hui.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Note
                    TextFormField(
                      controller: _ctrlNote,
                      decoration: const InputDecoration(
                        labelText: 'Note (facultative)',
                        hintText: 'Ajoutez des détails...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      maxLength: 200,
                      validator: (v) {
                        if (v != null && v.trim().length > 200) {
                          return 'La note ne doit pas dépasser 200 caractères.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Bouton Enregistrer
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        key: const Key('bouton_enregistrer'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Enregistrer',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          // Vérification supplémentaire de la date avant validation
                          if (_echeance != null &&
                              _echeance!.isBefore(
                                DateTime(
                                  aujourd.year,
                                  aujourd.month,
                                  aujourd.day,
                                ),
                              )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Corrigez les erreurs avant d\'enregistrer.',
                                ),
                              ),
                            );
                            return;
                          }
                          _enregistrer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
