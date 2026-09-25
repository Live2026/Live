import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';

part 'paiement.dart';
part 'gains_retrait.dart';
part 'recu.dart';

enum Moyen { mtn, airtel, visa }

extension on Moyen {
  String get nom => switch (this) {
    Moyen.mtn => 'MTN Mobile Money',
    Moyen.airtel => 'Airtel Money',
    Moyen.visa => 'Carte Visa',
  };
}
