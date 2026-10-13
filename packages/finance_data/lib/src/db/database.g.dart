// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incomeBracketMeta = const VerificationMeta(
    'incomeBracket',
  );
  @override
  late final GeneratedColumn<String> incomeBracket = GeneratedColumn<String>(
    'income_bracket',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyNetIncomePaiseMeta =
      const VerificationMeta('monthlyNetIncomePaise');
  @override
  late final GeneratedColumn<int> monthlyNetIncomePaise = GeneratedColumn<int>(
    'monthly_net_income_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    birthYear,
    occupation,
    incomeBracket,
    monthlyNetIncomePaise,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('income_bracket')) {
      context.handle(
        _incomeBracketMeta,
        incomeBracket.isAcceptableOrUnknown(
          data['income_bracket']!,
          _incomeBracketMeta,
        ),
      );
    }
    if (data.containsKey('monthly_net_income_paise')) {
      context.handle(
        _monthlyNetIncomePaiseMeta,
        monthlyNetIncomePaise.isAcceptableOrUnknown(
          data['monthly_net_income_paise']!,
          _monthlyNetIncomePaiseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      incomeBracket: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_bracket'],
      ),
      monthlyNetIncomePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_net_income_paise'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final int? birthYear;
  final String? occupation;
  final String? incomeBracket;
  final int? monthlyNetIncomePaise;
  const UserProfile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.birthYear,
    this.occupation,
    this.incomeBracket,
    this.monthlyNetIncomePaise,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    if (!nullToAbsent || incomeBracket != null) {
      map['income_bracket'] = Variable<String>(incomeBracket);
    }
    if (!nullToAbsent || monthlyNetIncomePaise != null) {
      map['monthly_net_income_paise'] = Variable<int>(monthlyNetIncomePaise);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      incomeBracket: incomeBracket == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeBracket),
      monthlyNetIncomePaise: monthlyNetIncomePaise == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyNetIncomePaise),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      incomeBracket: serializer.fromJson<String?>(json['incomeBracket']),
      monthlyNetIncomePaise: serializer.fromJson<int?>(
        json['monthlyNetIncomePaise'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'birthYear': serializer.toJson<int?>(birthYear),
      'occupation': serializer.toJson<String?>(occupation),
      'incomeBracket': serializer.toJson<String?>(incomeBracket),
      'monthlyNetIncomePaise': serializer.toJson<int?>(monthlyNetIncomePaise),
    };
  }

  UserProfile copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    Value<int?> birthYear = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    Value<String?> incomeBracket = const Value.absent(),
    Value<int?> monthlyNetIncomePaise = const Value.absent(),
  }) => UserProfile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    occupation: occupation.present ? occupation.value : this.occupation,
    incomeBracket: incomeBracket.present
        ? incomeBracket.value
        : this.incomeBracket,
    monthlyNetIncomePaise: monthlyNetIncomePaise.present
        ? monthlyNetIncomePaise.value
        : this.monthlyNetIncomePaise,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      incomeBracket: data.incomeBracket.present
          ? data.incomeBracket.value
          : this.incomeBracket,
      monthlyNetIncomePaise: data.monthlyNetIncomePaise.present
          ? data.monthlyNetIncomePaise.value
          : this.monthlyNetIncomePaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('birthYear: $birthYear, ')
          ..write('occupation: $occupation, ')
          ..write('incomeBracket: $incomeBracket, ')
          ..write('monthlyNetIncomePaise: $monthlyNetIncomePaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    birthYear,
    occupation,
    incomeBracket,
    monthlyNetIncomePaise,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.birthYear == this.birthYear &&
          other.occupation == this.occupation &&
          other.incomeBracket == this.incomeBracket &&
          other.monthlyNetIncomePaise == this.monthlyNetIncomePaise);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int?> birthYear;
  final Value<String?> occupation;
  final Value<String?> incomeBracket;
  final Value<int?> monthlyNetIncomePaise;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.occupation = const Value.absent(),
    this.incomeBracket = const Value.absent(),
    this.monthlyNetIncomePaise = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.occupation = const Value.absent(),
    this.incomeBracket = const Value.absent(),
    this.monthlyNetIncomePaise = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? birthYear,
    Expression<String>? occupation,
    Expression<String>? incomeBracket,
    Expression<int>? monthlyNetIncomePaise,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (birthYear != null) 'birth_year': birthYear,
      if (occupation != null) 'occupation': occupation,
      if (incomeBracket != null) 'income_bracket': incomeBracket,
      if (monthlyNetIncomePaise != null)
        'monthly_net_income_paise': monthlyNetIncomePaise,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int?>? birthYear,
    Value<String?>? occupation,
    Value<String?>? incomeBracket,
    Value<int?>? monthlyNetIncomePaise,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      birthYear: birthYear ?? this.birthYear,
      occupation: occupation ?? this.occupation,
      incomeBracket: incomeBracket ?? this.incomeBracket,
      monthlyNetIncomePaise:
          monthlyNetIncomePaise ?? this.monthlyNetIncomePaise,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (incomeBracket.present) {
      map['income_bracket'] = Variable<String>(incomeBracket.value);
    }
    if (monthlyNetIncomePaise.present) {
      map['monthly_net_income_paise'] = Variable<int>(
        monthlyNetIncomePaise.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('birthYear: $birthYear, ')
          ..write('occupation: $occupation, ')
          ..write('incomeBracket: $incomeBracket, ')
          ..write('monthlyNetIncomePaise: $monthlyNetIncomePaise, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountKind>($AccountsTable.$converterkind);
  static const VerificationMeta _institutionMeta = const VerificationMeta(
    'institution',
  );
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
    'institution',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  upiHandles = GeneratedColumn<String>(
    'upi_handles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Object?>>($AccountsTable.$converterupiHandles);
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  smsSenderIds = GeneratedColumn<String>(
    'sms_sender_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Object?>>($AccountsTable.$convertersmsSenderIds);
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    institution,
    displayName,
    last4,
    upiHandles,
    smsSenderIds,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('institution')) {
      context.handle(
        _institutionMeta,
        institution.isAcceptableOrUnknown(
          data['institution']!,
          _institutionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_institutionMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('last4')) {
      context.handle(
        _last4Meta,
        last4.isAcceptableOrUnknown(data['last4']!, _last4Meta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      kind: $AccountsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      institution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      last4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last4'],
      ),
      upiHandles: $AccountsTable.$converterupiHandles.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}upi_handles'],
        )!,
      ),
      smsSenderIds: $AccountsTable.$convertersmsSenderIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sms_sender_ids'],
        )!,
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static TypeConverter<AccountKind, String> $converterkind =
      const WireEnumConverter(AccountKind.values);
  static TypeConverter<List<Object?>, String> $converterupiHandles =
      const JsonListConverter();
  static TypeConverter<List<Object?>, String> $convertersmsSenderIds =
      const JsonListConverter();
}

class Account extends DataClass implements Insertable<Account> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final AccountKind kind;
  final String institution;
  final String displayName;

  /// Last four digits of the account or card number, if known.
  final String? last4;
  final List<Object?> upiHandles;

  /// SMS sender ids that belong to this account, e.g. `VM-HDFCBK`.
  final List<Object?> smsSenderIds;
  final bool isArchived;
  const Account({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.kind,
    required this.institution,
    required this.displayName,
    this.last4,
    required this.upiHandles,
    required this.smsSenderIds,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['kind'] = Variable<String>($AccountsTable.$converterkind.toSql(kind));
    }
    map['institution'] = Variable<String>(institution);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    {
      map['upi_handles'] = Variable<String>(
        $AccountsTable.$converterupiHandles.toSql(upiHandles),
      );
    }
    {
      map['sms_sender_ids'] = Variable<String>(
        $AccountsTable.$convertersmsSenderIds.toSql(smsSenderIds),
      );
    }
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      kind: Value(kind),
      institution: Value(institution),
      displayName: Value(displayName),
      last4: last4 == null && nullToAbsent
          ? const Value.absent()
          : Value(last4),
      upiHandles: Value(upiHandles),
      smsSenderIds: Value(smsSenderIds),
      isArchived: Value(isArchived),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      kind: serializer.fromJson<AccountKind>(json['kind']),
      institution: serializer.fromJson<String>(json['institution']),
      displayName: serializer.fromJson<String>(json['displayName']),
      last4: serializer.fromJson<String?>(json['last4']),
      upiHandles: serializer.fromJson<List<Object?>>(json['upiHandles']),
      smsSenderIds: serializer.fromJson<List<Object?>>(json['smsSenderIds']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'kind': serializer.toJson<AccountKind>(kind),
      'institution': serializer.toJson<String>(institution),
      'displayName': serializer.toJson<String>(displayName),
      'last4': serializer.toJson<String?>(last4),
      'upiHandles': serializer.toJson<List<Object?>>(upiHandles),
      'smsSenderIds': serializer.toJson<List<Object?>>(smsSenderIds),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Account copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    AccountKind? kind,
    String? institution,
    String? displayName,
    Value<String?> last4 = const Value.absent(),
    List<Object?>? upiHandles,
    List<Object?>? smsSenderIds,
    bool? isArchived,
  }) => Account(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    institution: institution ?? this.institution,
    displayName: displayName ?? this.displayName,
    last4: last4.present ? last4.value : this.last4,
    upiHandles: upiHandles ?? this.upiHandles,
    smsSenderIds: smsSenderIds ?? this.smsSenderIds,
    isArchived: isArchived ?? this.isArchived,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      kind: data.kind.present ? data.kind.value : this.kind,
      institution: data.institution.present
          ? data.institution.value
          : this.institution,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      last4: data.last4.present ? data.last4.value : this.last4,
      upiHandles: data.upiHandles.present
          ? data.upiHandles.value
          : this.upiHandles,
      smsSenderIds: data.smsSenderIds.present
          ? data.smsSenderIds.value
          : this.smsSenderIds,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('institution: $institution, ')
          ..write('displayName: $displayName, ')
          ..write('last4: $last4, ')
          ..write('upiHandles: $upiHandles, ')
          ..write('smsSenderIds: $smsSenderIds, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    institution,
    displayName,
    last4,
    upiHandles,
    smsSenderIds,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.kind == this.kind &&
          other.institution == this.institution &&
          other.displayName == this.displayName &&
          other.last4 == this.last4 &&
          other.upiHandles == this.upiHandles &&
          other.smsSenderIds == this.smsSenderIds &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<AccountKind> kind;
  final Value<String> institution;
  final Value<String> displayName;
  final Value<String?> last4;
  final Value<List<Object?>> upiHandles;
  final Value<List<Object?>> smsSenderIds;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.kind = const Value.absent(),
    this.institution = const Value.absent(),
    this.displayName = const Value.absent(),
    this.last4 = const Value.absent(),
    this.upiHandles = const Value.absent(),
    this.smsSenderIds = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required AccountKind kind,
    required String institution,
    required String displayName,
    this.last4 = const Value.absent(),
    this.upiHandles = const Value.absent(),
    this.smsSenderIds = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       institution = Value(institution),
       displayName = Value(displayName);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? kind,
    Expression<String>? institution,
    Expression<String>? displayName,
    Expression<String>? last4,
    Expression<String>? upiHandles,
    Expression<String>? smsSenderIds,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (kind != null) 'kind': kind,
      if (institution != null) 'institution': institution,
      if (displayName != null) 'display_name': displayName,
      if (last4 != null) 'last4': last4,
      if (upiHandles != null) 'upi_handles': upiHandles,
      if (smsSenderIds != null) 'sms_sender_ids': smsSenderIds,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<AccountKind>? kind,
    Value<String>? institution,
    Value<String>? displayName,
    Value<String?>? last4,
    Value<List<Object?>>? upiHandles,
    Value<List<Object?>>? smsSenderIds,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      kind: kind ?? this.kind,
      institution: institution ?? this.institution,
      displayName: displayName ?? this.displayName,
      last4: last4 ?? this.last4,
      upiHandles: upiHandles ?? this.upiHandles,
      smsSenderIds: smsSenderIds ?? this.smsSenderIds,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AccountsTable.$converterkind.toSql(kind.value),
      );
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (upiHandles.present) {
      map['upi_handles'] = Variable<String>(
        $AccountsTable.$converterupiHandles.toSql(upiHandles.value),
      );
    }
    if (smsSenderIds.present) {
      map['sms_sender_ids'] = Variable<String>(
        $AccountsTable.$convertersmsSenderIds.toSql(smsSenderIds.value),
      );
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('institution: $institution, ')
          ..write('displayName: $displayName, ')
          ..write('last4: $last4, ')
          ..write('upiHandles: $upiHandles, ')
          ..write('smsSenderIds: $smsSenderIds, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportBatchesTable extends ImportBatches
    with TableInfo<$ImportBatchesTable, ImportBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ImportKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ImportKind>($ImportBatchesTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<ImportStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ImportStatus>($ImportBatchesTable.$converterstatus);
  static const VerificationMeta _adapterMeta = const VerificationMeta(
    'adapter',
  );
  @override
  late final GeneratedColumn<String> adapter = GeneratedColumn<String>(
    'adapter',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String> periodFrom =
      GeneratedColumn<String>(
        'period_from',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>($ImportBatchesTable.$converterperiodFromn);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String> periodTo =
      GeneratedColumn<String>(
        'period_to',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>($ImportBatchesTable.$converterperiodTon);
  static const VerificationMeta _parsedCountMeta = const VerificationMeta(
    'parsedCount',
  );
  @override
  late final GeneratedColumn<int> parsedCount = GeneratedColumn<int>(
    'parsed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _failedCountMeta = const VerificationMeta(
    'failedCount',
  );
  @override
  late final GeneratedColumn<int> failedCount = GeneratedColumn<int>(
    'failed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _duplicateCountMeta = const VerificationMeta(
    'duplicateCount',
  );
  @override
  late final GeneratedColumn<int> duplicateCount = GeneratedColumn<int>(
    'duplicate_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _matchedCountMeta = const VerificationMeta(
    'matchedCount',
  );
  @override
  late final GeneratedColumn<int> matchedCount = GeneratedColumn<int>(
    'matched_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdCountMeta = const VerificationMeta(
    'createdCount',
  );
  @override
  late final GeneratedColumn<int> createdCount = GeneratedColumn<int>(
    'created_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String> errors =
      GeneratedColumn<String>(
        'errors',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<Object?>>($ImportBatchesTable.$convertererrors);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    status,
    adapter,
    accountId,
    periodFrom,
    periodTo,
    parsedCount,
    failedCount,
    duplicateCount,
    matchedCount,
    createdCount,
    errors,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('adapter')) {
      context.handle(
        _adapterMeta,
        adapter.isAcceptableOrUnknown(data['adapter']!, _adapterMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('parsed_count')) {
      context.handle(
        _parsedCountMeta,
        parsedCount.isAcceptableOrUnknown(
          data['parsed_count']!,
          _parsedCountMeta,
        ),
      );
    }
    if (data.containsKey('failed_count')) {
      context.handle(
        _failedCountMeta,
        failedCount.isAcceptableOrUnknown(
          data['failed_count']!,
          _failedCountMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_count')) {
      context.handle(
        _duplicateCountMeta,
        duplicateCount.isAcceptableOrUnknown(
          data['duplicate_count']!,
          _duplicateCountMeta,
        ),
      );
    }
    if (data.containsKey('matched_count')) {
      context.handle(
        _matchedCountMeta,
        matchedCount.isAcceptableOrUnknown(
          data['matched_count']!,
          _matchedCountMeta,
        ),
      );
    }
    if (data.containsKey('created_count')) {
      context.handle(
        _createdCountMeta,
        createdCount.isAcceptableOrUnknown(
          data['created_count']!,
          _createdCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportBatche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      kind: $ImportBatchesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      status: $ImportBatchesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      adapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adapter'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      periodFrom: $ImportBatchesTable.$converterperiodFromn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period_from'],
        ),
      ),
      periodTo: $ImportBatchesTable.$converterperiodTon.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}period_to'],
        ),
      ),
      parsedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parsed_count'],
      )!,
      failedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_count'],
      )!,
      duplicateCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duplicate_count'],
      )!,
      matchedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}matched_count'],
      )!,
      createdCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_count'],
      )!,
      errors: $ImportBatchesTable.$convertererrors.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}errors'],
        )!,
      ),
    );
  }

  @override
  $ImportBatchesTable createAlias(String alias) {
    return $ImportBatchesTable(attachedDatabase, alias);
  }

  static TypeConverter<ImportKind, String> $converterkind =
      const WireEnumConverter(ImportKind.values);
  static TypeConverter<ImportStatus, String> $converterstatus =
      const WireEnumConverter(ImportStatus.values);
  static TypeConverter<LocalDate, String> $converterperiodFrom =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converterperiodFromn =
      NullAwareTypeConverter.wrap($converterperiodFrom);
  static TypeConverter<LocalDate, String> $converterperiodTo =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converterperiodTon =
      NullAwareTypeConverter.wrap($converterperiodTo);
  static TypeConverter<List<Object?>, String> $convertererrors =
      const JsonListConverter();
}

class ImportBatche extends DataClass implements Insertable<ImportBatche> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final ImportKind kind;
  final ImportStatus status;

  /// The bank adapter used, e.g. `hdfc_csv`.
  final String? adapter;
  final String? accountId;
  final LocalDate? periodFrom;
  final LocalDate? periodTo;
  final int parsedCount;
  final int failedCount;
  final int duplicateCount;
  final int matchedCount;
  final int createdCount;

  /// Rows that could not be parsed: row number, reason, redacted excerpt.
  final List<Object?> errors;
  const ImportBatche({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.kind,
    required this.status,
    this.adapter,
    this.accountId,
    this.periodFrom,
    this.periodTo,
    required this.parsedCount,
    required this.failedCount,
    required this.duplicateCount,
    required this.matchedCount,
    required this.createdCount,
    required this.errors,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['kind'] = Variable<String>(
        $ImportBatchesTable.$converterkind.toSql(kind),
      );
    }
    {
      map['status'] = Variable<String>(
        $ImportBatchesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || adapter != null) {
      map['adapter'] = Variable<String>(adapter);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || periodFrom != null) {
      map['period_from'] = Variable<String>(
        $ImportBatchesTable.$converterperiodFromn.toSql(periodFrom),
      );
    }
    if (!nullToAbsent || periodTo != null) {
      map['period_to'] = Variable<String>(
        $ImportBatchesTable.$converterperiodTon.toSql(periodTo),
      );
    }
    map['parsed_count'] = Variable<int>(parsedCount);
    map['failed_count'] = Variable<int>(failedCount);
    map['duplicate_count'] = Variable<int>(duplicateCount);
    map['matched_count'] = Variable<int>(matchedCount);
    map['created_count'] = Variable<int>(createdCount);
    {
      map['errors'] = Variable<String>(
        $ImportBatchesTable.$convertererrors.toSql(errors),
      );
    }
    return map;
  }

  ImportBatchesCompanion toCompanion(bool nullToAbsent) {
    return ImportBatchesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      kind: Value(kind),
      status: Value(status),
      adapter: adapter == null && nullToAbsent
          ? const Value.absent()
          : Value(adapter),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      periodFrom: periodFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(periodFrom),
      periodTo: periodTo == null && nullToAbsent
          ? const Value.absent()
          : Value(periodTo),
      parsedCount: Value(parsedCount),
      failedCount: Value(failedCount),
      duplicateCount: Value(duplicateCount),
      matchedCount: Value(matchedCount),
      createdCount: Value(createdCount),
      errors: Value(errors),
    );
  }

  factory ImportBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportBatche(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      kind: serializer.fromJson<ImportKind>(json['kind']),
      status: serializer.fromJson<ImportStatus>(json['status']),
      adapter: serializer.fromJson<String?>(json['adapter']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      periodFrom: serializer.fromJson<LocalDate?>(json['periodFrom']),
      periodTo: serializer.fromJson<LocalDate?>(json['periodTo']),
      parsedCount: serializer.fromJson<int>(json['parsedCount']),
      failedCount: serializer.fromJson<int>(json['failedCount']),
      duplicateCount: serializer.fromJson<int>(json['duplicateCount']),
      matchedCount: serializer.fromJson<int>(json['matchedCount']),
      createdCount: serializer.fromJson<int>(json['createdCount']),
      errors: serializer.fromJson<List<Object?>>(json['errors']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'kind': serializer.toJson<ImportKind>(kind),
      'status': serializer.toJson<ImportStatus>(status),
      'adapter': serializer.toJson<String?>(adapter),
      'accountId': serializer.toJson<String?>(accountId),
      'periodFrom': serializer.toJson<LocalDate?>(periodFrom),
      'periodTo': serializer.toJson<LocalDate?>(periodTo),
      'parsedCount': serializer.toJson<int>(parsedCount),
      'failedCount': serializer.toJson<int>(failedCount),
      'duplicateCount': serializer.toJson<int>(duplicateCount),
      'matchedCount': serializer.toJson<int>(matchedCount),
      'createdCount': serializer.toJson<int>(createdCount),
      'errors': serializer.toJson<List<Object?>>(errors),
    };
  }

  ImportBatche copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    ImportKind? kind,
    ImportStatus? status,
    Value<String?> adapter = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    Value<LocalDate?> periodFrom = const Value.absent(),
    Value<LocalDate?> periodTo = const Value.absent(),
    int? parsedCount,
    int? failedCount,
    int? duplicateCount,
    int? matchedCount,
    int? createdCount,
    List<Object?>? errors,
  }) => ImportBatche(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    adapter: adapter.present ? adapter.value : this.adapter,
    accountId: accountId.present ? accountId.value : this.accountId,
    periodFrom: periodFrom.present ? periodFrom.value : this.periodFrom,
    periodTo: periodTo.present ? periodTo.value : this.periodTo,
    parsedCount: parsedCount ?? this.parsedCount,
    failedCount: failedCount ?? this.failedCount,
    duplicateCount: duplicateCount ?? this.duplicateCount,
    matchedCount: matchedCount ?? this.matchedCount,
    createdCount: createdCount ?? this.createdCount,
    errors: errors ?? this.errors,
  );
  ImportBatche copyWithCompanion(ImportBatchesCompanion data) {
    return ImportBatche(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      adapter: data.adapter.present ? data.adapter.value : this.adapter,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      periodFrom: data.periodFrom.present
          ? data.periodFrom.value
          : this.periodFrom,
      periodTo: data.periodTo.present ? data.periodTo.value : this.periodTo,
      parsedCount: data.parsedCount.present
          ? data.parsedCount.value
          : this.parsedCount,
      failedCount: data.failedCount.present
          ? data.failedCount.value
          : this.failedCount,
      duplicateCount: data.duplicateCount.present
          ? data.duplicateCount.value
          : this.duplicateCount,
      matchedCount: data.matchedCount.present
          ? data.matchedCount.value
          : this.matchedCount,
      createdCount: data.createdCount.present
          ? data.createdCount.value
          : this.createdCount,
      errors: data.errors.present ? data.errors.value : this.errors,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatche(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('adapter: $adapter, ')
          ..write('accountId: $accountId, ')
          ..write('periodFrom: $periodFrom, ')
          ..write('periodTo: $periodTo, ')
          ..write('parsedCount: $parsedCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('matchedCount: $matchedCount, ')
          ..write('createdCount: $createdCount, ')
          ..write('errors: $errors')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    status,
    adapter,
    accountId,
    periodFrom,
    periodTo,
    parsedCount,
    failedCount,
    duplicateCount,
    matchedCount,
    createdCount,
    errors,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportBatche &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.adapter == this.adapter &&
          other.accountId == this.accountId &&
          other.periodFrom == this.periodFrom &&
          other.periodTo == this.periodTo &&
          other.parsedCount == this.parsedCount &&
          other.failedCount == this.failedCount &&
          other.duplicateCount == this.duplicateCount &&
          other.matchedCount == this.matchedCount &&
          other.createdCount == this.createdCount &&
          other.errors == this.errors);
}

class ImportBatchesCompanion extends UpdateCompanion<ImportBatche> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<ImportKind> kind;
  final Value<ImportStatus> status;
  final Value<String?> adapter;
  final Value<String?> accountId;
  final Value<LocalDate?> periodFrom;
  final Value<LocalDate?> periodTo;
  final Value<int> parsedCount;
  final Value<int> failedCount;
  final Value<int> duplicateCount;
  final Value<int> matchedCount;
  final Value<int> createdCount;
  final Value<List<Object?>> errors;
  final Value<int> rowid;
  const ImportBatchesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.adapter = const Value.absent(),
    this.accountId = const Value.absent(),
    this.periodFrom = const Value.absent(),
    this.periodTo = const Value.absent(),
    this.parsedCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.matchedCount = const Value.absent(),
    this.createdCount = const Value.absent(),
    this.errors = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportBatchesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required ImportKind kind,
    required ImportStatus status,
    this.adapter = const Value.absent(),
    this.accountId = const Value.absent(),
    this.periodFrom = const Value.absent(),
    this.periodTo = const Value.absent(),
    this.parsedCount = const Value.absent(),
    this.failedCount = const Value.absent(),
    this.duplicateCount = const Value.absent(),
    this.matchedCount = const Value.absent(),
    this.createdCount = const Value.absent(),
    this.errors = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       status = Value(status);
  static Insertable<ImportBatche> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<String>? adapter,
    Expression<String>? accountId,
    Expression<String>? periodFrom,
    Expression<String>? periodTo,
    Expression<int>? parsedCount,
    Expression<int>? failedCount,
    Expression<int>? duplicateCount,
    Expression<int>? matchedCount,
    Expression<int>? createdCount,
    Expression<String>? errors,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (adapter != null) 'adapter': adapter,
      if (accountId != null) 'account_id': accountId,
      if (periodFrom != null) 'period_from': periodFrom,
      if (periodTo != null) 'period_to': periodTo,
      if (parsedCount != null) 'parsed_count': parsedCount,
      if (failedCount != null) 'failed_count': failedCount,
      if (duplicateCount != null) 'duplicate_count': duplicateCount,
      if (matchedCount != null) 'matched_count': matchedCount,
      if (createdCount != null) 'created_count': createdCount,
      if (errors != null) 'errors': errors,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportBatchesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<ImportKind>? kind,
    Value<ImportStatus>? status,
    Value<String?>? adapter,
    Value<String?>? accountId,
    Value<LocalDate?>? periodFrom,
    Value<LocalDate?>? periodTo,
    Value<int>? parsedCount,
    Value<int>? failedCount,
    Value<int>? duplicateCount,
    Value<int>? matchedCount,
    Value<int>? createdCount,
    Value<List<Object?>>? errors,
    Value<int>? rowid,
  }) {
    return ImportBatchesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      adapter: adapter ?? this.adapter,
      accountId: accountId ?? this.accountId,
      periodFrom: periodFrom ?? this.periodFrom,
      periodTo: periodTo ?? this.periodTo,
      parsedCount: parsedCount ?? this.parsedCount,
      failedCount: failedCount ?? this.failedCount,
      duplicateCount: duplicateCount ?? this.duplicateCount,
      matchedCount: matchedCount ?? this.matchedCount,
      createdCount: createdCount ?? this.createdCount,
      errors: errors ?? this.errors,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ImportBatchesTable.$converterkind.toSql(kind.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ImportBatchesTable.$converterstatus.toSql(status.value),
      );
    }
    if (adapter.present) {
      map['adapter'] = Variable<String>(adapter.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (periodFrom.present) {
      map['period_from'] = Variable<String>(
        $ImportBatchesTable.$converterperiodFromn.toSql(periodFrom.value),
      );
    }
    if (periodTo.present) {
      map['period_to'] = Variable<String>(
        $ImportBatchesTable.$converterperiodTon.toSql(periodTo.value),
      );
    }
    if (parsedCount.present) {
      map['parsed_count'] = Variable<int>(parsedCount.value);
    }
    if (failedCount.present) {
      map['failed_count'] = Variable<int>(failedCount.value);
    }
    if (duplicateCount.present) {
      map['duplicate_count'] = Variable<int>(duplicateCount.value);
    }
    if (matchedCount.present) {
      map['matched_count'] = Variable<int>(matchedCount.value);
    }
    if (createdCount.present) {
      map['created_count'] = Variable<int>(createdCount.value);
    }
    if (errors.present) {
      map['errors'] = Variable<String>(
        $ImportBatchesTable.$convertererrors.toSql(errors.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportBatchesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('adapter: $adapter, ')
          ..write('accountId: $accountId, ')
          ..write('periodFrom: $periodFrom, ')
          ..write('periodTo: $periodTo, ')
          ..write('parsedCount: $parsedCount, ')
          ..write('failedCount: $failedCount, ')
          ..write('duplicateCount: $duplicateCount, ')
          ..write('matchedCount: $matchedCount, ')
          ..write('createdCount: $createdCount, ')
          ..write('errors: $errors, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceRecordsTable extends SourceRecords
    with TableInfo<$SourceRecordsTable, SourceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SourceKind>($SourceRecordsTable.$converterkind);
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_batches (id)',
    ),
  );
  static const VerificationMeta _dedupeHashMeta = const VerificationMeta(
    'dedupeHash',
  );
  @override
  late final GeneratedColumn<String> dedupeHash = GeneratedColumn<String>(
    'dedupe_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ParseStatus, String> parseStatus =
      GeneratedColumn<String>(
        'parse_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ParseStatus>($SourceRecordsTable.$converterparseStatus);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  parsed = GeneratedColumn<String>(
    'parsed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, Object?>?>($SourceRecordsTable.$converterparsedn);
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    batchId,
    dedupeHash,
    parseStatus,
    parsed,
    rawText,
    sender,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    }
    if (data.containsKey('dedupe_hash')) {
      context.handle(
        _dedupeHashMeta,
        dedupeHash.isAcceptableOrUnknown(data['dedupe_hash']!, _dedupeHashMeta),
      );
    } else if (isInserting) {
      context.missing(_dedupeHashMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      kind: $SourceRecordsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_id'],
      ),
      dedupeHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_hash'],
      )!,
      parseStatus: $SourceRecordsTable.$converterparseStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parse_status'],
        )!,
      ),
      parsed: $SourceRecordsTable.$converterparsedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}parsed'],
        ),
      ),
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      ),
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      ),
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $SourceRecordsTable createAlias(String alias) {
    return $SourceRecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<SourceKind, String> $converterkind =
      const WireEnumConverter(SourceKind.values);
  static TypeConverter<ParseStatus, String> $converterparseStatus =
      const WireEnumConverter(ParseStatus.values);
  static TypeConverter<Map<String, Object?>, String> $converterparsed =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?> $converterparsedn =
      NullAwareTypeConverter.wrap($converterparsed);
}

