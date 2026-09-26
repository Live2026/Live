import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'paiement.dart';
part 'gains_retrait.dart';
part 'recu.dart';
part 'portefeuille.dart';

/// Moyens hors Mobile Money ; les opérateurs dépendent du pays
/// (`villesLive`, data/donnees_pays.dart).
enum Moyen { solde, visa }

extension on Moyen {
  String get nom => switch (this) {
    Moyen.solde => 'Solde Live',
    Moyen.visa => 'Carte Visa',
  };
}

/// Nom d'un moyen de paiement dans la langue choisie (la valeur enregistrée
/// reste la même).
String moyenAffiche(Textes t, String moyen) => switch (moyen) {
  'Solde Live' => t.paySoldeLive,
  'Carte Visa' => t.payCarteVisa,
  _ => moyen,
};
