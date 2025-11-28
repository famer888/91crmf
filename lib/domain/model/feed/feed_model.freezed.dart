// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) {
  switch (json['feed_type']) {
    case 'video':
      return FeedVideoModel.fromJson(json);
    case 'ad':
      return FeedAdModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'feed_type', 'FeedModel',
          'Invalid union type "${json['feed_type']}"!');
  }
}

/// @nodoc
mixin _$FeedModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  int? get crackAppType => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedModelCopyWith<FeedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedModelCopyWith<$Res> {
  factory $FeedModelCopyWith(FeedModel value, $Res Function(FeedModel) then) =
      _$FeedModelCopyWithImpl<$Res, FeedModel>;
  @useResult
  $Res call({int id, String title, String? createdAt, int? crackAppType});
}

/// @nodoc
class _$FeedModelCopyWithImpl<$Res, $Val extends FeedModel>
    implements $FeedModelCopyWith<$Res> {
  _$FeedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = freezed,
    Object? crackAppType = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      crackAppType: freezed == crackAppType
          ? _value.crackAppType
          : crackAppType // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedVideoModelImplCopyWith<$Res>
    implements $FeedModelCopyWith<$Res> {
  factory _$$FeedVideoModelImplCopyWith(_$FeedVideoModelImpl value,
          $Res Function(_$FeedVideoModelImpl) then) =
      __$$FeedVideoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int? aff,
      String title,
      String tags,
      int isfree,
      int countPlay,
      int countPlayFake,
      int duration,
      String? createdAt,
      int countComment,
      int coins,
      int playCt,
      String? refreshAt,
      String coverHorizontal,
      String? sourceOriginStr,
      List<String> tagList,
      int isPay,
      int discount,
      int? crackAppType,
      int discountCoins,
      bool isPackage});
}

