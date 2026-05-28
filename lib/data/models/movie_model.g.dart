// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMovieModelCollection on Isar {
  IsarCollection<MovieModel> get movieModels => this.collection();
}

const MovieModelSchema = CollectionSchema(
  name: r'MovieModel',
  id: -9200480355564222076,
  properties: {
    r'folderId': PropertySchema(
      id: 0,
      name: r'folderId',
      type: IsarType.long,
    ),
    r'genreNames': PropertySchema(
      id: 1,
      name: r'genreNames',
      type: IsarType.stringList,
    ),
    r'imdbId': PropertySchema(
      id: 2,
      name: r'imdbId',
      type: IsarType.string,
    ),
    r'isWatch': PropertySchema(
      id: 3,
      name: r'isWatch',
      type: IsarType.bool,
    ),
    r'modifiedTime': PropertySchema(
      id: 4,
      name: r'modifiedTime',
      type: IsarType.dateTime,
    ),
    r'originalLanguage': PropertySchema(
      id: 5,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'originalTitle': PropertySchema(
      id: 6,
      name: r'originalTitle',
      type: IsarType.string,
    ),
    r'plotOverview': PropertySchema(
      id: 7,
      name: r'plotOverview',
      type: IsarType.string,
    ),
    r'poster': PropertySchema(
      id: 8,
      name: r'poster',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    ),
    r'tmdbType': PropertySchema(
      id: 10,
      name: r'tmdbType',
      type: IsarType.string,
    ),
    r'trailer': PropertySchema(
      id: 11,
      name: r'trailer',
      type: IsarType.string,
    ),
    r'trailerThumbnail': PropertySchema(
      id: 12,
      name: r'trailerThumbnail',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.string,
    ),
    r'userRating': PropertySchema(
      id: 14,
      name: r'userRating',
      type: IsarType.double,
    ),
    r'year': PropertySchema(
      id: 15,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _movieModelEstimateSize,
  serialize: _movieModelSerialize,
  deserialize: _movieModelDeserialize,
  deserializeProp: _movieModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _movieModelGetId,
  getLinks: _movieModelGetLinks,
  attach: _movieModelAttach,
  version: '3.1.0+1',
);

int _movieModelEstimateSize(
  MovieModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.genreNames.length * 3;
  {
    for (var i = 0; i < object.genreNames.length; i++) {
      final value = object.genreNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.imdbId.length * 3;
  bytesCount += 3 + object.originalLanguage.length * 3;
  bytesCount += 3 + object.originalTitle.length * 3;
  bytesCount += 3 + object.plotOverview.length * 3;
  bytesCount += 3 + object.poster.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.tmdbType.length * 3;
  {
    final value = object.trailer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.trailerThumbnail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _movieModelSerialize(
  MovieModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.folderId);
  writer.writeStringList(offsets[1], object.genreNames);
  writer.writeString(offsets[2], object.imdbId);
  writer.writeBool(offsets[3], object.isWatch);
  writer.writeDateTime(offsets[4], object.modifiedTime);
  writer.writeString(offsets[5], object.originalLanguage);
  writer.writeString(offsets[6], object.originalTitle);
  writer.writeString(offsets[7], object.plotOverview);
  writer.writeString(offsets[8], object.poster);
  writer.writeString(offsets[9], object.title);
  writer.writeString(offsets[10], object.tmdbType);
  writer.writeString(offsets[11], object.trailer);
  writer.writeString(offsets[12], object.trailerThumbnail);
  writer.writeString(offsets[13], object.type);
  writer.writeDouble(offsets[14], object.userRating);
  writer.writeLong(offsets[15], object.year);
}

MovieModel _movieModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MovieModel(
    folderId: reader.readLong(offsets[0]),
    genreNames: reader.readStringList(offsets[1]) ?? [],
    id: id,
    imdbId: reader.readString(offsets[2]),
    isWatch: reader.readBool(offsets[3]),
    modifiedTime: reader.readDateTime(offsets[4]),
    originalLanguage: reader.readString(offsets[5]),
    originalTitle: reader.readString(offsets[6]),
    plotOverview: reader.readString(offsets[7]),
    poster: reader.readString(offsets[8]),
    title: reader.readString(offsets[9]),
    tmdbType: reader.readString(offsets[10]),
    trailer: reader.readStringOrNull(offsets[11]),
    trailerThumbnail: reader.readStringOrNull(offsets[12]),
    type: reader.readString(offsets[13]),
    userRating: reader.readDouble(offsets[14]),
    year: reader.readLong(offsets[15]),
  );
  return object;
}

P _movieModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _movieModelGetId(MovieModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _movieModelGetLinks(MovieModel object) {
  return [];
}

void _movieModelAttach(IsarCollection<dynamic> col, Id id, MovieModel object) {
  object.id = id;
}

extension MovieModelQueryWhereSort
    on QueryBuilder<MovieModel, MovieModel, QWhere> {
  QueryBuilder<MovieModel, MovieModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MovieModelQueryWhere
    on QueryBuilder<MovieModel, MovieModel, QWhereClause> {
  QueryBuilder<MovieModel, MovieModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieModelQueryFilter
    on QueryBuilder<MovieModel, MovieModel, QFilterCondition> {
  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> folderIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      folderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> folderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folderId',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> folderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genreNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genreNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreNames',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genreNames',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      genreNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imdbId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imdbId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imdbId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> imdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imdbId',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      imdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imdbId',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> isWatchEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWatch',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      modifiedTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      modifiedTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      modifiedTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      modifiedTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modifiedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      originalTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plotOverview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plotOverview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plotOverview',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plotOverview',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      plotOverviewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plotOverview',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poster',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poster',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poster',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> posterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poster',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      posterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poster',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      tmdbTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tmdbType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      tmdbTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tmdbType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> tmdbTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tmdbType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      tmdbTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tmdbType',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      tmdbTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tmdbType',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trailer',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trailer',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trailer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trailer',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trailer',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> trailerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trailer',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trailer',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trailerThumbnail',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trailerThumbnail',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trailerThumbnail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trailerThumbnail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trailerThumbnail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trailerThumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      trailerThumbnailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trailerThumbnail',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> userRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      userRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition>
      userRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> userRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovieModelQueryObject
    on QueryBuilder<MovieModel, MovieModel, QFilterCondition> {}

extension MovieModelQueryLinks
    on QueryBuilder<MovieModel, MovieModel, QFilterCondition> {}

extension MovieModelQuerySortBy
    on QueryBuilder<MovieModel, MovieModel, QSortBy> {
  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByIsWatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWatch', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByIsWatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWatch', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy>
      sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByPlotOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plotOverview', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByPlotOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plotOverview', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByPoster() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByPosterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTmdbType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbType', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTmdbTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbType', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTrailer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailer', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTrailerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailer', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTrailerThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailerThumbnail', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy>
      sortByTrailerThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailerThumbnail', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByUserRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userRating', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByUserRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userRating', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MovieModelQuerySortThenBy
    on QueryBuilder<MovieModel, MovieModel, QSortThenBy> {
  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folderId', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByIsWatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWatch', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByIsWatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWatch', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy>
      thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByPlotOverview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plotOverview', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByPlotOverviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plotOverview', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByPoster() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByPosterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poster', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTmdbType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbType', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTmdbTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbType', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTrailer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailer', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTrailerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailer', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTrailerThumbnail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailerThumbnail', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy>
      thenByTrailerThumbnailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trailerThumbnail', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByUserRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userRating', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByUserRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userRating', Sort.desc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MovieModelQueryWhereDistinct
    on QueryBuilder<MovieModel, MovieModel, QDistinct> {
  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folderId');
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByGenreNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreNames');
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByImdbId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByIsWatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWatch');
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedTime');
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByOriginalLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByOriginalTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByPlotOverview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plotOverview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByPoster(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poster', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByTmdbType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByTrailer(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trailer', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByTrailerThumbnail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trailerThumbnail',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByUserRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userRating');
    });
  }

  QueryBuilder<MovieModel, MovieModel, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension MovieModelQueryProperty
    on QueryBuilder<MovieModel, MovieModel, QQueryProperty> {
  QueryBuilder<MovieModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MovieModel, int, QQueryOperations> folderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folderId');
    });
  }

  QueryBuilder<MovieModel, List<String>, QQueryOperations>
      genreNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreNames');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> imdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imdbId');
    });
  }

  QueryBuilder<MovieModel, bool, QQueryOperations> isWatchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWatch');
    });
  }

  QueryBuilder<MovieModel, DateTime, QQueryOperations> modifiedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedTime');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations>
      originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> originalTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalTitle');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> plotOverviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plotOverview');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> posterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poster');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> tmdbTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbType');
    });
  }

  QueryBuilder<MovieModel, String?, QQueryOperations> trailerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trailer');
    });
  }

  QueryBuilder<MovieModel, String?, QQueryOperations>
      trailerThumbnailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trailerThumbnail');
    });
  }

  QueryBuilder<MovieModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<MovieModel, double, QQueryOperations> userRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userRating');
    });
  }

  QueryBuilder<MovieModel, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
