// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTopicProgressCollection on Isar {
  IsarCollection<TopicProgress> get topicProgress => this.collection();
}

const TopicProgressSchema = CollectionSchema(
  name: r'TopicProgress',
  id: -9102827750859956213,
  properties: {
    r'highScore': PropertySchema(
      id: 0,
      name: r'highScore',
      type: IsarType.long,
    ),
    r'highScorePercentage': PropertySchema(
      id: 1,
      name: r'highScorePercentage',
      type: IsarType.double,
    ),
    r'isCompleted': PropertySchema(
      id: 2,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'lastAttemptDate': PropertySchema(
      id: 3,
      name: r'lastAttemptDate',
      type: IsarType.dateTime,
    ),
    r'topicId': PropertySchema(
      id: 4,
      name: r'topicId',
      type: IsarType.string,
    ),
    r'totalAttempts': PropertySchema(
      id: 5,
      name: r'totalAttempts',
      type: IsarType.long,
    ),
    r'totalQuestions': PropertySchema(
      id: 6,
      name: r'totalQuestions',
      type: IsarType.long,
    )
  },
  estimateSize: _topicProgressEstimateSize,
  serialize: _topicProgressSerialize,
  deserialize: _topicProgressDeserialize,
  deserializeProp: _topicProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'topicId': IndexSchema(
      id: 3718206658163357569,
      name: r'topicId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'topicId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _topicProgressGetId,
  getLinks: _topicProgressGetLinks,
  attach: _topicProgressAttach,
  version: '3.1.0+1',
);

int _topicProgressEstimateSize(
  TopicProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.topicId.length * 3;
  return bytesCount;
}

void _topicProgressSerialize(
  TopicProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.highScore);
  writer.writeDouble(offsets[1], object.highScorePercentage);
  writer.writeBool(offsets[2], object.isCompleted);
  writer.writeDateTime(offsets[3], object.lastAttemptDate);
  writer.writeString(offsets[4], object.topicId);
  writer.writeLong(offsets[5], object.totalAttempts);
  writer.writeLong(offsets[6], object.totalQuestions);
}

TopicProgress _topicProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TopicProgress();
  object.highScore = reader.readLong(offsets[0]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[2]);
  object.lastAttemptDate = reader.readDateTimeOrNull(offsets[3]);
  object.topicId = reader.readString(offsets[4]);
  object.totalAttempts = reader.readLong(offsets[5]);
  object.totalQuestions = reader.readLong(offsets[6]);
  return object;
}

P _topicProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _topicProgressGetId(TopicProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _topicProgressGetLinks(TopicProgress object) {
  return [];
}

void _topicProgressAttach(
    IsarCollection<dynamic> col, Id id, TopicProgress object) {
  object.id = id;
}

extension TopicProgressByIndex on IsarCollection<TopicProgress> {
  Future<TopicProgress?> getByTopicId(String topicId) {
    return getByIndex(r'topicId', [topicId]);
  }

  TopicProgress? getByTopicIdSync(String topicId) {
    return getByIndexSync(r'topicId', [topicId]);
  }

  Future<bool> deleteByTopicId(String topicId) {
    return deleteByIndex(r'topicId', [topicId]);
  }

  bool deleteByTopicIdSync(String topicId) {
    return deleteByIndexSync(r'topicId', [topicId]);
  }

  Future<List<TopicProgress?>> getAllByTopicId(List<String> topicIdValues) {
    final values = topicIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'topicId', values);
  }

  List<TopicProgress?> getAllByTopicIdSync(List<String> topicIdValues) {
    final values = topicIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'topicId', values);
  }

  Future<int> deleteAllByTopicId(List<String> topicIdValues) {
    final values = topicIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'topicId', values);
  }

  int deleteAllByTopicIdSync(List<String> topicIdValues) {
    final values = topicIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'topicId', values);
  }

  Future<Id> putByTopicId(TopicProgress object) {
    return putByIndex(r'topicId', object);
  }

  Id putByTopicIdSync(TopicProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'topicId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTopicId(List<TopicProgress> objects) {
    return putAllByIndex(r'topicId', objects);
  }

  List<Id> putAllByTopicIdSync(List<TopicProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'topicId', objects, saveLinks: saveLinks);
  }
}