/// @nodoc
class __$$FeedVideoModelImplCopyWithImpl<$Res>
    extends _$FeedModelCopyWithImpl<$Res, _$FeedVideoModelImpl>
    implements _$$FeedVideoModelImplCopyWith<$Res> {
  __$$FeedVideoModelImplCopyWithImpl(
      _$FeedVideoModelImpl _value, $Res Function(_$FeedVideoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aff = freezed,
    Object? title = null,
    Object? tags = null,
    Object? isfree = null,
    Object? countPlay = null,
    Object? countPlayFake = null,
    Object? duration = null,
    Object? createdAt = freezed,
    Object? countComment = null,
    Object? coins = null,
    Object? playCt = null,
    Object? refreshAt = freezed,
    Object? coverHorizontal = null,
    Object? sourceOriginStr = freezed,
    Object? tagList = null,
    Object? isPay = null,
    Object? discount = null,
    Object? crackAppType = freezed,
    Object? discountCoins = null,
    Object? isPackage = null,
  }) {
    return _then(_$FeedVideoModelImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == aff
          ? _value.aff
          : aff // ignore: cast_nullable_to_non_nullable
              as int?,
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as String,
      null == isfree
          ? _value.isfree
          : isfree // ignore: cast_nullable_to_non_nullable
              as int,
      null == countPlay
          ? _value.countPlay
          : countPlay // ignore: cast_nullable_to_non_nullable
              as int,
      null == countPlayFake
          ? _value.countPlayFake
          : countPlayFake // ignore: cast_nullable_to_non_nullable
              as int,
      null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      null == countComment
          ? _value.countComment
          : countComment // ignore: cast_nullable_to_non_nullable
              as int,
      null == coins
          ? _value.coins
          : coins // ignore: cast_nullable_to_non_nullable
              as int,
      null == playCt
          ? _value.playCt
          : playCt // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == refreshAt
          ? _value.refreshAt
          : refreshAt // ignore: cast_nullable_to_non_nullable
              as String?,
      null == coverHorizontal
          ? _value.coverHorizontal
          : coverHorizontal // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == sourceOriginStr
          ? _value.sourceOriginStr
          : sourceOriginStr // ignore: cast_nullable_to_non_nullable
              as String?,
      null == tagList
          ? _value._tagList
          : tagList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      null == isPay
          ? _value.isPay
          : isPay // ignore: cast_nullable_to_non_nullable
              as int,
      null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == crackAppType
          ? _value.crackAppType
          : crackAppType // ignore: cast_nullable_to_non_nullable
              as int?,
      null == discountCoins
          ? _value.discountCoins
          : discountCoins // ignore: cast_nullable_to_non_nullable
              as int,
      null == isPackage
          ? _value.isPackage
          : isPackage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FeedVideoModelImpl implements FeedVideoModel {
  const _$FeedVideoModelImpl(
      this.id,
      this.aff,
      this.title,
      this.tags,
      this.isfree,
      this.countPlay,
      this.countPlayFake,
      this.duration,
      this.createdAt,
      this.countComment,
      this.coins,
      this.playCt,
      this.refreshAt,
      this.coverHorizontal,
      this.sourceOriginStr,
      final List<String> tagList,
      this.isPay,
      this.discount,
      this.crackAppType,
      this.discountCoins,
      this.isPackage,
      {final String? $type})
      : _tagList = tagList,
        $type = $type ?? 'video';

  factory _$FeedVideoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedVideoModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? aff;
  @override
  final String title;
  @override
  final String tags;
  @override
  final int isfree;
  @override
  final int countPlay;
  @override
  final int countPlayFake;
  @override
  final int duration;
  @override
  final String? createdAt;
  @override
  final int countComment;
  @override
  final int coins;
  @override
  final int playCt;
  @override
  final String? refreshAt;
  @override
  final String coverHorizontal;
  @override
  final String? sourceOriginStr;
  final List<String> _tagList;
  @override
  List<String> get tagList {
    if (_tagList is EqualUnmodifiableListView) return _tagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagList);
  }

  @override
  final int isPay;
  @override
  final int discount;
  @override
  final int? crackAppType;
  @override
  final int discountCoins;
  @override
  final bool isPackage;

  @JsonKey(name: 'feed_type')
  final String $type;

  @override
  String toString() {
    return 'FeedModel.video(id: $id, aff: $aff, title: $title, tags: $tags, isfree: $isfree, countPlay: $countPlay, countPlayFake: $countPlayFake, duration: $duration, createdAt: $createdAt, countComment: $countComment, coins: $coins, playCt: $playCt, refreshAt: $refreshAt, coverHorizontal: $coverHorizontal, sourceOriginStr: $sourceOriginStr, tagList: $tagList, isPay: $isPay, discount: $discount, crackAppType: $crackAppType, discountCoins: $discountCoins, isPackage: $isPackage)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedVideoModelImplCopyWith<_$FeedVideoModelImpl> get copyWith =>
      __$$FeedVideoModelImplCopyWithImpl<_$FeedVideoModelImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) {
    return video(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedVideoModelImplToJson(
      this,
    );
  }
}

abstract class FeedVideoModel implements FeedModel {
  const factory FeedVideoModel(
      final int id,
      final int? aff,
      final String title,
      final String tags,
      final int isfree,
      final int countPlay,
      final int countPlayFake,
      final int duration,
      final String? createdAt,
      final int countComment,
      final int coins,
      final int playCt,
      final String? refreshAt,
      final String coverHorizontal,
      final String? sourceOriginStr,
      final List<String> tagList,
      final int isPay,
      final int discount,
      final int? crackAppType,
      final int discountCoins,
      final bool isPackage) = _$FeedVideoModelImpl;

  factory FeedVideoModel.fromJson(Map<String, dynamic> json) =
      _$FeedVideoModelImpl.fromJson;

  @override
  int get id;
  int? get aff;
  @override
  String get title;
  String get tags;
  int get isfree;
  int get countPlay;
  int get countPlayFake;
  int get duration;
  @override
  String? get createdAt;
  int get countComment;
  int get coins;
  int get playCt;
  String? get refreshAt;
  String get coverHorizontal;
  String? get sourceOriginStr;
  List<String> get tagList;
  int get isPay;
  int get discount;
  @override
  int? get crackAppType;
  int get discountCoins;
  bool get isPackage;
  @override
  @JsonKey(ignore: true)
  _$$FeedVideoModelImplCopyWith<_$FeedVideoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FeedAdModelImplCopyWith<$Res>
    implements $FeedModelCopyWith<$Res> {
  factory _$$FeedAdModelImplCopyWith(
          _$FeedAdModelImpl value, $Res Function(_$FeedAdModelImpl) then) =
      __$$FeedAdModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      String? imgUrl,
      String urlConfig,
      int? position,
      String? androidDownUrl,
      String? iosDownUrl,
      int? type,
      int? status,
      int? oauthType,
      String? mvM3U8,
      String? channel,
      String? createdAt,
      String router,
      String? startAt,
      String? endAt,
      int clicked,
      int sort,
      String urlStr,
      String linkUrl,
      String? url,
      String resourceUrl,
      int redirectType,
      int reportId,
      int reportType,
      int? crackAppType,
      String? subTitle});
}

/// @nodoc
class __$$FeedAdModelImplCopyWithImpl<$Res>
    extends _$FeedModelCopyWithImpl<$Res, _$FeedAdModelImpl>
    implements _$$FeedAdModelImplCopyWith<$Res> {
  __$$FeedAdModelImplCopyWithImpl(
      _$FeedAdModelImpl _value, $Res Function(_$FeedAdModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? imgUrl = freezed,
    Object? urlConfig = null,
    Object? position = freezed,
    Object? androidDownUrl = freezed,
    Object? iosDownUrl = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? oauthType = freezed,
    Object? mvM3U8 = freezed,
    Object? channel = freezed,
    Object? createdAt = freezed,
    Object? router = null,
    Object? startAt = freezed,
    Object? endAt = freezed,
    Object? clicked = null,
    Object? sort = null,
    Object? urlStr = null,
    Object? linkUrl = null,
    Object? url = freezed,
    Object? resourceUrl = null,
    Object? redirectType = null,
    Object? reportId = null,
    Object? reportType = null,
    Object? crackAppType = freezed,
    Object? subTitle = freezed,
  }) {
    return _then(_$FeedAdModelImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == imgUrl
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      null == urlConfig
          ? _value.urlConfig
          : urlConfig // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == androidDownUrl
          ? _value.androidDownUrl
          : androidDownUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == iosDownUrl
          ? _value.iosDownUrl
          : iosDownUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == oauthType
          ? _value.oauthType
          : oauthType // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == mvM3U8
          ? _value.mvM3U8
          : mvM3U8 // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      null == router
          ? _value.router
          : router // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == startAt
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == endAt
          ? _value.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as String?,
      null == clicked
          ? _value.clicked
          : clicked // ignore: cast_nullable_to_non_nullable
              as int,
      null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as int,
      null == urlStr
          ? _value.urlStr
          : urlStr // ignore: cast_nullable_to_non_nullable
              as String,
      null == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      null == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
              as String,
      null == redirectType
          ? _value.redirectType
          : redirectType // ignore: cast_nullable_to_non_nullable
              as int,
      null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as int,
      null == reportType
          ? _value.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == crackAppType
          ? _value.crackAppType
          : crackAppType // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == subTitle
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$FeedAdModelImpl implements FeedAdModel {
  const _$FeedAdModelImpl(
      this.id,
      this.title,
      this.description,
      this.imgUrl,
      this.urlConfig,
      this.position,
      this.androidDownUrl,
      this.iosDownUrl,
      this.type,
      this.status,
      this.oauthType,
      this.mvM3U8,
      this.channel,
      this.createdAt,
      this.router,
      this.startAt,
      this.endAt,
      this.clicked,
      this.sort,
      this.urlStr,
      this.linkUrl,
      this.url,
      this.resourceUrl,
      this.redirectType,
      this.reportId,
      this.reportType,
      this.crackAppType,
      this.subTitle,
      {final String? $type})
      : $type = $type ?? 'ad';

  factory _$FeedAdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedAdModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? imgUrl;
  @override
  final String urlConfig;
  @override
  final int? position;
  @override
  final String? androidDownUrl;
  @override
  final String? iosDownUrl;
  @override
  final int? type;
  @override
  final int? status;
  @override
  final int? oauthType;
  @override
  final String? mvM3U8;
  @override
  final String? channel;
  @override
  final String? createdAt;
  @override
  final String router;
  @override
  final String? startAt;
  @override
  final String? endAt;
  @override
  final int clicked;
  @override
  final int sort;
  @override
  final String urlStr;
  @override
  final String linkUrl;
  @override
  final String? url;
  @override
  final String resourceUrl;
  @override
  final int redirectType;
  @override
  final int reportId;
  @override
  final int reportType;
  @override
  final int? crackAppType;
  @override
  final String? subTitle;

  @JsonKey(name: 'feed_type')
  final String $type;

  @override
  String toString() {
    return 'FeedModel.ad(id: $id, title: $title, description: $description, imgUrl: $imgUrl, urlConfig: $urlConfig, position: $position, androidDownUrl: $androidDownUrl, iosDownUrl: $iosDownUrl, type: $type, status: $status, oauthType: $oauthType, mvM3U8: $mvM3U8, channel: $channel, createdAt: $createdAt, router: $router, startAt: $startAt, endAt: $endAt, clicked: $clicked, sort: $sort, urlStr: $urlStr, linkUrl: $linkUrl, url: $url, resourceUrl: $resourceUrl, redirectType: $redirectType, reportId: $reportId, reportType: $reportType, crackAppType: $crackAppType, subTitle: $subTitle)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedAdModelImplCopyWith<_$FeedAdModelImpl> get copyWith =>
      __$$FeedAdModelImplCopyWithImpl<_$FeedAdModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedVideoModel value) video,
    required TResult Function(FeedAdModel value) ad,
  }) {
    return ad(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedAdModelImplToJson(
      this,
    );
  }
}

abstract class FeedAdModel implements FeedModel {
  const factory FeedAdModel(
      final int id,
      final String title,
      final String? description,
      final String? imgUrl,
      final String urlConfig,
      final int? position,
      final String? androidDownUrl,
      final String? iosDownUrl,
      final int? type,
      final int? status,
      final int? oauthType,
      final String? mvM3U8,
      final String? channel,
      final String? createdAt,
      final String router,
      final String? startAt,
      final String? endAt,
      final int clicked,
      final int sort,
      final String urlStr,
      final String linkUrl,
      final String? url,
      final String resourceUrl,
      final int redirectType,
      final int reportId,
      final int reportType,
      final int? crackAppType,
      final String? subTitle) = _$FeedAdModelImpl;

  factory FeedAdModel.fromJson(Map<String, dynamic> json) =
      _$FeedAdModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  String? get description;
  String? get imgUrl;
  String get urlConfig;
  int? get position;
  String? get androidDownUrl;
  String? get iosDownUrl;
  int? get type;
  int? get status;
  int? get oauthType;
  String? get mvM3U8;
  String? get channel;
  @override
  String? get createdAt;
  String get router;
  String? get startAt;
  String? get endAt;
  int get clicked;
  int get sort;
  String get urlStr;
  String get linkUrl;
  String? get url;
  String get resourceUrl;
  int get redirectType;
  int get reportId;
  int get reportType;
  @override
  int? get crackAppType;
  String? get subTitle;
  @override
  @JsonKey(ignore: true)
  _$$FeedAdModelImplCopyWith<_$FeedAdModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
