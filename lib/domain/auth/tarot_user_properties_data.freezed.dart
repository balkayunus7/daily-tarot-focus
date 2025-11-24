// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tarot_user_properties_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TarotUserPropertiesData {
  ZodiacSign get zodiac => throw _privateConstructorUsedError;
  RelationshipStatus get relationshipStatus =>
      throw _privateConstructorUsedError;
  DateTime get birthDate => throw _privateConstructorUsedError;

  /// Create a copy of TarotUserPropertiesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TarotUserPropertiesDataCopyWith<TarotUserPropertiesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TarotUserPropertiesDataCopyWith<$Res> {
  factory $TarotUserPropertiesDataCopyWith(
    TarotUserPropertiesData value,
    $Res Function(TarotUserPropertiesData) then,
  ) = _$TarotUserPropertiesDataCopyWithImpl<$Res, TarotUserPropertiesData>;
  @useResult
  $Res call({
    ZodiacSign zodiac,
    RelationshipStatus relationshipStatus,
    DateTime birthDate,
  });
}

/// @nodoc
class _$TarotUserPropertiesDataCopyWithImpl<
  $Res,
  $Val extends TarotUserPropertiesData
>
    implements $TarotUserPropertiesDataCopyWith<$Res> {
  _$TarotUserPropertiesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TarotUserPropertiesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zodiac = null,
    Object? relationshipStatus = null,
    Object? birthDate = null,
  }) {
    return _then(
      _value.copyWith(
            zodiac:
                null == zodiac
                    ? _value.zodiac
                    : zodiac // ignore: cast_nullable_to_non_nullable
                        as ZodiacSign,
            relationshipStatus:
                null == relationshipStatus
                    ? _value.relationshipStatus
                    : relationshipStatus // ignore: cast_nullable_to_non_nullable
                        as RelationshipStatus,
            birthDate:
                null == birthDate
                    ? _value.birthDate
                    : birthDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TarotUserPropertiesDataImplCopyWith<$Res>
    implements $TarotUserPropertiesDataCopyWith<$Res> {
  factory _$$TarotUserPropertiesDataImplCopyWith(
    _$TarotUserPropertiesDataImpl value,
    $Res Function(_$TarotUserPropertiesDataImpl) then,
  ) = __$$TarotUserPropertiesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ZodiacSign zodiac,
    RelationshipStatus relationshipStatus,
    DateTime birthDate,
  });
}

/// @nodoc
class __$$TarotUserPropertiesDataImplCopyWithImpl<$Res>
    extends
        _$TarotUserPropertiesDataCopyWithImpl<
          $Res,
          _$TarotUserPropertiesDataImpl
        >
    implements _$$TarotUserPropertiesDataImplCopyWith<$Res> {
  __$$TarotUserPropertiesDataImplCopyWithImpl(
    _$TarotUserPropertiesDataImpl _value,
    $Res Function(_$TarotUserPropertiesDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TarotUserPropertiesData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zodiac = null,
    Object? relationshipStatus = null,
    Object? birthDate = null,
  }) {
    return _then(
      _$TarotUserPropertiesDataImpl(
        zodiac:
            null == zodiac
                ? _value.zodiac
                : zodiac // ignore: cast_nullable_to_non_nullable
                    as ZodiacSign,
        relationshipStatus:
            null == relationshipStatus
                ? _value.relationshipStatus
                : relationshipStatus // ignore: cast_nullable_to_non_nullable
                    as RelationshipStatus,
        birthDate:
            null == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TarotUserPropertiesDataImpl extends _TarotUserPropertiesData {
  const _$TarotUserPropertiesDataImpl({
    required this.zodiac,
    required this.relationshipStatus,
    required this.birthDate,
  }) : super._();

  @override
  final ZodiacSign zodiac;
  @override
  final RelationshipStatus relationshipStatus;
  @override
  final DateTime birthDate;

  @override
  String toString() {
    return 'TarotUserPropertiesData(zodiac: $zodiac, relationshipStatus: $relationshipStatus, birthDate: $birthDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TarotUserPropertiesDataImpl &&
            (identical(other.zodiac, zodiac) || other.zodiac == zodiac) &&
            (identical(other.relationshipStatus, relationshipStatus) ||
                other.relationshipStatus == relationshipStatus) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, zodiac, relationshipStatus, birthDate);

  /// Create a copy of TarotUserPropertiesData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TarotUserPropertiesDataImplCopyWith<_$TarotUserPropertiesDataImpl>
  get copyWith => __$$TarotUserPropertiesDataImplCopyWithImpl<
    _$TarotUserPropertiesDataImpl
  >(this, _$identity);
}

abstract class _TarotUserPropertiesData extends TarotUserPropertiesData {
  const factory _TarotUserPropertiesData({
    required final ZodiacSign zodiac,
    required final RelationshipStatus relationshipStatus,
    required final DateTime birthDate,
  }) = _$TarotUserPropertiesDataImpl;
  const _TarotUserPropertiesData._() : super._();

  @override
  ZodiacSign get zodiac;
  @override
  RelationshipStatus get relationshipStatus;
  @override
  DateTime get birthDate;

  /// Create a copy of TarotUserPropertiesData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TarotUserPropertiesDataImplCopyWith<_$TarotUserPropertiesDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}
