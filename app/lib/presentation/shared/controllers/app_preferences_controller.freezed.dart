// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_preferences_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppPreferences {
  Locale get locale;
  ThemeMode get themeMode;
  AccountingBasis get defaultAccountingBasis;
  bool get amountsVisible;
  Set<TicketDeadlineKind> get enabledReminderKinds;
  bool get onboardingCompleted;
  bool get isSaving;

  /// Create a copy of AppPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppPreferencesCopyWith<AppPreferences> get copyWith =>
      _$AppPreferencesCopyWithImpl<AppPreferences>(
        this as AppPreferences,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppPreferences &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.defaultAccountingBasis, defaultAccountingBasis) ||
                other.defaultAccountingBasis == defaultAccountingBasis) &&
            (identical(other.amountsVisible, amountsVisible) ||
                other.amountsVisible == amountsVisible) &&
            const DeepCollectionEquality().equals(
              other.enabledReminderKinds,
              enabledReminderKinds,
            ) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    locale,
    themeMode,
    defaultAccountingBasis,
    amountsVisible,
    const DeepCollectionEquality().hash(enabledReminderKinds),
    onboardingCompleted,
    isSaving,
  );

  @override
  String toString() {
    return 'AppPreferences(locale: $locale, themeMode: $themeMode, defaultAccountingBasis: $defaultAccountingBasis, amountsVisible: $amountsVisible, enabledReminderKinds: $enabledReminderKinds, onboardingCompleted: $onboardingCompleted, isSaving: $isSaving)';
  }
}

/// @nodoc
abstract mixin class $AppPreferencesCopyWith<$Res> {
  factory $AppPreferencesCopyWith(
    AppPreferences value,
    $Res Function(AppPreferences) _then,
  ) = _$AppPreferencesCopyWithImpl;
  @useResult
  $Res call({
    Locale locale,
    ThemeMode themeMode,
    AccountingBasis defaultAccountingBasis,
    bool amountsVisible,
    Set<TicketDeadlineKind> enabledReminderKinds,
    bool onboardingCompleted,
    bool isSaving,
  });
}