class SourceRecord extends DataClass implements Insertable<SourceRecord> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final SourceKind kind;
  final String? batchId;

  /// Identifies the same SMS or statement row arriving twice, so importing
  /// again creates nothing new.
  final String dedupeHash;
  final ParseStatus parseStatus;
  final Map<String, Object?>? parsed;

  /// The SMS body or the statement line. Stays on the device, inside the
  /// encrypted database, and is never logged or sent to an AI provider.
  final String? rawText;
  final String? sender;
  final DateTime receivedAt;
  const SourceRecord({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.kind,
    this.batchId,
    required this.dedupeHash,
    required this.parseStatus,
    this.parsed,
    this.rawText,
    this.sender,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['kind'] = Variable<String>(
        $SourceRecordsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    map['dedupe_hash'] = Variable<String>(dedupeHash);
    {
      map['parse_status'] = Variable<String>(
        $SourceRecordsTable.$converterparseStatus.toSql(parseStatus),
      );
    }
    if (!nullToAbsent || parsed != null) {
      map['parsed'] = Variable<String>(
        $SourceRecordsTable.$converterparsedn.toSql(parsed),
      );
    }
    if (!nullToAbsent || rawText != null) {
      map['raw_text'] = Variable<String>(rawText);
    }
    if (!nullToAbsent || sender != null) {
      map['sender'] = Variable<String>(sender);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  SourceRecordsCompanion toCompanion(bool nullToAbsent) {
    return SourceRecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      kind: Value(kind),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      dedupeHash: Value(dedupeHash),
      parseStatus: Value(parseStatus),
      parsed: parsed == null && nullToAbsent
          ? const Value.absent()
          : Value(parsed),
      rawText: rawText == null && nullToAbsent
          ? const Value.absent()
          : Value(rawText),
      sender: sender == null && nullToAbsent
          ? const Value.absent()
          : Value(sender),
      receivedAt: Value(receivedAt),
    );
  }

  factory SourceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRecord(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      kind: serializer.fromJson<SourceKind>(json['kind']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      dedupeHash: serializer.fromJson<String>(json['dedupeHash']),
      parseStatus: serializer.fromJson<ParseStatus>(json['parseStatus']),
      parsed: serializer.fromJson<Map<String, Object?>?>(json['parsed']),
      rawText: serializer.fromJson<String?>(json['rawText']),
      sender: serializer.fromJson<String?>(json['sender']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'kind': serializer.toJson<SourceKind>(kind),
      'batchId': serializer.toJson<String?>(batchId),
      'dedupeHash': serializer.toJson<String>(dedupeHash),
      'parseStatus': serializer.toJson<ParseStatus>(parseStatus),
      'parsed': serializer.toJson<Map<String, Object?>?>(parsed),
      'rawText': serializer.toJson<String?>(rawText),
      'sender': serializer.toJson<String?>(sender),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  SourceRecord copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    SourceKind? kind,
    Value<String?> batchId = const Value.absent(),
    String? dedupeHash,
    ParseStatus? parseStatus,
    Value<Map<String, Object?>?> parsed = const Value.absent(),
    Value<String?> rawText = const Value.absent(),
    Value<String?> sender = const Value.absent(),
    DateTime? receivedAt,
  }) => SourceRecord(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    batchId: batchId.present ? batchId.value : this.batchId,
    dedupeHash: dedupeHash ?? this.dedupeHash,
    parseStatus: parseStatus ?? this.parseStatus,
    parsed: parsed.present ? parsed.value : this.parsed,
    rawText: rawText.present ? rawText.value : this.rawText,
    sender: sender.present ? sender.value : this.sender,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  SourceRecord copyWithCompanion(SourceRecordsCompanion data) {
    return SourceRecord(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      kind: data.kind.present ? data.kind.value : this.kind,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      dedupeHash: data.dedupeHash.present
          ? data.dedupeHash.value
          : this.dedupeHash,
      parseStatus: data.parseStatus.present
          ? data.parseStatus.value
          : this.parseStatus,
      parsed: data.parsed.present ? data.parsed.value : this.parsed,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      sender: data.sender.present ? data.sender.value : this.sender,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceRecord(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('batchId: $batchId, ')
          ..write('dedupeHash: $dedupeHash, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('parsed: $parsed, ')
          ..write('rawText: $rawText, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    batchId,
    dedupeHash,
    parseStatus,
    parsed,
    rawText,
    sender,
    receivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceRecord &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.kind == this.kind &&
          other.batchId == this.batchId &&
          other.dedupeHash == this.dedupeHash &&
          other.parseStatus == this.parseStatus &&
          other.parsed == this.parsed &&
          other.rawText == this.rawText &&
          other.sender == this.sender &&
          other.receivedAt == this.receivedAt);
}

class SourceRecordsCompanion extends UpdateCompanion<SourceRecord> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<SourceKind> kind;
  final Value<String?> batchId;
  final Value<String> dedupeHash;
  final Value<ParseStatus> parseStatus;
  final Value<Map<String, Object?>?> parsed;
  final Value<String?> rawText;
  final Value<String?> sender;
  final Value<DateTime> receivedAt;
  final Value<int> rowid;
  const SourceRecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.kind = const Value.absent(),
    this.batchId = const Value.absent(),
    this.dedupeHash = const Value.absent(),
    this.parseStatus = const Value.absent(),
    this.parsed = const Value.absent(),
    this.rawText = const Value.absent(),
    this.sender = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceRecordsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required SourceKind kind,
    this.batchId = const Value.absent(),
    required String dedupeHash,
    required ParseStatus parseStatus,
    this.parsed = const Value.absent(),
    this.rawText = const Value.absent(),
    this.sender = const Value.absent(),
    required DateTime receivedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       dedupeHash = Value(dedupeHash),
       parseStatus = Value(parseStatus),
       receivedAt = Value(receivedAt);
  static Insertable<SourceRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? kind,
    Expression<String>? batchId,
    Expression<String>? dedupeHash,
    Expression<String>? parseStatus,
    Expression<String>? parsed,
    Expression<String>? rawText,
    Expression<String>? sender,
    Expression<DateTime>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (kind != null) 'kind': kind,
      if (batchId != null) 'batch_id': batchId,
      if (dedupeHash != null) 'dedupe_hash': dedupeHash,
      if (parseStatus != null) 'parse_status': parseStatus,
      if (parsed != null) 'parsed': parsed,
      if (rawText != null) 'raw_text': rawText,
      if (sender != null) 'sender': sender,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<SourceKind>? kind,
    Value<String?>? batchId,
    Value<String>? dedupeHash,
    Value<ParseStatus>? parseStatus,
    Value<Map<String, Object?>?>? parsed,
    Value<String?>? rawText,
    Value<String?>? sender,
    Value<DateTime>? receivedAt,
    Value<int>? rowid,
  }) {
    return SourceRecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      kind: kind ?? this.kind,
      batchId: batchId ?? this.batchId,
      dedupeHash: dedupeHash ?? this.dedupeHash,
      parseStatus: parseStatus ?? this.parseStatus,
      parsed: parsed ?? this.parsed,
      rawText: rawText ?? this.rawText,
      sender: sender ?? this.sender,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SourceRecordsTable.$converterkind.toSql(kind.value),
      );
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (dedupeHash.present) {
      map['dedupe_hash'] = Variable<String>(dedupeHash.value);
    }
    if (parseStatus.present) {
      map['parse_status'] = Variable<String>(
        $SourceRecordsTable.$converterparseStatus.toSql(parseStatus.value),
      );
    }
    if (parsed.present) {
      map['parsed'] = Variable<String>(
        $SourceRecordsTable.$converterparsedn.toSql(parsed.value),
      );
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('batchId: $batchId, ')
          ..write('dedupeHash: $dedupeHash, ')
          ..write('parseStatus: $parseStatus, ')
          ..write('parsed: $parsed, ')
          ..write('rawText: $rawText, ')
          ..write('sender: $sender, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SpendClass, String> spendClass =
      GeneratedColumn<String>(
        'spend_class',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpendClass>($CategoriesTable.$converterspendClass);
  @override
  late final GeneratedColumnWithTypeConverter<SpendClassSource, String>
  spendClassSource =
      GeneratedColumn<String>(
        'spend_class_source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpendClassSource>(
        $CategoriesTable.$converterspendClassSource,
      );
  static const VerificationMeta _floorPaiseMeta = const VerificationMeta(
    'floorPaise',
  );
  @override
  late final GeneratedColumn<int> floorPaise = GeneratedColumn<int>(
    'floor_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorTokenMeta = const VerificationMeta(
    'colorToken',
  );
  @override
  late final GeneratedColumn<String> colorToken = GeneratedColumn<String>(
    'color_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    name,
    parentId,
    spendClass,
    spendClassSource,
    floorPaise,
    icon,
    colorToken,
    isSystem,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('floor_paise')) {
      context.handle(
        _floorPaiseMeta,
        floorPaise.isAcceptableOrUnknown(data['floor_paise']!, _floorPaiseMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_token')) {
      context.handle(
        _colorTokenMeta,
        colorToken.isAcceptableOrUnknown(data['color_token']!, _colorTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_colorTokenMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      spendClass: $CategoriesTable.$converterspendClass.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}spend_class'],
        )!,
      ),
      spendClassSource: $CategoriesTable.$converterspendClassSource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}spend_class_source'],
        )!,
      ),
      floorPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor_paise'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_token'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<SpendClass, String> $converterspendClass =
      const WireEnumConverter(SpendClass.values);
  static TypeConverter<SpendClassSource, String> $converterspendClassSource =
      const WireEnumConverter(SpendClassSource.values);
}

class Category extends DataClass implements Insertable<Category> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String name;
  final String? parentId;
  final SpendClass spendClass;
  final SpendClassSource spendClassSource;

  /// The goal simulator never suggests cutting this category below this
  /// monthly amount.
  final int floorPaise;
  final String icon;

  /// A design token name such as `chart3`, never a raw colour.
  final String colorToken;
  final bool isSystem;
  final int sortOrder;
  const Category({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.name,
    this.parentId,
    required this.spendClass,
    required this.spendClassSource,
    required this.floorPaise,
    required this.icon,
    required this.colorToken,
    required this.isSystem,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    {
      map['spend_class'] = Variable<String>(
        $CategoriesTable.$converterspendClass.toSql(spendClass),
      );
    }
    {
      map['spend_class_source'] = Variable<String>(
        $CategoriesTable.$converterspendClassSource.toSql(spendClassSource),
      );
    }
    map['floor_paise'] = Variable<int>(floorPaise);
    map['icon'] = Variable<String>(icon);
    map['color_token'] = Variable<String>(colorToken);
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      spendClass: Value(spendClass),
      spendClassSource: Value(spendClassSource),
      floorPaise: Value(floorPaise),
      icon: Value(icon),
      colorToken: Value(colorToken),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      spendClass: serializer.fromJson<SpendClass>(json['spendClass']),
      spendClassSource: serializer.fromJson<SpendClassSource>(
        json['spendClassSource'],
      ),
      floorPaise: serializer.fromJson<int>(json['floorPaise']),
      icon: serializer.fromJson<String>(json['icon']),
      colorToken: serializer.fromJson<String>(json['colorToken']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'spendClass': serializer.toJson<SpendClass>(spendClass),
      'spendClassSource': serializer.toJson<SpendClassSource>(spendClassSource),
      'floorPaise': serializer.toJson<int>(floorPaise),
      'icon': serializer.toJson<String>(icon),
      'colorToken': serializer.toJson<String>(colorToken),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? name,
    Value<String?> parentId = const Value.absent(),
    SpendClass? spendClass,
    SpendClassSource? spendClassSource,
    int? floorPaise,
    String? icon,
    String? colorToken,
    bool? isSystem,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    spendClass: spendClass ?? this.spendClass,
    spendClassSource: spendClassSource ?? this.spendClassSource,
    floorPaise: floorPaise ?? this.floorPaise,
    icon: icon ?? this.icon,
    colorToken: colorToken ?? this.colorToken,
    isSystem: isSystem ?? this.isSystem,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      spendClass: data.spendClass.present
          ? data.spendClass.value
          : this.spendClass,
      spendClassSource: data.spendClassSource.present
          ? data.spendClassSource.value
          : this.spendClassSource,
      floorPaise: data.floorPaise.present
          ? data.floorPaise.value
          : this.floorPaise,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorToken: data.colorToken.present
          ? data.colorToken.value
          : this.colorToken,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('spendClass: $spendClass, ')
          ..write('spendClassSource: $spendClassSource, ')
          ..write('floorPaise: $floorPaise, ')
          ..write('icon: $icon, ')
          ..write('colorToken: $colorToken, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    name,
    parentId,
    spendClass,
    spendClassSource,
    floorPaise,
    icon,
    colorToken,
    isSystem,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.spendClass == this.spendClass &&
          other.spendClassSource == this.spendClassSource &&
          other.floorPaise == this.floorPaise &&
          other.icon == this.icon &&
          other.colorToken == this.colorToken &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<SpendClass> spendClass;
  final Value<SpendClassSource> spendClassSource;
  final Value<int> floorPaise;
  final Value<String> icon;
  final Value<String> colorToken;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.spendClass = const Value.absent(),
    this.spendClassSource = const Value.absent(),
    this.floorPaise = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorToken = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required SpendClass spendClass,
    required SpendClassSource spendClassSource,
    this.floorPaise = const Value.absent(),
    required String icon,
    required String colorToken,
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       spendClass = Value(spendClass),
       spendClassSource = Value(spendClassSource),
       icon = Value(icon),
       colorToken = Value(colorToken);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? spendClass,
    Expression<String>? spendClassSource,
    Expression<int>? floorPaise,
    Expression<String>? icon,
    Expression<String>? colorToken,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (spendClass != null) 'spend_class': spendClass,
      if (spendClassSource != null) 'spend_class_source': spendClassSource,
      if (floorPaise != null) 'floor_paise': floorPaise,
      if (icon != null) 'icon': icon,
      if (colorToken != null) 'color_token': colorToken,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? name,
    Value<String?>? parentId,
    Value<SpendClass>? spendClass,
    Value<SpendClassSource>? spendClassSource,
    Value<int>? floorPaise,
    Value<String>? icon,
    Value<String>? colorToken,
    Value<bool>? isSystem,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      spendClass: spendClass ?? this.spendClass,
      spendClassSource: spendClassSource ?? this.spendClassSource,
      floorPaise: floorPaise ?? this.floorPaise,
      icon: icon ?? this.icon,
      colorToken: colorToken ?? this.colorToken,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (spendClass.present) {
      map['spend_class'] = Variable<String>(
        $CategoriesTable.$converterspendClass.toSql(spendClass.value),
      );
    }
    if (spendClassSource.present) {
      map['spend_class_source'] = Variable<String>(
        $CategoriesTable.$converterspendClassSource.toSql(
          spendClassSource.value,
        ),
      );
    }
    if (floorPaise.present) {
      map['floor_paise'] = Variable<int>(floorPaise.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorToken.present) {
      map['color_token'] = Variable<String>(colorToken.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('spendClass: $spendClass, ')
          ..write('spendClassSource: $spendClassSource, ')
          ..write('floorPaise: $floorPaise, ')
          ..write('icon: $icon, ')
          ..write('colorToken: $colorToken, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryRulesTable extends CategoryRules
    with TableInfo<$CategoryRulesTable, CategoryRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RuleType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RuleType>($CategoryRulesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  match = GeneratedColumn<String>(
    'match',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($CategoryRulesTable.$convertermatch);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Origin, String> createdBy =
      GeneratedColumn<String>(
        'created_by',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Origin>($CategoryRulesTable.$convertercreatedBy);
  static const VerificationMeta _hitCountMeta = const VerificationMeta(
    'hitCount',
  );
  @override
  late final GeneratedColumn<int> hitCount = GeneratedColumn<int>(
    'hit_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _missCountMeta = const VerificationMeta(
    'missCount',
  );
  @override
  late final GeneratedColumn<int> missCount = GeneratedColumn<int>(
    'miss_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    type,
    match,
    categoryId,
    priority,
    enabled,
    createdBy,
    hitCount,
    missCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('hit_count')) {
      context.handle(
        _hitCountMeta,
        hitCount.isAcceptableOrUnknown(data['hit_count']!, _hitCountMeta),
      );
    }
    if (data.containsKey('miss_count')) {
      context.handle(
        _missCountMeta,
        missCount.isAcceptableOrUnknown(data['miss_count']!, _missCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      type: $CategoryRulesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      match: $CategoryRulesTable.$convertermatch.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}match'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdBy: $CategoryRulesTable.$convertercreatedBy.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}created_by'],
        )!,
      ),
      hitCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hit_count'],
      )!,
      missCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}miss_count'],
      )!,
    );
  }

  @override
  $CategoryRulesTable createAlias(String alias) {
    return $CategoryRulesTable(attachedDatabase, alias);
  }

  static TypeConverter<RuleType, String> $convertertype =
      const WireEnumConverter(RuleType.values);
  static TypeConverter<Map<String, Object?>, String> $convertermatch =
      const JsonMapConverter();
  static TypeConverter<Origin, String> $convertercreatedBy =
      const WireEnumConverter(Origin.values);
}

class CategoryRule extends DataClass implements Insertable<CategoryRule> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final RuleType type;

  /// What to match; its shape depends on [type]. See ARCHITECTURE.md.
  final Map<String, Object?> match;
  final String categoryId;

  /// Lower runs first.
  final int priority;
  final bool enabled;
  final Origin createdBy;
  final int hitCount;
  final int missCount;
  const CategoryRule({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.type,
    required this.match,
    required this.categoryId,
    required this.priority,
    required this.enabled,
    required this.createdBy,
    required this.hitCount,
    required this.missCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['type'] = Variable<String>(
        $CategoryRulesTable.$convertertype.toSql(type),
      );
    }
    {
      map['match'] = Variable<String>(
        $CategoryRulesTable.$convertermatch.toSql(match),
      );
    }
    map['category_id'] = Variable<String>(categoryId);
    map['priority'] = Variable<int>(priority);
    map['enabled'] = Variable<bool>(enabled);
    {
      map['created_by'] = Variable<String>(
        $CategoryRulesTable.$convertercreatedBy.toSql(createdBy),
      );
    }
    map['hit_count'] = Variable<int>(hitCount);
    map['miss_count'] = Variable<int>(missCount);
    return map;
  }

  CategoryRulesCompanion toCompanion(bool nullToAbsent) {
    return CategoryRulesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      type: Value(type),
      match: Value(match),
      categoryId: Value(categoryId),
      priority: Value(priority),
      enabled: Value(enabled),
      createdBy: Value(createdBy),
      hitCount: Value(hitCount),
      missCount: Value(missCount),
    );
  }

  factory CategoryRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRule(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      type: serializer.fromJson<RuleType>(json['type']),
      match: serializer.fromJson<Map<String, Object?>>(json['match']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      priority: serializer.fromJson<int>(json['priority']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdBy: serializer.fromJson<Origin>(json['createdBy']),
      hitCount: serializer.fromJson<int>(json['hitCount']),
      missCount: serializer.fromJson<int>(json['missCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'type': serializer.toJson<RuleType>(type),
      'match': serializer.toJson<Map<String, Object?>>(match),
      'categoryId': serializer.toJson<String>(categoryId),
      'priority': serializer.toJson<int>(priority),
      'enabled': serializer.toJson<bool>(enabled),
      'createdBy': serializer.toJson<Origin>(createdBy),
      'hitCount': serializer.toJson<int>(hitCount),
      'missCount': serializer.toJson<int>(missCount),
    };
  }

  CategoryRule copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    RuleType? type,
    Map<String, Object?>? match,
    String? categoryId,
    int? priority,
    bool? enabled,
    Origin? createdBy,
    int? hitCount,
    int? missCount,
  }) => CategoryRule(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    type: type ?? this.type,
    match: match ?? this.match,
    categoryId: categoryId ?? this.categoryId,
    priority: priority ?? this.priority,
    enabled: enabled ?? this.enabled,
    createdBy: createdBy ?? this.createdBy,
    hitCount: hitCount ?? this.hitCount,
    missCount: missCount ?? this.missCount,
  );
  CategoryRule copyWithCompanion(CategoryRulesCompanion data) {
    return CategoryRule(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      type: data.type.present ? data.type.value : this.type,
      match: data.match.present ? data.match.value : this.match,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      priority: data.priority.present ? data.priority.value : this.priority,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      hitCount: data.hitCount.present ? data.hitCount.value : this.hitCount,
      missCount: data.missCount.present ? data.missCount.value : this.missCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRule(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('type: $type, ')
          ..write('match: $match, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled, ')
          ..write('createdBy: $createdBy, ')
          ..write('hitCount: $hitCount, ')
          ..write('missCount: $missCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    type,
    match,
    categoryId,
    priority,
    enabled,
    createdBy,
    hitCount,
    missCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRule &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.type == this.type &&
          other.match == this.match &&
          other.categoryId == this.categoryId &&
          other.priority == this.priority &&
          other.enabled == this.enabled &&
          other.createdBy == this.createdBy &&
          other.hitCount == this.hitCount &&
          other.missCount == this.missCount);
}

class CategoryRulesCompanion extends UpdateCompanion<CategoryRule> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<RuleType> type;
  final Value<Map<String, Object?>> match;
  final Value<String> categoryId;
  final Value<int> priority;
  final Value<bool> enabled;
  final Value<Origin> createdBy;
  final Value<int> hitCount;
  final Value<int> missCount;
  final Value<int> rowid;
  const CategoryRulesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.type = const Value.absent(),
    this.match = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.priority = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.hitCount = const Value.absent(),
    this.missCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryRulesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required RuleType type,
    required Map<String, Object?> match,
    required String categoryId,
    this.priority = const Value.absent(),
    this.enabled = const Value.absent(),
    required Origin createdBy,
    this.hitCount = const Value.absent(),
    this.missCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       type = Value(type),
       match = Value(match),
       categoryId = Value(categoryId),
       createdBy = Value(createdBy);
  static Insertable<CategoryRule> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? type,
    Expression<String>? match,
    Expression<String>? categoryId,
    Expression<int>? priority,
    Expression<bool>? enabled,
    Expression<String>? createdBy,
    Expression<int>? hitCount,
    Expression<int>? missCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (type != null) 'type': type,
      if (match != null) 'match': match,
      if (categoryId != null) 'category_id': categoryId,
      if (priority != null) 'priority': priority,
      if (enabled != null) 'enabled': enabled,
      if (createdBy != null) 'created_by': createdBy,
      if (hitCount != null) 'hit_count': hitCount,
      if (missCount != null) 'miss_count': missCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryRulesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<RuleType>? type,
    Value<Map<String, Object?>>? match,
    Value<String>? categoryId,
    Value<int>? priority,
    Value<bool>? enabled,
    Value<Origin>? createdBy,
    Value<int>? hitCount,
    Value<int>? missCount,
    Value<int>? rowid,
  }) {
    return CategoryRulesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      type: type ?? this.type,
      match: match ?? this.match,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      enabled: enabled ?? this.enabled,
      createdBy: createdBy ?? this.createdBy,
      hitCount: hitCount ?? this.hitCount,
      missCount: missCount ?? this.missCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CategoryRulesTable.$convertertype.toSql(type.value),
      );
    }
    if (match.present) {
      map['match'] = Variable<String>(
        $CategoryRulesTable.$convertermatch.toSql(match.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(
        $CategoryRulesTable.$convertercreatedBy.toSql(createdBy.value),
      );
    }
    if (hitCount.present) {
      map['hit_count'] = Variable<int>(hitCount.value);
    }
    if (missCount.present) {
      map['miss_count'] = Variable<int>(missCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRulesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('type: $type, ')
          ..write('match: $match, ')
          ..write('categoryId: $categoryId, ')
          ..write('priority: $priority, ')
          ..write('enabled: $enabled, ')
          ..write('createdBy: $createdBy, ')
          ..write('hitCount: $hitCount, ')
          ..write('missCount: $missCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Direction, String> direction =
      GeneratedColumn<String>(
        'direction',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Direction>($TransactionsTable.$converterdirection);
  static const VerificationMeta _amountPaiseMeta = const VerificationMeta(
    'amountPaise',
  );
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
    'amount_paise',
    aliasedName,
    false,
    check: () => ComparableExpr(amountPaise).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> localDate =
      GeneratedColumn<String>(
        'local_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($TransactionsTable.$converterlocalDate);
  @override
  late final GeneratedColumnWithTypeConverter<Channel, String> channel =
      GeneratedColumn<String>(
        'channel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Channel>($TransactionsTable.$converterchannel);
  static const VerificationMeta _counterpartyNameMeta = const VerificationMeta(
    'counterpartyName',
  );
  @override
  late final GeneratedColumn<String> counterpartyName = GeneratedColumn<String>(
    'counterparty_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantKeyMeta = const VerificationMeta(
    'merchantKey',
  );
  @override
  late final GeneratedColumn<String> merchantKey = GeneratedColumn<String>(
    'merchant_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vpaMeta = const VerificationMeta('vpa');
  @override
  late final GeneratedColumn<String> vpa = GeneratedColumn<String>(
    'vpa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CounterpartyKind, String>
  counterpartyKind =
      GeneratedColumn<String>(
        'counterparty_kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unknown'),
      ).withConverter<CounterpartyKind>(
        $TransactionsTable.$convertercounterpartyKind,
      );
  static const VerificationMeta _upiRefMeta = const VerificationMeta('upiRef');
  @override
  late final GeneratedColumn<String> upiRef = GeneratedColumn<String>(
    'upi_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankRefMeta = const VerificationMeta(
    'bankRef',
  );
  @override
  late final GeneratedColumn<String> bankRef = GeneratedColumn<String>(
    'bank_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardLast4Meta = const VerificationMeta(
    'cardLast4',
  );
  @override
  late final GeneratedColumn<String> cardLast4 = GeneratedColumn<String>(
    'card_last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionRawMeta = const VerificationMeta(
    'descriptionRaw',
  );
  @override
  late final GeneratedColumn<String> descriptionRaw = GeneratedColumn<String>(
    'description_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategorizationMethod?, String>
  categorizedBy =
      GeneratedColumn<String>(
        'categorized_by',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CategorizationMethod?>(
        $TransactionsTable.$convertercategorizedByn,
      );
  static const VerificationMeta _categorizationRuleIdMeta =
      const VerificationMeta('categorizationRuleId');
  @override
  late final GeneratedColumn<String> categorizationRuleId =
      GeneratedColumn<String>(
        'categorization_rule_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES category_rules (id)',
        ),
      );
  static const VerificationMeta _categorizationConfidenceMeta =
      const VerificationMeta('categorizationConfidence');
  @override
  late final GeneratedColumn<double> categorizationConfidence =
      GeneratedColumn<double>(
        'categorization_confidence',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionFlow, String> flow =
      GeneratedColumn<String>(
        'flow',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TransactionFlow>($TransactionsTable.$converterflow);
  @override
  late final GeneratedColumnWithTypeConverter<ReconciliationStatus, String>
  reconciliationStatus =
      GeneratedColumn<String>(
        'reconciliation_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReconciliationStatus>(
        $TransactionsTable.$converterreconciliationStatus,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    accountId,
    direction,
    amountPaise,
    occurredAt,
    localDate,
    channel,
    counterpartyName,
    merchantKey,
    vpa,
    counterpartyKind,
    upiRef,
    bankRef,
    cardLast4,
    descriptionRaw,
    categoryId,
    categorizedBy,
    categorizationRuleId,
    categorizationConfidence,
    flow,
    reconciliationStatus,
    notes,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
        _amountPaiseMeta,
        amountPaise.isAcceptableOrUnknown(
          data['amount_paise']!,
          _amountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('counterparty_name')) {
      context.handle(
        _counterpartyNameMeta,
        counterpartyName.isAcceptableOrUnknown(
          data['counterparty_name']!,
          _counterpartyNameMeta,
        ),
      );
    }
    if (data.containsKey('merchant_key')) {
      context.handle(
        _merchantKeyMeta,
        merchantKey.isAcceptableOrUnknown(
          data['merchant_key']!,
          _merchantKeyMeta,
        ),
      );
    }
    if (data.containsKey('vpa')) {
      context.handle(
        _vpaMeta,
        vpa.isAcceptableOrUnknown(data['vpa']!, _vpaMeta),
      );
    }
    if (data.containsKey('upi_ref')) {
      context.handle(
        _upiRefMeta,
        upiRef.isAcceptableOrUnknown(data['upi_ref']!, _upiRefMeta),
      );
    }
    if (data.containsKey('bank_ref')) {
      context.handle(
        _bankRefMeta,
        bankRef.isAcceptableOrUnknown(data['bank_ref']!, _bankRefMeta),
      );
    }
    if (data.containsKey('card_last4')) {
      context.handle(
        _cardLast4Meta,
        cardLast4.isAcceptableOrUnknown(data['card_last4']!, _cardLast4Meta),
      );
    }
    if (data.containsKey('description_raw')) {
      context.handle(
        _descriptionRawMeta,
        descriptionRaw.isAcceptableOrUnknown(
          data['description_raw']!,
          _descriptionRawMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('categorization_rule_id')) {
      context.handle(
        _categorizationRuleIdMeta,
        categorizationRuleId.isAcceptableOrUnknown(
          data['categorization_rule_id']!,
          _categorizationRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('categorization_confidence')) {
      context.handle(
        _categorizationConfidenceMeta,
        categorizationConfidence.isAcceptableOrUnknown(
          data['categorization_confidence']!,
          _categorizationConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      direction: $TransactionsTable.$converterdirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}direction'],
        )!,
      ),
      amountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_paise'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      localDate: $TransactionsTable.$converterlocalDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}local_date'],
        )!,
      ),
      channel: $TransactionsTable.$converterchannel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}channel'],
        )!,
      ),
      counterpartyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty_name'],
      ),
      merchantKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_key'],
      ),
      vpa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vpa'],
      ),
      counterpartyKind: $TransactionsTable.$convertercounterpartyKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}counterparty_kind'],
        )!,
      ),
      upiRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_ref'],
      ),
      bankRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_ref'],
      ),
      cardLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_last4'],
      ),
      descriptionRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_raw'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categorizedBy: $TransactionsTable.$convertercategorizedByn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}categorized_by'],
        ),
      ),
      categorizationRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categorization_rule_id'],
      ),
      categorizationConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}categorization_confidence'],
      ),
      flow: $TransactionsTable.$converterflow.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flow'],
        )!,
      ),
      reconciliationStatus: $TransactionsTable.$converterreconciliationStatus
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}reconciliation_status'],
            )!,
          ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Direction, String> $converterdirection =
      const WireEnumConverter(Direction.values);
  static TypeConverter<LocalDate, String> $converterlocalDate =
      const LocalDateConverter();
  static TypeConverter<Channel, String> $converterchannel =
      const WireEnumConverter(Channel.values);
  static TypeConverter<CounterpartyKind, String> $convertercounterpartyKind =
      const WireEnumConverter(CounterpartyKind.values);
  static TypeConverter<CategorizationMethod, String> $convertercategorizedBy =
      const WireEnumConverter(CategorizationMethod.values);
  static TypeConverter<CategorizationMethod?, String?>
  $convertercategorizedByn = NullAwareTypeConverter.wrap(
    $convertercategorizedBy,
  );
  static TypeConverter<TransactionFlow, String> $converterflow =
      const WireEnumConverter(TransactionFlow.values);
  static TypeConverter<ReconciliationStatus, String>
  $converterreconciliationStatus = const WireEnumConverter(
    ReconciliationStatus.values,
  );
}

class Transaction extends DataClass implements Insertable<Transaction> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String? accountId;
  final Direction direction;

  /// Always positive; [direction] says which way the money moved.
  final int amountPaise;
  final DateTime occurredAt;

  /// The IST calendar day of [occurredAt], used for monthly bucketing.
  final LocalDate localDate;
  final Channel channel;
  final String? counterpartyName;

  /// Normalized merchant name used by rules, e.g. `swiggy`.
  final String? merchantKey;
  final String? vpa;
  final CounterpartyKind counterpartyKind;
  final String? upiRef;
  final String? bankRef;
  final String? cardLast4;
  final String? descriptionRaw;
  final String? categoryId;
  final CategorizationMethod? categorizedBy;
  final String? categorizationRuleId;
  final double? categorizationConfidence;
  final TransactionFlow flow;
  final ReconciliationStatus reconciliationStatus;
  final String? notes;
  final DateTime? deletedAt;
  const Transaction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.accountId,
    required this.direction,
    required this.amountPaise,
    required this.occurredAt,
    required this.localDate,
    required this.channel,
    this.counterpartyName,
    this.merchantKey,
    this.vpa,
    required this.counterpartyKind,
    this.upiRef,
    this.bankRef,
    this.cardLast4,
    this.descriptionRaw,
    this.categoryId,
    this.categorizedBy,
    this.categorizationRuleId,
    this.categorizationConfidence,
    required this.flow,
    required this.reconciliationStatus,
    this.notes,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    {
      map['direction'] = Variable<String>(
        $TransactionsTable.$converterdirection.toSql(direction),
      );
    }
    map['amount_paise'] = Variable<int>(amountPaise);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    {
      map['local_date'] = Variable<String>(
        $TransactionsTable.$converterlocalDate.toSql(localDate),
      );
    }
    {
      map['channel'] = Variable<String>(
        $TransactionsTable.$converterchannel.toSql(channel),
      );
    }
    if (!nullToAbsent || counterpartyName != null) {
      map['counterparty_name'] = Variable<String>(counterpartyName);
    }
    if (!nullToAbsent || merchantKey != null) {
      map['merchant_key'] = Variable<String>(merchantKey);
    }
    if (!nullToAbsent || vpa != null) {
      map['vpa'] = Variable<String>(vpa);
    }
    {
      map['counterparty_kind'] = Variable<String>(
        $TransactionsTable.$convertercounterpartyKind.toSql(counterpartyKind),
      );
    }
    if (!nullToAbsent || upiRef != null) {
      map['upi_ref'] = Variable<String>(upiRef);
    }
    if (!nullToAbsent || bankRef != null) {
      map['bank_ref'] = Variable<String>(bankRef);
    }
    if (!nullToAbsent || cardLast4 != null) {
      map['card_last4'] = Variable<String>(cardLast4);
    }
    if (!nullToAbsent || descriptionRaw != null) {
      map['description_raw'] = Variable<String>(descriptionRaw);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categorizedBy != null) {
      map['categorized_by'] = Variable<String>(
        $TransactionsTable.$convertercategorizedByn.toSql(categorizedBy),
      );
    }
    if (!nullToAbsent || categorizationRuleId != null) {
      map['categorization_rule_id'] = Variable<String>(categorizationRuleId);
    }
    if (!nullToAbsent || categorizationConfidence != null) {
      map['categorization_confidence'] = Variable<double>(
        categorizationConfidence,
      );
    }
    {
      map['flow'] = Variable<String>(
        $TransactionsTable.$converterflow.toSql(flow),
      );
    }
    {
      map['reconciliation_status'] = Variable<String>(
        $TransactionsTable.$converterreconciliationStatus.toSql(
          reconciliationStatus,
        ),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      direction: Value(direction),
      amountPaise: Value(amountPaise),
      occurredAt: Value(occurredAt),
      localDate: Value(localDate),
      channel: Value(channel),
      counterpartyName: counterpartyName == null && nullToAbsent
          ? const Value.absent()
          : Value(counterpartyName),
      merchantKey: merchantKey == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantKey),
      vpa: vpa == null && nullToAbsent ? const Value.absent() : Value(vpa),
      counterpartyKind: Value(counterpartyKind),
      upiRef: upiRef == null && nullToAbsent
          ? const Value.absent()
          : Value(upiRef),
      bankRef: bankRef == null && nullToAbsent
          ? const Value.absent()
          : Value(bankRef),
      cardLast4: cardLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(cardLast4),
      descriptionRaw: descriptionRaw == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionRaw),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categorizedBy: categorizedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(categorizedBy),
      categorizationRuleId: categorizationRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(categorizationRuleId),
      categorizationConfidence: categorizationConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(categorizationConfidence),
      flow: Value(flow),
      reconciliationStatus: Value(reconciliationStatus),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      direction: serializer.fromJson<Direction>(json['direction']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      localDate: serializer.fromJson<LocalDate>(json['localDate']),
      channel: serializer.fromJson<Channel>(json['channel']),
      counterpartyName: serializer.fromJson<String?>(json['counterpartyName']),
      merchantKey: serializer.fromJson<String?>(json['merchantKey']),
      vpa: serializer.fromJson<String?>(json['vpa']),
      counterpartyKind: serializer.fromJson<CounterpartyKind>(
        json['counterpartyKind'],
      ),
      upiRef: serializer.fromJson<String?>(json['upiRef']),
      bankRef: serializer.fromJson<String?>(json['bankRef']),
      cardLast4: serializer.fromJson<String?>(json['cardLast4']),
      descriptionRaw: serializer.fromJson<String?>(json['descriptionRaw']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categorizedBy: serializer.fromJson<CategorizationMethod?>(
        json['categorizedBy'],
      ),
      categorizationRuleId: serializer.fromJson<String?>(
        json['categorizationRuleId'],
      ),
      categorizationConfidence: serializer.fromJson<double?>(
        json['categorizationConfidence'],
      ),
      flow: serializer.fromJson<TransactionFlow>(json['flow']),
      reconciliationStatus: serializer.fromJson<ReconciliationStatus>(
        json['reconciliationStatus'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'accountId': serializer.toJson<String?>(accountId),
      'direction': serializer.toJson<Direction>(direction),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'localDate': serializer.toJson<LocalDate>(localDate),
      'channel': serializer.toJson<Channel>(channel),
      'counterpartyName': serializer.toJson<String?>(counterpartyName),
      'merchantKey': serializer.toJson<String?>(merchantKey),
      'vpa': serializer.toJson<String?>(vpa),
      'counterpartyKind': serializer.toJson<CounterpartyKind>(counterpartyKind),
      'upiRef': serializer.toJson<String?>(upiRef),
      'bankRef': serializer.toJson<String?>(bankRef),
      'cardLast4': serializer.toJson<String?>(cardLast4),
      'descriptionRaw': serializer.toJson<String?>(descriptionRaw),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categorizedBy': serializer.toJson<CategorizationMethod?>(categorizedBy),
      'categorizationRuleId': serializer.toJson<String?>(categorizationRuleId),
      'categorizationConfidence': serializer.toJson<double?>(
        categorizationConfidence,
      ),
      'flow': serializer.toJson<TransactionFlow>(flow),
      'reconciliationStatus': serializer.toJson<ReconciliationStatus>(
        reconciliationStatus,
      ),
      'notes': serializer.toJson<String?>(notes),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Transaction copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    Value<String?> accountId = const Value.absent(),
    Direction? direction,
    int? amountPaise,
    DateTime? occurredAt,
    LocalDate? localDate,
    Channel? channel,
    Value<String?> counterpartyName = const Value.absent(),
    Value<String?> merchantKey = const Value.absent(),
    Value<String?> vpa = const Value.absent(),
    CounterpartyKind? counterpartyKind,
    Value<String?> upiRef = const Value.absent(),
    Value<String?> bankRef = const Value.absent(),
    Value<String?> cardLast4 = const Value.absent(),
    Value<String?> descriptionRaw = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<CategorizationMethod?> categorizedBy = const Value.absent(),
    Value<String?> categorizationRuleId = const Value.absent(),
    Value<double?> categorizationConfidence = const Value.absent(),
    TransactionFlow? flow,
    ReconciliationStatus? reconciliationStatus,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    accountId: accountId.present ? accountId.value : this.accountId,
    direction: direction ?? this.direction,
    amountPaise: amountPaise ?? this.amountPaise,
    occurredAt: occurredAt ?? this.occurredAt,
    localDate: localDate ?? this.localDate,
    channel: channel ?? this.channel,
    counterpartyName: counterpartyName.present
        ? counterpartyName.value
        : this.counterpartyName,
    merchantKey: merchantKey.present ? merchantKey.value : this.merchantKey,
    vpa: vpa.present ? vpa.value : this.vpa,
    counterpartyKind: counterpartyKind ?? this.counterpartyKind,
    upiRef: upiRef.present ? upiRef.value : this.upiRef,
    bankRef: bankRef.present ? bankRef.value : this.bankRef,
    cardLast4: cardLast4.present ? cardLast4.value : this.cardLast4,
    descriptionRaw: descriptionRaw.present
        ? descriptionRaw.value
        : this.descriptionRaw,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categorizedBy: categorizedBy.present
        ? categorizedBy.value
        : this.categorizedBy,
    categorizationRuleId: categorizationRuleId.present
        ? categorizationRuleId.value
        : this.categorizationRuleId,
    categorizationConfidence: categorizationConfidence.present
        ? categorizationConfidence.value
        : this.categorizationConfidence,
    flow: flow ?? this.flow,
    reconciliationStatus: reconciliationStatus ?? this.reconciliationStatus,
    notes: notes.present ? notes.value : this.notes,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      direction: data.direction.present ? data.direction.value : this.direction,
      amountPaise: data.amountPaise.present
          ? data.amountPaise.value
          : this.amountPaise,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      channel: data.channel.present ? data.channel.value : this.channel,
      counterpartyName: data.counterpartyName.present
          ? data.counterpartyName.value
          : this.counterpartyName,
      merchantKey: data.merchantKey.present
          ? data.merchantKey.value
          : this.merchantKey,
      vpa: data.vpa.present ? data.vpa.value : this.vpa,
      counterpartyKind: data.counterpartyKind.present
          ? data.counterpartyKind.value
          : this.counterpartyKind,
      upiRef: data.upiRef.present ? data.upiRef.value : this.upiRef,
      bankRef: data.bankRef.present ? data.bankRef.value : this.bankRef,
      cardLast4: data.cardLast4.present ? data.cardLast4.value : this.cardLast4,
      descriptionRaw: data.descriptionRaw.present
          ? data.descriptionRaw.value
          : this.descriptionRaw,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categorizedBy: data.categorizedBy.present
          ? data.categorizedBy.value
          : this.categorizedBy,
      categorizationRuleId: data.categorizationRuleId.present
          ? data.categorizationRuleId.value
          : this.categorizationRuleId,
      categorizationConfidence: data.categorizationConfidence.present
          ? data.categorizationConfidence.value
          : this.categorizationConfidence,
      flow: data.flow.present ? data.flow.value : this.flow,
      reconciliationStatus: data.reconciliationStatus.present
          ? data.reconciliationStatus.value
          : this.reconciliationStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('accountId: $accountId, ')
          ..write('direction: $direction, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate, ')
          ..write('channel: $channel, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('merchantKey: $merchantKey, ')
          ..write('vpa: $vpa, ')
          ..write('counterpartyKind: $counterpartyKind, ')
          ..write('upiRef: $upiRef, ')
          ..write('bankRef: $bankRef, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('categoryId: $categoryId, ')
          ..write('categorizedBy: $categorizedBy, ')
          ..write('categorizationRuleId: $categorizationRuleId, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('flow: $flow, ')
          ..write('reconciliationStatus: $reconciliationStatus, ')
          ..write('notes: $notes, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    version,
    accountId,
    direction,
    amountPaise,
    occurredAt,
    localDate,
    channel,
    counterpartyName,
    merchantKey,
    vpa,
    counterpartyKind,
    upiRef,
    bankRef,
    cardLast4,
    descriptionRaw,
    categoryId,
    categorizedBy,
    categorizationRuleId,
    categorizationConfidence,
    flow,
    reconciliationStatus,
    notes,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.accountId == this.accountId &&
          other.direction == this.direction &&
          other.amountPaise == this.amountPaise &&
          other.occurredAt == this.occurredAt &&
          other.localDate == this.localDate &&
          other.channel == this.channel &&
          other.counterpartyName == this.counterpartyName &&
          other.merchantKey == this.merchantKey &&
          other.vpa == this.vpa &&
          other.counterpartyKind == this.counterpartyKind &&
          other.upiRef == this.upiRef &&
          other.bankRef == this.bankRef &&
          other.cardLast4 == this.cardLast4 &&
          other.descriptionRaw == this.descriptionRaw &&
          other.categoryId == this.categoryId &&
          other.categorizedBy == this.categorizedBy &&
          other.categorizationRuleId == this.categorizationRuleId &&
          other.categorizationConfidence == this.categorizationConfidence &&
          other.flow == this.flow &&
          other.reconciliationStatus == this.reconciliationStatus &&
          other.notes == this.notes &&
          other.deletedAt == this.deletedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String?> accountId;
  final Value<Direction> direction;
  final Value<int> amountPaise;
  final Value<DateTime> occurredAt;
  final Value<LocalDate> localDate;
  final Value<Channel> channel;
  final Value<String?> counterpartyName;
  final Value<String?> merchantKey;
  final Value<String?> vpa;
  final Value<CounterpartyKind> counterpartyKind;
  final Value<String?> upiRef;
  final Value<String?> bankRef;
  final Value<String?> cardLast4;
  final Value<String?> descriptionRaw;
  final Value<String?> categoryId;
  final Value<CategorizationMethod?> categorizedBy;
  final Value<String?> categorizationRuleId;
  final Value<double?> categorizationConfidence;
  final Value<TransactionFlow> flow;
  final Value<ReconciliationStatus> reconciliationStatus;
  final Value<String?> notes;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.accountId = const Value.absent(),
    this.direction = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.channel = const Value.absent(),
    this.counterpartyName = const Value.absent(),
    this.merchantKey = const Value.absent(),
    this.vpa = const Value.absent(),
    this.counterpartyKind = const Value.absent(),
    this.upiRef = const Value.absent(),
    this.bankRef = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    this.descriptionRaw = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categorizedBy = const Value.absent(),
    this.categorizationRuleId = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    this.flow = const Value.absent(),
    this.reconciliationStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    this.accountId = const Value.absent(),
    required Direction direction,
    required int amountPaise,
    required DateTime occurredAt,
    required LocalDate localDate,
    required Channel channel,
    this.counterpartyName = const Value.absent(),
    this.merchantKey = const Value.absent(),
    this.vpa = const Value.absent(),
    this.counterpartyKind = const Value.absent(),
    this.upiRef = const Value.absent(),
    this.bankRef = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    this.descriptionRaw = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categorizedBy = const Value.absent(),
    this.categorizationRuleId = const Value.absent(),
    this.categorizationConfidence = const Value.absent(),
    required TransactionFlow flow,
    required ReconciliationStatus reconciliationStatus,
    this.notes = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       direction = Value(direction),
       amountPaise = Value(amountPaise),
       occurredAt = Value(occurredAt),
       localDate = Value(localDate),
       channel = Value(channel),
       flow = Value(flow),
       reconciliationStatus = Value(reconciliationStatus);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? accountId,
    Expression<String>? direction,
    Expression<int>? amountPaise,
    Expression<DateTime>? occurredAt,
    Expression<String>? localDate,
    Expression<String>? channel,
    Expression<String>? counterpartyName,
    Expression<String>? merchantKey,
    Expression<String>? vpa,
    Expression<String>? counterpartyKind,
    Expression<String>? upiRef,
    Expression<String>? bankRef,
    Expression<String>? cardLast4,
    Expression<String>? descriptionRaw,
    Expression<String>? categoryId,
    Expression<String>? categorizedBy,
    Expression<String>? categorizationRuleId,
    Expression<double>? categorizationConfidence,
    Expression<String>? flow,
    Expression<String>? reconciliationStatus,
    Expression<String>? notes,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (accountId != null) 'account_id': accountId,
      if (direction != null) 'direction': direction,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (localDate != null) 'local_date': localDate,
      if (channel != null) 'channel': channel,
      if (counterpartyName != null) 'counterparty_name': counterpartyName,
      if (merchantKey != null) 'merchant_key': merchantKey,
      if (vpa != null) 'vpa': vpa,
      if (counterpartyKind != null) 'counterparty_kind': counterpartyKind,
      if (upiRef != null) 'upi_ref': upiRef,
      if (bankRef != null) 'bank_ref': bankRef,
      if (cardLast4 != null) 'card_last4': cardLast4,
      if (descriptionRaw != null) 'description_raw': descriptionRaw,
      if (categoryId != null) 'category_id': categoryId,
      if (categorizedBy != null) 'categorized_by': categorizedBy,
      if (categorizationRuleId != null)
        'categorization_rule_id': categorizationRuleId,
      if (categorizationConfidence != null)
        'categorization_confidence': categorizationConfidence,
      if (flow != null) 'flow': flow,
      if (reconciliationStatus != null)
        'reconciliation_status': reconciliationStatus,
      if (notes != null) 'notes': notes,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String?>? accountId,
    Value<Direction>? direction,
    Value<int>? amountPaise,
    Value<DateTime>? occurredAt,
    Value<LocalDate>? localDate,
    Value<Channel>? channel,
    Value<String?>? counterpartyName,
    Value<String?>? merchantKey,
    Value<String?>? vpa,
    Value<CounterpartyKind>? counterpartyKind,
    Value<String?>? upiRef,
    Value<String?>? bankRef,
    Value<String?>? cardLast4,
    Value<String?>? descriptionRaw,
    Value<String?>? categoryId,
    Value<CategorizationMethod?>? categorizedBy,
    Value<String?>? categorizationRuleId,
    Value<double?>? categorizationConfidence,
    Value<TransactionFlow>? flow,
    Value<ReconciliationStatus>? reconciliationStatus,
    Value<String?>? notes,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      accountId: accountId ?? this.accountId,
      direction: direction ?? this.direction,
      amountPaise: amountPaise ?? this.amountPaise,
      occurredAt: occurredAt ?? this.occurredAt,
      localDate: localDate ?? this.localDate,
      channel: channel ?? this.channel,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      merchantKey: merchantKey ?? this.merchantKey,
      vpa: vpa ?? this.vpa,
      counterpartyKind: counterpartyKind ?? this.counterpartyKind,
      upiRef: upiRef ?? this.upiRef,
      bankRef: bankRef ?? this.bankRef,
      cardLast4: cardLast4 ?? this.cardLast4,
      descriptionRaw: descriptionRaw ?? this.descriptionRaw,
      categoryId: categoryId ?? this.categoryId,
      categorizedBy: categorizedBy ?? this.categorizedBy,
      categorizationRuleId: categorizationRuleId ?? this.categorizationRuleId,
      categorizationConfidence:
          categorizationConfidence ?? this.categorizationConfidence,
      flow: flow ?? this.flow,
      reconciliationStatus: reconciliationStatus ?? this.reconciliationStatus,
      notes: notes ?? this.notes,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(
        $TransactionsTable.$converterdirection.toSql(direction.value),
      );
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(
        $TransactionsTable.$converterlocalDate.toSql(localDate.value),
      );
    }
    if (channel.present) {
      map['channel'] = Variable<String>(
        $TransactionsTable.$converterchannel.toSql(channel.value),
      );
    }
    if (counterpartyName.present) {
      map['counterparty_name'] = Variable<String>(counterpartyName.value);
    }
    if (merchantKey.present) {
      map['merchant_key'] = Variable<String>(merchantKey.value);
    }
    if (vpa.present) {
      map['vpa'] = Variable<String>(vpa.value);
    }
    if (counterpartyKind.present) {
      map['counterparty_kind'] = Variable<String>(
        $TransactionsTable.$convertercounterpartyKind.toSql(
          counterpartyKind.value,
        ),
      );
    }
    if (upiRef.present) {
      map['upi_ref'] = Variable<String>(upiRef.value);
    }
    if (bankRef.present) {
      map['bank_ref'] = Variable<String>(bankRef.value);
    }
    if (cardLast4.present) {
      map['card_last4'] = Variable<String>(cardLast4.value);
    }
    if (descriptionRaw.present) {
      map['description_raw'] = Variable<String>(descriptionRaw.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categorizedBy.present) {
      map['categorized_by'] = Variable<String>(
        $TransactionsTable.$convertercategorizedByn.toSql(categorizedBy.value),
      );
    }
    if (categorizationRuleId.present) {
      map['categorization_rule_id'] = Variable<String>(
        categorizationRuleId.value,
      );
    }
    if (categorizationConfidence.present) {
      map['categorization_confidence'] = Variable<double>(
        categorizationConfidence.value,
      );
    }
    if (flow.present) {
      map['flow'] = Variable<String>(
        $TransactionsTable.$converterflow.toSql(flow.value),
      );
    }
    if (reconciliationStatus.present) {
      map['reconciliation_status'] = Variable<String>(
        $TransactionsTable.$converterreconciliationStatus.toSql(
          reconciliationStatus.value,
        ),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('accountId: $accountId, ')
          ..write('direction: $direction, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('localDate: $localDate, ')
          ..write('channel: $channel, ')
          ..write('counterpartyName: $counterpartyName, ')
          ..write('merchantKey: $merchantKey, ')
          ..write('vpa: $vpa, ')
          ..write('counterpartyKind: $counterpartyKind, ')
          ..write('upiRef: $upiRef, ')
          ..write('bankRef: $bankRef, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('descriptionRaw: $descriptionRaw, ')
          ..write('categoryId: $categoryId, ')
          ..write('categorizedBy: $categorizedBy, ')
          ..write('categorizationRuleId: $categorizationRuleId, ')
          ..write('categorizationConfidence: $categorizationConfidence, ')
          ..write('flow: $flow, ')
          ..write('reconciliationStatus: $reconciliationStatus, ')
          ..write('notes: $notes, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionSourcesTable extends TransactionSources
    with TableInfo<$TransactionSourcesTable, TransactionSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES source_records (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SourceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SourceKind>($TransactionSourcesTable.$converterkind);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    sourceRecordId,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceRecordIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {transactionId, kind},
  ];
  @override
  TransactionSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      )!,
      kind: $TransactionSourcesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
    );
  }

  @override
  $TransactionSourcesTable createAlias(String alias) {
    return $TransactionSourcesTable(attachedDatabase, alias);
  }

  static TypeConverter<SourceKind, String> $converterkind =
      const WireEnumConverter(SourceKind.values);
}

class TransactionSource extends DataClass
    implements Insertable<TransactionSource> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String transactionId;

  /// A record belongs to at most one transaction.
  final String sourceRecordId;
  final SourceKind kind;
  const TransactionSource({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.transactionId,
    required this.sourceRecordId,
    required this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['transaction_id'] = Variable<String>(transactionId);
    map['source_record_id'] = Variable<String>(sourceRecordId);
    {
      map['kind'] = Variable<String>(
        $TransactionSourcesTable.$converterkind.toSql(kind),
      );
    }
    return map;
  }

  TransactionSourcesCompanion toCompanion(bool nullToAbsent) {
    return TransactionSourcesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      transactionId: Value(transactionId),
      sourceRecordId: Value(sourceRecordId),
      kind: Value(kind),
    );
  }

  factory TransactionSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSource(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      sourceRecordId: serializer.fromJson<String>(json['sourceRecordId']),
      kind: serializer.fromJson<SourceKind>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'transactionId': serializer.toJson<String>(transactionId),
      'sourceRecordId': serializer.toJson<String>(sourceRecordId),
      'kind': serializer.toJson<SourceKind>(kind),
    };
  }

  TransactionSource copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? transactionId,
    String? sourceRecordId,
    SourceKind? kind,
  }) => TransactionSource(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    transactionId: transactionId ?? this.transactionId,
    sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    kind: kind ?? this.kind,
  );
  TransactionSource copyWithCompanion(TransactionSourcesCompanion data) {
    return TransactionSource(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSource(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    sourceRecordId,
    kind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSource &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.transactionId == this.transactionId &&
          other.sourceRecordId == this.sourceRecordId &&
          other.kind == this.kind);
}

class TransactionSourcesCompanion extends UpdateCompanion<TransactionSource> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> transactionId;
  final Value<String> sourceRecordId;
  final Value<SourceKind> kind;
  final Value<int> rowid;
  const TransactionSourcesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionSourcesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String transactionId,
    required String sourceRecordId,
    required SourceKind kind,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       transactionId = Value(transactionId),
       sourceRecordId = Value(sourceRecordId),
       kind = Value(kind);
  static Insertable<TransactionSource> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? transactionId,
    Expression<String>? sourceRecordId,
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (transactionId != null) 'transaction_id': transactionId,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionSourcesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? transactionId,
    Value<String>? sourceRecordId,
    Value<SourceKind>? kind,
    Value<int>? rowid,
  }) {
    return TransactionSourcesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      transactionId: transactionId ?? this.transactionId,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TransactionSourcesTable.$converterkind.toSql(kind.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSourcesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceRecordId: $sourceRecordId, ')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReconciliationReviewsTable extends ReconciliationReviews
    with TableInfo<$ReconciliationReviewsTable, ReconciliationReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReconciliationReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  candidateRecordIds =
      GeneratedColumn<String>(
        'candidate_record_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Object?>>(
        $ReconciliationReviewsTable.$convertercandidateRecordIds,
      );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String> reasons =
      GeneratedColumn<String>(
        'reasons',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<Object?>>(
        $ReconciliationReviewsTable.$converterreasons,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ReviewStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReviewStatus>(
        $ReconciliationReviewsTable.$converterstatus,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    candidateRecordIds,
    score,
    reasons,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reconciliation_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReconciliationReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReconciliationReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReconciliationReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      candidateRecordIds: $ReconciliationReviewsTable
          .$convertercandidateRecordIds
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}candidate_record_ids'],
            )!,
          ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      reasons: $ReconciliationReviewsTable.$converterreasons.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reasons'],
        )!,
      ),
      status: $ReconciliationReviewsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $ReconciliationReviewsTable createAlias(String alias) {
    return $ReconciliationReviewsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Object?>, String> $convertercandidateRecordIds =
      const JsonListConverter();
  static TypeConverter<List<Object?>, String> $converterreasons =
      const JsonListConverter();
  static TypeConverter<ReviewStatus, String> $converterstatus =
      const WireEnumConverter(ReviewStatus.values);
}

class ReconciliationReview extends DataClass
    implements Insertable<ReconciliationReview> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String transactionId;
  final List<Object?> candidateRecordIds;
  final double score;
  final List<Object?> reasons;
  final ReviewStatus status;
  const ReconciliationReview({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.transactionId,
    required this.candidateRecordIds,
    required this.score,
    required this.reasons,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['transaction_id'] = Variable<String>(transactionId);
    {
      map['candidate_record_ids'] = Variable<String>(
        $ReconciliationReviewsTable.$convertercandidateRecordIds.toSql(
          candidateRecordIds,
        ),
      );
    }
    map['score'] = Variable<double>(score);
    {
      map['reasons'] = Variable<String>(
        $ReconciliationReviewsTable.$converterreasons.toSql(reasons),
      );
    }
    {
      map['status'] = Variable<String>(
        $ReconciliationReviewsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  ReconciliationReviewsCompanion toCompanion(bool nullToAbsent) {
    return ReconciliationReviewsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      transactionId: Value(transactionId),
      candidateRecordIds: Value(candidateRecordIds),
      score: Value(score),
      reasons: Value(reasons),
      status: Value(status),
    );
  }

  factory ReconciliationReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReconciliationReview(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      candidateRecordIds: serializer.fromJson<List<Object?>>(
        json['candidateRecordIds'],
      ),
      score: serializer.fromJson<double>(json['score']),
      reasons: serializer.fromJson<List<Object?>>(json['reasons']),
      status: serializer.fromJson<ReviewStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'transactionId': serializer.toJson<String>(transactionId),
      'candidateRecordIds': serializer.toJson<List<Object?>>(
        candidateRecordIds,
      ),
      'score': serializer.toJson<double>(score),
      'reasons': serializer.toJson<List<Object?>>(reasons),
      'status': serializer.toJson<ReviewStatus>(status),
    };
  }

  ReconciliationReview copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? transactionId,
    List<Object?>? candidateRecordIds,
    double? score,
    List<Object?>? reasons,
    ReviewStatus? status,
  }) => ReconciliationReview(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    transactionId: transactionId ?? this.transactionId,
    candidateRecordIds: candidateRecordIds ?? this.candidateRecordIds,
    score: score ?? this.score,
    reasons: reasons ?? this.reasons,
    status: status ?? this.status,
  );
  ReconciliationReview copyWithCompanion(ReconciliationReviewsCompanion data) {
    return ReconciliationReview(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      candidateRecordIds: data.candidateRecordIds.present
          ? data.candidateRecordIds.value
          : this.candidateRecordIds,
      score: data.score.present ? data.score.value : this.score,
      reasons: data.reasons.present ? data.reasons.value : this.reasons,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReconciliationReview(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('candidateRecordIds: $candidateRecordIds, ')
          ..write('score: $score, ')
          ..write('reasons: $reasons, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    candidateRecordIds,
    score,
    reasons,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReconciliationReview &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.transactionId == this.transactionId &&
          other.candidateRecordIds == this.candidateRecordIds &&
          other.score == this.score &&
          other.reasons == this.reasons &&
          other.status == this.status);
}

class ReconciliationReviewsCompanion
    extends UpdateCompanion<ReconciliationReview> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> transactionId;
  final Value<List<Object?>> candidateRecordIds;
  final Value<double> score;
  final Value<List<Object?>> reasons;
  final Value<ReviewStatus> status;
  final Value<int> rowid;
  const ReconciliationReviewsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.candidateRecordIds = const Value.absent(),
    this.score = const Value.absent(),
    this.reasons = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReconciliationReviewsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String transactionId,
    required List<Object?> candidateRecordIds,
    required double score,
    this.reasons = const Value.absent(),
    required ReviewStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       transactionId = Value(transactionId),
       candidateRecordIds = Value(candidateRecordIds),
       score = Value(score),
       status = Value(status);
  static Insertable<ReconciliationReview> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? transactionId,
    Expression<String>? candidateRecordIds,
    Expression<double>? score,
    Expression<String>? reasons,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (transactionId != null) 'transaction_id': transactionId,
      if (candidateRecordIds != null)
        'candidate_record_ids': candidateRecordIds,
      if (score != null) 'score': score,
      if (reasons != null) 'reasons': reasons,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReconciliationReviewsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? transactionId,
    Value<List<Object?>>? candidateRecordIds,
    Value<double>? score,
    Value<List<Object?>>? reasons,
    Value<ReviewStatus>? status,
    Value<int>? rowid,
  }) {
    return ReconciliationReviewsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      transactionId: transactionId ?? this.transactionId,
      candidateRecordIds: candidateRecordIds ?? this.candidateRecordIds,
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (candidateRecordIds.present) {
      map['candidate_record_ids'] = Variable<String>(
        $ReconciliationReviewsTable.$convertercandidateRecordIds.toSql(
          candidateRecordIds.value,
        ),
      );
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (reasons.present) {
      map['reasons'] = Variable<String>(
        $ReconciliationReviewsTable.$converterreasons.toSql(reasons.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ReconciliationReviewsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReconciliationReviewsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('candidateRecordIds: $candidateRecordIds, ')
          ..write('score: $score, ')
          ..write('reasons: $reasons, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrainingLabelsTable extends TrainingLabels
    with TableInfo<$TrainingLabelsTable, TrainingLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _previousCategoryIdMeta =
      const VerificationMeta('previousCategoryId');
  @override
  late final GeneratedColumn<String> previousCategoryId =
      GeneratedColumn<String>(
        'previous_category_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id)',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<LabelOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LabelOrigin>($TrainingLabelsTable.$converterorigin);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  features =
      GeneratedColumn<String>(
        'features',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Map<String, Object?>>(
        $TrainingLabelsTable.$converterfeatures,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    categoryId,
    previousCategoryId,
    origin,
    features,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingLabel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('previous_category_id')) {
      context.handle(
        _previousCategoryIdMeta,
        previousCategoryId.isAcceptableOrUnknown(
          data['previous_category_id']!,
          _previousCategoryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingLabel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      previousCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_category_id'],
      ),
      origin: $TrainingLabelsTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
      features: $TrainingLabelsTable.$converterfeatures.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}features'],
        )!,
      ),
    );
  }

  @override
  $TrainingLabelsTable createAlias(String alias) {
    return $TrainingLabelsTable(attachedDatabase, alias);
  }

  static TypeConverter<LabelOrigin, String> $converterorigin =
      const WireEnumConverter(LabelOrigin.values);
  static TypeConverter<Map<String, Object?>, String> $converterfeatures =
      const JsonMapConverter();
}

class TrainingLabel extends DataClass implements Insertable<TrainingLabel> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String transactionId;
  final String categoryId;
  final String? previousCategoryId;
  final LabelOrigin origin;

  /// The model features at labeling time, so retraining is reproducible.
  final Map<String, Object?> features;
  const TrainingLabel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.transactionId,
    required this.categoryId,
    this.previousCategoryId,
    required this.origin,
    required this.features,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['transaction_id'] = Variable<String>(transactionId);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || previousCategoryId != null) {
      map['previous_category_id'] = Variable<String>(previousCategoryId);
    }
    {
      map['origin'] = Variable<String>(
        $TrainingLabelsTable.$converterorigin.toSql(origin),
      );
    }
    {
      map['features'] = Variable<String>(
        $TrainingLabelsTable.$converterfeatures.toSql(features),
      );
    }
    return map;
  }

  TrainingLabelsCompanion toCompanion(bool nullToAbsent) {
    return TrainingLabelsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      transactionId: Value(transactionId),
      categoryId: Value(categoryId),
      previousCategoryId: previousCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousCategoryId),
      origin: Value(origin),
      features: Value(features),
    );
  }

  factory TrainingLabel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingLabel(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      previousCategoryId: serializer.fromJson<String?>(
        json['previousCategoryId'],
      ),
      origin: serializer.fromJson<LabelOrigin>(json['origin']),
      features: serializer.fromJson<Map<String, Object?>>(json['features']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'transactionId': serializer.toJson<String>(transactionId),
      'categoryId': serializer.toJson<String>(categoryId),
      'previousCategoryId': serializer.toJson<String?>(previousCategoryId),
      'origin': serializer.toJson<LabelOrigin>(origin),
      'features': serializer.toJson<Map<String, Object?>>(features),
    };
  }

  TrainingLabel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? transactionId,
    String? categoryId,
    Value<String?> previousCategoryId = const Value.absent(),
    LabelOrigin? origin,
    Map<String, Object?>? features,
  }) => TrainingLabel(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    transactionId: transactionId ?? this.transactionId,
    categoryId: categoryId ?? this.categoryId,
    previousCategoryId: previousCategoryId.present
        ? previousCategoryId.value
        : this.previousCategoryId,
    origin: origin ?? this.origin,
    features: features ?? this.features,
  );
  TrainingLabel copyWithCompanion(TrainingLabelsCompanion data) {
    return TrainingLabel(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      previousCategoryId: data.previousCategoryId.present
          ? data.previousCategoryId.value
          : this.previousCategoryId,
      origin: data.origin.present ? data.origin.value : this.origin,
      features: data.features.present ? data.features.value : this.features,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingLabel(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('categoryId: $categoryId, ')
          ..write('previousCategoryId: $previousCategoryId, ')
          ..write('origin: $origin, ')
          ..write('features: $features')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    transactionId,
    categoryId,
    previousCategoryId,
    origin,
    features,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingLabel &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.transactionId == this.transactionId &&
          other.categoryId == this.categoryId &&
          other.previousCategoryId == this.previousCategoryId &&
          other.origin == this.origin &&
          other.features == this.features);
}

class TrainingLabelsCompanion extends UpdateCompanion<TrainingLabel> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> transactionId;
  final Value<String> categoryId;
  final Value<String?> previousCategoryId;
  final Value<LabelOrigin> origin;
  final Value<Map<String, Object?>> features;
  final Value<int> rowid;
  const TrainingLabelsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.previousCategoryId = const Value.absent(),
    this.origin = const Value.absent(),
    this.features = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingLabelsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String transactionId,
    required String categoryId,
    this.previousCategoryId = const Value.absent(),
    required LabelOrigin origin,
    required Map<String, Object?> features,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       transactionId = Value(transactionId),
       categoryId = Value(categoryId),
       origin = Value(origin),
       features = Value(features);
  static Insertable<TrainingLabel> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? transactionId,
    Expression<String>? categoryId,
    Expression<String>? previousCategoryId,
    Expression<String>? origin,
    Expression<String>? features,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (transactionId != null) 'transaction_id': transactionId,
      if (categoryId != null) 'category_id': categoryId,
      if (previousCategoryId != null)
        'previous_category_id': previousCategoryId,
      if (origin != null) 'origin': origin,
      if (features != null) 'features': features,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingLabelsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? transactionId,
    Value<String>? categoryId,
    Value<String?>? previousCategoryId,
    Value<LabelOrigin>? origin,
    Value<Map<String, Object?>>? features,
    Value<int>? rowid,
  }) {
    return TrainingLabelsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      transactionId: transactionId ?? this.transactionId,
      categoryId: categoryId ?? this.categoryId,
      previousCategoryId: previousCategoryId ?? this.previousCategoryId,
      origin: origin ?? this.origin,
      features: features ?? this.features,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (previousCategoryId.present) {
      map['previous_category_id'] = Variable<String>(previousCategoryId.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $TrainingLabelsTable.$converterorigin.toSql(origin.value),
      );
    }
    if (features.present) {
      map['features'] = Variable<String>(
        $TrainingLabelsTable.$converterfeatures.toSql(features.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingLabelsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('transactionId: $transactionId, ')
          ..write('categoryId: $categoryId, ')
          ..write('previousCategoryId: $previousCategoryId, ')
          ..write('origin: $origin, ')
          ..write('features: $features, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _limitPaiseMeta = const VerificationMeta(
    'limitPaise',
  );
  @override
  late final GeneratedColumn<int> limitPaise = GeneratedColumn<int>(
    'limit_paise',
    aliasedName,
    false,
    check: () => ComparableExpr(limitPaise).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  warnAtPercent = GeneratedColumn<String>(
    'warn_at_percent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[80,100]'),
  ).withConverter<List<Object?>>($BudgetsTable.$converterwarnAtPercent);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> effectiveFrom =
      GeneratedColumn<String>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($BudgetsTable.$convertereffectiveFrom);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    categoryId,
    limitPaise,
    warnAtPercent,
    effectiveFrom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_paise')) {
      context.handle(
        _limitPaiseMeta,
        limitPaise.isAcceptableOrUnknown(data['limit_paise']!, _limitPaiseMeta),
      );
    } else if (isInserting) {
      context.missing(_limitPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      limitPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_paise'],
      )!,
      warnAtPercent: $BudgetsTable.$converterwarnAtPercent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}warn_at_percent'],
        )!,
      ),
      effectiveFrom: $BudgetsTable.$convertereffectiveFrom.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effective_from'],
        )!,
      ),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Object?>, String> $converterwarnAtPercent =
      const JsonListConverter();
  static TypeConverter<LocalDate, String> $convertereffectiveFrom =
      const LocalDateConverter();
}

class Budget extends DataClass implements Insertable<Budget> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String categoryId;
  final int limitPaise;
  final List<Object?> warnAtPercent;
  final LocalDate effectiveFrom;
  const Budget({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.categoryId,
    required this.limitPaise,
    required this.warnAtPercent,
    required this.effectiveFrom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['category_id'] = Variable<String>(categoryId);
    map['limit_paise'] = Variable<int>(limitPaise);
    {
      map['warn_at_percent'] = Variable<String>(
        $BudgetsTable.$converterwarnAtPercent.toSql(warnAtPercent),
      );
    }
    {
      map['effective_from'] = Variable<String>(
        $BudgetsTable.$convertereffectiveFrom.toSql(effectiveFrom),
      );
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      categoryId: Value(categoryId),
      limitPaise: Value(limitPaise),
      warnAtPercent: Value(warnAtPercent),
      effectiveFrom: Value(effectiveFrom),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      limitPaise: serializer.fromJson<int>(json['limitPaise']),
      warnAtPercent: serializer.fromJson<List<Object?>>(json['warnAtPercent']),
      effectiveFrom: serializer.fromJson<LocalDate>(json['effectiveFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'categoryId': serializer.toJson<String>(categoryId),
      'limitPaise': serializer.toJson<int>(limitPaise),
      'warnAtPercent': serializer.toJson<List<Object?>>(warnAtPercent),
      'effectiveFrom': serializer.toJson<LocalDate>(effectiveFrom),
    };
  }

  Budget copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? categoryId,
    int? limitPaise,
    List<Object?>? warnAtPercent,
    LocalDate? effectiveFrom,
  }) => Budget(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    categoryId: categoryId ?? this.categoryId,
    limitPaise: limitPaise ?? this.limitPaise,
    warnAtPercent: warnAtPercent ?? this.warnAtPercent,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      limitPaise: data.limitPaise.present
          ? data.limitPaise.value
          : this.limitPaise,
      warnAtPercent: data.warnAtPercent.present
          ? data.warnAtPercent.value
          : this.warnAtPercent,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitPaise: $limitPaise, ')
          ..write('warnAtPercent: $warnAtPercent, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    categoryId,
    limitPaise,
    warnAtPercent,
    effectiveFrom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.categoryId == this.categoryId &&
          other.limitPaise == this.limitPaise &&
          other.warnAtPercent == this.warnAtPercent &&
          other.effectiveFrom == this.effectiveFrom);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> categoryId;
  final Value<int> limitPaise;
  final Value<List<Object?>> warnAtPercent;
  final Value<LocalDate> effectiveFrom;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitPaise = const Value.absent(),
    this.warnAtPercent = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String categoryId,
    required int limitPaise,
    this.warnAtPercent = const Value.absent(),
    required LocalDate effectiveFrom,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       categoryId = Value(categoryId),
       limitPaise = Value(limitPaise),
       effectiveFrom = Value(effectiveFrom);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? categoryId,
    Expression<int>? limitPaise,
    Expression<String>? warnAtPercent,
    Expression<String>? effectiveFrom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (categoryId != null) 'category_id': categoryId,
      if (limitPaise != null) 'limit_paise': limitPaise,
      if (warnAtPercent != null) 'warn_at_percent': warnAtPercent,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? categoryId,
    Value<int>? limitPaise,
    Value<List<Object?>>? warnAtPercent,
    Value<LocalDate>? effectiveFrom,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      categoryId: categoryId ?? this.categoryId,
      limitPaise: limitPaise ?? this.limitPaise,
      warnAtPercent: warnAtPercent ?? this.warnAtPercent,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (limitPaise.present) {
      map['limit_paise'] = Variable<int>(limitPaise.value);
    }
    if (warnAtPercent.present) {
      map['warn_at_percent'] = Variable<String>(
        $BudgetsTable.$converterwarnAtPercent.toSql(warnAtPercent.value),
      );
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<String>(
        $BudgetsTable.$convertereffectiveFrom.toSql(effectiveFrom.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitPaise: $limitPaise, ')
          ..write('warnAtPercent: $warnAtPercent, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPaiseMeta = const VerificationMeta(
    'targetPaise',
  );
  @override
  late final GeneratedColumn<int> targetPaise = GeneratedColumn<int>(
    'target_paise',
    aliasedName,
    false,
    check: () => ComparableExpr(targetPaise).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedPaiseMeta = const VerificationMeta(
    'savedPaise',
  );
  @override
  late final GeneratedColumn<int> savedPaise = GeneratedColumn<int>(
    'saved_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> deadline =
      GeneratedColumn<String>(
        'deadline',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($GoalsTable.$converterdeadline);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  fundingRule = GeneratedColumn<String>(
    'funding_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, Object?>?>($GoalsTable.$converterfundingRulen);
  @override
  late final GeneratedColumnWithTypeConverter<GoalStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GoalStatus>($GoalsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    name,
    targetPaise,
    savedPaise,
    deadline,
    fundingRule,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_paise')) {
      context.handle(
        _targetPaiseMeta,
        targetPaise.isAcceptableOrUnknown(
          data['target_paise']!,
          _targetPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPaiseMeta);
    }
    if (data.containsKey('saved_paise')) {
      context.handle(
        _savedPaiseMeta,
        savedPaise.isAcceptableOrUnknown(data['saved_paise']!, _savedPaiseMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_paise'],
      )!,
      savedPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_paise'],
      )!,
      deadline: $GoalsTable.$converterdeadline.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}deadline'],
        )!,
      ),
      fundingRule: $GoalsTable.$converterfundingRulen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}funding_rule'],
        ),
      ),
      status: $GoalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converterdeadline =
      const LocalDateConverter();
  static TypeConverter<Map<String, Object?>, String> $converterfundingRule =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?> $converterfundingRulen =
      NullAwareTypeConverter.wrap($converterfundingRule);
  static TypeConverter<GoalStatus, String> $converterstatus =
      const WireEnumConverter(GoalStatus.values);
}

class Goal extends DataClass implements Insertable<Goal> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String name;
  final int targetPaise;
  final int savedPaise;
  final LocalDate deadline;

  /// How money reaches this goal, e.g. a fixed monthly amount.
  final Map<String, Object?>? fundingRule;
  final GoalStatus status;
  const Goal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.name,
    required this.targetPaise,
    required this.savedPaise,
    required this.deadline,
    this.fundingRule,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['name'] = Variable<String>(name);
    map['target_paise'] = Variable<int>(targetPaise);
    map['saved_paise'] = Variable<int>(savedPaise);
    {
      map['deadline'] = Variable<String>(
        $GoalsTable.$converterdeadline.toSql(deadline),
      );
    }
    if (!nullToAbsent || fundingRule != null) {
      map['funding_rule'] = Variable<String>(
        $GoalsTable.$converterfundingRulen.toSql(fundingRule),
      );
    }
    {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      name: Value(name),
      targetPaise: Value(targetPaise),
      savedPaise: Value(savedPaise),
      deadline: Value(deadline),
      fundingRule: fundingRule == null && nullToAbsent
          ? const Value.absent()
          : Value(fundingRule),
      status: Value(status),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      name: serializer.fromJson<String>(json['name']),
      targetPaise: serializer.fromJson<int>(json['targetPaise']),
      savedPaise: serializer.fromJson<int>(json['savedPaise']),
      deadline: serializer.fromJson<LocalDate>(json['deadline']),
      fundingRule: serializer.fromJson<Map<String, Object?>?>(
        json['fundingRule'],
      ),
      status: serializer.fromJson<GoalStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'name': serializer.toJson<String>(name),
      'targetPaise': serializer.toJson<int>(targetPaise),
      'savedPaise': serializer.toJson<int>(savedPaise),
      'deadline': serializer.toJson<LocalDate>(deadline),
      'fundingRule': serializer.toJson<Map<String, Object?>?>(fundingRule),
      'status': serializer.toJson<GoalStatus>(status),
    };
  }

  Goal copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? name,
    int? targetPaise,
    int? savedPaise,
    LocalDate? deadline,
    Value<Map<String, Object?>?> fundingRule = const Value.absent(),
    GoalStatus? status,
  }) => Goal(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    name: name ?? this.name,
    targetPaise: targetPaise ?? this.targetPaise,
    savedPaise: savedPaise ?? this.savedPaise,
    deadline: deadline ?? this.deadline,
    fundingRule: fundingRule.present ? fundingRule.value : this.fundingRule,
    status: status ?? this.status,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      name: data.name.present ? data.name.value : this.name,
      targetPaise: data.targetPaise.present
          ? data.targetPaise.value
          : this.targetPaise,
      savedPaise: data.savedPaise.present
          ? data.savedPaise.value
          : this.savedPaise,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      fundingRule: data.fundingRule.present
          ? data.fundingRule.value
          : this.fundingRule,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('savedPaise: $savedPaise, ')
          ..write('deadline: $deadline, ')
          ..write('fundingRule: $fundingRule, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    name,
    targetPaise,
    savedPaise,
    deadline,
    fundingRule,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.name == this.name &&
          other.targetPaise == this.targetPaise &&
          other.savedPaise == this.savedPaise &&
          other.deadline == this.deadline &&
          other.fundingRule == this.fundingRule &&
          other.status == this.status);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> name;
  final Value<int> targetPaise;
  final Value<int> savedPaise;
  final Value<LocalDate> deadline;
  final Value<Map<String, Object?>?> fundingRule;
  final Value<GoalStatus> status;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.targetPaise = const Value.absent(),
    this.savedPaise = const Value.absent(),
    this.deadline = const Value.absent(),
    this.fundingRule = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String name,
    required int targetPaise,
    this.savedPaise = const Value.absent(),
    required LocalDate deadline,
    this.fundingRule = const Value.absent(),
    required GoalStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       targetPaise = Value(targetPaise),
       deadline = Value(deadline),
       status = Value(status);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? name,
    Expression<int>? targetPaise,
    Expression<int>? savedPaise,
    Expression<String>? deadline,
    Expression<String>? fundingRule,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (targetPaise != null) 'target_paise': targetPaise,
      if (savedPaise != null) 'saved_paise': savedPaise,
      if (deadline != null) 'deadline': deadline,
      if (fundingRule != null) 'funding_rule': fundingRule,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? name,
    Value<int>? targetPaise,
    Value<int>? savedPaise,
    Value<LocalDate>? deadline,
    Value<Map<String, Object?>?>? fundingRule,
    Value<GoalStatus>? status,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      name: name ?? this.name,
      targetPaise: targetPaise ?? this.targetPaise,
      savedPaise: savedPaise ?? this.savedPaise,
      deadline: deadline ?? this.deadline,
      fundingRule: fundingRule ?? this.fundingRule,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetPaise.present) {
      map['target_paise'] = Variable<int>(targetPaise.value);
    }
    if (savedPaise.present) {
      map['saved_paise'] = Variable<int>(savedPaise.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(
        $GoalsTable.$converterdeadline.toSql(deadline.value),
      );
    }
    if (fundingRule.present) {
      map['funding_rule'] = Variable<String>(
        $GoalsTable.$converterfundingRulen.toSql(fundingRule.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $GoalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('targetPaise: $targetPaise, ')
          ..write('savedPaise: $savedPaise, ')
          ..write('deadline: $deadline, ')
          ..write('fundingRule: $fundingRule, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringSeriesTable extends RecurringSeries
    with TableInfo<$RecurringSeriesTable, RecurringSery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringSeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _merchantKeyMeta = const VerificationMeta(
    'merchantKey',
  );
  @override
  late final GeneratedColumn<String> merchantKey = GeneratedColumn<String>(
    'merchant_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Cadence, String> cadence =
      GeneratedColumn<String>(
        'cadence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Cadence>($RecurringSeriesTable.$convertercadence);
  static const VerificationMeta _typicalAmountPaiseMeta =
      const VerificationMeta('typicalAmountPaise');
  @override
  late final GeneratedColumn<int> typicalAmountPaise = GeneratedColumn<int>(
    'typical_amount_paise',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String>
  nextExpectedDate =
      GeneratedColumn<String>(
        'next_expected_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>(
        $RecurringSeriesTable.$converternextExpectedDaten,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  transactionIds =
      GeneratedColumn<String>(
        'transaction_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Object?>>(
        $RecurringSeriesTable.$convertertransactionIds,
      );
  @override
  late final GeneratedColumnWithTypeConverter<SeriesUserState, String>
  userState = GeneratedColumn<String>(
    'user_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SeriesUserState>($RecurringSeriesTable.$converteruserState);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    merchantKey,
    cadence,
    typicalAmountPaise,
    nextExpectedDate,
    transactionIds,
    userState,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringSery> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('merchant_key')) {
      context.handle(
        _merchantKeyMeta,
        merchantKey.isAcceptableOrUnknown(
          data['merchant_key']!,
          _merchantKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_merchantKeyMeta);
    }
    if (data.containsKey('typical_amount_paise')) {
      context.handle(
        _typicalAmountPaiseMeta,
        typicalAmountPaise.isAcceptableOrUnknown(
          data['typical_amount_paise']!,
          _typicalAmountPaiseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typicalAmountPaiseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringSery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringSery(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      merchantKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_key'],
      )!,
      cadence: $RecurringSeriesTable.$convertercadence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cadence'],
        )!,
      ),
      typicalAmountPaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typical_amount_paise'],
      )!,
      nextExpectedDate: $RecurringSeriesTable.$converternextExpectedDaten
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}next_expected_date'],
            ),
          ),
      transactionIds: $RecurringSeriesTable.$convertertransactionIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}transaction_ids'],
        )!,
      ),
      userState: $RecurringSeriesTable.$converteruserState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}user_state'],
        )!,
      ),
    );
  }

  @override
  $RecurringSeriesTable createAlias(String alias) {
    return $RecurringSeriesTable(attachedDatabase, alias);
  }

  static TypeConverter<Cadence, String> $convertercadence =
      const WireEnumConverter(Cadence.values);
  static TypeConverter<LocalDate, String> $converternextExpectedDate =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converternextExpectedDaten =
      NullAwareTypeConverter.wrap($converternextExpectedDate);
  static TypeConverter<List<Object?>, String> $convertertransactionIds =
      const JsonListConverter();
  static TypeConverter<SeriesUserState, String> $converteruserState =
      const WireEnumConverter(SeriesUserState.values);
}

class RecurringSery extends DataClass implements Insertable<RecurringSery> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String merchantKey;
  final Cadence cadence;
  final int typicalAmountPaise;
  final LocalDate? nextExpectedDate;
  final List<Object?> transactionIds;
  final SeriesUserState userState;
  const RecurringSery({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.merchantKey,
    required this.cadence,
    required this.typicalAmountPaise,
    this.nextExpectedDate,
    required this.transactionIds,
    required this.userState,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['merchant_key'] = Variable<String>(merchantKey);
    {
      map['cadence'] = Variable<String>(
        $RecurringSeriesTable.$convertercadence.toSql(cadence),
      );
    }
    map['typical_amount_paise'] = Variable<int>(typicalAmountPaise);
    if (!nullToAbsent || nextExpectedDate != null) {
      map['next_expected_date'] = Variable<String>(
        $RecurringSeriesTable.$converternextExpectedDaten.toSql(
          nextExpectedDate,
        ),
      );
    }
    {
      map['transaction_ids'] = Variable<String>(
        $RecurringSeriesTable.$convertertransactionIds.toSql(transactionIds),
      );
    }
    {
      map['user_state'] = Variable<String>(
        $RecurringSeriesTable.$converteruserState.toSql(userState),
      );
    }
    return map;
  }

  RecurringSeriesCompanion toCompanion(bool nullToAbsent) {
    return RecurringSeriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      merchantKey: Value(merchantKey),
      cadence: Value(cadence),
      typicalAmountPaise: Value(typicalAmountPaise),
      nextExpectedDate: nextExpectedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextExpectedDate),
      transactionIds: Value(transactionIds),
      userState: Value(userState),
    );
  }

  factory RecurringSery.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringSery(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      merchantKey: serializer.fromJson<String>(json['merchantKey']),
      cadence: serializer.fromJson<Cadence>(json['cadence']),
      typicalAmountPaise: serializer.fromJson<int>(json['typicalAmountPaise']),
      nextExpectedDate: serializer.fromJson<LocalDate?>(
        json['nextExpectedDate'],
      ),
      transactionIds: serializer.fromJson<List<Object?>>(
        json['transactionIds'],
      ),
      userState: serializer.fromJson<SeriesUserState>(json['userState']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'merchantKey': serializer.toJson<String>(merchantKey),
      'cadence': serializer.toJson<Cadence>(cadence),
      'typicalAmountPaise': serializer.toJson<int>(typicalAmountPaise),
      'nextExpectedDate': serializer.toJson<LocalDate?>(nextExpectedDate),
      'transactionIds': serializer.toJson<List<Object?>>(transactionIds),
      'userState': serializer.toJson<SeriesUserState>(userState),
    };
  }

  RecurringSery copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? merchantKey,
    Cadence? cadence,
    int? typicalAmountPaise,
    Value<LocalDate?> nextExpectedDate = const Value.absent(),
    List<Object?>? transactionIds,
    SeriesUserState? userState,
  }) => RecurringSery(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    merchantKey: merchantKey ?? this.merchantKey,
    cadence: cadence ?? this.cadence,
    typicalAmountPaise: typicalAmountPaise ?? this.typicalAmountPaise,
    nextExpectedDate: nextExpectedDate.present
        ? nextExpectedDate.value
        : this.nextExpectedDate,
    transactionIds: transactionIds ?? this.transactionIds,
    userState: userState ?? this.userState,
  );
  RecurringSery copyWithCompanion(RecurringSeriesCompanion data) {
    return RecurringSery(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      merchantKey: data.merchantKey.present
          ? data.merchantKey.value
          : this.merchantKey,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      typicalAmountPaise: data.typicalAmountPaise.present
          ? data.typicalAmountPaise.value
          : this.typicalAmountPaise,
      nextExpectedDate: data.nextExpectedDate.present
          ? data.nextExpectedDate.value
          : this.nextExpectedDate,
      transactionIds: data.transactionIds.present
          ? data.transactionIds.value
          : this.transactionIds,
      userState: data.userState.present ? data.userState.value : this.userState,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringSery(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('merchantKey: $merchantKey, ')
          ..write('cadence: $cadence, ')
          ..write('typicalAmountPaise: $typicalAmountPaise, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('transactionIds: $transactionIds, ')
          ..write('userState: $userState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    merchantKey,
    cadence,
    typicalAmountPaise,
    nextExpectedDate,
    transactionIds,
    userState,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringSery &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.merchantKey == this.merchantKey &&
          other.cadence == this.cadence &&
          other.typicalAmountPaise == this.typicalAmountPaise &&
          other.nextExpectedDate == this.nextExpectedDate &&
          other.transactionIds == this.transactionIds &&
          other.userState == this.userState);
}

class RecurringSeriesCompanion extends UpdateCompanion<RecurringSery> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> merchantKey;
  final Value<Cadence> cadence;
  final Value<int> typicalAmountPaise;
  final Value<LocalDate?> nextExpectedDate;
  final Value<List<Object?>> transactionIds;
  final Value<SeriesUserState> userState;
  final Value<int> rowid;
  const RecurringSeriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.merchantKey = const Value.absent(),
    this.cadence = const Value.absent(),
    this.typicalAmountPaise = const Value.absent(),
    this.nextExpectedDate = const Value.absent(),
    this.transactionIds = const Value.absent(),
    this.userState = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringSeriesCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String merchantKey,
    required Cadence cadence,
    required int typicalAmountPaise,
    this.nextExpectedDate = const Value.absent(),
    required List<Object?> transactionIds,
    required SeriesUserState userState,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       merchantKey = Value(merchantKey),
       cadence = Value(cadence),
       typicalAmountPaise = Value(typicalAmountPaise),
       transactionIds = Value(transactionIds),
       userState = Value(userState);
  static Insertable<RecurringSery> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? merchantKey,
    Expression<String>? cadence,
    Expression<int>? typicalAmountPaise,
    Expression<String>? nextExpectedDate,
    Expression<String>? transactionIds,
    Expression<String>? userState,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (merchantKey != null) 'merchant_key': merchantKey,
      if (cadence != null) 'cadence': cadence,
      if (typicalAmountPaise != null)
        'typical_amount_paise': typicalAmountPaise,
      if (nextExpectedDate != null) 'next_expected_date': nextExpectedDate,
      if (transactionIds != null) 'transaction_ids': transactionIds,
      if (userState != null) 'user_state': userState,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringSeriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? merchantKey,
    Value<Cadence>? cadence,
    Value<int>? typicalAmountPaise,
    Value<LocalDate?>? nextExpectedDate,
    Value<List<Object?>>? transactionIds,
    Value<SeriesUserState>? userState,
    Value<int>? rowid,
  }) {
    return RecurringSeriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      merchantKey: merchantKey ?? this.merchantKey,
      cadence: cadence ?? this.cadence,
      typicalAmountPaise: typicalAmountPaise ?? this.typicalAmountPaise,
      nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
      transactionIds: transactionIds ?? this.transactionIds,
      userState: userState ?? this.userState,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (merchantKey.present) {
      map['merchant_key'] = Variable<String>(merchantKey.value);
    }
    if (cadence.present) {
      map['cadence'] = Variable<String>(
        $RecurringSeriesTable.$convertercadence.toSql(cadence.value),
      );
    }
    if (typicalAmountPaise.present) {
      map['typical_amount_paise'] = Variable<int>(typicalAmountPaise.value);
    }
    if (nextExpectedDate.present) {
      map['next_expected_date'] = Variable<String>(
        $RecurringSeriesTable.$converternextExpectedDaten.toSql(
          nextExpectedDate.value,
        ),
      );
    }
    if (transactionIds.present) {
      map['transaction_ids'] = Variable<String>(
        $RecurringSeriesTable.$convertertransactionIds.toSql(
          transactionIds.value,
        ),
      );
    }
    if (userState.present) {
      map['user_state'] = Variable<String>(
        $RecurringSeriesTable.$converteruserState.toSql(userState.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringSeriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('merchantKey: $merchantKey, ')
          ..write('cadence: $cadence, ')
          ..write('typicalAmountPaise: $typicalAmountPaise, ')
          ..write('nextExpectedDate: $nextExpectedDate, ')
          ..write('transactionIds: $transactionIds, ')
          ..write('userState: $userState, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InsightsTable extends Insights with TableInfo<$InsightsTable, Insight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InsightType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InsightType>($InsightsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  facts = GeneratedColumn<String>(
    'facts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($InsightsTable.$converterfacts);
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  guidelineIds = GeneratedColumn<String>(
    'guideline_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Object?>>($InsightsTable.$converterguidelineIds);
  static const VerificationMeta _aiNarrativeMeta = const VerificationMeta(
    'aiNarrative',
  );
  @override
  late final GeneratedColumn<String> aiNarrative = GeneratedColumn<String>(
    'ai_narrative',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiProviderMeta = const VerificationMeta(
    'aiProvider',
  );
  @override
  late final GeneratedColumn<String> aiProvider = GeneratedColumn<String>(
    'ai_provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InsightStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InsightStatus>($InsightsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    type,
    facts,
    guidelineIds,
    aiNarrative,
    aiProvider,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'insights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Insight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('ai_narrative')) {
      context.handle(
        _aiNarrativeMeta,
        aiNarrative.isAcceptableOrUnknown(
          data['ai_narrative']!,
          _aiNarrativeMeta,
        ),
      );
    }
    if (data.containsKey('ai_provider')) {
      context.handle(
        _aiProviderMeta,
        aiProvider.isAcceptableOrUnknown(data['ai_provider']!, _aiProviderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      type: $InsightsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      facts: $InsightsTable.$converterfacts.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}facts'],
        )!,
      ),
      guidelineIds: $InsightsTable.$converterguidelineIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}guideline_ids'],
        )!,
      ),
      aiNarrative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_narrative'],
      ),
      aiProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_provider'],
      ),
      status: $InsightsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $InsightsTable createAlias(String alias) {
    return $InsightsTable(attachedDatabase, alias);
  }

  static TypeConverter<InsightType, String> $convertertype =
      const WireEnumConverter(InsightType.values);
  static TypeConverter<Map<String, Object?>, String> $converterfacts =
      const JsonMapConverter();
  static TypeConverter<List<Object?>, String> $converterguidelineIds =
      const JsonListConverter();
  static TypeConverter<InsightStatus, String> $converterstatus =
      const WireEnumConverter(InsightStatus.values);
}

class Insight extends DataClass implements Insertable<Insight> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final InsightType type;
  final Map<String, Object?> facts;
  final List<Object?> guidelineIds;
  final String? aiNarrative;
  final String? aiProvider;
  final InsightStatus status;
  const Insight({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.type,
    required this.facts,
    required this.guidelineIds,
    this.aiNarrative,
    this.aiProvider,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['type'] = Variable<String>($InsightsTable.$convertertype.toSql(type));
    }
    {
      map['facts'] = Variable<String>(
        $InsightsTable.$converterfacts.toSql(facts),
      );
    }
    {
      map['guideline_ids'] = Variable<String>(
        $InsightsTable.$converterguidelineIds.toSql(guidelineIds),
      );
    }
    if (!nullToAbsent || aiNarrative != null) {
      map['ai_narrative'] = Variable<String>(aiNarrative);
    }
    if (!nullToAbsent || aiProvider != null) {
      map['ai_provider'] = Variable<String>(aiProvider);
    }
    {
      map['status'] = Variable<String>(
        $InsightsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  InsightsCompanion toCompanion(bool nullToAbsent) {
    return InsightsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      type: Value(type),
      facts: Value(facts),
      guidelineIds: Value(guidelineIds),
      aiNarrative: aiNarrative == null && nullToAbsent
          ? const Value.absent()
          : Value(aiNarrative),
      aiProvider: aiProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(aiProvider),
      status: Value(status),
    );
  }

  factory Insight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insight(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      type: serializer.fromJson<InsightType>(json['type']),
      facts: serializer.fromJson<Map<String, Object?>>(json['facts']),
      guidelineIds: serializer.fromJson<List<Object?>>(json['guidelineIds']),
      aiNarrative: serializer.fromJson<String?>(json['aiNarrative']),
      aiProvider: serializer.fromJson<String?>(json['aiProvider']),
      status: serializer.fromJson<InsightStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'type': serializer.toJson<InsightType>(type),
      'facts': serializer.toJson<Map<String, Object?>>(facts),
      'guidelineIds': serializer.toJson<List<Object?>>(guidelineIds),
      'aiNarrative': serializer.toJson<String?>(aiNarrative),
      'aiProvider': serializer.toJson<String?>(aiProvider),
      'status': serializer.toJson<InsightStatus>(status),
    };
  }

  Insight copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    InsightType? type,
    Map<String, Object?>? facts,
    List<Object?>? guidelineIds,
    Value<String?> aiNarrative = const Value.absent(),
    Value<String?> aiProvider = const Value.absent(),
    InsightStatus? status,
  }) => Insight(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    type: type ?? this.type,
    facts: facts ?? this.facts,
    guidelineIds: guidelineIds ?? this.guidelineIds,
    aiNarrative: aiNarrative.present ? aiNarrative.value : this.aiNarrative,
    aiProvider: aiProvider.present ? aiProvider.value : this.aiProvider,
    status: status ?? this.status,
  );
  Insight copyWithCompanion(InsightsCompanion data) {
    return Insight(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      type: data.type.present ? data.type.value : this.type,
      facts: data.facts.present ? data.facts.value : this.facts,
      guidelineIds: data.guidelineIds.present
          ? data.guidelineIds.value
          : this.guidelineIds,
      aiNarrative: data.aiNarrative.present
          ? data.aiNarrative.value
          : this.aiNarrative,
      aiProvider: data.aiProvider.present
          ? data.aiProvider.value
          : this.aiProvider,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Insight(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('type: $type, ')
          ..write('facts: $facts, ')
          ..write('guidelineIds: $guidelineIds, ')
          ..write('aiNarrative: $aiNarrative, ')
          ..write('aiProvider: $aiProvider, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    type,
    facts,
    guidelineIds,
    aiNarrative,
    aiProvider,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insight &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.type == this.type &&
          other.facts == this.facts &&
          other.guidelineIds == this.guidelineIds &&
          other.aiNarrative == this.aiNarrative &&
          other.aiProvider == this.aiProvider &&
          other.status == this.status);
}

class InsightsCompanion extends UpdateCompanion<Insight> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<InsightType> type;
  final Value<Map<String, Object?>> facts;
  final Value<List<Object?>> guidelineIds;
  final Value<String?> aiNarrative;
  final Value<String?> aiProvider;
  final Value<InsightStatus> status;
  final Value<int> rowid;
  const InsightsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.type = const Value.absent(),
    this.facts = const Value.absent(),
    this.guidelineIds = const Value.absent(),
    this.aiNarrative = const Value.absent(),
    this.aiProvider = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InsightsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required InsightType type,
    required Map<String, Object?> facts,
    this.guidelineIds = const Value.absent(),
    this.aiNarrative = const Value.absent(),
    this.aiProvider = const Value.absent(),
    required InsightStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       type = Value(type),
       facts = Value(facts),
       status = Value(status);
  static Insertable<Insight> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? type,
    Expression<String>? facts,
    Expression<String>? guidelineIds,
    Expression<String>? aiNarrative,
    Expression<String>? aiProvider,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (type != null) 'type': type,
      if (facts != null) 'facts': facts,
      if (guidelineIds != null) 'guideline_ids': guidelineIds,
      if (aiNarrative != null) 'ai_narrative': aiNarrative,
      if (aiProvider != null) 'ai_provider': aiProvider,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InsightsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<InsightType>? type,
    Value<Map<String, Object?>>? facts,
    Value<List<Object?>>? guidelineIds,
    Value<String?>? aiNarrative,
    Value<String?>? aiProvider,
    Value<InsightStatus>? status,
    Value<int>? rowid,
  }) {
    return InsightsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      type: type ?? this.type,
      facts: facts ?? this.facts,
      guidelineIds: guidelineIds ?? this.guidelineIds,
      aiNarrative: aiNarrative ?? this.aiNarrative,
      aiProvider: aiProvider ?? this.aiProvider,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $InsightsTable.$convertertype.toSql(type.value),
      );
    }
    if (facts.present) {
      map['facts'] = Variable<String>(
        $InsightsTable.$converterfacts.toSql(facts.value),
      );
    }
    if (guidelineIds.present) {
      map['guideline_ids'] = Variable<String>(
        $InsightsTable.$converterguidelineIds.toSql(guidelineIds.value),
      );
    }
    if (aiNarrative.present) {
      map['ai_narrative'] = Variable<String>(aiNarrative.value);
    }
    if (aiProvider.present) {
      map['ai_provider'] = Variable<String>(aiProvider.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InsightsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsightsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('type: $type, ')
          ..write('facts: $facts, ')
          ..write('guidelineIds: $guidelineIds, ')
          ..write('aiNarrative: $aiNarrative, ')
          ..write('aiProvider: $aiProvider, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProposalsTable extends Proposals
    with TableInfo<$ProposalsTable, Proposal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProposalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($ProposalsTable.$convertertarget);
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String> patch =
      GeneratedColumn<String>(
        'patch',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Object?>>($ProposalsTable.$converterpatch);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  before = GeneratedColumn<String>(
    'before',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($ProposalsTable.$converterbefore);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  after = GeneratedColumn<String>(
    'after',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($ProposalsTable.$converterafter);
  static const VerificationMeta _rationaleMeta = const VerificationMeta(
    'rationale',
  );
  @override
  late final GeneratedColumn<String> rationale = GeneratedColumn<String>(
    'rationale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proposerMeta = const VerificationMeta(
    'proposer',
  );
  @override
  late final GeneratedColumn<String> proposer = GeneratedColumn<String>(
    'proposer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  baseVersions = GeneratedColumn<String>(
    'base_versions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($ProposalsTable.$converterbaseVersions);
  @override
  late final GeneratedColumnWithTypeConverter<ProposalStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProposalStatus>($ProposalsTable.$converterstatus);
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decidedAtMeta = const VerificationMeta(
    'decidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> decidedAt = GeneratedColumn<DateTime>(
    'decided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    target,
    patch,
    before,
    after,
    rationale,
    proposer,
    baseVersions,
    status,
    expiresAt,
    decidedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proposals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proposal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('rationale')) {
      context.handle(
        _rationaleMeta,
        rationale.isAcceptableOrUnknown(data['rationale']!, _rationaleMeta),
      );
    } else if (isInserting) {
      context.missing(_rationaleMeta);
    }
    if (data.containsKey('proposer')) {
      context.handle(
        _proposerMeta,
        proposer.isAcceptableOrUnknown(data['proposer']!, _proposerMeta),
      );
    } else if (isInserting) {
      context.missing(_proposerMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('decided_at')) {
      context.handle(
        _decidedAtMeta,
        decidedAt.isAcceptableOrUnknown(data['decided_at']!, _decidedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Proposal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proposal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      target: $ProposalsTable.$convertertarget.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target'],
        )!,
      ),
      patch: $ProposalsTable.$converterpatch.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}patch'],
        )!,
      ),
      before: $ProposalsTable.$converterbefore.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}before'],
        )!,
      ),
      after: $ProposalsTable.$converterafter.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}after'],
        )!,
      ),
      rationale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rationale'],
      )!,
      proposer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposer'],
      )!,
      baseVersions: $ProposalsTable.$converterbaseVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}base_versions'],
        )!,
      ),
      status: $ProposalsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      decidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}decided_at'],
      ),
    );
  }

  @override
  $ProposalsTable createAlias(String alias) {
    return $ProposalsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $convertertarget =
      const JsonMapConverter();
  static TypeConverter<List<Object?>, String> $converterpatch =
      const JsonListConverter();
  static TypeConverter<Map<String, Object?>, String> $converterbefore =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>, String> $converterafter =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>, String> $converterbaseVersions =
      const JsonMapConverter();
  static TypeConverter<ProposalStatus, String> $converterstatus =
      const WireEnumConverter(ProposalStatus.values);
}