extension TopicProgressQueryWhereSort
    on QueryBuilder<TopicProgress, TopicProgress, QWhere> {
  QueryBuilder<TopicProgress, TopicProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TopicProgressQueryWhere
    on QueryBuilder<TopicProgress, TopicProgress, QWhereClause> {
  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> idBetween(
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

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause> topicIdEqualTo(
      String topicId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'topicId',
        value: [topicId],
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterWhereClause>
      topicIdNotEqualTo(String topicId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicId',
              lower: [],
              upper: [topicId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicId',
              lower: [topicId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicId',
              lower: [topicId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicId',
              lower: [],
              upper: [topicId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TopicProgressQueryFilter
    on QueryBuilder<TopicProgress, TopicProgress, QFilterCondition> {
  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highScore',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highScore',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highScore',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScorePercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highScorePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScorePercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highScorePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScorePercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highScorePercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      highScorePercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highScorePercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAttemptDate',
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAttemptDate',
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAttemptDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAttemptDate',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      lastAttemptDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAttemptDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topicId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topicId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topicId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicId',
        value: '',
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      topicIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topicId',
        value: '',
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalAttemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalAttemptsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalAttemptsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalAttemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAttempts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalQuestionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalQuestionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalQuestionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterFilterCondition>
      totalQuestionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalQuestions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TopicProgressQueryObject
    on QueryBuilder<TopicProgress, TopicProgress, QFilterCondition> {}

extension TopicProgressQueryLinks
    on QueryBuilder<TopicProgress, TopicProgress, QFilterCondition> {}

extension TopicProgressQuerySortBy
    on QueryBuilder<TopicProgress, TopicProgress, QSortBy> {
  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> sortByHighScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScore', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByHighScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScore', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByHighScorePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScorePercentage', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByHighScorePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScorePercentage', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByLastAttemptDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptDate', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByLastAttemptDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptDate', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> sortByTopicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> sortByTopicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByTotalAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAttempts', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByTotalAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAttempts', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      sortByTotalQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.desc);
    });
  }
}

extension TopicProgressQuerySortThenBy
    on QueryBuilder<TopicProgress, TopicProgress, QSortThenBy> {
  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenByHighScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScore', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByHighScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScore', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByHighScorePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScorePercentage', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByHighScorePercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highScorePercentage', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByLastAttemptDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptDate', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByLastAttemptDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptDate', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenByTopicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy> thenByTopicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicId', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByTotalAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAttempts', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByTotalAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAttempts', Sort.desc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.asc);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QAfterSortBy>
      thenByTotalQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.desc);
    });
  }
}

extension TopicProgressQueryWhereDistinct
    on QueryBuilder<TopicProgress, TopicProgress, QDistinct> {
  QueryBuilder<TopicProgress, TopicProgress, QDistinct> distinctByHighScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highScore');
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct>
      distinctByHighScorePercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highScorePercentage');
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct>
      distinctByLastAttemptDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptDate');
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct> distinctByTopicId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topicId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct>
      distinctByTotalAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAttempts');
    });
  }

  QueryBuilder<TopicProgress, TopicProgress, QDistinct>
      distinctByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalQuestions');
    });
  }
}

extension TopicProgressQueryProperty
    on QueryBuilder<TopicProgress, TopicProgress, QQueryProperty> {
  QueryBuilder<TopicProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TopicProgress, int, QQueryOperations> highScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highScore');
    });
  }

  QueryBuilder<TopicProgress, double, QQueryOperations>
      highScorePercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highScorePercentage');
    });
  }

  QueryBuilder<TopicProgress, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<TopicProgress, DateTime?, QQueryOperations>
      lastAttemptDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptDate');
    });
  }

  QueryBuilder<TopicProgress, String, QQueryOperations> topicIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topicId');
    });
  }

  QueryBuilder<TopicProgress, int, QQueryOperations> totalAttemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAttempts');
    });
  }

  QueryBuilder<TopicProgress, int, QQueryOperations> totalQuestionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalQuestions');
    });
  }
}
