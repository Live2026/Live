// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_locale.dart';

// ignore_for_file: type=lint
class $ParametresTable extends Parametres
    with TableInfo<$ParametresTable, Parametre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParametresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  @override
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
    'cle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<String> valeur = GeneratedColumn<String>(
    'valeur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cle, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parametres';
  @override
  VerificationContext validateIntegrity(
    Insertable<Parametre> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cle')) {
      context.handle(
        _cleMeta,
        cle.isAcceptableOrUnknown(data['cle']!, _cleMeta),
      );
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(
        _valeurMeta,
        valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta),
      );
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cle};
  @override
  Parametre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Parametre(
      cle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cle'],
      )!,
      valeur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valeur'],
      )!,
    );
  }

  @override
  $ParametresTable createAlias(String alias) {
    return $ParametresTable(attachedDatabase, alias);
  }
}

class Parametre extends DataClass implements Insertable<Parametre> {
  final String cle;
  final String valeur;
  const Parametre({required this.cle, required this.valeur});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cle'] = Variable<String>(cle);
    map['valeur'] = Variable<String>(valeur);
    return map;
  }

  ParametresCompanion toCompanion(bool nullToAbsent) {
    return ParametresCompanion(cle: Value(cle), valeur: Value(valeur));
  }

  factory Parametre.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Parametre(
      cle: serializer.fromJson<String>(json['cle']),
      valeur: serializer.fromJson<String>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cle': serializer.toJson<String>(cle),
      'valeur': serializer.toJson<String>(valeur),
    };
  }

  Parametre copyWith({String? cle, String? valeur}) =>
      Parametre(cle: cle ?? this.cle, valeur: valeur ?? this.valeur);
  Parametre copyWithCompanion(ParametresCompanion data) {
    return Parametre(
      cle: data.cle.present ? data.cle.value : this.cle,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Parametre(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cle, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parametre &&
          other.cle == this.cle &&
          other.valeur == this.valeur);
}

class ParametresCompanion extends UpdateCompanion<Parametre> {
  final Value<String> cle;
  final Value<String> valeur;
  final Value<int> rowid;
  const ParametresCompanion({
    this.cle = const Value.absent(),
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParametresCompanion.insert({
    required String cle,
    required String valeur,
    this.rowid = const Value.absent(),
  }) : cle = Value(cle),
       valeur = Value(valeur);
  static Insertable<Parametre> custom({
    Expression<String>? cle,
    Expression<String>? valeur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cle != null) 'cle': cle,
      if (valeur != null) 'valeur': valeur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParametresCompanion copyWith({
    Value<String>? cle,
    Value<String>? valeur,
    Value<int>? rowid,
  }) {
    return ParametresCompanion(
      cle: cle ?? this.cle,
      valeur: valeur ?? this.valeur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<String>(valeur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParametresCompanion(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrouillonsTable extends Brouillons
    with TableInfo<$BrouillonsTable, Brouillon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrouillonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
    'titre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contenuMeta = const VerificationMeta(
    'contenu',
  );
  @override
  late final GeneratedColumn<String> contenu = GeneratedColumn<String>(
    'contenu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _misAJourMeta = const VerificationMeta(
    'misAJour',
  );
  @override
  late final GeneratedColumn<DateTime> misAJour = GeneratedColumn<DateTime>(
    'mis_a_jour',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, titre, contenu, misAJour];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brouillons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Brouillon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('titre')) {
      context.handle(
        _titreMeta,
        titre.isAcceptableOrUnknown(data['titre']!, _titreMeta),
      );
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('contenu')) {
      context.handle(
        _contenuMeta,
        contenu.isAcceptableOrUnknown(data['contenu']!, _contenuMeta),
      );
    } else if (isInserting) {
      context.missing(_contenuMeta);
    }
    if (data.containsKey('mis_a_jour')) {
      context.handle(
        _misAJourMeta,
        misAJour.isAcceptableOrUnknown(data['mis_a_jour']!, _misAJourMeta),
      );
    } else if (isInserting) {
      context.missing(_misAJourMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brouillon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brouillon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      titre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titre'],
      )!,
      contenu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contenu'],
      )!,
      misAJour: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}mis_a_jour'],
      )!,
    );
  }

  @override
  $BrouillonsTable createAlias(String alias) {
    return $BrouillonsTable(attachedDatabase, alias);
  }
}

class Brouillon extends DataClass implements Insertable<Brouillon> {
  final String id;

  /// `produit`, `bien`, `service`, `publication`…
  final String type;
  final String titre;

  /// Contenu du formulaire, en JSON.
  final String contenu;
  final DateTime misAJour;
  const Brouillon({
    required this.id,
    required this.type,
    required this.titre,
    required this.contenu,
    required this.misAJour,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['titre'] = Variable<String>(titre);
    map['contenu'] = Variable<String>(contenu);
    map['mis_a_jour'] = Variable<DateTime>(misAJour);
    return map;
  }

  BrouillonsCompanion toCompanion(bool nullToAbsent) {
    return BrouillonsCompanion(
      id: Value(id),
      type: Value(type),
      titre: Value(titre),
      contenu: Value(contenu),
      misAJour: Value(misAJour),
    );
  }

  factory Brouillon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brouillon(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      titre: serializer.fromJson<String>(json['titre']),
      contenu: serializer.fromJson<String>(json['contenu']),
      misAJour: serializer.fromJson<DateTime>(json['misAJour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'titre': serializer.toJson<String>(titre),
      'contenu': serializer.toJson<String>(contenu),
      'misAJour': serializer.toJson<DateTime>(misAJour),
    };
  }

  Brouillon copyWith({
    String? id,
    String? type,
    String? titre,
    String? contenu,
    DateTime? misAJour,
  }) => Brouillon(
    id: id ?? this.id,
    type: type ?? this.type,
    titre: titre ?? this.titre,
    contenu: contenu ?? this.contenu,
    misAJour: misAJour ?? this.misAJour,
  );
  Brouillon copyWithCompanion(BrouillonsCompanion data) {
    return Brouillon(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      titre: data.titre.present ? data.titre.value : this.titre,
      contenu: data.contenu.present ? data.contenu.value : this.contenu,
      misAJour: data.misAJour.present ? data.misAJour.value : this.misAJour,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Brouillon(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('titre: $titre, ')
          ..write('contenu: $contenu, ')
          ..write('misAJour: $misAJour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, titre, contenu, misAJour);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Brouillon &&
          other.id == this.id &&
          other.type == this.type &&
          other.titre == this.titre &&
          other.contenu == this.contenu &&
          other.misAJour == this.misAJour);
}

class BrouillonsCompanion extends UpdateCompanion<Brouillon> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> titre;
  final Value<String> contenu;
  final Value<DateTime> misAJour;
  final Value<int> rowid;
  const BrouillonsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.titre = const Value.absent(),
    this.contenu = const Value.absent(),
    this.misAJour = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrouillonsCompanion.insert({
    required String id,
    required String type,
    required String titre,
    required String contenu,
    required DateTime misAJour,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       titre = Value(titre),
       contenu = Value(contenu),
       misAJour = Value(misAJour);
  static Insertable<Brouillon> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? titre,
    Expression<String>? contenu,
    Expression<DateTime>? misAJour,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (titre != null) 'titre': titre,
      if (contenu != null) 'contenu': contenu,
      if (misAJour != null) 'mis_a_jour': misAJour,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrouillonsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? titre,
    Value<String>? contenu,
    Value<DateTime>? misAJour,
    Value<int>? rowid,
  }) {
    return BrouillonsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      misAJour: misAJour ?? this.misAJour,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (contenu.present) {
      map['contenu'] = Variable<String>(contenu.value);
    }
    if (misAJour.present) {
      map['mis_a_jour'] = Variable<DateTime>(misAJour.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrouillonsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('titre: $titre, ')
          ..write('contenu: $contenu, ')
          ..write('misAJour: $misAJour, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavorisTable extends Favoris with TableInfo<$FavorisTable, Favori> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavorisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ajouteMeta = const VerificationMeta('ajoute');
  @override
  late final GeneratedColumn<DateTime> ajoute = GeneratedColumn<DateTime>(
    'ajoute',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, ajoute];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favoris';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favori> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('ajoute')) {
      context.handle(
        _ajouteMeta,
        ajoute.isAcceptableOrUnknown(data['ajoute']!, _ajouteMeta),
      );
    } else if (isInserting) {
      context.missing(_ajouteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type, id};
  @override
  Favori map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favori(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      ajoute: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ajoute'],
      )!,
    );
  }

  @override
  $FavorisTable createAlias(String alias) {
    return $FavorisTable(attachedDatabase, alias);
  }
}

class Favori extends DataClass implements Insertable<Favori> {
  final String id;
  final String type;
  final DateTime ajoute;
  const Favori({required this.id, required this.type, required this.ajoute});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['ajoute'] = Variable<DateTime>(ajoute);
    return map;
  }

  FavorisCompanion toCompanion(bool nullToAbsent) {
    return FavorisCompanion(
      id: Value(id),
      type: Value(type),
      ajoute: Value(ajoute),
    );
  }

  factory Favori.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favori(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      ajoute: serializer.fromJson<DateTime>(json['ajoute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'ajoute': serializer.toJson<DateTime>(ajoute),
    };
  }

  Favori copyWith({String? id, String? type, DateTime? ajoute}) => Favori(
    id: id ?? this.id,
    type: type ?? this.type,
    ajoute: ajoute ?? this.ajoute,
  );
  Favori copyWithCompanion(FavorisCompanion data) {
    return Favori(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      ajoute: data.ajoute.present ? data.ajoute.value : this.ajoute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favori(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('ajoute: $ajoute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, ajoute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favori &&
          other.id == this.id &&
          other.type == this.type &&
          other.ajoute == this.ajoute);
}

class FavorisCompanion extends UpdateCompanion<Favori> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> ajoute;
  final Value<int> rowid;
  const FavorisCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.ajoute = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavorisCompanion.insert({
    required String id,
    required String type,
    required DateTime ajoute,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       ajoute = Value(ajoute);
  static Insertable<Favori> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? ajoute,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (ajoute != null) 'ajoute': ajoute,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavorisCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<DateTime>? ajoute,
    Value<int>? rowid,
  }) {
    return FavorisCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      ajoute: ajoute ?? this.ajoute,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (ajoute.present) {
      map['ajoute'] = Variable<DateTime>(ajoute.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavorisCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('ajoute: $ajoute, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FileEnvoiTable extends FileEnvoi with TableInfo<$FileEnvoiTable, Envoi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileEnvoiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contenuMeta = const VerificationMeta(
    'contenu',
  );
  @override
  late final GeneratedColumn<String> contenu = GeneratedColumn<String>(
    'contenu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tentativesMeta = const VerificationMeta(
    'tentatives',
  );
  @override
  late final GeneratedColumn<int> tentatives = GeneratedColumn<int>(
    'tentatives',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _etatMeta = const VerificationMeta('etat');
  @override
  late final GeneratedColumn<String> etat = GeneratedColumn<String>(
    'etat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en_attente'),
  );
  static const VerificationMeta _creeMeta = const VerificationMeta('cree');
  @override
  late final GeneratedColumn<DateTime> cree = GeneratedColumn<DateTime>(
    'cree',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    contenu,
    tentatives,
    etat,
    cree,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_envoi';
  @override
  VerificationContext validateIntegrity(
    Insertable<Envoi> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('contenu')) {
      context.handle(
        _contenuMeta,
        contenu.isAcceptableOrUnknown(data['contenu']!, _contenuMeta),
      );
    } else if (isInserting) {
      context.missing(_contenuMeta);
    }
    if (data.containsKey('tentatives')) {
      context.handle(
        _tentativesMeta,
        tentatives.isAcceptableOrUnknown(data['tentatives']!, _tentativesMeta),
      );
    }
    if (data.containsKey('etat')) {
      context.handle(
        _etatMeta,
        etat.isAcceptableOrUnknown(data['etat']!, _etatMeta),
      );
    }
    if (data.containsKey('cree')) {
      context.handle(
        _creeMeta,
        cree.isAcceptableOrUnknown(data['cree']!, _creeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Envoi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Envoi(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      contenu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contenu'],
      )!,
      tentatives: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tentatives'],
      )!,
      etat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etat'],
      )!,
      cree: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree'],
      )!,
    );
  }

  @override
  $FileEnvoiTable createAlias(String alias) {
    return $FileEnvoiTable(attachedDatabase, alias);
  }
}

class Envoi extends DataClass implements Insertable<Envoi> {
  final String id;
  final String type;

  /// Données de l'action, en JSON.
  final String contenu;
  final int tentatives;

  /// `en_attente`, `envoye` ou `echec`.
  final String etat;
  final DateTime cree;
  const Envoi({
    required this.id,
    required this.type,
    required this.contenu,
    required this.tentatives,
    required this.etat,
    required this.cree,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['contenu'] = Variable<String>(contenu);
    map['tentatives'] = Variable<int>(tentatives);
    map['etat'] = Variable<String>(etat);
    map['cree'] = Variable<DateTime>(cree);
    return map;
  }

  FileEnvoiCompanion toCompanion(bool nullToAbsent) {
    return FileEnvoiCompanion(
      id: Value(id),
      type: Value(type),
      contenu: Value(contenu),
      tentatives: Value(tentatives),
      etat: Value(etat),
      cree: Value(cree),
    );
  }

  factory Envoi.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Envoi(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      contenu: serializer.fromJson<String>(json['contenu']),
      tentatives: serializer.fromJson<int>(json['tentatives']),
      etat: serializer.fromJson<String>(json['etat']),
      cree: serializer.fromJson<DateTime>(json['cree']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'contenu': serializer.toJson<String>(contenu),
      'tentatives': serializer.toJson<int>(tentatives),
      'etat': serializer.toJson<String>(etat),
      'cree': serializer.toJson<DateTime>(cree),
    };
  }

  Envoi copyWith({
    String? id,
    String? type,
    String? contenu,
    int? tentatives,
    String? etat,
    DateTime? cree,
  }) => Envoi(
    id: id ?? this.id,
    type: type ?? this.type,
    contenu: contenu ?? this.contenu,
    tentatives: tentatives ?? this.tentatives,
    etat: etat ?? this.etat,
    cree: cree ?? this.cree,
  );
  Envoi copyWithCompanion(FileEnvoiCompanion data) {
    return Envoi(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      contenu: data.contenu.present ? data.contenu.value : this.contenu,
      tentatives: data.tentatives.present
          ? data.tentatives.value
          : this.tentatives,
      etat: data.etat.present ? data.etat.value : this.etat,
      cree: data.cree.present ? data.cree.value : this.cree,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Envoi(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('contenu: $contenu, ')
          ..write('tentatives: $tentatives, ')
          ..write('etat: $etat, ')
          ..write('cree: $cree')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, contenu, tentatives, etat, cree);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Envoi &&
          other.id == this.id &&
          other.type == this.type &&
          other.contenu == this.contenu &&
          other.tentatives == this.tentatives &&
          other.etat == this.etat &&
          other.cree == this.cree);
}

class FileEnvoiCompanion extends UpdateCompanion<Envoi> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> contenu;
  final Value<int> tentatives;
  final Value<String> etat;
  final Value<DateTime> cree;
  final Value<int> rowid;
  const FileEnvoiCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.contenu = const Value.absent(),
    this.tentatives = const Value.absent(),
    this.etat = const Value.absent(),
    this.cree = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FileEnvoiCompanion.insert({
    required String id,
    required String type,
    required String contenu,
    this.tentatives = const Value.absent(),
    this.etat = const Value.absent(),
    required DateTime cree,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       contenu = Value(contenu),
       cree = Value(cree);
  static Insertable<Envoi> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? contenu,
    Expression<int>? tentatives,
    Expression<String>? etat,
    Expression<DateTime>? cree,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (contenu != null) 'contenu': contenu,
      if (tentatives != null) 'tentatives': tentatives,
      if (etat != null) 'etat': etat,
      if (cree != null) 'cree': cree,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FileEnvoiCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? contenu,
    Value<int>? tentatives,
    Value<String>? etat,
    Value<DateTime>? cree,
    Value<int>? rowid,
  }) {
    return FileEnvoiCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      contenu: contenu ?? this.contenu,
      tentatives: tentatives ?? this.tentatives,
      etat: etat ?? this.etat,
      cree: cree ?? this.cree,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (contenu.present) {
      map['contenu'] = Variable<String>(contenu.value);
    }
    if (tentatives.present) {
      map['tentatives'] = Variable<int>(tentatives.value);
    }
    if (etat.present) {
      map['etat'] = Variable<String>(etat.value);
    }
    if (cree.present) {
      map['cree'] = Variable<DateTime>(cree.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileEnvoiCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('contenu: $contenu, ')
          ..write('tentatives: $tentatives, ')
          ..write('etat: $etat, ')
          ..write('cree: $cree, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BaseLocale extends GeneratedDatabase {
  _$BaseLocale(QueryExecutor e) : super(e);
  $BaseLocaleManager get managers => $BaseLocaleManager(this);
  late final $ParametresTable parametres = $ParametresTable(this);
  late final $BrouillonsTable brouillons = $BrouillonsTable(this);
  late final $FavorisTable favoris = $FavorisTable(this);
  late final $FileEnvoiTable fileEnvoi = $FileEnvoiTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    parametres,
    brouillons,
    favoris,
    fileEnvoi,
  ];
}

typedef $$ParametresTableCreateCompanionBuilder = ParametresCompanion Function({
  required String cle,
  required String valeur,
  Value<int> rowid,
});
typedef $$ParametresTableUpdateCompanionBuilder = ParametresCompanion Function({
  Value<String> cle,
  Value<String> valeur,
  Value<int> rowid,
});

class $$ParametresTableFilterComposer
    extends Composer<_$BaseLocale, $ParametresTable> {
  $$ParametresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParametresTableOrderingComposer
    extends Composer<_$BaseLocale, $ParametresTable> {
  $$ParametresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParametresTableAnnotationComposer
    extends Composer<_$BaseLocale, $ParametresTable> {
  $$ParametresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<String> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);
}

class $$ParametresTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $ParametresTable,
          Parametre,
          $$ParametresTableFilterComposer,
          $$ParametresTableOrderingComposer,
          $$ParametresTableAnnotationComposer,
          $$ParametresTableCreateCompanionBuilder,
          $$ParametresTableUpdateCompanionBuilder,
          (
            Parametre,
            BaseReferences<_$BaseLocale, $ParametresTable, Parametre>,
          ),
          Parametre,
          PrefetchHooks Function()
        > {
  $$ParametresTableTableManager(_$BaseLocale db, $ParametresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParametresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParametresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParametresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cle = const Value.absent(),
            Value<String> valeur = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ParametresCompanion(cle: cle, valeur: valeur, rowid: rowid),
          createCompanionCallback:
              ({
                required String cle,
                required String valeur,
                Value<int> rowid = const Value.absent(),
              }) => ParametresCompanion.insert(
                cle: cle,
                valeur: valeur,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParametresTable, Parametre>(table),
                  BaseReferences<_$BaseLocale, $ParametresTable, Parametre>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParametresTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $ParametresTable,
      Parametre,
      $$ParametresTableFilterComposer,
      $$ParametresTableOrderingComposer,
      $$ParametresTableAnnotationComposer,
      $$ParametresTableCreateCompanionBuilder,
      $$ParametresTableUpdateCompanionBuilder,
      (Parametre, BaseReferences<_$BaseLocale, $ParametresTable, Parametre>),
      Parametre,
      PrefetchHooks Function()
    >;
typedef $$BrouillonsTableCreateCompanionBuilder = BrouillonsCompanion Function({
  required String id,
  required String type,
  required String titre,
  required String contenu,
  required DateTime misAJour,
  Value<int> rowid,
});
typedef $$BrouillonsTableUpdateCompanionBuilder = BrouillonsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> titre,
  Value<String> contenu,
  Value<DateTime> misAJour,
  Value<int> rowid,
});

class $$BrouillonsTableFilterComposer
    extends Composer<_$BaseLocale, $BrouillonsTable> {
  $$BrouillonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contenu => $composableBuilder(
    column: $table.contenu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get misAJour => $composableBuilder(
    column: $table.misAJour,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrouillonsTableOrderingComposer
    extends Composer<_$BaseLocale, $BrouillonsTable> {
  $$BrouillonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contenu => $composableBuilder(
    column: $table.contenu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get misAJour => $composableBuilder(
    column: $table.misAJour,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrouillonsTableAnnotationComposer
    extends Composer<_$BaseLocale, $BrouillonsTable> {
  $$BrouillonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<String> get contenu =>
      $composableBuilder(column: $table.contenu, builder: (column) => column);

  GeneratedColumn<DateTime> get misAJour =>
      $composableBuilder(column: $table.misAJour, builder: (column) => column);
}

class $$BrouillonsTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $BrouillonsTable,
          Brouillon,
          $$BrouillonsTableFilterComposer,
          $$BrouillonsTableOrderingComposer,
          $$BrouillonsTableAnnotationComposer,
          $$BrouillonsTableCreateCompanionBuilder,
          $$BrouillonsTableUpdateCompanionBuilder,
          (
            Brouillon,
            BaseReferences<_$BaseLocale, $BrouillonsTable, Brouillon>,
          ),
          Brouillon,
          PrefetchHooks Function()
        > {
  $$BrouillonsTableTableManager(_$BaseLocale db, $BrouillonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrouillonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrouillonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrouillonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> titre = const Value.absent(),
                Value<String> contenu = const Value.absent(),
                Value<DateTime> misAJour = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrouillonsCompanion(
                id: id,
                type: type,
                titre: titre,
                contenu: contenu,
                misAJour: misAJour,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String titre,
                required String contenu,
                required DateTime misAJour,
                Value<int> rowid = const Value.absent(),
              }) => BrouillonsCompanion.insert(
                id: id,
                type: type,
                titre: titre,
                contenu: contenu,
                misAJour: misAJour,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BrouillonsTable, Brouillon>(table),
                  BaseReferences<_$BaseLocale, $BrouillonsTable, Brouillon>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrouillonsTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $BrouillonsTable,
      Brouillon,
      $$BrouillonsTableFilterComposer,
      $$BrouillonsTableOrderingComposer,
      $$BrouillonsTableAnnotationComposer,
      $$BrouillonsTableCreateCompanionBuilder,
      $$BrouillonsTableUpdateCompanionBuilder,
      (Brouillon, BaseReferences<_$BaseLocale, $BrouillonsTable, Brouillon>),
      Brouillon,
      PrefetchHooks Function()
    >;
typedef $$FavorisTableCreateCompanionBuilder = FavorisCompanion Function({
  required String id,
  required String type,
  required DateTime ajoute,
  Value<int> rowid,
});
typedef $$FavorisTableUpdateCompanionBuilder = FavorisCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<DateTime> ajoute,
  Value<int> rowid,
});

class $$FavorisTableFilterComposer
    extends Composer<_$BaseLocale, $FavorisTable> {
  $$FavorisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ajoute => $composableBuilder(
    column: $table.ajoute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavorisTableOrderingComposer
    extends Composer<_$BaseLocale, $FavorisTable> {
  $$FavorisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ajoute => $composableBuilder(
    column: $table.ajoute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavorisTableAnnotationComposer
    extends Composer<_$BaseLocale, $FavorisTable> {
  $$FavorisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get ajoute =>
      $composableBuilder(column: $table.ajoute, builder: (column) => column);
}

class $$FavorisTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $FavorisTable,
          Favori,
          $$FavorisTableFilterComposer,
          $$FavorisTableOrderingComposer,
          $$FavorisTableAnnotationComposer,
          $$FavorisTableCreateCompanionBuilder,
          $$FavorisTableUpdateCompanionBuilder,
          (Favori, BaseReferences<_$BaseLocale, $FavorisTable, Favori>),
          Favori,
          PrefetchHooks Function()
        > {
  $$FavorisTableTableManager(_$BaseLocale db, $FavorisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavorisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavorisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavorisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> ajoute = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavorisCompanion(
                id: id,
                type: type,
                ajoute: ajoute,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required DateTime ajoute,
                Value<int> rowid = const Value.absent(),
              }) => FavorisCompanion.insert(
                id: id,
                type: type,
                ajoute: ajoute,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavorisTable, Favori>(table),
                  BaseReferences<_$BaseLocale, $FavorisTable, Favori>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavorisTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $FavorisTable,
      Favori,
      $$FavorisTableFilterComposer,
      $$FavorisTableOrderingComposer,
      $$FavorisTableAnnotationComposer,
      $$FavorisTableCreateCompanionBuilder,
      $$FavorisTableUpdateCompanionBuilder,
      (Favori, BaseReferences<_$BaseLocale, $FavorisTable, Favori>),
      Favori,
      PrefetchHooks Function()
    >;
typedef $$FileEnvoiTableCreateCompanionBuilder = FileEnvoiCompanion Function({
  required String id,
  required String type,
  required String contenu,
  Value<int> tentatives,
  Value<String> etat,
  required DateTime cree,
  Value<int> rowid,
});
typedef $$FileEnvoiTableUpdateCompanionBuilder = FileEnvoiCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> contenu,
  Value<int> tentatives,
  Value<String> etat,
  Value<DateTime> cree,
  Value<int> rowid,
});

class $$FileEnvoiTableFilterComposer
    extends Composer<_$BaseLocale, $FileEnvoiTable> {
  $$FileEnvoiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contenu => $composableBuilder(
    column: $table.contenu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tentatives => $composableBuilder(
    column: $table.tentatives,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etat => $composableBuilder(
    column: $table.etat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cree => $composableBuilder(
    column: $table.cree,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FileEnvoiTableOrderingComposer
    extends Composer<_$BaseLocale, $FileEnvoiTable> {
  $$FileEnvoiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contenu => $composableBuilder(
    column: $table.contenu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tentatives => $composableBuilder(
    column: $table.tentatives,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etat => $composableBuilder(
    column: $table.etat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cree => $composableBuilder(
    column: $table.cree,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FileEnvoiTableAnnotationComposer
    extends Composer<_$BaseLocale, $FileEnvoiTable> {
  $$FileEnvoiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get contenu =>
      $composableBuilder(column: $table.contenu, builder: (column) => column);

  GeneratedColumn<int> get tentatives => $composableBuilder(
    column: $table.tentatives,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etat =>
      $composableBuilder(column: $table.etat, builder: (column) => column);

  GeneratedColumn<DateTime> get cree =>
      $composableBuilder(column: $table.cree, builder: (column) => column);
}

class $$FileEnvoiTableTableManager
    extends
        RootTableManager<
          _$BaseLocale,
          $FileEnvoiTable,
          Envoi,
          $$FileEnvoiTableFilterComposer,
          $$FileEnvoiTableOrderingComposer,
          $$FileEnvoiTableAnnotationComposer,
          $$FileEnvoiTableCreateCompanionBuilder,
          $$FileEnvoiTableUpdateCompanionBuilder,
          (Envoi, BaseReferences<_$BaseLocale, $FileEnvoiTable, Envoi>),
          Envoi,
          PrefetchHooks Function()
        > {
  $$FileEnvoiTableTableManager(_$BaseLocale db, $FileEnvoiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileEnvoiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileEnvoiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileEnvoiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> contenu = const Value.absent(),
                Value<int> tentatives = const Value.absent(),
                Value<String> etat = const Value.absent(),
                Value<DateTime> cree = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FileEnvoiCompanion(
                id: id,
                type: type,
                contenu: contenu,
                tentatives: tentatives,
                etat: etat,
                cree: cree,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String contenu,
                Value<int> tentatives = const Value.absent(),
                Value<String> etat = const Value.absent(),
                required DateTime cree,
                Value<int> rowid = const Value.absent(),
              }) => FileEnvoiCompanion.insert(
                id: id,
                type: type,
                contenu: contenu,
                tentatives: tentatives,
                etat: etat,
                cree: cree,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FileEnvoiTable, Envoi>(table),
                  BaseReferences<_$BaseLocale, $FileEnvoiTable, Envoi>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FileEnvoiTableProcessedTableManager =
    ProcessedTableManager<
      _$BaseLocale,
      $FileEnvoiTable,
      Envoi,
      $$FileEnvoiTableFilterComposer,
      $$FileEnvoiTableOrderingComposer,
      $$FileEnvoiTableAnnotationComposer,
      $$FileEnvoiTableCreateCompanionBuilder,
      $$FileEnvoiTableUpdateCompanionBuilder,
      (Envoi, BaseReferences<_$BaseLocale, $FileEnvoiTable, Envoi>),
      Envoi,
      PrefetchHooks Function()
    >;

class $BaseLocaleManager {
  final _$BaseLocale _db;
  $BaseLocaleManager(this._db);
  $$ParametresTableTableManager get parametres =>
      $$ParametresTableTableManager(_db, _db.parametres);
  $$BrouillonsTableTableManager get brouillons =>
      $$BrouillonsTableTableManager(_db, _db.brouillons);
  $$FavorisTableTableManager get favoris =>
      $$FavorisTableTableManager(_db, _db.favoris);
  $$FileEnvoiTableTableManager get fileEnvoi =>
      $$FileEnvoiTableTableManager(_db, _db.fileEnvoi);
}