class Proposal extends DataClass implements Insertable<Proposal> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;

  /// What the change is for: `{"type": "goal", "id": "..."}`.
  final Map<String, Object?> target;

  /// RFC 6902 JSON Patch operations.
  final List<Object?> patch;
  final Map<String, Object?> before;
  final Map<String, Object?> after;
  final String rationale;

  /// Who proposed it, e.g. `anthropic:claude-...` or `openai:...`.
  final String proposer;

  /// Row id → `version` of every record the AI was shown.
  final Map<String, Object?> baseVersions;
  final ProposalStatus status;
  final DateTime expiresAt;
  final DateTime? decidedAt;
  const Proposal({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.target,
    required this.patch,
    required this.before,
    required this.after,
    required this.rationale,
    required this.proposer,
    required this.baseVersions,
    required this.status,
    required this.expiresAt,
    this.decidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    {
      map['target'] = Variable<String>(
        $ProposalsTable.$convertertarget.toSql(target),
      );
    }
    {
      map['patch'] = Variable<String>(
        $ProposalsTable.$converterpatch.toSql(patch),
      );
    }
    {
      map['before'] = Variable<String>(
        $ProposalsTable.$converterbefore.toSql(before),
      );
    }
    {
      map['after'] = Variable<String>(
        $ProposalsTable.$converterafter.toSql(after),
      );
    }
    map['rationale'] = Variable<String>(rationale);
    map['proposer'] = Variable<String>(proposer);
    {
      map['base_versions'] = Variable<String>(
        $ProposalsTable.$converterbaseVersions.toSql(baseVersions),
      );
    }
    {
      map['status'] = Variable<String>(
        $ProposalsTable.$converterstatus.toSql(status),
      );
    }
    map['expires_at'] = Variable<DateTime>(expiresAt);
    if (!nullToAbsent || decidedAt != null) {
      map['decided_at'] = Variable<DateTime>(decidedAt);
    }
    return map;
  }

  ProposalsCompanion toCompanion(bool nullToAbsent) {
    return ProposalsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      target: Value(target),
      patch: Value(patch),
      before: Value(before),
      after: Value(after),
      rationale: Value(rationale),
      proposer: Value(proposer),
      baseVersions: Value(baseVersions),
      status: Value(status),
      expiresAt: Value(expiresAt),
      decidedAt: decidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedAt),
    );
  }

  factory Proposal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proposal(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      target: serializer.fromJson<Map<String, Object?>>(json['target']),
      patch: serializer.fromJson<List<Object?>>(json['patch']),
      before: serializer.fromJson<Map<String, Object?>>(json['before']),
      after: serializer.fromJson<Map<String, Object?>>(json['after']),
      rationale: serializer.fromJson<String>(json['rationale']),
      proposer: serializer.fromJson<String>(json['proposer']),
      baseVersions: serializer.fromJson<Map<String, Object?>>(
        json['baseVersions'],
      ),
      status: serializer.fromJson<ProposalStatus>(json['status']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      decidedAt: serializer.fromJson<DateTime?>(json['decidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'target': serializer.toJson<Map<String, Object?>>(target),
      'patch': serializer.toJson<List<Object?>>(patch),
      'before': serializer.toJson<Map<String, Object?>>(before),
      'after': serializer.toJson<Map<String, Object?>>(after),
      'rationale': serializer.toJson<String>(rationale),
      'proposer': serializer.toJson<String>(proposer),
      'baseVersions': serializer.toJson<Map<String, Object?>>(baseVersions),
      'status': serializer.toJson<ProposalStatus>(status),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'decidedAt': serializer.toJson<DateTime?>(decidedAt),
    };
  }

  Proposal copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    Map<String, Object?>? target,
    List<Object?>? patch,
    Map<String, Object?>? before,
    Map<String, Object?>? after,
    String? rationale,
    String? proposer,
    Map<String, Object?>? baseVersions,
    ProposalStatus? status,
    DateTime? expiresAt,
    Value<DateTime?> decidedAt = const Value.absent(),
  }) => Proposal(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    target: target ?? this.target,
    patch: patch ?? this.patch,
    before: before ?? this.before,
    after: after ?? this.after,
    rationale: rationale ?? this.rationale,
    proposer: proposer ?? this.proposer,
    baseVersions: baseVersions ?? this.baseVersions,
    status: status ?? this.status,
    expiresAt: expiresAt ?? this.expiresAt,
    decidedAt: decidedAt.present ? decidedAt.value : this.decidedAt,
  );
  Proposal copyWithCompanion(ProposalsCompanion data) {
    return Proposal(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      target: data.target.present ? data.target.value : this.target,
      patch: data.patch.present ? data.patch.value : this.patch,
      before: data.before.present ? data.before.value : this.before,
      after: data.after.present ? data.after.value : this.after,
      rationale: data.rationale.present ? data.rationale.value : this.rationale,
      proposer: data.proposer.present ? data.proposer.value : this.proposer,
      baseVersions: data.baseVersions.present
          ? data.baseVersions.value
          : this.baseVersions,
      status: data.status.present ? data.status.value : this.status,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      decidedAt: data.decidedAt.present ? data.decidedAt.value : this.decidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proposal(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('target: $target, ')
          ..write('patch: $patch, ')
          ..write('before: $before, ')
          ..write('after: $after, ')
          ..write('rationale: $rationale, ')
          ..write('proposer: $proposer, ')
          ..write('baseVersions: $baseVersions, ')
          ..write('status: $status, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    target,
    patch,
    before,
    after,
    rationale,
    proposer,
    baseVersions,
    status,
    expiresAt,
    decidedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proposal &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.target == this.target &&
          other.patch == this.patch &&
          other.before == this.before &&
          other.after == this.after &&
          other.rationale == this.rationale &&
          other.proposer == this.proposer &&
          other.baseVersions == this.baseVersions &&
          other.status == this.status &&
          other.expiresAt == this.expiresAt &&
          other.decidedAt == this.decidedAt);
}

class ProposalsCompanion extends UpdateCompanion<Proposal> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<Map<String, Object?>> target;
  final Value<List<Object?>> patch;
  final Value<Map<String, Object?>> before;
  final Value<Map<String, Object?>> after;
  final Value<String> rationale;
  final Value<String> proposer;
  final Value<Map<String, Object?>> baseVersions;
  final Value<ProposalStatus> status;
  final Value<DateTime> expiresAt;
  final Value<DateTime?> decidedAt;
  final Value<int> rowid;
  const ProposalsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.target = const Value.absent(),
    this.patch = const Value.absent(),
    this.before = const Value.absent(),
    this.after = const Value.absent(),
    this.rationale = const Value.absent(),
    this.proposer = const Value.absent(),
    this.baseVersions = const Value.absent(),
    this.status = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProposalsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required Map<String, Object?> target,
    required List<Object?> patch,
    required Map<String, Object?> before,
    required Map<String, Object?> after,
    required String rationale,
    required String proposer,
    required Map<String, Object?> baseVersions,
    required ProposalStatus status,
    required DateTime expiresAt,
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       target = Value(target),
       patch = Value(patch),
       before = Value(before),
       after = Value(after),
       rationale = Value(rationale),
       proposer = Value(proposer),
       baseVersions = Value(baseVersions),
       status = Value(status),
       expiresAt = Value(expiresAt);
  static Insertable<Proposal> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? target,
    Expression<String>? patch,
    Expression<String>? before,
    Expression<String>? after,
    Expression<String>? rationale,
    Expression<String>? proposer,
    Expression<String>? baseVersions,
    Expression<String>? status,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? decidedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (target != null) 'target': target,
      if (patch != null) 'patch': patch,
      if (before != null) 'before': before,
      if (after != null) 'after': after,
      if (rationale != null) 'rationale': rationale,
      if (proposer != null) 'proposer': proposer,
      if (baseVersions != null) 'base_versions': baseVersions,
      if (status != null) 'status': status,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (decidedAt != null) 'decided_at': decidedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProposalsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<Map<String, Object?>>? target,
    Value<List<Object?>>? patch,
    Value<Map<String, Object?>>? before,
    Value<Map<String, Object?>>? after,
    Value<String>? rationale,
    Value<String>? proposer,
    Value<Map<String, Object?>>? baseVersions,
    Value<ProposalStatus>? status,
    Value<DateTime>? expiresAt,
    Value<DateTime?>? decidedAt,
    Value<int>? rowid,
  }) {
    return ProposalsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      target: target ?? this.target,
      patch: patch ?? this.patch,
      before: before ?? this.before,
      after: after ?? this.after,
      rationale: rationale ?? this.rationale,
      proposer: proposer ?? this.proposer,
      baseVersions: baseVersions ?? this.baseVersions,
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      decidedAt: decidedAt ?? this.decidedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(
        $ProposalsTable.$convertertarget.toSql(target.value),
      );
    }
    if (patch.present) {
      map['patch'] = Variable<String>(
        $ProposalsTable.$converterpatch.toSql(patch.value),
      );
    }
    if (before.present) {
      map['before'] = Variable<String>(
        $ProposalsTable.$converterbefore.toSql(before.value),
      );
    }
    if (after.present) {
      map['after'] = Variable<String>(
        $ProposalsTable.$converterafter.toSql(after.value),
      );
    }
    if (rationale.present) {
      map['rationale'] = Variable<String>(rationale.value);
    }
    if (proposer.present) {
      map['proposer'] = Variable<String>(proposer.value);
    }
    if (baseVersions.present) {
      map['base_versions'] = Variable<String>(
        $ProposalsTable.$converterbaseVersions.toSql(baseVersions.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProposalsTable.$converterstatus.toSql(status.value),
      );
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (decidedAt.present) {
      map['decided_at'] = Variable<DateTime>(decidedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProposalsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('target: $target, ')
          ..write('patch: $patch, ')
          ..write('before: $before, ')
          ..write('after: $after, ')
          ..write('rationale: $rationale, ')
          ..write('proposer: $proposer, ')
          ..write('baseVersions: $baseVersions, ')
          ..write('status: $status, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('decidedAt: $decidedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanExtensionsTable extends PlanExtensions
    with TableInfo<$PlanExtensionsTable, PlanExtension> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanExtensionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($PlanExtensionsTable.$converterdata);
  @override
  late final GeneratedColumnWithTypeConverter<ExtensionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExtensionStatus>($PlanExtensionsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    schemaVersion,
    data,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_extensions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanExtension> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExtension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExtension(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      data: $PlanExtensionsTable.$converterdata.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}data'],
        )!,
      ),
      status: $PlanExtensionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $PlanExtensionsTable createAlias(String alias) {
    return $PlanExtensionsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, Object?>, String> $converterdata =
      const JsonMapConverter();
  static TypeConverter<ExtensionStatus, String> $converterstatus =
      const WireEnumConverter(ExtensionStatus.values);
}

class PlanExtension extends DataClass implements Insertable<PlanExtension> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String kind;
  final int schemaVersion;
  final Map<String, Object?> data;
  final ExtensionStatus status;
  const PlanExtension({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.kind,
    required this.schemaVersion,
    required this.data,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['kind'] = Variable<String>(kind);
    map['schema_version'] = Variable<int>(schemaVersion);
    {
      map['data'] = Variable<String>(
        $PlanExtensionsTable.$converterdata.toSql(data),
      );
    }
    {
      map['status'] = Variable<String>(
        $PlanExtensionsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  PlanExtensionsCompanion toCompanion(bool nullToAbsent) {
    return PlanExtensionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      kind: Value(kind),
      schemaVersion: Value(schemaVersion),
      data: Value(data),
      status: Value(status),
    );
  }

  factory PlanExtension.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExtension(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      kind: serializer.fromJson<String>(json['kind']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      data: serializer.fromJson<Map<String, Object?>>(json['data']),
      status: serializer.fromJson<ExtensionStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'kind': serializer.toJson<String>(kind),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'data': serializer.toJson<Map<String, Object?>>(data),
      'status': serializer.toJson<ExtensionStatus>(status),
    };
  }

  PlanExtension copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? kind,
    int? schemaVersion,
    Map<String, Object?>? data,
    ExtensionStatus? status,
  }) => PlanExtension(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    kind: kind ?? this.kind,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    data: data ?? this.data,
    status: status ?? this.status,
  );
  PlanExtension copyWithCompanion(PlanExtensionsCompanion data) {
    return PlanExtension(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      kind: data.kind.present ? data.kind.value : this.kind,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      data: data.data.present ? data.data.value : this.data,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanExtension(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('data: $data, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    kind,
    schemaVersion,
    data,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExtension &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.kind == this.kind &&
          other.schemaVersion == this.schemaVersion &&
          other.data == this.data &&
          other.status == this.status);
}

class PlanExtensionsCompanion extends UpdateCompanion<PlanExtension> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> kind;
  final Value<int> schemaVersion;
  final Value<Map<String, Object?>> data;
  final Value<ExtensionStatus> status;
  final Value<int> rowid;
  const PlanExtensionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.kind = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.data = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanExtensionsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String kind,
    required int schemaVersion,
    required Map<String, Object?> data,
    required ExtensionStatus status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       kind = Value(kind),
       schemaVersion = Value(schemaVersion),
       data = Value(data),
       status = Value(status);
  static Insertable<PlanExtension> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? kind,
    Expression<int>? schemaVersion,
    Expression<String>? data,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (kind != null) 'kind': kind,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (data != null) 'data': data,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanExtensionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? kind,
    Value<int>? schemaVersion,
    Value<Map<String, Object?>>? data,
    Value<ExtensionStatus>? status,
    Value<int>? rowid,
  }) {
    return PlanExtensionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      kind: kind ?? this.kind,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      data: data ?? this.data,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(
        $PlanExtensionsTable.$converterdata.toSql(data.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PlanExtensionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExtensionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('kind: $kind, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('data: $data, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AuditEvent, String> event =
      GeneratedColumn<String>(
        'event',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AuditEvent>($AuditLogTable.$converterevent);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proposalIdMeta = const VerificationMeta(
    'proposalId',
  );
  @override
  late final GeneratedColumn<String> proposalId = GeneratedColumn<String>(
    'proposal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  diff = GeneratedColumn<String>(
    'diff',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, Object?>?>($AuditLogTable.$converterdiffn);
  static const VerificationMeta _prevHashMeta = const VerificationMeta(
    'prevHash',
  );
  @override
  late final GeneratedColumn<String> prevHash = GeneratedColumn<String>(
    'prev_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    sequence,
    event,
    actor,
    proposalId,
    diff,
    prevHash,
    hash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('proposal_id')) {
      context.handle(
        _proposalIdMeta,
        proposalId.isAcceptableOrUnknown(data['proposal_id']!, _proposalIdMeta),
      );
    }
    if (data.containsKey('prev_hash')) {
      context.handle(
        _prevHashMeta,
        prevHash.isAcceptableOrUnknown(data['prev_hash']!, _prevHashMeta),
      );
    } else if (isInserting) {
      context.missing(_prevHashMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      event: $AuditLogTable.$converterevent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}event'],
        )!,
      ),
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      )!,
      proposalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_id'],
      ),
      diff: $AuditLogTable.$converterdiffn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}diff'],
        ),
      ),
      prevHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prev_hash'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }

  static TypeConverter<AuditEvent, String> $converterevent =
      const WireEnumConverter(AuditEvent.values);
  static TypeConverter<Map<String, Object?>, String> $converterdiff =
      const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?> $converterdiffn =
      NullAwareTypeConverter.wrap($converterdiff);
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;

  /// 1, 2, 3, ... in the order entries were written.
  final int sequence;
  final AuditEvent event;
  final String actor;
  final String? proposalId;
  final Map<String, Object?>? diff;

  /// Hash of the previous entry (empty for the first), then of this entry.
  final String prevHash;
  final String hash;
  const AuditLogData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.sequence,
    required this.event,
    required this.actor,
    this.proposalId,
    this.diff,
    required this.prevHash,
    required this.hash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['sequence'] = Variable<int>(sequence);
    {
      map['event'] = Variable<String>(
        $AuditLogTable.$converterevent.toSql(event),
      );
    }
    map['actor'] = Variable<String>(actor);
    if (!nullToAbsent || proposalId != null) {
      map['proposal_id'] = Variable<String>(proposalId);
    }
    if (!nullToAbsent || diff != null) {
      map['diff'] = Variable<String>(
        $AuditLogTable.$converterdiffn.toSql(diff),
      );
    }
    map['prev_hash'] = Variable<String>(prevHash);
    map['hash'] = Variable<String>(hash);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      sequence: Value(sequence),
      event: Value(event),
      actor: Value(actor),
      proposalId: proposalId == null && nullToAbsent
          ? const Value.absent()
          : Value(proposalId),
      diff: diff == null && nullToAbsent ? const Value.absent() : Value(diff),
      prevHash: Value(prevHash),
      hash: Value(hash),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      sequence: serializer.fromJson<int>(json['sequence']),
      event: serializer.fromJson<AuditEvent>(json['event']),
      actor: serializer.fromJson<String>(json['actor']),
      proposalId: serializer.fromJson<String?>(json['proposalId']),
      diff: serializer.fromJson<Map<String, Object?>?>(json['diff']),
      prevHash: serializer.fromJson<String>(json['prevHash']),
      hash: serializer.fromJson<String>(json['hash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'sequence': serializer.toJson<int>(sequence),
      'event': serializer.toJson<AuditEvent>(event),
      'actor': serializer.toJson<String>(actor),
      'proposalId': serializer.toJson<String?>(proposalId),
      'diff': serializer.toJson<Map<String, Object?>?>(diff),
      'prevHash': serializer.toJson<String>(prevHash),
      'hash': serializer.toJson<String>(hash),
    };
  }

  AuditLogData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    int? sequence,
    AuditEvent? event,
    String? actor,
    Value<String?> proposalId = const Value.absent(),
    Value<Map<String, Object?>?> diff = const Value.absent(),
    String? prevHash,
    String? hash,
  }) => AuditLogData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    sequence: sequence ?? this.sequence,
    event: event ?? this.event,
    actor: actor ?? this.actor,
    proposalId: proposalId.present ? proposalId.value : this.proposalId,
    diff: diff.present ? diff.value : this.diff,
    prevHash: prevHash ?? this.prevHash,
    hash: hash ?? this.hash,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      event: data.event.present ? data.event.value : this.event,
      actor: data.actor.present ? data.actor.value : this.actor,
      proposalId: data.proposalId.present
          ? data.proposalId.value
          : this.proposalId,
      diff: data.diff.present ? data.diff.value : this.diff,
      prevHash: data.prevHash.present ? data.prevHash.value : this.prevHash,
      hash: data.hash.present ? data.hash.value : this.hash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('sequence: $sequence, ')
          ..write('event: $event, ')
          ..write('actor: $actor, ')
          ..write('proposalId: $proposalId, ')
          ..write('diff: $diff, ')
          ..write('prevHash: $prevHash, ')
          ..write('hash: $hash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    sequence,
    event,
    actor,
    proposalId,
    diff,
    prevHash,
    hash,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.sequence == this.sequence &&
          other.event == this.event &&
          other.actor == this.actor &&
          other.proposalId == this.proposalId &&
          other.diff == this.diff &&
          other.prevHash == this.prevHash &&
          other.hash == this.hash);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<int> sequence;
  final Value<AuditEvent> event;
  final Value<String> actor;
  final Value<String?> proposalId;
  final Value<Map<String, Object?>?> diff;
  final Value<String> prevHash;
  final Value<String> hash;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.sequence = const Value.absent(),
    this.event = const Value.absent(),
    this.actor = const Value.absent(),
    this.proposalId = const Value.absent(),
    this.diff = const Value.absent(),
    this.prevHash = const Value.absent(),
    this.hash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required int sequence,
    required AuditEvent event,
    required String actor,
    this.proposalId = const Value.absent(),
    this.diff = const Value.absent(),
    required String prevHash,
    required String hash,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sequence = Value(sequence),
       event = Value(event),
       actor = Value(actor),
       prevHash = Value(prevHash),
       hash = Value(hash);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? sequence,
    Expression<String>? event,
    Expression<String>? actor,
    Expression<String>? proposalId,
    Expression<String>? diff,
    Expression<String>? prevHash,
    Expression<String>? hash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (sequence != null) 'sequence': sequence,
      if (event != null) 'event': event,
      if (actor != null) 'actor': actor,
      if (proposalId != null) 'proposal_id': proposalId,
      if (diff != null) 'diff': diff,
      if (prevHash != null) 'prev_hash': prevHash,
      if (hash != null) 'hash': hash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<int>? sequence,
    Value<AuditEvent>? event,
    Value<String>? actor,
    Value<String?>? proposalId,
    Value<Map<String, Object?>?>? diff,
    Value<String>? prevHash,
    Value<String>? hash,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      sequence: sequence ?? this.sequence,
      event: event ?? this.event,
      actor: actor ?? this.actor,
      proposalId: proposalId ?? this.proposalId,
      diff: diff ?? this.diff,
      prevHash: prevHash ?? this.prevHash,
      hash: hash ?? this.hash,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(
        $AuditLogTable.$converterevent.toSql(event.value),
      );
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (proposalId.present) {
      map['proposal_id'] = Variable<String>(proposalId.value);
    }
    if (diff.present) {
      map['diff'] = Variable<String>(
        $AuditLogTable.$converterdiffn.toSql(diff.value),
      );
    }
    if (prevHash.present) {
      map['prev_hash'] = Variable<String>(prevHash.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('sequence: $sequence, ')
          ..write('event: $event, ')
          ..write('actor: $actor, ')
          ..write('proposalId: $proposalId, ')
          ..write('diff: $diff, ')
          ..write('prevHash: $prevHash, ')
          ..write('hash: $hash, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiRequestsTable extends AiRequests
    with TableInfo<$AiRequestsTable, AiRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String>
  fieldsSent = GeneratedColumn<String>(
    'fields_sent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<Object?>>($AiRequestsTable.$converterfieldsSent);
  static const VerificationMeta _tokenCountMeta = const VerificationMeta(
    'tokenCount',
  );
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
    'token_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    version,
    feature,
    provider,
    model,
    fieldsSent,
    tokenCount,
    outcome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('token_count')) {
      context.handle(
        _tokenCountMeta,
        tokenCount.isAcceptableOrUnknown(data['token_count']!, _tokenCountMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      fieldsSent: $AiRequestsTable.$converterfieldsSent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fields_sent'],
        )!,
      ),
      tokenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_count'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
    );
  }

  @override
  $AiRequestsTable createAlias(String alias) {
    return $AiRequestsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Object?>, String> $converterfieldsSent =
      const JsonListConverter();
}

class AiRequest extends DataClass implements Insertable<AiRequest> {
  /// UUID v7, created with `newId()`.
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  final int version;
  final String feature;
  final String provider;
  final String model;

  /// Names of the fields that left the device, e.g. `["insight.facts"]`.
  final List<Object?> fieldsSent;
  final int? tokenCount;
  final String outcome;
  const AiRequest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.feature,
    required this.provider,
    required this.model,
    required this.fieldsSent,
    this.tokenCount,
    required this.outcome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    map['feature'] = Variable<String>(feature);
    map['provider'] = Variable<String>(provider);
    map['model'] = Variable<String>(model);
    {
      map['fields_sent'] = Variable<String>(
        $AiRequestsTable.$converterfieldsSent.toSql(fieldsSent),
      );
    }
    if (!nullToAbsent || tokenCount != null) {
      map['token_count'] = Variable<int>(tokenCount);
    }
    map['outcome'] = Variable<String>(outcome);
    return map;
  }

  AiRequestsCompanion toCompanion(bool nullToAbsent) {
    return AiRequestsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
      feature: Value(feature),
      provider: Value(provider),
      model: Value(model),
      fieldsSent: Value(fieldsSent),
      tokenCount: tokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenCount),
      outcome: Value(outcome),
    );
  }

  factory AiRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiRequest(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
      feature: serializer.fromJson<String>(json['feature']),
      provider: serializer.fromJson<String>(json['provider']),
      model: serializer.fromJson<String>(json['model']),
      fieldsSent: serializer.fromJson<List<Object?>>(json['fieldsSent']),
      tokenCount: serializer.fromJson<int?>(json['tokenCount']),
      outcome: serializer.fromJson<String>(json['outcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
      'feature': serializer.toJson<String>(feature),
      'provider': serializer.toJson<String>(provider),
      'model': serializer.toJson<String>(model),
      'fieldsSent': serializer.toJson<List<Object?>>(fieldsSent),
      'tokenCount': serializer.toJson<int?>(tokenCount),
      'outcome': serializer.toJson<String>(outcome),
    };
  }

  AiRequest copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? feature,
    String? provider,
    String? model,
    List<Object?>? fieldsSent,
    Value<int?> tokenCount = const Value.absent(),
    String? outcome,
  }) => AiRequest(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
    feature: feature ?? this.feature,
    provider: provider ?? this.provider,
    model: model ?? this.model,
    fieldsSent: fieldsSent ?? this.fieldsSent,
    tokenCount: tokenCount.present ? tokenCount.value : this.tokenCount,
    outcome: outcome ?? this.outcome,
  );
  AiRequest copyWithCompanion(AiRequestsCompanion data) {
    return AiRequest(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
      feature: data.feature.present ? data.feature.value : this.feature,
      provider: data.provider.present ? data.provider.value : this.provider,
      model: data.model.present ? data.model.value : this.model,
      fieldsSent: data.fieldsSent.present
          ? data.fieldsSent.value
          : this.fieldsSent,
      tokenCount: data.tokenCount.present
          ? data.tokenCount.value
          : this.tokenCount,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiRequest(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('feature: $feature, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('fieldsSent: $fieldsSent, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    version,
    feature,
    provider,
    model,
    fieldsSent,
    tokenCount,
    outcome,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiRequest &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version &&
          other.feature == this.feature &&
          other.provider == this.provider &&
          other.model == this.model &&
          other.fieldsSent == this.fieldsSent &&
          other.tokenCount == this.tokenCount &&
          other.outcome == this.outcome);
}

class AiRequestsCompanion extends UpdateCompanion<AiRequest> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  final Value<String> feature;
  final Value<String> provider;
  final Value<String> model;
  final Value<List<Object?>> fieldsSent;
  final Value<int?> tokenCount;
  final Value<String> outcome;
  final Value<int> rowid;
  const AiRequestsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.feature = const Value.absent(),
    this.provider = const Value.absent(),
    this.model = const Value.absent(),
    this.fieldsSent = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.outcome = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiRequestsCompanion.insert({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.version = const Value.absent(),
    required String feature,
    required String provider,
    required String model,
    required List<Object?> fieldsSent,
    this.tokenCount = const Value.absent(),
    required String outcome,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       feature = Value(feature),
       provider = Value(provider),
       model = Value(model),
       fieldsSent = Value(fieldsSent),
       outcome = Value(outcome);
  static Insertable<AiRequest> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<String>? feature,
    Expression<String>? provider,
    Expression<String>? model,
    Expression<String>? fieldsSent,
    Expression<int>? tokenCount,
    Expression<String>? outcome,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (feature != null) 'feature': feature,
      if (provider != null) 'provider': provider,
      if (model != null) 'model': model,
      if (fieldsSent != null) 'fields_sent': fieldsSent,
      if (tokenCount != null) 'token_count': tokenCount,
      if (outcome != null) 'outcome': outcome,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiRequestsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? version,
    Value<String>? feature,
    Value<String>? provider,
    Value<String>? model,
    Value<List<Object?>>? fieldsSent,
    Value<int?>? tokenCount,
    Value<String>? outcome,
    Value<int>? rowid,
  }) {
    return AiRequestsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      feature: feature ?? this.feature,
      provider: provider ?? this.provider,
      model: model ?? this.model,
      fieldsSent: fieldsSent ?? this.fieldsSent,
      tokenCount: tokenCount ?? this.tokenCount,
      outcome: outcome ?? this.outcome,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (fieldsSent.present) {
      map['fields_sent'] = Variable<String>(
        $AiRequestsTable.$converterfieldsSent.toSql(fieldsSent.value),
      );
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiRequestsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('feature: $feature, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('fieldsSent: $fieldsSent, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('outcome: $outcome, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FinanceDatabase extends GeneratedDatabase {
  _$FinanceDatabase(QueryExecutor e) : super(e);
  $FinanceDatabaseManager get managers => $FinanceDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $ImportBatchesTable importBatches = $ImportBatchesTable(this);
  late final $SourceRecordsTable sourceRecords = $SourceRecordsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CategoryRulesTable categoryRules = $CategoryRulesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionSourcesTable transactionSources =
      $TransactionSourcesTable(this);
  late final $ReconciliationReviewsTable reconciliationReviews =
      $ReconciliationReviewsTable(this);
  late final $TrainingLabelsTable trainingLabels = $TrainingLabelsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $RecurringSeriesTable recurringSeries = $RecurringSeriesTable(
    this,
  );
  late final $InsightsTable insights = $InsightsTable(this);
  late final $ProposalsTable proposals = $ProposalsTable(this);
  late final $PlanExtensionsTable planExtensions = $PlanExtensionsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $AiRequestsTable aiRequests = $AiRequestsTable(this);
  late final Index transactionsLocalDate = Index(
    'transactions_local_date',
    'CREATE INDEX transactions_local_date ON transactions (local_date)',
  );
  late final Index transactionsCategory = Index(
    'transactions_category',
    'CREATE INDEX transactions_category ON transactions (category_id)',
  );
  late final Index transactionsUpiRef = Index(
    'transactions_upi_ref',
    'CREATE INDEX transactions_upi_ref ON transactions (upi_ref)',
  );
  late final Index transactionsAmountDate = Index(
    'transactions_amount_date',
    'CREATE INDEX transactions_amount_date ON transactions (amount_paise, local_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    accounts,
    importBatches,
    sourceRecords,
    categories,
    categoryRules,
    transactions,
    transactionSources,
    reconciliationReviews,
    trainingLabels,
    budgets,
    goals,
    recurringSeries,
    insights,
    proposals,
    planExtensions,
    auditLog,
    aiRequests,
    transactionsLocalDate,
    transactionsCategory,
    transactionsUpiRef,
    transactionsAmountDate,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<int?> birthYear,
      Value<String?> occupation,
      Value<String?> incomeBracket,
      Value<int?> monthlyNetIncomePaise,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<int?> birthYear,
      Value<String?> occupation,
      Value<String?> incomeBracket,
      Value<int?> monthlyNetIncomePaise,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$FinanceDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyNetIncomePaise => $composableBuilder(
    column: $table.monthlyNetIncomePaise,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyNetIncomePaise => $composableBuilder(
    column: $table.monthlyNetIncomePaise,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get incomeBracket => $composableBuilder(
    column: $table.incomeBracket,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyNetIncomePaise => $composableBuilder(
    column: $table.monthlyNetIncomePaise,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$FinanceDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(
    _$FinanceDatabase db,
    $UserProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> incomeBracket = const Value.absent(),
                Value<int?> monthlyNetIncomePaise = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                birthYear: birthYear,
                occupation: occupation,
                incomeBracket: incomeBracket,
                monthlyNetIncomePaise: monthlyNetIncomePaise,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String?> incomeBracket = const Value.absent(),
                Value<int?> monthlyNetIncomePaise = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                birthYear: birthYear,
                occupation: occupation,
                incomeBracket: incomeBracket,
                monthlyNetIncomePaise: monthlyNetIncomePaise,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$FinanceDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$FinanceDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required AccountKind kind,
  required String institution,
  required String displayName,
  Value<String?> last4,
  Value<List<Object?>> upiHandles,
  Value<List<Object?>> smsSenderIds,
  Value<bool> isArchived,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<AccountKind> kind,
  Value<String> institution,
  Value<String> displayName,
  Value<String?> last4,
  Value<List<Object?>> upiHandles,
  Value<List<Object?>> smsSenderIds,
  Value<bool> isArchived,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$FinanceDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ImportBatchesTable, List<ImportBatche>>
  _importBatchesRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importBatches,
        aliasName: 'accounts__id__import_batches__account_id',
      );

  $$ImportBatchesTableProcessedTableManager get importBatchesRefs {
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_importBatchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$FinanceDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$FinanceDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountKind, AccountKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get upiHandles => $composableBuilder(
    column: $table.upiHandles,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get smsSenderIds => $composableBuilder(
    column: $table.smsSenderIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> importBatchesRefs(
    Expression<bool> Function($$ImportBatchesTableFilterComposer f) f,
  ) {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get last4 => $composableBuilder(
    column: $table.last4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiHandles => $composableBuilder(
    column: $table.upiHandles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsSenderIds => $composableBuilder(
    column: $table.smsSenderIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
    column: $table.institution,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String> get upiHandles =>
      $composableBuilder(
        column: $table.upiHandles,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<Object?>, String> get smsSenderIds =>
      $composableBuilder(
        column: $table.smsSenderIds,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  Expression<T> importBatchesRefs<T extends Object>(
    Expression<T> Function($$ImportBatchesTableAnnotationComposer a) f,
  ) {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool importBatchesRefs,
            bool transactionsRefs,
          })
        > {
  $$AccountsTableTableManager(_$FinanceDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<AccountKind> kind = const Value.absent(),
                Value<String> institution = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> last4 = const Value.absent(),
                Value<List<Object?>> upiHandles = const Value.absent(),
                Value<List<Object?>> smsSenderIds = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                institution: institution,
                displayName: displayName,
                last4: last4,
                upiHandles: upiHandles,
                smsSenderIds: smsSenderIds,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required AccountKind kind,
                required String institution,
                required String displayName,
                Value<String?> last4 = const Value.absent(),
                Value<List<Object?>> upiHandles = const Value.absent(),
                Value<List<Object?>> smsSenderIds = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                institution: institution,
                displayName: displayName,
                last4: last4,
                upiHandles: upiHandles,
                smsSenderIds: smsSenderIds,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({importBatchesRefs = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (importBatchesRefs) db.importBatches,
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (importBatchesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          ImportBatche
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._importBatchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).importBatchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({bool importBatchesRefs, bool transactionsRefs})
    >;
typedef $$ImportBatchesTableCreateCompanionBuilder =
    ImportBatchesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required ImportKind kind,
      required ImportStatus status,
      Value<String?> adapter,
      Value<String?> accountId,
      Value<LocalDate?> periodFrom,
      Value<LocalDate?> periodTo,
      Value<int> parsedCount,
      Value<int> failedCount,
      Value<int> duplicateCount,
      Value<int> matchedCount,
      Value<int> createdCount,
      Value<List<Object?>> errors,
      Value<int> rowid,
    });
typedef $$ImportBatchesTableUpdateCompanionBuilder =
    ImportBatchesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<ImportKind> kind,
      Value<ImportStatus> status,
      Value<String?> adapter,
      Value<String?> accountId,
      Value<LocalDate?> periodFrom,
      Value<LocalDate?> periodTo,
      Value<int> parsedCount,
      Value<int> failedCount,
      Value<int> duplicateCount,
      Value<int> matchedCount,
      Value<int> createdCount,
      Value<List<Object?>> errors,
      Value<int> rowid,
    });

final class $$ImportBatchesTableReferences
    extends
        BaseReferences<_$FinanceDatabase, $ImportBatchesTable, ImportBatche> {
  $$ImportBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$FinanceDatabase db) =>
      db.accounts.createAlias('import_batches__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SourceRecordsTable, List<SourceRecord>>
  _sourceRecordsRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.sourceRecords,
        aliasName: 'import_batches__id__source_records__batch_id',
      );

  $$SourceRecordsTableProcessedTableManager get sourceRecordsRefs {
    final manager = $$SourceRecordsTableTableManager(
      $_db,
      $_db.sourceRecords,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportBatchesTableFilterComposer
    extends Composer<_$FinanceDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ImportKind, ImportKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ImportStatus, ImportStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get adapter => $composableBuilder(
    column: $table.adapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String>
  get periodFrom => $composableBuilder(
    column: $table.periodFrom,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String> get periodTo =>
      $composableBuilder(
        column: $table.periodTo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdCount => $composableBuilder(
    column: $table.createdCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get errors => $composableBuilder(
    column: $table.errors,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sourceRecordsRefs(
    Expression<bool> Function($$SourceRecordsTableFilterComposer f) f,
  ) {
    final $$SourceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adapter => $composableBuilder(
    column: $table.adapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodFrom => $composableBuilder(
    column: $table.periodFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodTo => $composableBuilder(
    column: $table.periodTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdCount => $composableBuilder(
    column: $table.createdCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errors => $composableBuilder(
    column: $table.errors,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportBatchesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $ImportBatchesTable> {
  $$ImportBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ImportKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ImportStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get adapter =>
      $composableBuilder(column: $table.adapter, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate?, String> get periodFrom =>
      $composableBuilder(
        column: $table.periodFrom,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<LocalDate?, String> get periodTo =>
      $composableBuilder(column: $table.periodTo, builder: (column) => column);

  GeneratedColumn<int> get parsedCount => $composableBuilder(
    column: $table.parsedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedCount => $composableBuilder(
    column: $table.failedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duplicateCount => $composableBuilder(
    column: $table.duplicateCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get matchedCount => $composableBuilder(
    column: $table.matchedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdCount => $composableBuilder(
    column: $table.createdCount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Object?>, String> get errors =>
      $composableBuilder(column: $table.errors, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sourceRecordsRefs<T extends Object>(
    Expression<T> Function($$SourceRecordsTableAnnotationComposer a) f,
  ) {
    final $$SourceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportBatchesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $ImportBatchesTable,
          ImportBatche,
          $$ImportBatchesTableFilterComposer,
          $$ImportBatchesTableOrderingComposer,
          $$ImportBatchesTableAnnotationComposer,
          $$ImportBatchesTableCreateCompanionBuilder,
          $$ImportBatchesTableUpdateCompanionBuilder,
          (ImportBatche, $$ImportBatchesTableReferences),
          ImportBatche,
          PrefetchHooks Function({bool accountId, bool sourceRecordsRefs})
        > {
  $$ImportBatchesTableTableManager(
    _$FinanceDatabase db,
    $ImportBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<ImportKind> kind = const Value.absent(),
                Value<ImportStatus> status = const Value.absent(),
                Value<String?> adapter = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<LocalDate?> periodFrom = const Value.absent(),
                Value<LocalDate?> periodTo = const Value.absent(),
                Value<int> parsedCount = const Value.absent(),
                Value<int> failedCount = const Value.absent(),
                Value<int> duplicateCount = const Value.absent(),
                Value<int> matchedCount = const Value.absent(),
                Value<int> createdCount = const Value.absent(),
                Value<List<Object?>> errors = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportBatchesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                status: status,
                adapter: adapter,
                accountId: accountId,
                periodFrom: periodFrom,
                periodTo: periodTo,
                parsedCount: parsedCount,
                failedCount: failedCount,
                duplicateCount: duplicateCount,
                matchedCount: matchedCount,
                createdCount: createdCount,
                errors: errors,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required ImportKind kind,
                required ImportStatus status,
                Value<String?> adapter = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<LocalDate?> periodFrom = const Value.absent(),
                Value<LocalDate?> periodTo = const Value.absent(),
                Value<int> parsedCount = const Value.absent(),
                Value<int> failedCount = const Value.absent(),
                Value<int> duplicateCount = const Value.absent(),
                Value<int> matchedCount = const Value.absent(),
                Value<int> createdCount = const Value.absent(),
                Value<List<Object?>> errors = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportBatchesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                status: status,
                adapter: adapter,
                accountId: accountId,
                periodFrom: periodFrom,
                periodTo: periodTo,
                parsedCount: parsedCount,
                failedCount: failedCount,
                duplicateCount: duplicateCount,
                matchedCount: matchedCount,
                createdCount: createdCount,
                errors: errors,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportBatchesTable, ImportBatche>(table),
                  $$ImportBatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, sourceRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sourceRecordsRefs) db.sourceRecords,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$ImportBatchesTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$ImportBatchesTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sourceRecordsRefs)
                        await $_getPrefetchedData<
                          ImportBatche,
                          $ImportBatchesTable,
                          SourceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ImportBatchesTableReferences
                              ._sourceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ImportBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.batchId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ImportBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $ImportBatchesTable,
      ImportBatche,
      $$ImportBatchesTableFilterComposer,
      $$ImportBatchesTableOrderingComposer,
      $$ImportBatchesTableAnnotationComposer,
      $$ImportBatchesTableCreateCompanionBuilder,
      $$ImportBatchesTableUpdateCompanionBuilder,
      (ImportBatche, $$ImportBatchesTableReferences),
      ImportBatche,
      PrefetchHooks Function({bool accountId, bool sourceRecordsRefs})
    >;
typedef $$SourceRecordsTableCreateCompanionBuilder =
    SourceRecordsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required SourceKind kind,
      Value<String?> batchId,
      required String dedupeHash,
      required ParseStatus parseStatus,
      Value<Map<String, Object?>?> parsed,
      Value<String?> rawText,
      Value<String?> sender,
      required DateTime receivedAt,
      Value<int> rowid,
    });
typedef $$SourceRecordsTableUpdateCompanionBuilder =
    SourceRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<SourceKind> kind,
      Value<String?> batchId,
      Value<String> dedupeHash,
      Value<ParseStatus> parseStatus,
      Value<Map<String, Object?>?> parsed,
      Value<String?> rawText,
      Value<String?> sender,
      Value<DateTime> receivedAt,
      Value<int> rowid,
    });

final class $$SourceRecordsTableReferences
    extends
        BaseReferences<_$FinanceDatabase, $SourceRecordsTable, SourceRecord> {
  $$SourceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ImportBatchesTable _batchIdTable(_$FinanceDatabase db) => db
      .importBatches
      .createAlias('source_records__batch_id__import_batches__id');

  $$ImportBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<String>('batch_id');
    if ($_column == null) return null;
    final manager = $$ImportBatchesTableTableManager(
      $_db,
      $_db.importBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionSourcesTable, List<TransactionSource>>
  _transactionSourcesRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSources,
        aliasName: 'source_records__id__transaction_sources__source_record_id',
      );

  $$TransactionSourcesTableProcessedTableManager get transactionSourcesRefs {
    final manager = $$TransactionSourcesTableTableManager(
      $_db,
      $_db.transactionSources,
    ).filter((f) => f.sourceRecordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourceRecordsTableFilterComposer
    extends Composer<_$FinanceDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceKind, SourceKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get dedupeHash => $composableBuilder(
    column: $table.dedupeHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ParseStatus, ParseStatus, String>
  get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get parsed => $composableBuilder(
    column: $table.parsed,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ImportBatchesTableFilterComposer get batchId {
    final $$ImportBatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableFilterComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionSourcesRefs(
    Expression<bool> Function($$TransactionSourcesTableFilterComposer f) f,
  ) {
    final $$TransactionSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSources,
      getReferencedColumn: (t) => t.sourceRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSourcesTableFilterComposer(
            $db: $db,
            $table: $db.transactionSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceRecordsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeHash => $composableBuilder(
    column: $table.dedupeHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parseStatus => $composableBuilder(
    column: $table.parseStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parsed => $composableBuilder(
    column: $table.parsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ImportBatchesTableOrderingComposer get batchId {
    final $$ImportBatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableOrderingComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SourceRecordsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $SourceRecordsTable> {
  $$SourceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get dedupeHash => $composableBuilder(
    column: $table.dedupeHash,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ParseStatus, String> get parseStatus =>
      $composableBuilder(
        column: $table.parseStatus,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String> get parsed =>
      $composableBuilder(column: $table.parsed, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  $$ImportBatchesTableAnnotationComposer get batchId {
    final $$ImportBatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.importBatches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportBatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.importBatches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionSourcesRefs<T extends Object>(
    Expression<T> Function($$TransactionSourcesTableAnnotationComposer a) f,
  ) {
    final $$TransactionSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSources,
          getReferencedColumn: (t) => t.sourceRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SourceRecordsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $SourceRecordsTable,
          SourceRecord,
          $$SourceRecordsTableFilterComposer,
          $$SourceRecordsTableOrderingComposer,
          $$SourceRecordsTableAnnotationComposer,
          $$SourceRecordsTableCreateCompanionBuilder,
          $$SourceRecordsTableUpdateCompanionBuilder,
          (SourceRecord, $$SourceRecordsTableReferences),
          SourceRecord,
          PrefetchHooks Function({bool batchId, bool transactionSourcesRefs})
        > {
  $$SourceRecordsTableTableManager(
    _$FinanceDatabase db,
    $SourceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<SourceKind> kind = const Value.absent(),
                Value<String?> batchId = const Value.absent(),
                Value<String> dedupeHash = const Value.absent(),
                Value<ParseStatus> parseStatus = const Value.absent(),
                Value<Map<String, Object?>?> parsed = const Value.absent(),
                Value<String?> rawText = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceRecordsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                batchId: batchId,
                dedupeHash: dedupeHash,
                parseStatus: parseStatus,
                parsed: parsed,
                rawText: rawText,
                sender: sender,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required SourceKind kind,
                Value<String?> batchId = const Value.absent(),
                required String dedupeHash,
                required ParseStatus parseStatus,
                Value<Map<String, Object?>?> parsed = const Value.absent(),
                Value<String?> rawText = const Value.absent(),
                Value<String?> sender = const Value.absent(),
                required DateTime receivedAt,
                Value<int> rowid = const Value.absent(),
              }) => SourceRecordsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                batchId: batchId,
                dedupeHash: dedupeHash,
                parseStatus: parseStatus,
                parsed: parsed,
                rawText: rawText,
                sender: sender,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SourceRecordsTable, SourceRecord>(table),
                  $$SourceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({batchId = false, transactionSourcesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionSourcesRefs) db.transactionSources,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (batchId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.batchId,
                            referencedTable: $$SourceRecordsTableReferences
                                ._batchIdTable(db),
                            referencedColumn: $$SourceRecordsTableReferences
                                ._batchIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionSourcesRefs)
                        await $_getPrefetchedData<
                          SourceRecord,
                          $SourceRecordsTable,
                          TransactionSource
                        >(
                          currentTable: table,
                          referencedTable: $$SourceRecordsTableReferences
                              ._transactionSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SourceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionSourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SourceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $SourceRecordsTable,
      SourceRecord,
      $$SourceRecordsTableFilterComposer,
      $$SourceRecordsTableOrderingComposer,
      $$SourceRecordsTableAnnotationComposer,
      $$SourceRecordsTableCreateCompanionBuilder,
      $$SourceRecordsTableUpdateCompanionBuilder,
      (SourceRecord, $$SourceRecordsTableReferences),
      SourceRecord,
      PrefetchHooks Function({bool batchId, bool transactionSourcesRefs})
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required String name,
  Value<String?> parentId,
  required SpendClass spendClass,
  required SpendClassSource spendClassSource,
  Value<int> floorPaise,
  required String icon,
  required String colorToken,
  Value<bool> isSystem,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<String> name,
  Value<String?> parentId,
  Value<SpendClass> spendClass,
  Value<SpendClassSource> spendClassSource,
  Value<int> floorPaise,
  Value<String> icon,
  Value<String> colorToken,
  Value<bool> isSystem,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$FinanceDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$FinanceDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CategoryRulesTable, List<CategoryRule>>
  _categoryRulesRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryRules,
        aliasName: 'categories__id__category_rules__category_id',
      );

  $$CategoryRulesTableProcessedTableManager get categoryRulesRefs {
    final manager = $$CategoryRulesTableTableManager(
      $_db,
      $_db.categoryRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoryRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$FinanceDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainingLabelsTable, List<TrainingLabel>>
  _labelsTable(_$FinanceDatabase db) => MultiTypedResultKey.fromTable(
    db.trainingLabels,
    aliasName: 'categories__id__training_labels__category_id',
  );

  $$TrainingLabelsTableProcessedTableManager get labels {
    final manager = $$TrainingLabelsTableTableManager(
      $_db,
      $_db.trainingLabels,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_labelsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainingLabelsTable, List<TrainingLabel>>
  _correctedFromLabelsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trainingLabels,
        aliasName: 'categories__id__training_labels__previous_category_id',
      );

  $$TrainingLabelsTableProcessedTableManager get correctedFromLabels {
    final manager = $$TrainingLabelsTableTableManager($_db, $_db.trainingLabels)
        .filter(
          (f) => f.previousCategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _correctedFromLabelsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$FinanceDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$FinanceDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SpendClass, SpendClass, String>
  get spendClass => $composableBuilder(
    column: $table.spendClass,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SpendClassSource, SpendClassSource, String>
  get spendClassSource => $composableBuilder(
    column: $table.spendClassSource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get floorPaise => $composableBuilder(
    column: $table.floorPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> categoryRulesRefs(
    Expression<bool> Function($$CategoryRulesTableFilterComposer f) f,
  ) {
    final $$CategoryRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableFilterComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> labels(
    Expression<bool> Function($$TrainingLabelsTableFilterComposer f) f,
  ) {
    final $$TrainingLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableFilterComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> correctedFromLabels(
    Expression<bool> Function($$TrainingLabelsTableFilterComposer f) f,
  ) {
    final $$TrainingLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.previousCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableFilterComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spendClass => $composableBuilder(
    column: $table.spendClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spendClassSource => $composableBuilder(
    column: $table.spendClassSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floorPaise => $composableBuilder(
    column: $table.floorPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpendClass, String> get spendClass =>
      $composableBuilder(
        column: $table.spendClass,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SpendClassSource, String>
  get spendClassSource => $composableBuilder(
    column: $table.spendClassSource,
    builder: (column) => column,
  );

  GeneratedColumn<int> get floorPaise => $composableBuilder(
    column: $table.floorPaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> categoryRulesRefs<T extends Object>(
    Expression<T> Function($$CategoryRulesTableAnnotationComposer a) f,
  ) {
    final $$CategoryRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> labels<T extends Object>(
    Expression<T> Function($$TrainingLabelsTableAnnotationComposer a) f,
  ) {
    final $$TrainingLabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> correctedFromLabels<T extends Object>(
    Expression<T> Function($$TrainingLabelsTableAnnotationComposer a) f,
  ) {
    final $$TrainingLabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.previousCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool parentId,
            bool categoryRulesRefs,
            bool transactionsRefs,
            bool labels,
            bool correctedFromLabels,
            bool budgetsRefs,
          })
        > {
  $$CategoriesTableTableManager(_$FinanceDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<SpendClass> spendClass = const Value.absent(),
                Value<SpendClassSource> spendClassSource = const Value.absent(),
                Value<int> floorPaise = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> colorToken = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                name: name,
                parentId: parentId,
                spendClass: spendClass,
                spendClassSource: spendClassSource,
                floorPaise: floorPaise,
                icon: icon,
                colorToken: colorToken,
                isSystem: isSystem,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String name,
                Value<String?> parentId = const Value.absent(),
                required SpendClass spendClass,
                required SpendClassSource spendClassSource,
                Value<int> floorPaise = const Value.absent(),
                required String icon,
                required String colorToken,
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                name: name,
                parentId: parentId,
                spendClass: spendClass,
                spendClassSource: spendClassSource,
                floorPaise: floorPaise,
                icon: icon,
                colorToken: colorToken,
                isSystem: isSystem,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                categoryRulesRefs = false,
                transactionsRefs = false,
                labels = false,
                correctedFromLabels = false,
                budgetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryRulesRefs) db.categoryRules,
                    if (transactionsRefs) db.transactions,
                    if (labels) db.trainingLabels,
                    if (correctedFromLabels) db.trainingLabels,
                    if (budgetsRefs) db.budgets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$CategoriesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$CategoriesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryRulesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          CategoryRule
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._categoryRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (labels)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          TrainingLabel
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._labelsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(db, table, p0).labels,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (correctedFromLabels)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          TrainingLabel
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._correctedFromLabelsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).correctedFromLabels,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.previousCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Budget
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool parentId,
        bool categoryRulesRefs,
        bool transactionsRefs,
        bool labels,
        bool correctedFromLabels,
        bool budgetsRefs,
      })
    >;
typedef $$CategoryRulesTableCreateCompanionBuilder =
    CategoryRulesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required RuleType type,
      required Map<String, Object?> match,
      required String categoryId,
      Value<int> priority,
      Value<bool> enabled,
      required Origin createdBy,
      Value<int> hitCount,
      Value<int> missCount,
      Value<int> rowid,
    });
typedef $$CategoryRulesTableUpdateCompanionBuilder =
    CategoryRulesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<RuleType> type,
      Value<Map<String, Object?>> match,
      Value<String> categoryId,
      Value<int> priority,
      Value<bool> enabled,
      Value<Origin> createdBy,
      Value<int> hitCount,
      Value<int> missCount,
      Value<int> rowid,
    });

final class $$CategoryRulesTableReferences
    extends
        BaseReferences<_$FinanceDatabase, $CategoryRulesTable, CategoryRule> {
  $$CategoryRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$FinanceDatabase db) =>
      db.categories.createAlias('category_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$FinanceDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'category_rules__id__transactions__categorization_rule_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter(
          (f) =>
              f.categorizationRuleId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoryRulesTableFilterComposer
    extends Composer<_$FinanceDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RuleType, RuleType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get match => $composableBuilder(
    column: $table.match,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Origin, Origin, String> get createdBy =>
      $composableBuilder(
        column: $table.createdBy,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get hitCount => $composableBuilder(
    column: $table.hitCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missCount => $composableBuilder(
    column: $table.missCount,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categorizationRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryRulesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get match => $composableBuilder(
    column: $table.match,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitCount => $composableBuilder(
    column: $table.hitCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missCount => $composableBuilder(
    column: $table.missCount,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRulesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $CategoryRulesTable> {
  $$CategoryRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RuleType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get match =>
      $composableBuilder(column: $table.match, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Origin, String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get hitCount =>
      $composableBuilder(column: $table.hitCount, builder: (column) => column);

  GeneratedColumn<int> get missCount =>
      $composableBuilder(column: $table.missCount, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categorizationRuleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryRulesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $CategoryRulesTable,
          CategoryRule,
          $$CategoryRulesTableFilterComposer,
          $$CategoryRulesTableOrderingComposer,
          $$CategoryRulesTableAnnotationComposer,
          $$CategoryRulesTableCreateCompanionBuilder,
          $$CategoryRulesTableUpdateCompanionBuilder,
          (CategoryRule, $$CategoryRulesTableReferences),
          CategoryRule,
          PrefetchHooks Function({bool categoryId, bool transactionsRefs})
        > {
  $$CategoryRulesTableTableManager(
    _$FinanceDatabase db,
    $CategoryRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<RuleType> type = const Value.absent(),
                Value<Map<String, Object?>> match = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<Origin> createdBy = const Value.absent(),
                Value<int> hitCount = const Value.absent(),
                Value<int> missCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryRulesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                type: type,
                match: match,
                categoryId: categoryId,
                priority: priority,
                enabled: enabled,
                createdBy: createdBy,
                hitCount: hitCount,
                missCount: missCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required RuleType type,
                required Map<String, Object?> match,
                required String categoryId,
                Value<int> priority = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required Origin createdBy,
                Value<int> hitCount = const Value.absent(),
                Value<int> missCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryRulesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                type: type,
                match: match,
                categoryId: categoryId,
                priority: priority,
                enabled: enabled,
                createdBy: createdBy,
                hitCount: hitCount,
                missCount: missCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoryRulesTable, CategoryRule>(table),
                  $$CategoryRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, transactionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$CategoryRulesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$CategoryRulesTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          CategoryRule,
                          $CategoryRulesTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$CategoryRulesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoryRulesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categorizationRuleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoryRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $CategoryRulesTable,
      CategoryRule,
      $$CategoryRulesTableFilterComposer,
      $$CategoryRulesTableOrderingComposer,
      $$CategoryRulesTableAnnotationComposer,
      $$CategoryRulesTableCreateCompanionBuilder,
      $$CategoryRulesTableUpdateCompanionBuilder,
      (CategoryRule, $$CategoryRulesTableReferences),
      CategoryRule,
      PrefetchHooks Function({bool categoryId, bool transactionsRefs})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      Value<String?> accountId,
      required Direction direction,
      required int amountPaise,
      required DateTime occurredAt,
      required LocalDate localDate,
      required Channel channel,
      Value<String?> counterpartyName,
      Value<String?> merchantKey,
      Value<String?> vpa,
      Value<CounterpartyKind> counterpartyKind,
      Value<String?> upiRef,
      Value<String?> bankRef,
      Value<String?> cardLast4,
      Value<String?> descriptionRaw,
      Value<String?> categoryId,
      Value<CategorizationMethod?> categorizedBy,
      Value<String?> categorizationRuleId,
      Value<double?> categorizationConfidence,
      required TransactionFlow flow,
      required ReconciliationStatus reconciliationStatus,
      Value<String?> notes,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String?> accountId,
      Value<Direction> direction,
      Value<int> amountPaise,
      Value<DateTime> occurredAt,
      Value<LocalDate> localDate,
      Value<Channel> channel,
      Value<String?> counterpartyName,
      Value<String?> merchantKey,
      Value<String?> vpa,
      Value<CounterpartyKind> counterpartyKind,
      Value<String?> upiRef,
      Value<String?> bankRef,
      Value<String?> cardLast4,
      Value<String?> descriptionRaw,
      Value<String?> categoryId,
      Value<CategorizationMethod?> categorizedBy,
      Value<String?> categorizationRuleId,
      Value<double?> categorizationConfidence,
      Value<TransactionFlow> flow,
      Value<ReconciliationStatus> reconciliationStatus,
      Value<String?> notes,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$FinanceDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$FinanceDatabase db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$FinanceDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoryRulesTable _categorizationRuleIdTable(_$FinanceDatabase db) =>
      db.categoryRules.createAlias(
        'transactions__categorization_rule_id__category_rules__id',
      );

  $$CategoryRulesTableProcessedTableManager? get categorizationRuleId {
    final $_column = $_itemColumn<String>('categorization_rule_id');
    if ($_column == null) return null;
    final manager = $$CategoryRulesTableTableManager(
      $_db,
      $_db.categoryRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _categorizationRuleIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionSourcesTable, List<TransactionSource>>
  _transactionSourcesRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSources,
        aliasName: 'transactions__id__transaction_sources__transaction_id',
      );

  $$TransactionSourcesTableProcessedTableManager get transactionSourcesRefs {
    final manager = $$TransactionSourcesTableTableManager(
      $_db,
      $_db.transactionSources,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReconciliationReviewsTable,
    List<ReconciliationReview>
  >
  _reconciliationReviewsRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.reconciliationReviews,
        aliasName: 'transactions__id__reconciliation_reviews__transaction_id',
      );

  $$ReconciliationReviewsTableProcessedTableManager
  get reconciliationReviewsRefs {
    final manager = $$ReconciliationReviewsTableTableManager(
      $_db,
      $_db.reconciliationReviews,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reconciliationReviewsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrainingLabelsTable, List<TrainingLabel>>
  _trainingLabelsRefsTable(_$FinanceDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trainingLabels,
        aliasName: 'transactions__id__training_labels__transaction_id',
      );

  $$TrainingLabelsTableProcessedTableManager get trainingLabelsRefs {
    final manager = $$TrainingLabelsTableTableManager(
      $_db,
      $_db.trainingLabels,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trainingLabelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$FinanceDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Direction, Direction, String> get direction =>
      $composableBuilder(
        column: $table.direction,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get localDate =>
      $composableBuilder(
        column: $table.localDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Channel, Channel, String> get channel =>
      $composableBuilder(
        column: $table.channel,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vpa => $composableBuilder(
    column: $table.vpa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CounterpartyKind, CounterpartyKind, String>
  get counterpartyKind => $composableBuilder(
    column: $table.counterpartyKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get upiRef => $composableBuilder(
    column: $table.upiRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankRef => $composableBuilder(
    column: $table.bankRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    CategorizationMethod?,
    CategorizationMethod,
    String
  >
  get categorizedBy => $composableBuilder(
    column: $table.categorizedBy,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionFlow, TransactionFlow, String>
  get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    ReconciliationStatus,
    ReconciliationStatus,
    String
  >
  get reconciliationStatus => $composableBuilder(
    column: $table.reconciliationStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryRulesTableFilterComposer get categorizationRuleId {
    final $$CategoryRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorizationRuleId,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableFilterComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionSourcesRefs(
    Expression<bool> Function($$TransactionSourcesTableFilterComposer f) f,
  ) {
    final $$TransactionSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSources,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSourcesTableFilterComposer(
            $db: $db,
            $table: $db.transactionSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reconciliationReviewsRefs(
    Expression<bool> Function($$ReconciliationReviewsTableFilterComposer f) f,
  ) {
    final $$ReconciliationReviewsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reconciliationReviews,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReconciliationReviewsTableFilterComposer(
                $db: $db,
                $table: $db.reconciliationReviews,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> trainingLabelsRefs(
    Expression<bool> Function($$TrainingLabelsTableFilterComposer f) f,
  ) {
    final $$TrainingLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableFilterComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vpa => $composableBuilder(
    column: $table.vpa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterpartyKind => $composableBuilder(
    column: $table.counterpartyKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiRef => $composableBuilder(
    column: $table.upiRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankRef => $composableBuilder(
    column: $table.bankRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categorizedBy => $composableBuilder(
    column: $table.categorizedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reconciliationStatus => $composableBuilder(
    column: $table.reconciliationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryRulesTableOrderingComposer get categorizationRuleId {
    final $$CategoryRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorizationRuleId,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableOrderingComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Direction, String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
    column: $table.amountPaise,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDate, String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Channel, String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get counterpartyName => $composableBuilder(
    column: $table.counterpartyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vpa =>
      $composableBuilder(column: $table.vpa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CounterpartyKind, String>
  get counterpartyKind => $composableBuilder(
    column: $table.counterpartyKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get upiRef =>
      $composableBuilder(column: $table.upiRef, builder: (column) => column);

  GeneratedColumn<String> get bankRef =>
      $composableBuilder(column: $table.bankRef, builder: (column) => column);

  GeneratedColumn<String> get cardLast4 =>
      $composableBuilder(column: $table.cardLast4, builder: (column) => column);

  GeneratedColumn<String> get descriptionRaw => $composableBuilder(
    column: $table.descriptionRaw,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CategorizationMethod?, String>
  get categorizedBy => $composableBuilder(
    column: $table.categorizedBy,
    builder: (column) => column,
  );

  GeneratedColumn<double> get categorizationConfidence => $composableBuilder(
    column: $table.categorizationConfidence,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionFlow, String> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReconciliationStatus, String>
  get reconciliationStatus => $composableBuilder(
    column: $table.reconciliationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryRulesTableAnnotationComposer get categorizationRuleId {
    final $$CategoryRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categorizationRuleId,
      referencedTable: $db.categoryRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionSourcesRefs<T extends Object>(
    Expression<T> Function($$TransactionSourcesTableAnnotationComposer a) f,
  ) {
    final $$TransactionSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSources,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reconciliationReviewsRefs<T extends Object>(
    Expression<T> Function($$ReconciliationReviewsTableAnnotationComposer a) f,
  ) {
    final $$ReconciliationReviewsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.reconciliationReviews,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReconciliationReviewsTableAnnotationComposer(
                $db: $db,
                $table: $db.reconciliationReviews,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> trainingLabelsRefs<T extends Object>(
    Expression<T> Function($$TrainingLabelsTableAnnotationComposer a) f,
  ) {
    final $$TrainingLabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingLabels,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingLabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool categorizationRuleId,
            bool transactionSourcesRefs,
            bool reconciliationReviewsRefs,
            bool trainingLabelsRefs,
          })
        > {
  $$TransactionsTableTableManager(
    _$FinanceDatabase db,
    $TransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<Direction> direction = const Value.absent(),
                Value<int> amountPaise = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<LocalDate> localDate = const Value.absent(),
                Value<Channel> channel = const Value.absent(),
                Value<String?> counterpartyName = const Value.absent(),
                Value<String?> merchantKey = const Value.absent(),
                Value<String?> vpa = const Value.absent(),
                Value<CounterpartyKind> counterpartyKind = const Value.absent(),
                Value<String?> upiRef = const Value.absent(),
                Value<String?> bankRef = const Value.absent(),
                Value<String?> cardLast4 = const Value.absent(),
                Value<String?> descriptionRaw = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<CategorizationMethod?> categorizedBy =
                    const Value.absent(),
                Value<String?> categorizationRuleId = const Value.absent(),
                Value<double?> categorizationConfidence = const Value.absent(),
                Value<TransactionFlow> flow = const Value.absent(),
                Value<ReconciliationStatus> reconciliationStatus =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                accountId: accountId,
                direction: direction,
                amountPaise: amountPaise,
                occurredAt: occurredAt,
                localDate: localDate,
                channel: channel,
                counterpartyName: counterpartyName,
                merchantKey: merchantKey,
                vpa: vpa,
                counterpartyKind: counterpartyKind,
                upiRef: upiRef,
                bankRef: bankRef,
                cardLast4: cardLast4,
                descriptionRaw: descriptionRaw,
                categoryId: categoryId,
                categorizedBy: categorizedBy,
                categorizationRuleId: categorizationRuleId,
                categorizationConfidence: categorizationConfidence,
                flow: flow,
                reconciliationStatus: reconciliationStatus,
                notes: notes,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                required Direction direction,
                required int amountPaise,
                required DateTime occurredAt,
                required LocalDate localDate,
                required Channel channel,
                Value<String?> counterpartyName = const Value.absent(),
                Value<String?> merchantKey = const Value.absent(),
                Value<String?> vpa = const Value.absent(),
                Value<CounterpartyKind> counterpartyKind = const Value.absent(),
                Value<String?> upiRef = const Value.absent(),
                Value<String?> bankRef = const Value.absent(),
                Value<String?> cardLast4 = const Value.absent(),
                Value<String?> descriptionRaw = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<CategorizationMethod?> categorizedBy =
                    const Value.absent(),
                Value<String?> categorizationRuleId = const Value.absent(),
                Value<double?> categorizationConfidence = const Value.absent(),
                required TransactionFlow flow,
                required ReconciliationStatus reconciliationStatus,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                accountId: accountId,
                direction: direction,
                amountPaise: amountPaise,
                occurredAt: occurredAt,
                localDate: localDate,
                channel: channel,
                counterpartyName: counterpartyName,
                merchantKey: merchantKey,
                vpa: vpa,
                counterpartyKind: counterpartyKind,
                upiRef: upiRef,
                bankRef: bankRef,
                cardLast4: cardLast4,
                descriptionRaw: descriptionRaw,
                categoryId: categoryId,
                categorizedBy: categorizedBy,
                categorizationRuleId: categorizationRuleId,
                categorizationConfidence: categorizationConfidence,
                flow: flow,
                reconciliationStatus: reconciliationStatus,
                notes: notes,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                categoryId = false,
                categorizationRuleId = false,
                transactionSourcesRefs = false,
                reconciliationReviewsRefs = false,
                trainingLabelsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionSourcesRefs) db.transactionSources,
                    if (reconciliationReviewsRefs) db.reconciliationReviews,
                    if (trainingLabelsRefs) db.trainingLabels,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categorizationRuleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categorizationRuleId,
                            referencedTable: $$TransactionsTableReferences
                                ._categorizationRuleIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categorizationRuleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionSourcesRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TransactionSource
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionSourcesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reconciliationReviewsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          ReconciliationReview
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._reconciliationReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).reconciliationReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trainingLabelsRefs)
                        await $_getPrefetchedData<
                          Transaction,
                          $TransactionsTable,
                          TrainingLabel
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._trainingLabelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingLabelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool accountId,
        bool categoryId,
        bool categorizationRuleId,
        bool transactionSourcesRefs,
        bool reconciliationReviewsRefs,
        bool trainingLabelsRefs,
      })
    >;
typedef $$TransactionSourcesTableCreateCompanionBuilder =
    TransactionSourcesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required String transactionId,
      required String sourceRecordId,
      required SourceKind kind,
      Value<int> rowid,
    });
typedef $$TransactionSourcesTableUpdateCompanionBuilder =
    TransactionSourcesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String> transactionId,
      Value<String> sourceRecordId,
      Value<SourceKind> kind,
      Value<int> rowid,
    });

final class $$TransactionSourcesTableReferences
    extends
        BaseReferences<
          _$FinanceDatabase,
          $TransactionSourcesTable,
          TransactionSource
        > {
  $$TransactionSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$FinanceDatabase db) => db
      .transactions
      .createAlias('transaction_sources__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SourceRecordsTable _sourceRecordIdTable(_$FinanceDatabase db) => db
      .sourceRecords
      .createAlias('transaction_sources__source_record_id__source_records__id');

  $$SourceRecordsTableProcessedTableManager get sourceRecordId {
    final $_column = $_itemColumn<String>('source_record_id')!;

    final manager = $$SourceRecordsTableTableManager(
      $_db,
      $_db.sourceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionSourcesTableFilterComposer
    extends Composer<_$FinanceDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceKind, SourceKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableFilterComposer get sourceRecordId {
    final $$SourceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableOrderingComposer get sourceRecordId {
    final $$SourceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SourceRecordsTableAnnotationComposer get sourceRecordId {
    final $$SourceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceRecordId,
      referencedTable: $db.sourceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $TransactionSourcesTable,
          TransactionSource,
          $$TransactionSourcesTableFilterComposer,
          $$TransactionSourcesTableOrderingComposer,
          $$TransactionSourcesTableAnnotationComposer,
          $$TransactionSourcesTableCreateCompanionBuilder,
          $$TransactionSourcesTableUpdateCompanionBuilder,
          (TransactionSource, $$TransactionSourcesTableReferences),
          TransactionSource,
          PrefetchHooks Function({bool transactionId, bool sourceRecordId})
        > {
  $$TransactionSourcesTableTableManager(
    _$FinanceDatabase db,
    $TransactionSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> sourceRecordId = const Value.absent(),
                Value<SourceKind> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                sourceRecordId: sourceRecordId,
                kind: kind,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String transactionId,
                required String sourceRecordId,
                required SourceKind kind,
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                sourceRecordId: sourceRecordId,
                kind: kind,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionSourcesTable, TransactionSource>(
                    table,
                  ),
                  $$TransactionSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionId = false, sourceRecordId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$TransactionSourcesTableReferences
                                ._transactionIdTable(db),
                            referencedColumn:
                                $$TransactionSourcesTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (sourceRecordId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceRecordId,
                            referencedTable: $$TransactionSourcesTableReferences
                                ._sourceRecordIdTable(db),
                            referencedColumn:
                                $$TransactionSourcesTableReferences
                                    ._sourceRecordIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $TransactionSourcesTable,
      TransactionSource,
      $$TransactionSourcesTableFilterComposer,
      $$TransactionSourcesTableOrderingComposer,
      $$TransactionSourcesTableAnnotationComposer,
      $$TransactionSourcesTableCreateCompanionBuilder,
      $$TransactionSourcesTableUpdateCompanionBuilder,
      (TransactionSource, $$TransactionSourcesTableReferences),
      TransactionSource,
      PrefetchHooks Function({bool transactionId, bool sourceRecordId})
    >;
typedef $$ReconciliationReviewsTableCreateCompanionBuilder =
    ReconciliationReviewsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required String transactionId,
      required List<Object?> candidateRecordIds,
      required double score,
      Value<List<Object?>> reasons,
      required ReviewStatus status,
      Value<int> rowid,
    });
typedef $$ReconciliationReviewsTableUpdateCompanionBuilder =
    ReconciliationReviewsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String> transactionId,
      Value<List<Object?>> candidateRecordIds,
      Value<double> score,
      Value<List<Object?>> reasons,
      Value<ReviewStatus> status,
      Value<int> rowid,
    });

final class $$ReconciliationReviewsTableReferences
    extends
        BaseReferences<
          _$FinanceDatabase,
          $ReconciliationReviewsTable,
          ReconciliationReview
        > {
  $$ReconciliationReviewsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$FinanceDatabase db) => db
      .transactions
      .createAlias('reconciliation_reviews__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReconciliationReviewsTableFilterComposer
    extends Composer<_$FinanceDatabase, $ReconciliationReviewsTable> {
  $$ReconciliationReviewsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get candidateRecordIds => $composableBuilder(
    column: $table.candidateRecordIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get reasons => $composableBuilder(
    column: $table.reasons,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ReviewStatus, ReviewStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconciliationReviewsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $ReconciliationReviewsTable> {
  $$ReconciliationReviewsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateRecordIds => $composableBuilder(
    column: $table.candidateRecordIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasons => $composableBuilder(
    column: $table.reasons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconciliationReviewsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $ReconciliationReviewsTable> {
  $$ReconciliationReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String>
  get candidateRecordIds => $composableBuilder(
    column: $table.candidateRecordIds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String> get reasons =>
      $composableBuilder(column: $table.reasons, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReviewStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReconciliationReviewsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $ReconciliationReviewsTable,
          ReconciliationReview,
          $$ReconciliationReviewsTableFilterComposer,
          $$ReconciliationReviewsTableOrderingComposer,
          $$ReconciliationReviewsTableAnnotationComposer,
          $$ReconciliationReviewsTableCreateCompanionBuilder,
          $$ReconciliationReviewsTableUpdateCompanionBuilder,
          (ReconciliationReview, $$ReconciliationReviewsTableReferences),
          ReconciliationReview,
          PrefetchHooks Function({bool transactionId})
        > {
  $$ReconciliationReviewsTableTableManager(
    _$FinanceDatabase db,
    $ReconciliationReviewsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReconciliationReviewsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReconciliationReviewsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReconciliationReviewsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<List<Object?>> candidateRecordIds = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<List<Object?>> reasons = const Value.absent(),
                Value<ReviewStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReconciliationReviewsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                candidateRecordIds: candidateRecordIds,
                score: score,
                reasons: reasons,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String transactionId,
                required List<Object?> candidateRecordIds,
                required double score,
                Value<List<Object?>> reasons = const Value.absent(),
                required ReviewStatus status,
                Value<int> rowid = const Value.absent(),
              }) => ReconciliationReviewsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                candidateRecordIds: candidateRecordIds,
                score: score,
                reasons: reasons,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ReconciliationReviewsTable,
                    ReconciliationReview
                  >(table),
                  $$ReconciliationReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$ReconciliationReviewsTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$ReconciliationReviewsTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReconciliationReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $ReconciliationReviewsTable,
      ReconciliationReview,
      $$ReconciliationReviewsTableFilterComposer,
      $$ReconciliationReviewsTableOrderingComposer,
      $$ReconciliationReviewsTableAnnotationComposer,
      $$ReconciliationReviewsTableCreateCompanionBuilder,
      $$ReconciliationReviewsTableUpdateCompanionBuilder,
      (ReconciliationReview, $$ReconciliationReviewsTableReferences),
      ReconciliationReview,
      PrefetchHooks Function({bool transactionId})
    >;
typedef $$TrainingLabelsTableCreateCompanionBuilder =
    TrainingLabelsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required String transactionId,
      required String categoryId,
      Value<String?> previousCategoryId,
      required LabelOrigin origin,
      required Map<String, Object?> features,
      Value<int> rowid,
    });
typedef $$TrainingLabelsTableUpdateCompanionBuilder =
    TrainingLabelsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String> transactionId,
      Value<String> categoryId,
      Value<String?> previousCategoryId,
      Value<LabelOrigin> origin,
      Value<Map<String, Object?>> features,
      Value<int> rowid,
    });

final class $$TrainingLabelsTableReferences
    extends
        BaseReferences<_$FinanceDatabase, $TrainingLabelsTable, TrainingLabel> {
  $$TrainingLabelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$FinanceDatabase db) => db
      .transactions
      .createAlias('training_labels__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$FinanceDatabase db) =>
      db.categories.createAlias('training_labels__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _previousCategoryIdTable(_$FinanceDatabase db) => db
      .categories
      .createAlias('training_labels__previous_category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get previousCategoryId {
    final $_column = $_itemColumn<String>('previous_category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_previousCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrainingLabelsTableFilterComposer
    extends Composer<_$FinanceDatabase, $TrainingLabelsTable> {
  $$TrainingLabelsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LabelOrigin, LabelOrigin, String> get origin =>
      $composableBuilder(
        column: $table.origin,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get previousCategoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingLabelsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $TrainingLabelsTable> {
  $$TrainingLabelsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get features => $composableBuilder(
    column: $table.features,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get previousCategoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingLabelsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $TrainingLabelsTable> {
  $$TrainingLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LabelOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get features =>
      $composableBuilder(column: $table.features, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get previousCategoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousCategoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingLabelsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $TrainingLabelsTable,
          TrainingLabel,
          $$TrainingLabelsTableFilterComposer,
          $$TrainingLabelsTableOrderingComposer,
          $$TrainingLabelsTableAnnotationComposer,
          $$TrainingLabelsTableCreateCompanionBuilder,
          $$TrainingLabelsTableUpdateCompanionBuilder,
          (TrainingLabel, $$TrainingLabelsTableReferences),
          TrainingLabel,
          PrefetchHooks Function({
            bool transactionId,
            bool categoryId,
            bool previousCategoryId,
          })
        > {
  $$TrainingLabelsTableTableManager(
    _$FinanceDatabase db,
    $TrainingLabelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingLabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String?> previousCategoryId = const Value.absent(),
                Value<LabelOrigin> origin = const Value.absent(),
                Value<Map<String, Object?>> features = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingLabelsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                categoryId: categoryId,
                previousCategoryId: previousCategoryId,
                origin: origin,
                features: features,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String transactionId,
                required String categoryId,
                Value<String?> previousCategoryId = const Value.absent(),
                required LabelOrigin origin,
                required Map<String, Object?> features,
                Value<int> rowid = const Value.absent(),
              }) => TrainingLabelsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                transactionId: transactionId,
                categoryId: categoryId,
                previousCategoryId: previousCategoryId,
                origin: origin,
                features: features,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingLabelsTable, TrainingLabel>(table),
                  $$TrainingLabelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionId = false,
                categoryId = false,
                previousCategoryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$TrainingLabelsTableReferences
                                ._transactionIdTable(db),
                            referencedColumn: $$TrainingLabelsTableReferences
                                ._transactionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TrainingLabelsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TrainingLabelsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (previousCategoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.previousCategoryId,
                            referencedTable: $$TrainingLabelsTableReferences
                                ._previousCategoryIdTable(db),
                            referencedColumn: $$TrainingLabelsTableReferences
                                ._previousCategoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TrainingLabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $TrainingLabelsTable,
      TrainingLabel,
      $$TrainingLabelsTableFilterComposer,
      $$TrainingLabelsTableOrderingComposer,
      $$TrainingLabelsTableAnnotationComposer,
      $$TrainingLabelsTableCreateCompanionBuilder,
      $$TrainingLabelsTableUpdateCompanionBuilder,
      (TrainingLabel, $$TrainingLabelsTableReferences),
      TrainingLabel,
      PrefetchHooks Function({
        bool transactionId,
        bool categoryId,
        bool previousCategoryId,
      })
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required String categoryId,
  required int limitPaise,
  Value<List<Object?>> warnAtPercent,
  required LocalDate effectiveFrom,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<String> categoryId,
  Value<int> limitPaise,
  Value<List<Object?>> warnAtPercent,
  Value<LocalDate> effectiveFrom,
  Value<int> rowid,
});

final class $$BudgetsTableReferences
    extends BaseReferences<_$FinanceDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$FinanceDatabase db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$FinanceDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitPaise => $composableBuilder(
    column: $table.limitPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get warnAtPercent => $composableBuilder(
    column: $table.warnAtPercent,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String>
  get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitPaise => $composableBuilder(
    column: $table.limitPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warnAtPercent => $composableBuilder(
    column: $table.warnAtPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get limitPaise => $composableBuilder(
    column: $table.limitPaise,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Object?>, String> get warnAtPercent =>
      $composableBuilder(
        column: $table.warnAtPercent,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<LocalDate, String> get effectiveFrom =>
      $composableBuilder(
        column: $table.effectiveFrom,
        builder: (column) => column,
      );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool categoryId})
        > {
  $$BudgetsTableTableManager(_$FinanceDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> limitPaise = const Value.absent(),
                Value<List<Object?>> warnAtPercent = const Value.absent(),
                Value<LocalDate> effectiveFrom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                categoryId: categoryId,
                limitPaise: limitPaise,
                warnAtPercent: warnAtPercent,
                effectiveFrom: effectiveFrom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String categoryId,
                required int limitPaise,
                Value<List<Object?>> warnAtPercent = const Value.absent(),
                required LocalDate effectiveFrom,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                categoryId: categoryId,
                limitPaise: limitPaise,
                warnAtPercent: warnAtPercent,
                effectiveFrom: effectiveFrom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, Budget>(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetsTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetsTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required String name,
  required int targetPaise,
  Value<int> savedPaise,
  required LocalDate deadline,
  Value<Map<String, Object?>?> fundingRule,
  required GoalStatus status,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<String> name,
  Value<int> targetPaise,
  Value<int> savedPaise,
  Value<LocalDate> deadline,
  Value<Map<String, Object?>?> fundingRule,
  Value<GoalStatus> status,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer
    extends Composer<_$FinanceDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get deadline =>
      $composableBuilder(
        column: $table.deadline,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get fundingRule => $composableBuilder(
    column: $table.fundingRule,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<GoalStatus, GoalStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fundingRule => $composableBuilder(
    column: $table.fundingRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetPaise => $composableBuilder(
    column: $table.targetPaise,
    builder: (column) => column,
  );

  GeneratedColumn<int> get savedPaise => $composableBuilder(
    column: $table.savedPaise,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDate, String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  get fundingRule => $composableBuilder(
    column: $table.fundingRule,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GoalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$FinanceDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$FinanceDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetPaise = const Value.absent(),
                Value<int> savedPaise = const Value.absent(),
                Value<LocalDate> deadline = const Value.absent(),
                Value<Map<String, Object?>?> fundingRule = const Value.absent(),
                Value<GoalStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                name: name,
                targetPaise: targetPaise,
                savedPaise: savedPaise,
                deadline: deadline,
                fundingRule: fundingRule,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String name,
                required int targetPaise,
                Value<int> savedPaise = const Value.absent(),
                required LocalDate deadline,
                Value<Map<String, Object?>?> fundingRule = const Value.absent(),
                required GoalStatus status,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                name: name,
                targetPaise: targetPaise,
                savedPaise: savedPaise,
                deadline: deadline,
                fundingRule: fundingRule,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, Goal>(table),
                  BaseReferences<_$FinanceDatabase, $GoalsTable, Goal>(
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

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$FinanceDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$RecurringSeriesTableCreateCompanionBuilder =
    RecurringSeriesCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required String merchantKey,
      required Cadence cadence,
      required int typicalAmountPaise,
      Value<LocalDate?> nextExpectedDate,
      required List<Object?> transactionIds,
      required SeriesUserState userState,
      Value<int> rowid,
    });
typedef $$RecurringSeriesTableUpdateCompanionBuilder =
    RecurringSeriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String> merchantKey,
      Value<Cadence> cadence,
      Value<int> typicalAmountPaise,
      Value<LocalDate?> nextExpectedDate,
      Value<List<Object?>> transactionIds,
      Value<SeriesUserState> userState,
      Value<int> rowid,
    });

class $$RecurringSeriesTableFilterComposer
    extends Composer<_$FinanceDatabase, $RecurringSeriesTable> {
  $$RecurringSeriesTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Cadence, Cadence, String> get cadence =>
      $composableBuilder(
        column: $table.cadence,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get typicalAmountPaise => $composableBuilder(
    column: $table.typicalAmountPaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String>
  get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get transactionIds => $composableBuilder(
    column: $table.transactionIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SeriesUserState, SeriesUserState, String>
  get userState => $composableBuilder(
    column: $table.userState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$RecurringSeriesTableOrderingComposer
    extends Composer<_$FinanceDatabase, $RecurringSeriesTable> {
  $$RecurringSeriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typicalAmountPaise => $composableBuilder(
    column: $table.typicalAmountPaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextExpectedDate => $composableBuilder(
    column: $table.nextExpectedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionIds => $composableBuilder(
    column: $table.transactionIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userState => $composableBuilder(
    column: $table.userState,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringSeriesTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $RecurringSeriesTable> {
  $$RecurringSeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get merchantKey => $composableBuilder(
    column: $table.merchantKey,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Cadence, String> get cadence =>
      $composableBuilder(column: $table.cadence, builder: (column) => column);

  GeneratedColumn<int> get typicalAmountPaise => $composableBuilder(
    column: $table.typicalAmountPaise,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDate?, String> get nextExpectedDate =>
      $composableBuilder(
        column: $table.nextExpectedDate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<Object?>, String> get transactionIds =>
      $composableBuilder(
        column: $table.transactionIds,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SeriesUserState, String> get userState =>
      $composableBuilder(column: $table.userState, builder: (column) => column);
}

class $$RecurringSeriesTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $RecurringSeriesTable,
          RecurringSery,
          $$RecurringSeriesTableFilterComposer,
          $$RecurringSeriesTableOrderingComposer,
          $$RecurringSeriesTableAnnotationComposer,
          $$RecurringSeriesTableCreateCompanionBuilder,
          $$RecurringSeriesTableUpdateCompanionBuilder,
          (
            RecurringSery,
            BaseReferences<
              _$FinanceDatabase,
              $RecurringSeriesTable,
              RecurringSery
            >,
          ),
          RecurringSery,
          PrefetchHooks Function()
        > {
  $$RecurringSeriesTableTableManager(
    _$FinanceDatabase db,
    $RecurringSeriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> merchantKey = const Value.absent(),
                Value<Cadence> cadence = const Value.absent(),
                Value<int> typicalAmountPaise = const Value.absent(),
                Value<LocalDate?> nextExpectedDate = const Value.absent(),
                Value<List<Object?>> transactionIds = const Value.absent(),
                Value<SeriesUserState> userState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringSeriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                merchantKey: merchantKey,
                cadence: cadence,
                typicalAmountPaise: typicalAmountPaise,
                nextExpectedDate: nextExpectedDate,
                transactionIds: transactionIds,
                userState: userState,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String merchantKey,
                required Cadence cadence,
                required int typicalAmountPaise,
                Value<LocalDate?> nextExpectedDate = const Value.absent(),
                required List<Object?> transactionIds,
                required SeriesUserState userState,
                Value<int> rowid = const Value.absent(),
              }) => RecurringSeriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                merchantKey: merchantKey,
                cadence: cadence,
                typicalAmountPaise: typicalAmountPaise,
                nextExpectedDate: nextExpectedDate,
                transactionIds: transactionIds,
                userState: userState,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurringSeriesTable, RecurringSery>(table),
                  BaseReferences<
                    _$FinanceDatabase,
                    $RecurringSeriesTable,
                    RecurringSery
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $RecurringSeriesTable,
      RecurringSery,
      $$RecurringSeriesTableFilterComposer,
      $$RecurringSeriesTableOrderingComposer,
      $$RecurringSeriesTableAnnotationComposer,
      $$RecurringSeriesTableCreateCompanionBuilder,
      $$RecurringSeriesTableUpdateCompanionBuilder,
      (
        RecurringSery,
        BaseReferences<_$FinanceDatabase, $RecurringSeriesTable, RecurringSery>,
      ),
      RecurringSery,
      PrefetchHooks Function()
    >;
typedef $$InsightsTableCreateCompanionBuilder = InsightsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required InsightType type,
  required Map<String, Object?> facts,
  Value<List<Object?>> guidelineIds,
  Value<String?> aiNarrative,
  Value<String?> aiProvider,
  required InsightStatus status,
  Value<int> rowid,
});
typedef $$InsightsTableUpdateCompanionBuilder = InsightsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<InsightType> type,
  Value<Map<String, Object?>> facts,
  Value<List<Object?>> guidelineIds,
  Value<String?> aiNarrative,
  Value<String?> aiProvider,
  Value<InsightStatus> status,
  Value<int> rowid,
});

class $$InsightsTableFilterComposer
    extends Composer<_$FinanceDatabase, $InsightsTable> {
  $$InsightsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InsightType, InsightType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get facts => $composableBuilder(
    column: $table.facts,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get guidelineIds => $composableBuilder(
    column: $table.guidelineIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get aiNarrative => $composableBuilder(
    column: $table.aiNarrative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiProvider => $composableBuilder(
    column: $table.aiProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InsightStatus, InsightStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$InsightsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $InsightsTable> {
  $$InsightsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facts => $composableBuilder(
    column: $table.facts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guidelineIds => $composableBuilder(
    column: $table.guidelineIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiNarrative => $composableBuilder(
    column: $table.aiNarrative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiProvider => $composableBuilder(
    column: $table.aiProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InsightsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $InsightsTable> {
  $$InsightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InsightType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get facts =>
      $composableBuilder(column: $table.facts, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String> get guidelineIds =>
      $composableBuilder(
        column: $table.guidelineIds,
        builder: (column) => column,
      );

  GeneratedColumn<String> get aiNarrative => $composableBuilder(
    column: $table.aiNarrative,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiProvider => $composableBuilder(
    column: $table.aiProvider,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InsightStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$InsightsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $InsightsTable,
          Insight,
          $$InsightsTableFilterComposer,
          $$InsightsTableOrderingComposer,
          $$InsightsTableAnnotationComposer,
          $$InsightsTableCreateCompanionBuilder,
          $$InsightsTableUpdateCompanionBuilder,
          (Insight, BaseReferences<_$FinanceDatabase, $InsightsTable, Insight>),
          Insight,
          PrefetchHooks Function()
        > {
  $$InsightsTableTableManager(_$FinanceDatabase db, $InsightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InsightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InsightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InsightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<InsightType> type = const Value.absent(),
                Value<Map<String, Object?>> facts = const Value.absent(),
                Value<List<Object?>> guidelineIds = const Value.absent(),
                Value<String?> aiNarrative = const Value.absent(),
                Value<String?> aiProvider = const Value.absent(),
                Value<InsightStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                type: type,
                facts: facts,
                guidelineIds: guidelineIds,
                aiNarrative: aiNarrative,
                aiProvider: aiProvider,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required InsightType type,
                required Map<String, Object?> facts,
                Value<List<Object?>> guidelineIds = const Value.absent(),
                Value<String?> aiNarrative = const Value.absent(),
                Value<String?> aiProvider = const Value.absent(),
                required InsightStatus status,
                Value<int> rowid = const Value.absent(),
              }) => InsightsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                type: type,
                facts: facts,
                guidelineIds: guidelineIds,
                aiNarrative: aiNarrative,
                aiProvider: aiProvider,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InsightsTable, Insight>(table),
                  BaseReferences<_$FinanceDatabase, $InsightsTable, Insight>(
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

typedef $$InsightsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $InsightsTable,
      Insight,
      $$InsightsTableFilterComposer,
      $$InsightsTableOrderingComposer,
      $$InsightsTableAnnotationComposer,
      $$InsightsTableCreateCompanionBuilder,
      $$InsightsTableUpdateCompanionBuilder,
      (Insight, BaseReferences<_$FinanceDatabase, $InsightsTable, Insight>),
      Insight,
      PrefetchHooks Function()
    >;
typedef $$ProposalsTableCreateCompanionBuilder = ProposalsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required Map<String, Object?> target,
  required List<Object?> patch,
  required Map<String, Object?> before,
  required Map<String, Object?> after,
  required String rationale,
  required String proposer,
  required Map<String, Object?> baseVersions,
  required ProposalStatus status,
  required DateTime expiresAt,
  Value<DateTime?> decidedAt,
  Value<int> rowid,
});
typedef $$ProposalsTableUpdateCompanionBuilder = ProposalsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<Map<String, Object?>> target,
  Value<List<Object?>> patch,
  Value<Map<String, Object?>> before,
  Value<Map<String, Object?>> after,
  Value<String> rationale,
  Value<String> proposer,
  Value<Map<String, Object?>> baseVersions,
  Value<ProposalStatus> status,
  Value<DateTime> expiresAt,
  Value<DateTime?> decidedAt,
  Value<int> rowid,
});

class $$ProposalsTableFilterComposer
    extends Composer<_$FinanceDatabase, $ProposalsTable> {
  $$ProposalsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get before => $composableBuilder(
    column: $table.before,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get after => $composableBuilder(
    column: $table.after,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposer => $composableBuilder(
    column: $table.proposer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get baseVersions => $composableBuilder(
    column: $table.baseVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ProposalStatus, ProposalStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProposalsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $ProposalsTable> {
  $$ProposalsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get before => $composableBuilder(
    column: $table.before,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get after => $composableBuilder(
    column: $table.after,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposer => $composableBuilder(
    column: $table.proposer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseVersions => $composableBuilder(
    column: $table.baseVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProposalsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $ProposalsTable> {
  $$ProposalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String> get patch =>
      $composableBuilder(column: $table.patch, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get before =>
      $composableBuilder(column: $table.before, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get after =>
      $composableBuilder(column: $table.after, builder: (column) => column);

  GeneratedColumn<String> get rationale =>
      $composableBuilder(column: $table.rationale, builder: (column) => column);

  GeneratedColumn<String> get proposer =>
      $composableBuilder(column: $table.proposer, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  get baseVersions => $composableBuilder(
    column: $table.baseVersions,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ProposalStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get decidedAt =>
      $composableBuilder(column: $table.decidedAt, builder: (column) => column);
}

class $$ProposalsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $ProposalsTable,
          Proposal,
          $$ProposalsTableFilterComposer,
          $$ProposalsTableOrderingComposer,
          $$ProposalsTableAnnotationComposer,
          $$ProposalsTableCreateCompanionBuilder,
          $$ProposalsTableUpdateCompanionBuilder,
          (
            Proposal,
            BaseReferences<_$FinanceDatabase, $ProposalsTable, Proposal>,
          ),
          Proposal,
          PrefetchHooks Function()
        > {
  $$ProposalsTableTableManager(_$FinanceDatabase db, $ProposalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProposalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProposalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProposalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<Map<String, Object?>> target = const Value.absent(),
                Value<List<Object?>> patch = const Value.absent(),
                Value<Map<String, Object?>> before = const Value.absent(),
                Value<Map<String, Object?>> after = const Value.absent(),
                Value<String> rationale = const Value.absent(),
                Value<String> proposer = const Value.absent(),
                Value<Map<String, Object?>> baseVersions = const Value.absent(),
                Value<ProposalStatus> status = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProposalsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                target: target,
                patch: patch,
                before: before,
                after: after,
                rationale: rationale,
                proposer: proposer,
                baseVersions: baseVersions,
                status: status,
                expiresAt: expiresAt,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required Map<String, Object?> target,
                required List<Object?> patch,
                required Map<String, Object?> before,
                required Map<String, Object?> after,
                required String rationale,
                required String proposer,
                required Map<String, Object?> baseVersions,
                required ProposalStatus status,
                required DateTime expiresAt,
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProposalsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                target: target,
                patch: patch,
                before: before,
                after: after,
                rationale: rationale,
                proposer: proposer,
                baseVersions: baseVersions,
                status: status,
                expiresAt: expiresAt,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProposalsTable, Proposal>(table),
                  BaseReferences<_$FinanceDatabase, $ProposalsTable, Proposal>(
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

typedef $$ProposalsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $ProposalsTable,
      Proposal,
      $$ProposalsTableFilterComposer,
      $$ProposalsTableOrderingComposer,
      $$ProposalsTableAnnotationComposer,
      $$ProposalsTableCreateCompanionBuilder,
      $$ProposalsTableUpdateCompanionBuilder,
      (Proposal, BaseReferences<_$FinanceDatabase, $ProposalsTable, Proposal>),
      Proposal,
      PrefetchHooks Function()
    >;
typedef $$PlanExtensionsTableCreateCompanionBuilder =
    PlanExtensionsCompanion Function({
      required String id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> version,
      required String kind,
      required int schemaVersion,
      required Map<String, Object?> data,
      required ExtensionStatus status,
      Value<int> rowid,
    });
typedef $$PlanExtensionsTableUpdateCompanionBuilder =
    PlanExtensionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> version,
      Value<String> kind,
      Value<int> schemaVersion,
      Value<Map<String, Object?>> data,
      Value<ExtensionStatus> status,
      Value<int> rowid,
    });

class $$PlanExtensionsTableFilterComposer
    extends Composer<_$FinanceDatabase, $PlanExtensionsTable> {
  $$PlanExtensionsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ExtensionStatus, ExtensionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$PlanExtensionsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $PlanExtensionsTable> {
  $$PlanExtensionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanExtensionsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $PlanExtensionsTable> {
  $$PlanExtensionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExtensionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PlanExtensionsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $PlanExtensionsTable,
          PlanExtension,
          $$PlanExtensionsTableFilterComposer,
          $$PlanExtensionsTableOrderingComposer,
          $$PlanExtensionsTableAnnotationComposer,
          $$PlanExtensionsTableCreateCompanionBuilder,
          $$PlanExtensionsTableUpdateCompanionBuilder,
          (
            PlanExtension,
            BaseReferences<
              _$FinanceDatabase,
              $PlanExtensionsTable,
              PlanExtension
            >,
          ),
          PlanExtension,
          PrefetchHooks Function()
        > {
  $$PlanExtensionsTableTableManager(
    _$FinanceDatabase db,
    $PlanExtensionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanExtensionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanExtensionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanExtensionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<Map<String, Object?>> data = const Value.absent(),
                Value<ExtensionStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanExtensionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                schemaVersion: schemaVersion,
                data: data,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String kind,
                required int schemaVersion,
                required Map<String, Object?> data,
                required ExtensionStatus status,
                Value<int> rowid = const Value.absent(),
              }) => PlanExtensionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                kind: kind,
                schemaVersion: schemaVersion,
                data: data,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanExtensionsTable, PlanExtension>(table),
                  BaseReferences<
                    _$FinanceDatabase,
                    $PlanExtensionsTable,
                    PlanExtension
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanExtensionsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $PlanExtensionsTable,
      PlanExtension,
      $$PlanExtensionsTableFilterComposer,
      $$PlanExtensionsTableOrderingComposer,
      $$PlanExtensionsTableAnnotationComposer,
      $$PlanExtensionsTableCreateCompanionBuilder,
      $$PlanExtensionsTableUpdateCompanionBuilder,
      (
        PlanExtension,
        BaseReferences<_$FinanceDatabase, $PlanExtensionsTable, PlanExtension>,
      ),
      PlanExtension,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required int sequence,
  required AuditEvent event,
  required String actor,
  Value<String?> proposalId,
  Value<Map<String, Object?>?> diff,
  required String prevHash,
  required String hash,
  Value<int> rowid,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<int> sequence,
  Value<AuditEvent> event,
  Value<String> actor,
  Value<String?> proposalId,
  Value<Map<String, Object?>?> diff,
  Value<String> prevHash,
  Value<String> hash,
  Value<int> rowid,
});

class $$AuditLogTableFilterComposer
    extends Composer<_$FinanceDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AuditEvent, AuditEvent, String> get event =>
      $composableBuilder(
        column: $table.event,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get diff => $composableBuilder(
    column: $table.diff,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$FinanceDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diff => $composableBuilder(
    column: $table.diff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prevHash => $composableBuilder(
    column: $table.prevHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AuditEvent, String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get proposalId => $composableBuilder(
    column: $table.proposalId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String> get diff =>
      $composableBuilder(column: $table.diff, builder: (column) => column);

  GeneratedColumn<String> get prevHash =>
      $composableBuilder(column: $table.prevHash, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$FinanceDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$FinanceDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<AuditEvent> event = const Value.absent(),
                Value<String> actor = const Value.absent(),
                Value<String?> proposalId = const Value.absent(),
                Value<Map<String, Object?>?> diff = const Value.absent(),
                Value<String> prevHash = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                sequence: sequence,
                event: event,
                actor: actor,
                proposalId: proposalId,
                diff: diff,
                prevHash: prevHash,
                hash: hash,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required int sequence,
                required AuditEvent event,
                required String actor,
                Value<String?> proposalId = const Value.absent(),
                Value<Map<String, Object?>?> diff = const Value.absent(),
                required String prevHash,
                required String hash,
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                sequence: sequence,
                event: event,
                actor: actor,
                proposalId: proposalId,
                diff: diff,
                prevHash: prevHash,
                hash: hash,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditLogTable, AuditLogData>(table),
                  BaseReferences<
                    _$FinanceDatabase,
                    $AuditLogTable,
                    AuditLogData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$FinanceDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$AiRequestsTableCreateCompanionBuilder = AiRequestsCompanion Function({
  required String id,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> version,
  required String feature,
  required String provider,
  required String model,
  required List<Object?> fieldsSent,
  Value<int?> tokenCount,
  required String outcome,
  Value<int> rowid,
});
typedef $$AiRequestsTableUpdateCompanionBuilder = AiRequestsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> version,
  Value<String> feature,
  Value<String> provider,
  Value<String> model,
  Value<List<Object?>> fieldsSent,
  Value<int?> tokenCount,
  Value<String> outcome,
  Value<int> rowid,
});

class $$AiRequestsTableFilterComposer
    extends Composer<_$FinanceDatabase, $AiRequestsTable> {
  $$AiRequestsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get fieldsSent => $composableBuilder(
    column: $table.fieldsSent,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiRequestsTableOrderingComposer
    extends Composer<_$FinanceDatabase, $AiRequestsTable> {
  $$AiRequestsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsSent => $composableBuilder(
    column: $table.fieldsSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiRequestsTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $AiRequestsTable> {
  $$AiRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Object?>, String> get fieldsSent =>
      $composableBuilder(
        column: $table.fieldsSent,
        builder: (column) => column,
      );

  GeneratedColumn<int> get tokenCount => $composableBuilder(
    column: $table.tokenCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);
}

class $$AiRequestsTableTableManager
    extends
        RootTableManager<
          _$FinanceDatabase,
          $AiRequestsTable,
          AiRequest,
          $$AiRequestsTableFilterComposer,
          $$AiRequestsTableOrderingComposer,
          $$AiRequestsTableAnnotationComposer,
          $$AiRequestsTableCreateCompanionBuilder,
          $$AiRequestsTableUpdateCompanionBuilder,
          (
            AiRequest,
            BaseReferences<_$FinanceDatabase, $AiRequestsTable, AiRequest>,
          ),
          AiRequest,
          PrefetchHooks Function()
        > {
  $$AiRequestsTableTableManager(_$FinanceDatabase db, $AiRequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<List<Object?>> fieldsSent = const Value.absent(),
                Value<int?> tokenCount = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiRequestsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                feature: feature,
                provider: provider,
                model: model,
                fieldsSent: fieldsSent,
                tokenCount: tokenCount,
                outcome: outcome,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> version = const Value.absent(),
                required String feature,
                required String provider,
                required String model,
                required List<Object?> fieldsSent,
                Value<int?> tokenCount = const Value.absent(),
                required String outcome,
                Value<int> rowid = const Value.absent(),
              }) => AiRequestsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                feature: feature,
                provider: provider,
                model: model,
                fieldsSent: fieldsSent,
                tokenCount: tokenCount,
                outcome: outcome,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiRequestsTable, AiRequest>(table),
                  BaseReferences<
                    _$FinanceDatabase,
                    $AiRequestsTable,
                    AiRequest
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$FinanceDatabase,
      $AiRequestsTable,
      AiRequest,
      $$AiRequestsTableFilterComposer,
      $$AiRequestsTableOrderingComposer,
      $$AiRequestsTableAnnotationComposer,
      $$AiRequestsTableCreateCompanionBuilder,
      $$AiRequestsTableUpdateCompanionBuilder,
      (
        AiRequest,
        BaseReferences<_$FinanceDatabase, $AiRequestsTable, AiRequest>,
      ),
      AiRequest,
      PrefetchHooks Function()
    >;

class $FinanceDatabaseManager {
  final _$FinanceDatabase _db;
  $FinanceDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$ImportBatchesTableTableManager get importBatches =>
      $$ImportBatchesTableTableManager(_db, _db.importBatches);
  $$SourceRecordsTableTableManager get sourceRecords =>
      $$SourceRecordsTableTableManager(_db, _db.sourceRecords);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CategoryRulesTableTableManager get categoryRules =>
      $$CategoryRulesTableTableManager(_db, _db.categoryRules);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionSourcesTableTableManager get transactionSources =>
      $$TransactionSourcesTableTableManager(_db, _db.transactionSources);
  $$ReconciliationReviewsTableTableManager get reconciliationReviews =>
      $$ReconciliationReviewsTableTableManager(_db, _db.reconciliationReviews);
  $$TrainingLabelsTableTableManager get trainingLabels =>
      $$TrainingLabelsTableTableManager(_db, _db.trainingLabels);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$RecurringSeriesTableTableManager get recurringSeries =>
      $$RecurringSeriesTableTableManager(_db, _db.recurringSeries);
  $$InsightsTableTableManager get insights =>
      $$InsightsTableTableManager(_db, _db.insights);
  $$ProposalsTableTableManager get proposals =>
      $$ProposalsTableTableManager(_db, _db.proposals);
  $$PlanExtensionsTableTableManager get planExtensions =>
      $$PlanExtensionsTableTableManager(_db, _db.planExtensions);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$AiRequestsTableTableManager get aiRequests =>
      $$AiRequestsTableTableManager(_db, _db.aiRequests);
}
