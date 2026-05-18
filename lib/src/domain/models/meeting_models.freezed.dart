// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meeting {

 String get id; String get title; DateTime get createdAt; DateTime? get startedAt; DateTime? get endedAt; int get durationMs; MeetingStatus get status; bool get isPinned; bool get isFavorite; String get languageCode; String? get summaryPreview; List<String> get tags;
/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCopyWith<Meeting> get copyWith => _$MeetingCopyWithImpl<Meeting>(this as Meeting, _$identity);

  /// Serializes this Meeting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meeting&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.summaryPreview, summaryPreview) || other.summaryPreview == summaryPreview)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,startedAt,endedAt,durationMs,status,isPinned,isFavorite,languageCode,summaryPreview,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'Meeting(id: $id, title: $title, createdAt: $createdAt, startedAt: $startedAt, endedAt: $endedAt, durationMs: $durationMs, status: $status, isPinned: $isPinned, isFavorite: $isFavorite, languageCode: $languageCode, summaryPreview: $summaryPreview, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $MeetingCopyWith<$Res>  {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) _then) = _$MeetingCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime? startedAt, DateTime? endedAt, int durationMs, MeetingStatus status, bool isPinned, bool isFavorite, String languageCode, String? summaryPreview, List<String> tags
});




}
/// @nodoc
class _$MeetingCopyWithImpl<$Res>
    implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._self, this._then);

  final Meeting _self;
  final $Res Function(Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? durationMs = null,Object? status = null,Object? isPinned = null,Object? isFavorite = null,Object? languageCode = null,Object? summaryPreview = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingStatus,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,summaryPreview: freezed == summaryPreview ? _self.summaryPreview : summaryPreview // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Meeting].
extension MeetingPatterns on Meeting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meeting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meeting value)  $default,){
final _that = this;
switch (_that) {
case _Meeting():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meeting value)?  $default,){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime? startedAt,  DateTime? endedAt,  int durationMs,  MeetingStatus status,  bool isPinned,  bool isFavorite,  String languageCode,  String? summaryPreview,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.startedAt,_that.endedAt,_that.durationMs,_that.status,_that.isPinned,_that.isFavorite,_that.languageCode,_that.summaryPreview,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime? startedAt,  DateTime? endedAt,  int durationMs,  MeetingStatus status,  bool isPinned,  bool isFavorite,  String languageCode,  String? summaryPreview,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Meeting():
return $default(_that.id,_that.title,_that.createdAt,_that.startedAt,_that.endedAt,_that.durationMs,_that.status,_that.isPinned,_that.isFavorite,_that.languageCode,_that.summaryPreview,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime createdAt,  DateTime? startedAt,  DateTime? endedAt,  int durationMs,  MeetingStatus status,  bool isPinned,  bool isFavorite,  String languageCode,  String? summaryPreview,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.startedAt,_that.endedAt,_that.durationMs,_that.status,_that.isPinned,_that.isFavorite,_that.languageCode,_that.summaryPreview,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meeting implements Meeting {
  const _Meeting({required this.id, required this.title, required this.createdAt, this.startedAt, this.endedAt, this.durationMs = 0, this.status = MeetingStatus.draft, this.isPinned = false, this.isFavorite = false, this.languageCode = 'auto', this.summaryPreview, final  List<String> tags = const <String>[]}): _tags = tags;
  factory _Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime createdAt;
@override final  DateTime? startedAt;
@override final  DateTime? endedAt;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  MeetingStatus status;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  String languageCode;
@override final  String? summaryPreview;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCopyWith<_Meeting> get copyWith => __$MeetingCopyWithImpl<_Meeting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meeting&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.status, status) || other.status == status)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.summaryPreview, summaryPreview) || other.summaryPreview == summaryPreview)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,startedAt,endedAt,durationMs,status,isPinned,isFavorite,languageCode,summaryPreview,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'Meeting(id: $id, title: $title, createdAt: $createdAt, startedAt: $startedAt, endedAt: $endedAt, durationMs: $durationMs, status: $status, isPinned: $isPinned, isFavorite: $isFavorite, languageCode: $languageCode, summaryPreview: $summaryPreview, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MeetingCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$MeetingCopyWith(_Meeting value, $Res Function(_Meeting) _then) = __$MeetingCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime? startedAt, DateTime? endedAt, int durationMs, MeetingStatus status, bool isPinned, bool isFavorite, String languageCode, String? summaryPreview, List<String> tags
});




}
/// @nodoc
class __$MeetingCopyWithImpl<$Res>
    implements _$MeetingCopyWith<$Res> {
  __$MeetingCopyWithImpl(this._self, this._then);

  final _Meeting _self;
  final $Res Function(_Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? startedAt = freezed,Object? endedAt = freezed,Object? durationMs = null,Object? status = null,Object? isPinned = null,Object? isFavorite = null,Object? languageCode = null,Object? summaryPreview = freezed,Object? tags = null,}) {
  return _then(_Meeting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingStatus,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,summaryPreview: freezed == summaryPreview ? _self.summaryPreview : summaryPreview // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AudioAsset {

 String get id; String get meetingId; AudioSourceKind get source; String get path; int get sampleRate; int get channels; DateTime get createdAt; int get durationMs; int get byteSize;
/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioAssetCopyWith<AudioAsset> get copyWith => _$AudioAssetCopyWithImpl<AudioAsset>(this as AudioAsset, _$identity);

  /// Serializes this AudioAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.source, source) || other.source == source)&&(identical(other.path, path) || other.path == path)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,source,path,sampleRate,channels,createdAt,durationMs,byteSize);

@override
String toString() {
  return 'AudioAsset(id: $id, meetingId: $meetingId, source: $source, path: $path, sampleRate: $sampleRate, channels: $channels, createdAt: $createdAt, durationMs: $durationMs, byteSize: $byteSize)';
}


}

/// @nodoc
abstract mixin class $AudioAssetCopyWith<$Res>  {
  factory $AudioAssetCopyWith(AudioAsset value, $Res Function(AudioAsset) _then) = _$AudioAssetCopyWithImpl;
@useResult
$Res call({
 String id, String meetingId, AudioSourceKind source, String path, int sampleRate, int channels, DateTime createdAt, int durationMs, int byteSize
});




}
/// @nodoc
class _$AudioAssetCopyWithImpl<$Res>
    implements $AudioAssetCopyWith<$Res> {
  _$AudioAssetCopyWithImpl(this._self, this._then);

  final AudioAsset _self;
  final $Res Function(AudioAsset) _then;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? meetingId = null,Object? source = null,Object? path = null,Object? sampleRate = null,Object? channels = null,Object? createdAt = null,Object? durationMs = null,Object? byteSize = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioAsset].
extension AudioAssetPatterns on AudioAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioAsset value)  $default,){
final _that = this;
switch (_that) {
case _AudioAsset():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioAsset value)?  $default,){
final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String meetingId,  AudioSourceKind source,  String path,  int sampleRate,  int channels,  DateTime createdAt,  int durationMs,  int byteSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that.id,_that.meetingId,_that.source,_that.path,_that.sampleRate,_that.channels,_that.createdAt,_that.durationMs,_that.byteSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String meetingId,  AudioSourceKind source,  String path,  int sampleRate,  int channels,  DateTime createdAt,  int durationMs,  int byteSize)  $default,) {final _that = this;
switch (_that) {
case _AudioAsset():
return $default(_that.id,_that.meetingId,_that.source,_that.path,_that.sampleRate,_that.channels,_that.createdAt,_that.durationMs,_that.byteSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String meetingId,  AudioSourceKind source,  String path,  int sampleRate,  int channels,  DateTime createdAt,  int durationMs,  int byteSize)?  $default,) {final _that = this;
switch (_that) {
case _AudioAsset() when $default != null:
return $default(_that.id,_that.meetingId,_that.source,_that.path,_that.sampleRate,_that.channels,_that.createdAt,_that.durationMs,_that.byteSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioAsset implements AudioAsset {
  const _AudioAsset({required this.id, required this.meetingId, required this.source, required this.path, required this.sampleRate, required this.channels, required this.createdAt, this.durationMs = 0, this.byteSize = 0});
  factory _AudioAsset.fromJson(Map<String, dynamic> json) => _$AudioAssetFromJson(json);

@override final  String id;
@override final  String meetingId;
@override final  AudioSourceKind source;
@override final  String path;
@override final  int sampleRate;
@override final  int channels;
@override final  DateTime createdAt;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  int byteSize;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioAssetCopyWith<_AudioAsset> get copyWith => __$AudioAssetCopyWithImpl<_AudioAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.source, source) || other.source == source)&&(identical(other.path, path) || other.path == path)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,source,path,sampleRate,channels,createdAt,durationMs,byteSize);

@override
String toString() {
  return 'AudioAsset(id: $id, meetingId: $meetingId, source: $source, path: $path, sampleRate: $sampleRate, channels: $channels, createdAt: $createdAt, durationMs: $durationMs, byteSize: $byteSize)';
}


}

/// @nodoc
abstract mixin class _$AudioAssetCopyWith<$Res> implements $AudioAssetCopyWith<$Res> {
  factory _$AudioAssetCopyWith(_AudioAsset value, $Res Function(_AudioAsset) _then) = __$AudioAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String meetingId, AudioSourceKind source, String path, int sampleRate, int channels, DateTime createdAt, int durationMs, int byteSize
});




}
/// @nodoc
class __$AudioAssetCopyWithImpl<$Res>
    implements _$AudioAssetCopyWith<$Res> {
  __$AudioAssetCopyWithImpl(this._self, this._then);

  final _AudioAsset _self;
  final $Res Function(_AudioAsset) _then;

/// Create a copy of AudioAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? meetingId = null,Object? source = null,Object? path = null,Object? sampleRate = null,Object? channels = null,Object? createdAt = null,Object? durationMs = null,Object? byteSize = null,}) {
  return _then(_AudioAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TranscriptSegment {

 String get id; String get meetingId; AudioSourceKind get source; int get startMs; int get endMs; String get text; String? get speakerLabel; double? get confidence; bool get isFinal; List<String> get tags;
/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptSegmentCopyWith<TranscriptSegment> get copyWith => _$TranscriptSegmentCopyWithImpl<TranscriptSegment>(this as TranscriptSegment, _$identity);

  /// Serializes this TranscriptSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptSegment&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.source, source) || other.source == source)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.endMs, endMs) || other.endMs == endMs)&&(identical(other.text, text) || other.text == text)&&(identical(other.speakerLabel, speakerLabel) || other.speakerLabel == speakerLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,source,startMs,endMs,text,speakerLabel,confidence,isFinal,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'TranscriptSegment(id: $id, meetingId: $meetingId, source: $source, startMs: $startMs, endMs: $endMs, text: $text, speakerLabel: $speakerLabel, confidence: $confidence, isFinal: $isFinal, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $TranscriptSegmentCopyWith<$Res>  {
  factory $TranscriptSegmentCopyWith(TranscriptSegment value, $Res Function(TranscriptSegment) _then) = _$TranscriptSegmentCopyWithImpl;
@useResult
$Res call({
 String id, String meetingId, AudioSourceKind source, int startMs, int endMs, String text, String? speakerLabel, double? confidence, bool isFinal, List<String> tags
});




}
/// @nodoc
class _$TranscriptSegmentCopyWithImpl<$Res>
    implements $TranscriptSegmentCopyWith<$Res> {
  _$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final TranscriptSegment _self;
  final $Res Function(TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? meetingId = null,Object? source = null,Object? startMs = null,Object? endMs = null,Object? text = null,Object? speakerLabel = freezed,Object? confidence = freezed,Object? isFinal = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,endMs: null == endMs ? _self.endMs : endMs // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,speakerLabel: freezed == speakerLabel ? _self.speakerLabel : speakerLabel // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptSegment].
extension TranscriptSegmentPatterns on TranscriptSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptSegment value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptSegment value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String meetingId,  AudioSourceKind source,  int startMs,  int endMs,  String text,  String? speakerLabel,  double? confidence,  bool isFinal,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.id,_that.meetingId,_that.source,_that.startMs,_that.endMs,_that.text,_that.speakerLabel,_that.confidence,_that.isFinal,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String meetingId,  AudioSourceKind source,  int startMs,  int endMs,  String text,  String? speakerLabel,  double? confidence,  bool isFinal,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment():
return $default(_that.id,_that.meetingId,_that.source,_that.startMs,_that.endMs,_that.text,_that.speakerLabel,_that.confidence,_that.isFinal,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String meetingId,  AudioSourceKind source,  int startMs,  int endMs,  String text,  String? speakerLabel,  double? confidence,  bool isFinal,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.id,_that.meetingId,_that.source,_that.startMs,_that.endMs,_that.text,_that.speakerLabel,_that.confidence,_that.isFinal,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranscriptSegment implements TranscriptSegment {
  const _TranscriptSegment({required this.id, required this.meetingId, required this.source, required this.startMs, required this.endMs, required this.text, this.speakerLabel, this.confidence, this.isFinal = true, final  List<String> tags = const <String>[]}): _tags = tags;
  factory _TranscriptSegment.fromJson(Map<String, dynamic> json) => _$TranscriptSegmentFromJson(json);

@override final  String id;
@override final  String meetingId;
@override final  AudioSourceKind source;
@override final  int startMs;
@override final  int endMs;
@override final  String text;
@override final  String? speakerLabel;
@override final  double? confidence;
@override@JsonKey() final  bool isFinal;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptSegmentCopyWith<_TranscriptSegment> get copyWith => __$TranscriptSegmentCopyWithImpl<_TranscriptSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptSegment&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.source, source) || other.source == source)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.endMs, endMs) || other.endMs == endMs)&&(identical(other.text, text) || other.text == text)&&(identical(other.speakerLabel, speakerLabel) || other.speakerLabel == speakerLabel)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,source,startMs,endMs,text,speakerLabel,confidence,isFinal,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'TranscriptSegment(id: $id, meetingId: $meetingId, source: $source, startMs: $startMs, endMs: $endMs, text: $text, speakerLabel: $speakerLabel, confidence: $confidence, isFinal: $isFinal, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$TranscriptSegmentCopyWith<$Res> implements $TranscriptSegmentCopyWith<$Res> {
  factory _$TranscriptSegmentCopyWith(_TranscriptSegment value, $Res Function(_TranscriptSegment) _then) = __$TranscriptSegmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String meetingId, AudioSourceKind source, int startMs, int endMs, String text, String? speakerLabel, double? confidence, bool isFinal, List<String> tags
});




}
/// @nodoc
class __$TranscriptSegmentCopyWithImpl<$Res>
    implements _$TranscriptSegmentCopyWith<$Res> {
  __$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final _TranscriptSegment _self;
  final $Res Function(_TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? meetingId = null,Object? source = null,Object? startMs = null,Object? endMs = null,Object? text = null,Object? speakerLabel = freezed,Object? confidence = freezed,Object? isFinal = null,Object? tags = null,}) {
  return _then(_TranscriptSegment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,endMs: null == endMs ? _self.endMs : endMs // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,speakerLabel: freezed == speakerLabel ? _self.speakerLabel : speakerLabel // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SummaryChapter {

 String get id; String get title; String get summary; int get startMs; int get endMs; List<String> get evidenceSegmentIds;
/// Create a copy of SummaryChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryChapterCopyWith<SummaryChapter> get copyWith => _$SummaryChapterCopyWithImpl<SummaryChapter>(this as SummaryChapter, _$identity);

  /// Serializes this SummaryChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.endMs, endMs) || other.endMs == endMs)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,summary,startMs,endMs,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'SummaryChapter(id: $id, title: $title, summary: $summary, startMs: $startMs, endMs: $endMs, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $SummaryChapterCopyWith<$Res>  {
  factory $SummaryChapterCopyWith(SummaryChapter value, $Res Function(SummaryChapter) _then) = _$SummaryChapterCopyWithImpl;
@useResult
$Res call({
 String id, String title, String summary, int startMs, int endMs, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$SummaryChapterCopyWithImpl<$Res>
    implements $SummaryChapterCopyWith<$Res> {
  _$SummaryChapterCopyWithImpl(this._self, this._then);

  final SummaryChapter _self;
  final $Res Function(SummaryChapter) _then;

/// Create a copy of SummaryChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? startMs = null,Object? endMs = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,endMs: null == endMs ? _self.endMs : endMs // ignore: cast_nullable_to_non_nullable
as int,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SummaryChapter].
extension SummaryChapterPatterns on SummaryChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryChapter() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryChapter value)  $default,){
final _that = this;
switch (_that) {
case _SummaryChapter():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryChapter value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryChapter() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  int startMs,  int endMs,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryChapter() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.startMs,_that.endMs,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String summary,  int startMs,  int endMs,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _SummaryChapter():
return $default(_that.id,_that.title,_that.summary,_that.startMs,_that.endMs,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String summary,  int startMs,  int endMs,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _SummaryChapter() when $default != null:
return $default(_that.id,_that.title,_that.summary,_that.startMs,_that.endMs,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SummaryChapter implements SummaryChapter {
  const _SummaryChapter({required this.id, required this.title, required this.summary, this.startMs = 0, this.endMs = 0, final  List<String> evidenceSegmentIds = const <String>[]}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _SummaryChapter.fromJson(Map<String, dynamic> json) => _$SummaryChapterFromJson(json);

@override final  String id;
@override final  String title;
@override final  String summary;
@override@JsonKey() final  int startMs;
@override@JsonKey() final  int endMs;
 final  List<String> _evidenceSegmentIds;
@override@JsonKey() List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of SummaryChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryChapterCopyWith<_SummaryChapter> get copyWith => __$SummaryChapterCopyWithImpl<_SummaryChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SummaryChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.startMs, startMs) || other.startMs == startMs)&&(identical(other.endMs, endMs) || other.endMs == endMs)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,summary,startMs,endMs,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'SummaryChapter(id: $id, title: $title, summary: $summary, startMs: $startMs, endMs: $endMs, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$SummaryChapterCopyWith<$Res> implements $SummaryChapterCopyWith<$Res> {
  factory _$SummaryChapterCopyWith(_SummaryChapter value, $Res Function(_SummaryChapter) _then) = __$SummaryChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String summary, int startMs, int endMs, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$SummaryChapterCopyWithImpl<$Res>
    implements _$SummaryChapterCopyWith<$Res> {
  __$SummaryChapterCopyWithImpl(this._self, this._then);

  final _SummaryChapter _self;
  final $Res Function(_SummaryChapter) _then;

/// Create a copy of SummaryChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? summary = null,Object? startMs = null,Object? endMs = null,Object? evidenceSegmentIds = null,}) {
  return _then(_SummaryChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,startMs: null == startMs ? _self.startMs : startMs // ignore: cast_nullable_to_non_nullable
as int,endMs: null == endMs ? _self.endMs : endMs // ignore: cast_nullable_to_non_nullable
as int,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ActionItem {

 String get id; String get text; String? get owner; String? get dueDate; bool get done; List<String> get evidenceSegmentIds;
/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemCopyWith<ActionItem> get copyWith => _$ActionItemCopyWithImpl<ActionItem>(this as ActionItem, _$identity);

  /// Serializes this ActionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.done, done) || other.done == done)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,owner,dueDate,done,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'ActionItem(id: $id, text: $text, owner: $owner, dueDate: $dueDate, done: $done, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $ActionItemCopyWith<$Res>  {
  factory $ActionItemCopyWith(ActionItem value, $Res Function(ActionItem) _then) = _$ActionItemCopyWithImpl;
@useResult
$Res call({
 String id, String text, String? owner, String? dueDate, bool done, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$ActionItemCopyWithImpl<$Res>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._self, this._then);

  final ActionItem _self;
  final $Res Function(ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? owner = freezed,Object? dueDate = freezed,Object? done = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItem].
extension ActionItemPatterns on ActionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItem value)  $default,){
final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String? owner,  String? dueDate,  bool done,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.text,_that.owner,_that.dueDate,_that.done,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String? owner,  String? dueDate,  bool done,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that.id,_that.text,_that.owner,_that.dueDate,_that.done,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String? owner,  String? dueDate,  bool done,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.text,_that.owner,_that.dueDate,_that.done,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionItem implements ActionItem {
  const _ActionItem({required this.id, required this.text, this.owner, this.dueDate, this.done = false, final  List<String> evidenceSegmentIds = const <String>[]}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _ActionItem.fromJson(Map<String, dynamic> json) => _$ActionItemFromJson(json);

@override final  String id;
@override final  String text;
@override final  String? owner;
@override final  String? dueDate;
@override@JsonKey() final  bool done;
 final  List<String> _evidenceSegmentIds;
@override@JsonKey() List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemCopyWith<_ActionItem> get copyWith => __$ActionItemCopyWithImpl<_ActionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.done, done) || other.done == done)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,owner,dueDate,done,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'ActionItem(id: $id, text: $text, owner: $owner, dueDate: $dueDate, done: $done, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$ActionItemCopyWith<$Res> implements $ActionItemCopyWith<$Res> {
  factory _$ActionItemCopyWith(_ActionItem value, $Res Function(_ActionItem) _then) = __$ActionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String? owner, String? dueDate, bool done, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$ActionItemCopyWithImpl<$Res>
    implements _$ActionItemCopyWith<$Res> {
  __$ActionItemCopyWithImpl(this._self, this._then);

  final _ActionItem _self;
  final $Res Function(_ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? owner = freezed,Object? dueDate = freezed,Object? done = null,Object? evidenceSegmentIds = null,}) {
  return _then(_ActionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DecisionItem {

 String get id; String get text; String? get rationale; List<String> get evidenceSegmentIds;
/// Create a copy of DecisionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DecisionItemCopyWith<DecisionItem> get copyWith => _$DecisionItemCopyWithImpl<DecisionItem>(this as DecisionItem, _$identity);

  /// Serializes this DecisionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecisionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'DecisionItem(id: $id, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $DecisionItemCopyWith<$Res>  {
  factory $DecisionItemCopyWith(DecisionItem value, $Res Function(DecisionItem) _then) = _$DecisionItemCopyWithImpl;
@useResult
$Res call({
 String id, String text, String? rationale, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$DecisionItemCopyWithImpl<$Res>
    implements $DecisionItemCopyWith<$Res> {
  _$DecisionItemCopyWithImpl(this._self, this._then);

  final DecisionItem _self;
  final $Res Function(DecisionItem) _then;

/// Create a copy of DecisionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? rationale = freezed,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DecisionItem].
extension DecisionItemPatterns on DecisionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DecisionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DecisionItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DecisionItem value)  $default,){
final _that = this;
switch (_that) {
case _DecisionItem():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DecisionItem value)?  $default,){
final _that = this;
switch (_that) {
case _DecisionItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String? rationale,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DecisionItem() when $default != null:
return $default(_that.id,_that.text,_that.rationale,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String? rationale,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _DecisionItem():
return $default(_that.id,_that.text,_that.rationale,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String? rationale,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _DecisionItem() when $default != null:
return $default(_that.id,_that.text,_that.rationale,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DecisionItem implements DecisionItem {
  const _DecisionItem({required this.id, required this.text, this.rationale, final  List<String> evidenceSegmentIds = const <String>[]}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _DecisionItem.fromJson(Map<String, dynamic> json) => _$DecisionItemFromJson(json);

@override final  String id;
@override final  String text;
@override final  String? rationale;
 final  List<String> _evidenceSegmentIds;
@override@JsonKey() List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of DecisionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DecisionItemCopyWith<_DecisionItem> get copyWith => __$DecisionItemCopyWithImpl<_DecisionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DecisionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DecisionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'DecisionItem(id: $id, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$DecisionItemCopyWith<$Res> implements $DecisionItemCopyWith<$Res> {
  factory _$DecisionItemCopyWith(_DecisionItem value, $Res Function(_DecisionItem) _then) = __$DecisionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String? rationale, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$DecisionItemCopyWithImpl<$Res>
    implements _$DecisionItemCopyWith<$Res> {
  __$DecisionItemCopyWithImpl(this._self, this._then);

  final _DecisionItem _self;
  final $Res Function(_DecisionItem) _then;

/// Create a copy of DecisionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? rationale = freezed,Object? evidenceSegmentIds = null,}) {
  return _then(_DecisionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: freezed == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String?,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$OpenQuestion {

 String get id; String get text; String? get owner; List<String> get evidenceSegmentIds;
/// Create a copy of OpenQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenQuestionCopyWith<OpenQuestion> get copyWith => _$OpenQuestionCopyWithImpl<OpenQuestion>(this as OpenQuestion, _$identity);

  /// Serializes this OpenQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,owner,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'OpenQuestion(id: $id, text: $text, owner: $owner, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $OpenQuestionCopyWith<$Res>  {
  factory $OpenQuestionCopyWith(OpenQuestion value, $Res Function(OpenQuestion) _then) = _$OpenQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String text, String? owner, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$OpenQuestionCopyWithImpl<$Res>
    implements $OpenQuestionCopyWith<$Res> {
  _$OpenQuestionCopyWithImpl(this._self, this._then);

  final OpenQuestion _self;
  final $Res Function(OpenQuestion) _then;

/// Create a copy of OpenQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? owner = freezed,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenQuestion].
extension OpenQuestionPatterns on OpenQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenQuestion() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenQuestion value)  $default,){
final _that = this;
switch (_that) {
case _OpenQuestion():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _OpenQuestion() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  String? owner,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenQuestion() when $default != null:
return $default(_that.id,_that.text,_that.owner,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  String? owner,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _OpenQuestion():
return $default(_that.id,_that.text,_that.owner,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  String? owner,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _OpenQuestion() when $default != null:
return $default(_that.id,_that.text,_that.owner,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenQuestion implements OpenQuestion {
  const _OpenQuestion({required this.id, required this.text, this.owner, final  List<String> evidenceSegmentIds = const <String>[]}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _OpenQuestion.fromJson(Map<String, dynamic> json) => _$OpenQuestionFromJson(json);

@override final  String id;
@override final  String text;
@override final  String? owner;
 final  List<String> _evidenceSegmentIds;
@override@JsonKey() List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of OpenQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenQuestionCopyWith<_OpenQuestion> get copyWith => __$OpenQuestionCopyWithImpl<_OpenQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,owner,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'OpenQuestion(id: $id, text: $text, owner: $owner, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$OpenQuestionCopyWith<$Res> implements $OpenQuestionCopyWith<$Res> {
  factory _$OpenQuestionCopyWith(_OpenQuestion value, $Res Function(_OpenQuestion) _then) = __$OpenQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, String? owner, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$OpenQuestionCopyWithImpl<$Res>
    implements _$OpenQuestionCopyWith<$Res> {
  __$OpenQuestionCopyWithImpl(this._self, this._then);

  final _OpenQuestion _self;
  final $Res Function(_OpenQuestion) _then;

/// Create a copy of OpenQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? owner = freezed,Object? evidenceSegmentIds = null,}) {
  return _then(_OpenQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$MeetingSummary {

 String get meetingId; String get generatedTitle; String get overview; DateTime get createdAt; List<SummaryChapter> get chapters; List<ActionItem> get actionItems; List<DecisionItem> get decisions; List<OpenQuestion> get openQuestions; List<String> get followUpSuggestions; List<String> get tags;
/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingSummaryCopyWith<MeetingSummary> get copyWith => _$MeetingSummaryCopyWithImpl<MeetingSummary>(this as MeetingSummary, _$identity);

  /// Serializes this MeetingSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingSummary&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.generatedTitle, generatedTitle) || other.generatedTitle == generatedTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&const DeepCollectionEquality().equals(other.actionItems, actionItems)&&const DeepCollectionEquality().equals(other.decisions, decisions)&&const DeepCollectionEquality().equals(other.openQuestions, openQuestions)&&const DeepCollectionEquality().equals(other.followUpSuggestions, followUpSuggestions)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meetingId,generatedTitle,overview,createdAt,const DeepCollectionEquality().hash(chapters),const DeepCollectionEquality().hash(actionItems),const DeepCollectionEquality().hash(decisions),const DeepCollectionEquality().hash(openQuestions),const DeepCollectionEquality().hash(followUpSuggestions),const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'MeetingSummary(meetingId: $meetingId, generatedTitle: $generatedTitle, overview: $overview, createdAt: $createdAt, chapters: $chapters, actionItems: $actionItems, decisions: $decisions, openQuestions: $openQuestions, followUpSuggestions: $followUpSuggestions, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $MeetingSummaryCopyWith<$Res>  {
  factory $MeetingSummaryCopyWith(MeetingSummary value, $Res Function(MeetingSummary) _then) = _$MeetingSummaryCopyWithImpl;
@useResult
$Res call({
 String meetingId, String generatedTitle, String overview, DateTime createdAt, List<SummaryChapter> chapters, List<ActionItem> actionItems, List<DecisionItem> decisions, List<OpenQuestion> openQuestions, List<String> followUpSuggestions, List<String> tags
});




}
/// @nodoc
class _$MeetingSummaryCopyWithImpl<$Res>
    implements $MeetingSummaryCopyWith<$Res> {
  _$MeetingSummaryCopyWithImpl(this._self, this._then);

  final MeetingSummary _self;
  final $Res Function(MeetingSummary) _then;

/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? generatedTitle = null,Object? overview = null,Object? createdAt = null,Object? chapters = null,Object? actionItems = null,Object? decisions = null,Object? openQuestions = null,Object? followUpSuggestions = null,Object? tags = null,}) {
  return _then(_self.copyWith(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,generatedTitle: null == generatedTitle ? _self.generatedTitle : generatedTitle // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<SummaryChapter>,actionItems: null == actionItems ? _self.actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,decisions: null == decisions ? _self.decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<DecisionItem>,openQuestions: null == openQuestions ? _self.openQuestions : openQuestions // ignore: cast_nullable_to_non_nullable
as List<OpenQuestion>,followUpSuggestions: null == followUpSuggestions ? _self.followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingSummary].
extension MeetingSummaryPatterns on MeetingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingSummary value)  $default,){
final _that = this;
switch (_that) {
case _MeetingSummary():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String meetingId,  String generatedTitle,  String overview,  DateTime createdAt,  List<SummaryChapter> chapters,  List<ActionItem> actionItems,  List<DecisionItem> decisions,  List<OpenQuestion> openQuestions,  List<String> followUpSuggestions,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that.meetingId,_that.generatedTitle,_that.overview,_that.createdAt,_that.chapters,_that.actionItems,_that.decisions,_that.openQuestions,_that.followUpSuggestions,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String meetingId,  String generatedTitle,  String overview,  DateTime createdAt,  List<SummaryChapter> chapters,  List<ActionItem> actionItems,  List<DecisionItem> decisions,  List<OpenQuestion> openQuestions,  List<String> followUpSuggestions,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _MeetingSummary():
return $default(_that.meetingId,_that.generatedTitle,_that.overview,_that.createdAt,_that.chapters,_that.actionItems,_that.decisions,_that.openQuestions,_that.followUpSuggestions,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String meetingId,  String generatedTitle,  String overview,  DateTime createdAt,  List<SummaryChapter> chapters,  List<ActionItem> actionItems,  List<DecisionItem> decisions,  List<OpenQuestion> openQuestions,  List<String> followUpSuggestions,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _MeetingSummary() when $default != null:
return $default(_that.meetingId,_that.generatedTitle,_that.overview,_that.createdAt,_that.chapters,_that.actionItems,_that.decisions,_that.openQuestions,_that.followUpSuggestions,_that.tags);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MeetingSummary implements MeetingSummary {
  const _MeetingSummary({required this.meetingId, required this.generatedTitle, required this.overview, required this.createdAt, final  List<SummaryChapter> chapters = const <SummaryChapter>[], final  List<ActionItem> actionItems = const <ActionItem>[], final  List<DecisionItem> decisions = const <DecisionItem>[], final  List<OpenQuestion> openQuestions = const <OpenQuestion>[], final  List<String> followUpSuggestions = const <String>[], final  List<String> tags = const <String>[]}): _chapters = chapters,_actionItems = actionItems,_decisions = decisions,_openQuestions = openQuestions,_followUpSuggestions = followUpSuggestions,_tags = tags;
  factory _MeetingSummary.fromJson(Map<String, dynamic> json) => _$MeetingSummaryFromJson(json);

@override final  String meetingId;
@override final  String generatedTitle;
@override final  String overview;
@override final  DateTime createdAt;
 final  List<SummaryChapter> _chapters;
@override@JsonKey() List<SummaryChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}

 final  List<ActionItem> _actionItems;
@override@JsonKey() List<ActionItem> get actionItems {
  if (_actionItems is EqualUnmodifiableListView) return _actionItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionItems);
}

 final  List<DecisionItem> _decisions;
@override@JsonKey() List<DecisionItem> get decisions {
  if (_decisions is EqualUnmodifiableListView) return _decisions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_decisions);
}

 final  List<OpenQuestion> _openQuestions;
@override@JsonKey() List<OpenQuestion> get openQuestions {
  if (_openQuestions is EqualUnmodifiableListView) return _openQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openQuestions);
}

 final  List<String> _followUpSuggestions;
@override@JsonKey() List<String> get followUpSuggestions {
  if (_followUpSuggestions is EqualUnmodifiableListView) return _followUpSuggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followUpSuggestions);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingSummaryCopyWith<_MeetingSummary> get copyWith => __$MeetingSummaryCopyWithImpl<_MeetingSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingSummary&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.generatedTitle, generatedTitle) || other.generatedTitle == generatedTitle)&&(identical(other.overview, overview) || other.overview == overview)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&const DeepCollectionEquality().equals(other._actionItems, _actionItems)&&const DeepCollectionEquality().equals(other._decisions, _decisions)&&const DeepCollectionEquality().equals(other._openQuestions, _openQuestions)&&const DeepCollectionEquality().equals(other._followUpSuggestions, _followUpSuggestions)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meetingId,generatedTitle,overview,createdAt,const DeepCollectionEquality().hash(_chapters),const DeepCollectionEquality().hash(_actionItems),const DeepCollectionEquality().hash(_decisions),const DeepCollectionEquality().hash(_openQuestions),const DeepCollectionEquality().hash(_followUpSuggestions),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'MeetingSummary(meetingId: $meetingId, generatedTitle: $generatedTitle, overview: $overview, createdAt: $createdAt, chapters: $chapters, actionItems: $actionItems, decisions: $decisions, openQuestions: $openQuestions, followUpSuggestions: $followUpSuggestions, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MeetingSummaryCopyWith<$Res> implements $MeetingSummaryCopyWith<$Res> {
  factory _$MeetingSummaryCopyWith(_MeetingSummary value, $Res Function(_MeetingSummary) _then) = __$MeetingSummaryCopyWithImpl;
@override @useResult
$Res call({
 String meetingId, String generatedTitle, String overview, DateTime createdAt, List<SummaryChapter> chapters, List<ActionItem> actionItems, List<DecisionItem> decisions, List<OpenQuestion> openQuestions, List<String> followUpSuggestions, List<String> tags
});




}
/// @nodoc
class __$MeetingSummaryCopyWithImpl<$Res>
    implements _$MeetingSummaryCopyWith<$Res> {
  __$MeetingSummaryCopyWithImpl(this._self, this._then);

  final _MeetingSummary _self;
  final $Res Function(_MeetingSummary) _then;

/// Create a copy of MeetingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? generatedTitle = null,Object? overview = null,Object? createdAt = null,Object? chapters = null,Object? actionItems = null,Object? decisions = null,Object? openQuestions = null,Object? followUpSuggestions = null,Object? tags = null,}) {
  return _then(_MeetingSummary(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,generatedTitle: null == generatedTitle ? _self.generatedTitle : generatedTitle // ignore: cast_nullable_to_non_nullable
as String,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<SummaryChapter>,actionItems: null == actionItems ? _self._actionItems : actionItems // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,decisions: null == decisions ? _self._decisions : decisions // ignore: cast_nullable_to_non_nullable
as List<DecisionItem>,openQuestions: null == openQuestions ? _self._openQuestions : openQuestions // ignore: cast_nullable_to_non_nullable
as List<OpenQuestion>,followUpSuggestions: null == followUpSuggestions ? _self._followUpSuggestions : followUpSuggestions // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get meetingId; ChatRole get role; String get content; DateTime get createdAt; bool get isStreaming; List<String> get evidenceSegmentIds;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,role,content,createdAt,isStreaming,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'ChatMessage(id: $id, meetingId: $meetingId, role: $role, content: $content, createdAt: $createdAt, isStreaming: $isStreaming, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String meetingId, ChatRole role, String content, DateTime createdAt, bool isStreaming, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? meetingId = null,Object? role = null,Object? content = null,Object? createdAt = null,Object? isStreaming = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String meetingId,  ChatRole role,  String content,  DateTime createdAt,  bool isStreaming,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.meetingId,_that.role,_that.content,_that.createdAt,_that.isStreaming,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String meetingId,  ChatRole role,  String content,  DateTime createdAt,  bool isStreaming,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.meetingId,_that.role,_that.content,_that.createdAt,_that.isStreaming,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String meetingId,  ChatRole role,  String content,  DateTime createdAt,  bool isStreaming,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.meetingId,_that.role,_that.content,_that.createdAt,_that.isStreaming,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.meetingId, required this.role, required this.content, required this.createdAt, this.isStreaming = false, final  List<String> evidenceSegmentIds = const <String>[]}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String meetingId;
@override final  ChatRole role;
@override final  String content;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isStreaming;
 final  List<String> _evidenceSegmentIds;
@override@JsonKey() List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,meetingId,role,content,createdAt,isStreaming,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'ChatMessage(id: $id, meetingId: $meetingId, role: $role, content: $content, createdAt: $createdAt, isStreaming: $isStreaming, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String meetingId, ChatRole role, String content, DateTime createdAt, bool isStreaming, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? meetingId = null,Object? role = null,Object? content = null,Object? createdAt = null,Object? isStreaming = null,Object? evidenceSegmentIds = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as ChatRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$AudioDeviceInfo {

 String get id; String get name; AudioSourceKind get source; bool get isDefault; int get channels;
/// Create a copy of AudioDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioDeviceInfoCopyWith<AudioDeviceInfo> get copyWith => _$AudioDeviceInfoCopyWithImpl<AudioDeviceInfo>(this as AudioDeviceInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioDeviceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,source,isDefault,channels);

@override
String toString() {
  return 'AudioDeviceInfo(id: $id, name: $name, source: $source, isDefault: $isDefault, channels: $channels)';
}


}

/// @nodoc
abstract mixin class $AudioDeviceInfoCopyWith<$Res>  {
  factory $AudioDeviceInfoCopyWith(AudioDeviceInfo value, $Res Function(AudioDeviceInfo) _then) = _$AudioDeviceInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, AudioSourceKind source, bool isDefault, int channels
});




}
/// @nodoc
class _$AudioDeviceInfoCopyWithImpl<$Res>
    implements $AudioDeviceInfoCopyWith<$Res> {
  _$AudioDeviceInfoCopyWithImpl(this._self, this._then);

  final AudioDeviceInfo _self;
  final $Res Function(AudioDeviceInfo) _then;

/// Create a copy of AudioDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? source = null,Object? isDefault = null,Object? channels = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioDeviceInfo].
extension AudioDeviceInfoPatterns on AudioDeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioDeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioDeviceInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioDeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceInfo():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioDeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AudioSourceKind source,  bool isDefault,  int channels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioDeviceInfo() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.isDefault,_that.channels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AudioSourceKind source,  bool isDefault,  int channels)  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceInfo():
return $default(_that.id,_that.name,_that.source,_that.isDefault,_that.channels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AudioSourceKind source,  bool isDefault,  int channels)?  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceInfo() when $default != null:
return $default(_that.id,_that.name,_that.source,_that.isDefault,_that.channels);case _:
  return null;

}
}

}

/// @nodoc


class _AudioDeviceInfo implements AudioDeviceInfo {
  const _AudioDeviceInfo({required this.id, required this.name, required this.source, this.isDefault = false, this.channels = 1});
  

@override final  String id;
@override final  String name;
@override final  AudioSourceKind source;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  int channels;

/// Create a copy of AudioDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioDeviceInfoCopyWith<_AudioDeviceInfo> get copyWith => __$AudioDeviceInfoCopyWithImpl<_AudioDeviceInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioDeviceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,source,isDefault,channels);

@override
String toString() {
  return 'AudioDeviceInfo(id: $id, name: $name, source: $source, isDefault: $isDefault, channels: $channels)';
}


}

/// @nodoc
abstract mixin class _$AudioDeviceInfoCopyWith<$Res> implements $AudioDeviceInfoCopyWith<$Res> {
  factory _$AudioDeviceInfoCopyWith(_AudioDeviceInfo value, $Res Function(_AudioDeviceInfo) _then) = __$AudioDeviceInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AudioSourceKind source, bool isDefault, int channels
});




}
/// @nodoc
class __$AudioDeviceInfoCopyWithImpl<$Res>
    implements _$AudioDeviceInfoCopyWith<$Res> {
  __$AudioDeviceInfoCopyWithImpl(this._self, this._then);

  final _AudioDeviceInfo _self;
  final $Res Function(_AudioDeviceInfo) _then;

/// Create a copy of AudioDeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? source = null,Object? isDefault = null,Object? channels = null,}) {
  return _then(_AudioDeviceInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AudioSourceKind,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AudioLevelFrame {

 double get micLevel; double get systemLevel; double get mixedLevel; DateTime get capturedAt;
/// Create a copy of AudioLevelFrame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioLevelFrameCopyWith<AudioLevelFrame> get copyWith => _$AudioLevelFrameCopyWithImpl<AudioLevelFrame>(this as AudioLevelFrame, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioLevelFrame&&(identical(other.micLevel, micLevel) || other.micLevel == micLevel)&&(identical(other.systemLevel, systemLevel) || other.systemLevel == systemLevel)&&(identical(other.mixedLevel, mixedLevel) || other.mixedLevel == mixedLevel)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}


@override
int get hashCode => Object.hash(runtimeType,micLevel,systemLevel,mixedLevel,capturedAt);

@override
String toString() {
  return 'AudioLevelFrame(micLevel: $micLevel, systemLevel: $systemLevel, mixedLevel: $mixedLevel, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class $AudioLevelFrameCopyWith<$Res>  {
  factory $AudioLevelFrameCopyWith(AudioLevelFrame value, $Res Function(AudioLevelFrame) _then) = _$AudioLevelFrameCopyWithImpl;
@useResult
$Res call({
 double micLevel, double systemLevel, double mixedLevel, DateTime capturedAt
});




}
/// @nodoc
class _$AudioLevelFrameCopyWithImpl<$Res>
    implements $AudioLevelFrameCopyWith<$Res> {
  _$AudioLevelFrameCopyWithImpl(this._self, this._then);

  final AudioLevelFrame _self;
  final $Res Function(AudioLevelFrame) _then;

/// Create a copy of AudioLevelFrame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? micLevel = null,Object? systemLevel = null,Object? mixedLevel = null,Object? capturedAt = null,}) {
  return _then(_self.copyWith(
micLevel: null == micLevel ? _self.micLevel : micLevel // ignore: cast_nullable_to_non_nullable
as double,systemLevel: null == systemLevel ? _self.systemLevel : systemLevel // ignore: cast_nullable_to_non_nullable
as double,mixedLevel: null == mixedLevel ? _self.mixedLevel : mixedLevel // ignore: cast_nullable_to_non_nullable
as double,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioLevelFrame].
extension AudioLevelFramePatterns on AudioLevelFrame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioLevelFrame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioLevelFrame() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioLevelFrame value)  $default,){
final _that = this;
switch (_that) {
case _AudioLevelFrame():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioLevelFrame value)?  $default,){
final _that = this;
switch (_that) {
case _AudioLevelFrame() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double micLevel,  double systemLevel,  double mixedLevel,  DateTime capturedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioLevelFrame() when $default != null:
return $default(_that.micLevel,_that.systemLevel,_that.mixedLevel,_that.capturedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double micLevel,  double systemLevel,  double mixedLevel,  DateTime capturedAt)  $default,) {final _that = this;
switch (_that) {
case _AudioLevelFrame():
return $default(_that.micLevel,_that.systemLevel,_that.mixedLevel,_that.capturedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double micLevel,  double systemLevel,  double mixedLevel,  DateTime capturedAt)?  $default,) {final _that = this;
switch (_that) {
case _AudioLevelFrame() when $default != null:
return $default(_that.micLevel,_that.systemLevel,_that.mixedLevel,_that.capturedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AudioLevelFrame implements AudioLevelFrame {
  const _AudioLevelFrame({required this.micLevel, required this.systemLevel, required this.mixedLevel, required this.capturedAt});
  

@override final  double micLevel;
@override final  double systemLevel;
@override final  double mixedLevel;
@override final  DateTime capturedAt;

/// Create a copy of AudioLevelFrame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioLevelFrameCopyWith<_AudioLevelFrame> get copyWith => __$AudioLevelFrameCopyWithImpl<_AudioLevelFrame>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioLevelFrame&&(identical(other.micLevel, micLevel) || other.micLevel == micLevel)&&(identical(other.systemLevel, systemLevel) || other.systemLevel == systemLevel)&&(identical(other.mixedLevel, mixedLevel) || other.mixedLevel == mixedLevel)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt));
}


@override
int get hashCode => Object.hash(runtimeType,micLevel,systemLevel,mixedLevel,capturedAt);

@override
String toString() {
  return 'AudioLevelFrame(micLevel: $micLevel, systemLevel: $systemLevel, mixedLevel: $mixedLevel, capturedAt: $capturedAt)';
}


}

/// @nodoc
abstract mixin class _$AudioLevelFrameCopyWith<$Res> implements $AudioLevelFrameCopyWith<$Res> {
  factory _$AudioLevelFrameCopyWith(_AudioLevelFrame value, $Res Function(_AudioLevelFrame) _then) = __$AudioLevelFrameCopyWithImpl;
@override @useResult
$Res call({
 double micLevel, double systemLevel, double mixedLevel, DateTime capturedAt
});




}
/// @nodoc
class __$AudioLevelFrameCopyWithImpl<$Res>
    implements _$AudioLevelFrameCopyWith<$Res> {
  __$AudioLevelFrameCopyWithImpl(this._self, this._then);

  final _AudioLevelFrame _self;
  final $Res Function(_AudioLevelFrame) _then;

/// Create a copy of AudioLevelFrame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? micLevel = null,Object? systemLevel = null,Object? mixedLevel = null,Object? capturedAt = null,}) {
  return _then(_AudioLevelFrame(
micLevel: null == micLevel ? _self.micLevel : micLevel // ignore: cast_nullable_to_non_nullable
as double,systemLevel: null == systemLevel ? _self.systemLevel : systemLevel // ignore: cast_nullable_to_non_nullable
as double,mixedLevel: null == mixedLevel ? _self.mixedLevel : mixedLevel // ignore: cast_nullable_to_non_nullable
as double,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$RecordingSnapshot {

 String get meetingId; Duration get elapsed; AudioLevelFrame get levels; MeetingStatus get status; String get statusMessage;
/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordingSnapshotCopyWith<RecordingSnapshot> get copyWith => _$RecordingSnapshotCopyWithImpl<RecordingSnapshot>(this as RecordingSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordingSnapshot&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.levels, levels) || other.levels == levels)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode => Object.hash(runtimeType,meetingId,elapsed,levels,status,statusMessage);

@override
String toString() {
  return 'RecordingSnapshot(meetingId: $meetingId, elapsed: $elapsed, levels: $levels, status: $status, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class $RecordingSnapshotCopyWith<$Res>  {
  factory $RecordingSnapshotCopyWith(RecordingSnapshot value, $Res Function(RecordingSnapshot) _then) = _$RecordingSnapshotCopyWithImpl;
@useResult
$Res call({
 String meetingId, Duration elapsed, AudioLevelFrame levels, MeetingStatus status, String statusMessage
});


$AudioLevelFrameCopyWith<$Res> get levels;

}
/// @nodoc
class _$RecordingSnapshotCopyWithImpl<$Res>
    implements $RecordingSnapshotCopyWith<$Res> {
  _$RecordingSnapshotCopyWithImpl(this._self, this._then);

  final RecordingSnapshot _self;
  final $Res Function(RecordingSnapshot) _then;

/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetingId = null,Object? elapsed = null,Object? levels = null,Object? status = null,Object? statusMessage = null,}) {
  return _then(_self.copyWith(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as AudioLevelFrame,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingStatus,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioLevelFrameCopyWith<$Res> get levels {
  
  return $AudioLevelFrameCopyWith<$Res>(_self.levels, (value) {
    return _then(_self.copyWith(levels: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecordingSnapshot].
extension RecordingSnapshotPatterns on RecordingSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordingSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordingSnapshot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordingSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _RecordingSnapshot():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordingSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _RecordingSnapshot() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String meetingId,  Duration elapsed,  AudioLevelFrame levels,  MeetingStatus status,  String statusMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordingSnapshot() when $default != null:
return $default(_that.meetingId,_that.elapsed,_that.levels,_that.status,_that.statusMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String meetingId,  Duration elapsed,  AudioLevelFrame levels,  MeetingStatus status,  String statusMessage)  $default,) {final _that = this;
switch (_that) {
case _RecordingSnapshot():
return $default(_that.meetingId,_that.elapsed,_that.levels,_that.status,_that.statusMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String meetingId,  Duration elapsed,  AudioLevelFrame levels,  MeetingStatus status,  String statusMessage)?  $default,) {final _that = this;
switch (_that) {
case _RecordingSnapshot() when $default != null:
return $default(_that.meetingId,_that.elapsed,_that.levels,_that.status,_that.statusMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RecordingSnapshot implements RecordingSnapshot {
  const _RecordingSnapshot({required this.meetingId, required this.elapsed, required this.levels, this.status = MeetingStatus.recording, this.statusMessage = 'Ready'});
  

@override final  String meetingId;
@override final  Duration elapsed;
@override final  AudioLevelFrame levels;
@override@JsonKey() final  MeetingStatus status;
@override@JsonKey() final  String statusMessage;

/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingSnapshotCopyWith<_RecordingSnapshot> get copyWith => __$RecordingSnapshotCopyWithImpl<_RecordingSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingSnapshot&&(identical(other.meetingId, meetingId) || other.meetingId == meetingId)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.levels, levels) || other.levels == levels)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode => Object.hash(runtimeType,meetingId,elapsed,levels,status,statusMessage);

@override
String toString() {
  return 'RecordingSnapshot(meetingId: $meetingId, elapsed: $elapsed, levels: $levels, status: $status, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$RecordingSnapshotCopyWith<$Res> implements $RecordingSnapshotCopyWith<$Res> {
  factory _$RecordingSnapshotCopyWith(_RecordingSnapshot value, $Res Function(_RecordingSnapshot) _then) = __$RecordingSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String meetingId, Duration elapsed, AudioLevelFrame levels, MeetingStatus status, String statusMessage
});


@override $AudioLevelFrameCopyWith<$Res> get levels;

}
/// @nodoc
class __$RecordingSnapshotCopyWithImpl<$Res>
    implements _$RecordingSnapshotCopyWith<$Res> {
  __$RecordingSnapshotCopyWithImpl(this._self, this._then);

  final _RecordingSnapshot _self;
  final $Res Function(_RecordingSnapshot) _then;

/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetingId = null,Object? elapsed = null,Object? levels = null,Object? status = null,Object? statusMessage = null,}) {
  return _then(_RecordingSnapshot(
meetingId: null == meetingId ? _self.meetingId : meetingId // ignore: cast_nullable_to_non_nullable
as String,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as Duration,levels: null == levels ? _self.levels : levels // ignore: cast_nullable_to_non_nullable
as AudioLevelFrame,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeetingStatus,statusMessage: null == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of RecordingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioLevelFrameCopyWith<$Res> get levels {
  
  return $AudioLevelFrameCopyWith<$Res>(_self.levels, (value) {
    return _then(_self.copyWith(levels: value));
  });
}
}

/// @nodoc
mixin _$ExportArtifact {

 String get fileName; ExportFormat get format; Uint8List get bytes; String get mimeType;
/// Create a copy of ExportArtifact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportArtifactCopyWith<ExportArtifact> get copyWith => _$ExportArtifactCopyWithImpl<ExportArtifact>(this as ExportArtifact, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportArtifact&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.format, format) || other.format == format)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,format,const DeepCollectionEquality().hash(bytes),mimeType);

@override
String toString() {
  return 'ExportArtifact(fileName: $fileName, format: $format, bytes: $bytes, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $ExportArtifactCopyWith<$Res>  {
  factory $ExportArtifactCopyWith(ExportArtifact value, $Res Function(ExportArtifact) _then) = _$ExportArtifactCopyWithImpl;
@useResult
$Res call({
 String fileName, ExportFormat format, Uint8List bytes, String mimeType
});




}
/// @nodoc
class _$ExportArtifactCopyWithImpl<$Res>
    implements $ExportArtifactCopyWith<$Res> {
  _$ExportArtifactCopyWithImpl(this._self, this._then);

  final ExportArtifact _self;
  final $Res Function(ExportArtifact) _then;

/// Create a copy of ExportArtifact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? format = null,Object? bytes = null,Object? mimeType = null,}) {
  return _then(_self.copyWith(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportArtifact].
extension ExportArtifactPatterns on ExportArtifact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportArtifact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportArtifact() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportArtifact value)  $default,){
final _that = this;
switch (_that) {
case _ExportArtifact():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportArtifact value)?  $default,){
final _that = this;
switch (_that) {
case _ExportArtifact() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  ExportFormat format,  Uint8List bytes,  String mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportArtifact() when $default != null:
return $default(_that.fileName,_that.format,_that.bytes,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  ExportFormat format,  Uint8List bytes,  String mimeType)  $default,) {final _that = this;
switch (_that) {
case _ExportArtifact():
return $default(_that.fileName,_that.format,_that.bytes,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  ExportFormat format,  Uint8List bytes,  String mimeType)?  $default,) {final _that = this;
switch (_that) {
case _ExportArtifact() when $default != null:
return $default(_that.fileName,_that.format,_that.bytes,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc


class _ExportArtifact implements ExportArtifact {
  const _ExportArtifact({required this.fileName, required this.format, required this.bytes, required this.mimeType});
  

@override final  String fileName;
@override final  ExportFormat format;
@override final  Uint8List bytes;
@override final  String mimeType;

/// Create a copy of ExportArtifact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportArtifactCopyWith<_ExportArtifact> get copyWith => __$ExportArtifactCopyWithImpl<_ExportArtifact>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportArtifact&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.format, format) || other.format == format)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}


@override
int get hashCode => Object.hash(runtimeType,fileName,format,const DeepCollectionEquality().hash(bytes),mimeType);

@override
String toString() {
  return 'ExportArtifact(fileName: $fileName, format: $format, bytes: $bytes, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$ExportArtifactCopyWith<$Res> implements $ExportArtifactCopyWith<$Res> {
  factory _$ExportArtifactCopyWith(_ExportArtifact value, $Res Function(_ExportArtifact) _then) = __$ExportArtifactCopyWithImpl;
@override @useResult
$Res call({
 String fileName, ExportFormat format, Uint8List bytes, String mimeType
});




}
/// @nodoc
class __$ExportArtifactCopyWithImpl<$Res>
    implements _$ExportArtifactCopyWith<$Res> {
  __$ExportArtifactCopyWithImpl(this._self, this._then);

  final _ExportArtifact _self;
  final $Res Function(_ExportArtifact) _then;

/// Create a copy of ExportArtifact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? format = null,Object? bytes = null,Object? mimeType = null,}) {
  return _then(_ExportArtifact(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as ExportFormat,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
