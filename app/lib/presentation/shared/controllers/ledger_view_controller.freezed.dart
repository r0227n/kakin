// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_view_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LedgerView {
  YearMonth get month;
  AccountingBasis get basis;

  /// Create a copy of LedgerView
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LedgerViewCopyWith<LedgerView> get copyWith =>
      _$LedgerViewCopyWithImpl<LedgerView>(this as LedgerView, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LedgerView &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.basis, basis) || other.basis == basis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, basis);

  @override
  String toString() {
    return 'LedgerView(month: $month, basis: $basis)';
  }
}

/// @nodoc
abstract mixin class $LedgerViewCopyWith<$Res> {
  factory $LedgerViewCopyWith(
    LedgerView value,
    $Res Function(LedgerView) _then,
  ) = _$LedgerViewCopyWithImpl;
  @useResult
  $Res call({YearMonth month, AccountingBasis basis});
}

/// @nodoc
class _$LedgerViewCopyWithImpl<$Res> implements $LedgerViewCopyWith<$Res> {
  _$LedgerViewCopyWithImpl(this._self, this._then);

  final LedgerView _self;
  final $Res Function(LedgerView) _then;

  /// Create a copy of LedgerView
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? month = null, Object? basis = null}) {
    return _then(
      _self.copyWith(
        month: null == month
            ? _self.month
            : month // ignore: cast_nullable_to_non_nullable
                  as YearMonth,
        basis: null == basis
            ? _self.basis
            : basis // ignore: cast_nullable_to_non_nullable
                  as AccountingBasis,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [LedgerView].
extension LedgerViewPatterns on LedgerView {
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
    TResult Function(_LedgerView value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LedgerView() when $default != null:
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
    TResult Function(_LedgerView value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LedgerView():
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
    TResult? Function(_LedgerView value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LedgerView() when $default != null:
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
    TResult Function(YearMonth month, AccountingBasis basis)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LedgerView() when $default != null:
        return $default(_that.month, _that.basis);
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
    TResult Function(YearMonth month, AccountingBasis basis) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LedgerView():
        return $default(_that.month, _that.basis);
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
    TResult? Function(YearMonth month, AccountingBasis basis)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LedgerView() when $default != null:
        return $default(_that.month, _that.basis);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LedgerView implements LedgerView {
  const _LedgerView({required this.month, required this.basis});

  @override
  final YearMonth month;
  @override
  final AccountingBasis basis;

  /// Create a copy of LedgerView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LedgerViewCopyWith<_LedgerView> get copyWith =>
      __$LedgerViewCopyWithImpl<_LedgerView>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LedgerView &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.basis, basis) || other.basis == basis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, month, basis);

  @override
  String toString() {
    return 'LedgerView(month: $month, basis: $basis)';
  }
}

/// @nodoc
abstract mixin class _$LedgerViewCopyWith<$Res>
    implements $LedgerViewCopyWith<$Res> {
  factory _$LedgerViewCopyWith(
    _LedgerView value,
    $Res Function(_LedgerView) _then,
  ) = __$LedgerViewCopyWithImpl;
  @override
  @useResult
  $Res call({YearMonth month, AccountingBasis basis});
}

/// @nodoc
class __$LedgerViewCopyWithImpl<$Res> implements _$LedgerViewCopyWith<$Res> {
  __$LedgerViewCopyWithImpl(this._self, this._then);

  final _LedgerView _self;
  final $Res Function(_LedgerView) _then;

  /// Create a copy of LedgerView
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? month = null, Object? basis = null}) {
    return _then(
      _LedgerView(
        month: null == month
            ? _self.month
            : month // ignore: cast_nullable_to_non_nullable
                  as YearMonth,
        basis: null == basis
            ? _self.basis
            : basis // ignore: cast_nullable_to_non_nullable
                  as AccountingBasis,
      ),
    );
  }
}
