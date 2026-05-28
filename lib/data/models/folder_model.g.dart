// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFolderModelCollection on Isar {
  IsarCollection<FolderModel> get folderModels => this.collection();
}

const FolderModelSchema = CollectionSchema(
  name: r'FolderModel',
  id: -424889283014507682,
  properties: {
    r'colorValue': PropertySchema(
      id: 0,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'iconCodePoint': PropertySchema(
      id: 2,
      name: r'iconCodePoint',
      type: IsarType.long,
    ),
    r'iconFontFamily': PropertySchema(
      id: 3,
      name: r'iconFontFamily',
      type: IsarType.string,
    ),
    r'modifiedTime': PropertySchema(
      id: 4,
      name: r'modifiedTime',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _folderModelEstimateSize,
  serialize: _folderModelSerialize,
  deserialize: _folderModelDeserialize,
  deserializeProp: _folderModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'modifiedTime': IndexSchema(
      id: -608962959549919354,
      name: r'modifiedTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'modifiedTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'movieIds': LinkSchema(
      id: -4645303979291638471,
      name: r'movieIds',
      target: r'MovieModel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _folderModelGetId,
  getLinks: _folderModelGetLinks,
  attach: _folderModelAttach,
  version: '3.1.0+1',
);

int _folderModelEstimateSize(
  FolderModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.iconFontFamily.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _folderModelSerialize(
  FolderModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorValue);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.iconCodePoint);
  writer.writeString(offsets[3], object.iconFontFamily);
  writer.writeDateTime(offsets[4], object.modifiedTime);
  writer.writeString(offsets[5], object.name);
}

FolderModel _folderModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FolderModel(
    colorValue: reader.readLong(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    iconCodePoint: reader.readLong(offsets[2]),
    iconFontFamily: reader.readString(offsets[3]),
    modifiedTime: reader.readDateTime(offsets[4]),
    name: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _folderModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _folderModelGetId(FolderModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _folderModelGetLinks(FolderModel object) {
  return [object.movieIds];
}

void _folderModelAttach(
    IsarCollection<dynamic> col, Id id, FolderModel object) {
  object.id = id;
  object.movieIds
      .attach(col, col.isar.collection<MovieModel>(), r'movieIds', id);
}

extension FolderModelQueryWhereSort
    on QueryBuilder<FolderModel, FolderModel, QWhere> {
  QueryBuilder<FolderModel, FolderModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhere> anyModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'modifiedTime'),
      );
    });
  }
}

extension FolderModelQueryWhere
    on QueryBuilder<FolderModel, FolderModel, QWhereClause> {
  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> modifiedTimeEqualTo(
      DateTime modifiedTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modifiedTime',
        value: [modifiedTime],
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause>
      modifiedTimeNotEqualTo(DateTime modifiedTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [],
              upper: [modifiedTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [modifiedTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [modifiedTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modifiedTime',
              lower: [],
              upper: [modifiedTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause>
      modifiedTimeGreaterThan(
    DateTime modifiedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [modifiedTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause>
      modifiedTimeLessThan(
    DateTime modifiedTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [],
        upper: [modifiedTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterWhereClause> modifiedTimeBetween(
    DateTime lowerModifiedTime,
    DateTime upperModifiedTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'modifiedTime',
        lower: [lowerModifiedTime],
        includeLower: includeLower,
        upper: [upperModifiedTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FolderModelQueryFilter
    on QueryBuilder<FolderModel, FolderModel, QFilterCondition> {
  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconCodePointEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconCodePointGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconCodePointLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconCodePointBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconCodePoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconFontFamily',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconFontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconFontFamily',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconFontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      iconFontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconFontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      modifiedTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modifiedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
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

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension FolderModelQueryObject
    on QueryBuilder<FolderModel, FolderModel, QFilterCondition> {}

extension FolderModelQueryLinks
    on QueryBuilder<FolderModel, FolderModel, QFilterCondition> {
  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition> movieIds(
      FilterQuery<MovieModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'movieIds');
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movieIds', length, true, length, true);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movieIds', 0, true, 0, true);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movieIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movieIds', 0, true, length, include);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movieIds', length, include, 999999, true);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterFilterCondition>
      movieIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'movieIds', lower, includeLower, upper, includeUpper);
    });
  }
}

extension FolderModelQuerySortBy
    on QueryBuilder<FolderModel, FolderModel, QSortBy> {
  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      sortByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByIconFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFontFamily', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      sortByIconFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFontFamily', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      sortByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension FolderModelQuerySortThenBy
    on QueryBuilder<FolderModel, FolderModel, QSortThenBy> {
  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      thenByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByIconFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFontFamily', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      thenByIconFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconFontFamily', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy>
      thenByModifiedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedTime', Sort.desc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension FolderModelQueryWhereDistinct
    on QueryBuilder<FolderModel, FolderModel, QDistinct> {
  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconCodePoint');
    });
  }

  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByIconFontFamily(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconFontFamily',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByModifiedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedTime');
    });
  }

  QueryBuilder<FolderModel, FolderModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension FolderModelQueryProperty
    on QueryBuilder<FolderModel, FolderModel, QQueryProperty> {
  QueryBuilder<FolderModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FolderModel, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<FolderModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FolderModel, int, QQueryOperations> iconCodePointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconCodePoint');
    });
  }

  QueryBuilder<FolderModel, String, QQueryOperations> iconFontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconFontFamily');
    });
  }

  QueryBuilder<FolderModel, DateTime, QQueryOperations> modifiedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedTime');
    });
  }

  QueryBuilder<FolderModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