/// @nodoc
class _$AppPreferencesCopyWithImpl<$Res>
    implements $AppPreferencesCopyWith<$Res> {
  _$AppPreferencesCopyWithImpl(this._self, this._then);

  final AppPreferences _self;
  final $Res Function(AppPreferences) _then;

  /// Create a copy of AppPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
    Object? themeMode = null,
    Object? defaultAccountingBasis = null,
    Object? amountsVisible = null,
    Object? enabledReminderKinds = null,
    Object? onboardingCompleted = null,
    Object? isSaving = null,
  }) {
    return _then(
      _self.copyWith(
        locale: null == locale
            ? _self.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as Locale,
        themeMode: null == themeMode
            ? _self.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        defaultAccountingBasis: null == defaultAccountingBasis
            ? _self.defaultAccountingBasis
            : defaultAccountingBasis // ignore: cast_nullable_to_non_nullable
                  as AccountingBasis,
        amountsVisible: null == amountsVisible
            ? _self.amountsVisible
            : amountsVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        enabledReminderKinds: null == enabledReminderKinds
            ? _self.enabledReminderKinds
            : enabledReminderKinds // ignore: cast_nullable_to_non_nullable
                  as Set<TicketDeadlineKind>,
        onboardingCompleted: null == onboardingCompleted
            ? _self.onboardingCompleted
            : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _self.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AppPreferences].
extension AppPreferencesPatterns on AppPreferences {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AppPreferences value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppPreferences() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AppPreferences value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppPreferences():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AppPreferences value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppPreferences() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      Locale locale,
      ThemeMode themeMode,
      AccountingBasis defaultAccountingBasis,
      bool amountsVisible,
      Set<TicketDeadlineKind> enabledReminderKinds,
      bool onboardingCompleted,
      bool isSaving,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppPreferences() when $default != null:
        return $default(
          _that.locale,
          _that.themeMode,
          _that.defaultAccountingBasis,
          _that.amountsVisible,
          _that.enabledReminderKinds,
          _that.onboardingCompleted,
          _that.isSaving,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      Locale locale,
      ThemeMode themeMode,
      AccountingBasis defaultAccountingBasis,
      bool amountsVisible,
      Set<TicketDeadlineKind> enabledReminderKinds,
      bool onboardingCompleted,
      bool isSaving,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppPreferences():
        return $default(
          _that.locale,
          _that.themeMode,
          _that.defaultAccountingBasis,
          _that.amountsVisible,
          _that.enabledReminderKinds,
          _that.onboardingCompleted,
          _that.isSaving,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      Locale locale,
      ThemeMode themeMode,
      AccountingBasis defaultAccountingBasis,
      bool amountsVisible,
      Set<TicketDeadlineKind> enabledReminderKinds,
      bool onboardingCompleted,
      bool isSaving,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppPreferences() when $default != null:
        return $default(
          _that.locale,
          _that.themeMode,
          _that.defaultAccountingBasis,
          _that.amountsVisible,
          _that.enabledReminderKinds,
          _that.onboardingCompleted,
          _that.isSaving,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AppPreferences implements AppPreferences {
  const _AppPreferences({
    required this.locale,
    required this.themeMode,
    required this.defaultAccountingBasis,
    required this.amountsVisible,
    required final Set<TicketDeadlineKind> enabledReminderKinds,
    required this.onboardingCompleted,
    this.isSaving = false,
  }) : _enabledReminderKinds = enabledReminderKinds;

  @override
  final Locale locale;
  @override
  final ThemeMode themeMode;
  @override
  final AccountingBasis defaultAccountingBasis;
  @override
  final bool amountsVisible;
  final Set<TicketDeadlineKind> _enabledReminderKinds;
  @override
  Set<TicketDeadlineKind> get enabledReminderKinds {
    if (_enabledReminderKinds is EqualUnmodifiableSetView)
      return _enabledReminderKinds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_enabledReminderKinds);
  }

  @override
  final bool onboardingCompleted;
  @override
  @JsonKey()
  final bool isSaving;

  /// Create a copy of AppPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppPreferencesCopyWith<_AppPreferences> get copyWith =>
      __$AppPreferencesCopyWithImpl<_AppPreferences>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppPreferences &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.defaultAccountingBasis, defaultAccountingBasis) ||
                other.defaultAccountingBasis == defaultAccountingBasis) &&
            (identical(other.amountsVisible, amountsVisible) ||
                other.amountsVisible == amountsVisible) &&
            const DeepCollectionEquality().equals(
              other._enabledReminderKinds,
              _enabledReminderKinds,
            ) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    locale,
    themeMode,
    defaultAccountingBasis,
    amountsVisible,
    const DeepCollectionEquality().hash(_enabledReminderKinds),
    onboardingCompleted,
    isSaving,
  );

  @override
  String toString() {
    return 'AppPreferences(locale: $locale, themeMode: $themeMode, defaultAccountingBasis: $defaultAccountingBasis, amountsVisible: $amountsVisible, enabledReminderKinds: $enabledReminderKinds, onboardingCompleted: $onboardingCompleted, isSaving: $isSaving)';
  }
}

/// @nodoc
abstract mixin class _$AppPreferencesCopyWith<$Res>
    implements $AppPreferencesCopyWith<$Res> {
  factory _$AppPreferencesCopyWith(
    _AppPreferences value,
    $Res Function(_AppPreferences) _then,
  ) = __$AppPreferencesCopyWithImpl;
  @override
  @useResult
  $Res call({
    Locale locale,
    ThemeMode themeMode,
    AccountingBasis defaultAccountingBasis,
    bool amountsVisible,
    Set<TicketDeadlineKind> enabledReminderKinds,
    bool onboardingCompleted,
    bool isSaving,
  });
}

/// @nodoc
class __$AppPreferencesCopyWithImpl<$Res>
    implements _$AppPreferencesCopyWith<$Res> {
  __$AppPreferencesCopyWithImpl(this._self, this._then);

  final _AppPreferences _self;
  final $Res Function(_AppPreferences) _then;

  /// Create a copy of AppPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? locale = null,
    Object? themeMode = null,
    Object? defaultAccountingBasis = null,
    Object? amountsVisible = null,
    Object? enabledReminderKinds = null,
    Object? onboardingCompleted = null,
    Object? isSaving = null,
  }) {
    return _then(
      _AppPreferences(
        locale: null == locale
            ? _self.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as Locale,
        themeMode: null == themeMode
            ? _self.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeMode,
        defaultAccountingBasis: null == defaultAccountingBasis
            ? _self.defaultAccountingBasis
            : defaultAccountingBasis // ignore: cast_nullable_to_non_nullable
                  as AccountingBasis,
        amountsVisible: null == amountsVisible
            ? _self.amountsVisible
            : amountsVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        enabledReminderKinds: null == enabledReminderKinds
            ? _self._enabledReminderKinds
            : enabledReminderKinds // ignore: cast_nullable_to_non_nullable
                  as Set<TicketDeadlineKind>,
        onboardingCompleted: null == onboardingCompleted
            ? _self.onboardingCompleted
            : onboardingCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSaving: null == isSaving
            ? _self.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
