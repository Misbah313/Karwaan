/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'greeting.dart' as _i4;
import 'app_auth_exception.dart' as _i5;
import 'app_exception.dart' as _i6;
import 'app_not_found_exception.dart' as _i7;
import 'app_permission_exception.dart' as _i8;
import 'attachment.dart' as _i9;
import 'auth_response.dart' as _i10;
import 'board.dart' as _i11;
import 'board_analytics.dart' as _i12;
import 'board_card.dart' as _i13;
import 'board_card_assignment.dart' as _i14;
import 'board_details.dart' as _i15;
import 'board_list.dart' as _i16;
import 'board_member.dart' as _i17;
import 'board_member_details.dart' as _i18;
import 'card_label.dart' as _i19;
import 'checklist.dart' as _i20;
import 'checklist_item.dart' as _i21;
import 'comment.dart' as _i22;
import 'comment_withauthor.dart' as _i23;
import 'label.dart' as _i24;
import 'overall_analytics.dart' as _i25;
import 'pinned_board.dart' as _i26;
import 'random_app_exception.dart' as _i27;
import 'user.dart' as _i28;
import 'user_recent_boards.dart' as _i29;
import 'user_token.dart' as _i30;
import 'workspace.dart' as _i31;
import 'workspace_member.dart' as _i32;
import 'workspace_member_details.dart' as _i33;
import 'package:karwaan_server/src/generated/board_analytics.dart' as _i34;
import 'package:karwaan_server/src/generated/attachment.dart' as _i35;
import 'package:karwaan_server/src/generated/board_card.dart' as _i36;
import 'package:karwaan_server/src/generated/board_card_assignment.dart'
    as _i37;
import 'package:karwaan_server/src/generated/user.dart' as _i38;
import 'package:karwaan_server/src/generated/board_details.dart' as _i39;
import 'package:karwaan_server/src/generated/board_list.dart' as _i40;
import 'package:karwaan_server/src/generated/board_member_details.dart' as _i41;
import 'package:karwaan_server/src/generated/label.dart' as _i42;
import 'package:karwaan_server/src/generated/checklist.dart' as _i43;
import 'package:karwaan_server/src/generated/checklist_item.dart' as _i44;
import 'package:karwaan_server/src/generated/comment_withauthor.dart' as _i45;
import 'package:karwaan_server/src/generated/board.dart' as _i46;
import 'package:karwaan_server/src/generated/workspace.dart' as _i47;
import 'package:karwaan_server/src/generated/workspace_member_details.dart'
    as _i48;
export 'greeting.dart';
export 'app_auth_exception.dart';
export 'app_exception.dart';
export 'app_not_found_exception.dart';
export 'app_permission_exception.dart';
export 'attachment.dart';
export 'auth_response.dart';
export 'board.dart';
export 'board_analytics.dart';
export 'board_card.dart';
export 'board_card_assignment.dart';
export 'board_details.dart';
export 'board_list.dart';
export 'board_member.dart';
export 'board_member_details.dart';
export 'card_label.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'comment.dart';
export 'comment_withauthor.dart';
export 'label.dart';
export 'overall_analytics.dart';
export 'pinned_board.dart';
export 'random_app_exception.dart';
export 'user.dart';
export 'user_recent_boards.dart';
export 'user_token.dart';
export 'workspace.dart';
export 'workspace_member.dart';
export 'workspace_member_details.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'attachment',
      dartName: 'Attachment',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'attachment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'card',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'uploadedBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'fileName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'attachment_fk_0',
          columns: ['card'],
          referenceTable: 'board_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'attachment_fk_1',
          columns: ['uploadedBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'attachment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board',
      dartName: 'Board',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_fk_1',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_analytics',
      dartName: 'BoardAnalytics',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_analytics_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'boardName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'totalCards',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'completedCards',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'completionPercentage',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'cardPerList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,int>?',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_analytics_fk_0',
          columns: ['boardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_analytics_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_card',
      dartName: 'BoardCard',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_card_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'list',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'position',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'isCompleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'assignedUsers',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_card_fk_0',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_card_fk_1',
          columns: ['list'],
          referenceTable: 'board_list',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_card_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_card_assignment',
      dartName: 'BoardCardAssignment',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_card_assignment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'card',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'user',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'assignedBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'assignedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_card_assignment_fk_0',
          columns: ['card'],
          referenceTable: 'board_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_card_assignment_fk_1',
          columns: ['user'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_card_assignment_fk_2',
          columns: ['assignedBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_card_assignment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_details',
      dartName: 'BoardDetails',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_details_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'members',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_details_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_details_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_list',
      dartName: 'BoardList',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_list_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'board',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_list_fk_0',
          columns: ['board'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_list_fk_1',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_list_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'board_member',
      dartName: 'BoardMember',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'board_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'user',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'board',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'board_member_fk_0',
          columns: ['user'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'board_member_fk_1',
          columns: ['board'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'board_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'boardmemberdetails',
      dartName: 'BoardMemberDetails',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'boardmemberdetails_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'avatarUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'boardmemberdetails_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'boardmemberdetails_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'card_label',
      dartName: 'CardLabel',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_label_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'card',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'label',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_label_fk_0',
          columns: ['card'],
          referenceTable: 'board_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'card_label_fk_1',
          columns: ['label'],
          referenceTable: 'lable',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'card_label_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'check_list',
      dartName: 'CheckList',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'check_list_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'card',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'check_list_fk_0',
          columns: ['card'],
          referenceTable: 'board_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'check_list_fk_1',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'check_list_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'checklist_item',
      dartName: 'CheckListItem',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'checklist_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'checklist',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isDone',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'checklist_item_fk_0',
          columns: ['checklist'],
          referenceTable: 'check_list',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'checklist_item_fk_1',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'checklist_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'comment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'card',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'author',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['card'],
          referenceTable: 'board_card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'comment_fk_1',
          columns: ['author'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'lable',
      dartName: 'Label',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'lable_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'color',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'board',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'lable_fk_0',
          columns: ['board'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'lable_fk_1',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'lable_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'over_all_analytics',
      dartName: 'OverAllAnalytics',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'over_all_analytics_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'totalBoard',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'totalCard',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'completedCards',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'completionPercentage',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'cardsPerWorkspace',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,int>?',
        ),
        _i2.ColumnDefinition(
          name: 'cardsPerStatus',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,int>?',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'over_all_analytics_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'over_all_analytics_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'pinned_boards',
      dartName: 'PinnedBoard',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'pinned_boards_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'pinnedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pinned_boards_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user',
      dartName: 'User',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'password',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'profileImage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isDarkMode',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_recent_boards',
      dartName: 'UserRecentBoards',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_recent_boards_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'boardId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastAccess',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_recent_boards_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'user_recent_boards_fk_1',
          columns: ['boardId'],
          referenceTable: 'board',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_recent_boards_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_token',
      dartName: 'UserToken',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_token_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_token_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace',
      dartName: 'Workspace',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ownerId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'backgroundColor',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isPrivate',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_fk_0',
          columns: ['ownerId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace_member',
      dartName: 'WorkspaceMember',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'user',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'workspace',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_0',
          columns: ['user'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_1',
          columns: ['workspace'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspacememberdetails',
      dartName: 'WorkspaceMemberDetails',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspacememberdetails_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'avatarUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspacememberdetails_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspacememberdetails_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.Greeting) {
      return _i4.Greeting.fromJson(data) as T;
    }
    if (t == _i5.AppAuthException) {
      return _i5.AppAuthException.fromJson(data) as T;
    }
    if (t == _i6.AppException) {
      return _i6.AppException.fromJson(data) as T;
    }
    if (t == _i7.AppNotFoundException) {
      return _i7.AppNotFoundException.fromJson(data) as T;
    }
    if (t == _i8.AppPermissionException) {
      return _i8.AppPermissionException.fromJson(data) as T;
    }
    if (t == _i9.Attachment) {
      return _i9.Attachment.fromJson(data) as T;
    }
    if (t == _i10.AuthResponse) {
      return _i10.AuthResponse.fromJson(data) as T;
    }
    if (t == _i11.Board) {
      return _i11.Board.fromJson(data) as T;
    }
    if (t == _i12.BoardAnalytics) {
      return _i12.BoardAnalytics.fromJson(data) as T;
    }
    if (t == _i13.BoardCard) {
      return _i13.BoardCard.fromJson(data) as T;
    }
    if (t == _i14.BoardCardAssignment) {
      return _i14.BoardCardAssignment.fromJson(data) as T;
    }
    if (t == _i15.BoardDetails) {
      return _i15.BoardDetails.fromJson(data) as T;
    }
    if (t == _i16.BoardList) {
      return _i16.BoardList.fromJson(data) as T;
    }
    if (t == _i17.BoardMember) {
      return _i17.BoardMember.fromJson(data) as T;
    }
    if (t == _i18.BoardMemberDetails) {
      return _i18.BoardMemberDetails.fromJson(data) as T;
    }
    if (t == _i19.CardLabel) {
      return _i19.CardLabel.fromJson(data) as T;
    }
    if (t == _i20.CheckList) {
      return _i20.CheckList.fromJson(data) as T;
    }
    if (t == _i21.CheckListItem) {
      return _i21.CheckListItem.fromJson(data) as T;
    }
    if (t == _i22.Comment) {
      return _i22.Comment.fromJson(data) as T;
    }
    if (t == _i23.CommentWithAuthor) {
      return _i23.CommentWithAuthor.fromJson(data) as T;
    }
    if (t == _i24.Label) {
      return _i24.Label.fromJson(data) as T;
    }
    if (t == _i25.OverAllAnalytics) {
      return _i25.OverAllAnalytics.fromJson(data) as T;
    }
    if (t == _i26.PinnedBoard) {
      return _i26.PinnedBoard.fromJson(data) as T;
    }
    if (t == _i27.RandomAppException) {
      return _i27.RandomAppException.fromJson(data) as T;
    }
    if (t == _i28.User) {
      return _i28.User.fromJson(data) as T;
    }
    if (t == _i29.UserRecentBoards) {
      return _i29.UserRecentBoards.fromJson(data) as T;
    }
    if (t == _i30.UserToken) {
      return _i30.UserToken.fromJson(data) as T;
    }
    if (t == _i31.Workspace) {
      return _i31.Workspace.fromJson(data) as T;
    }
    if (t == _i32.WorkspaceMember) {
      return _i32.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i33.WorkspaceMemberDetails) {
      return _i33.WorkspaceMemberDetails.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.Greeting?>()) {
      return (data != null ? _i4.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AppAuthException?>()) {
      return (data != null ? _i5.AppAuthException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AppException?>()) {
      return (data != null ? _i6.AppException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AppNotFoundException?>()) {
      return (data != null ? _i7.AppNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.AppPermissionException?>()) {
      return (data != null ? _i8.AppPermissionException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.Attachment?>()) {
      return (data != null ? _i9.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AuthResponse?>()) {
      return (data != null ? _i10.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Board?>()) {
      return (data != null ? _i11.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BoardAnalytics?>()) {
      return (data != null ? _i12.BoardAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.BoardCard?>()) {
      return (data != null ? _i13.BoardCard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BoardCardAssignment?>()) {
      return (data != null ? _i14.BoardCardAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.BoardDetails?>()) {
      return (data != null ? _i15.BoardDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BoardList?>()) {
      return (data != null ? _i16.BoardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BoardMember?>()) {
      return (data != null ? _i17.BoardMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.BoardMemberDetails?>()) {
      return (data != null ? _i18.BoardMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.CardLabel?>()) {
      return (data != null ? _i19.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.CheckList?>()) {
      return (data != null ? _i20.CheckList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.CheckListItem?>()) {
      return (data != null ? _i21.CheckListItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Comment?>()) {
      return (data != null ? _i22.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CommentWithAuthor?>()) {
      return (data != null ? _i23.CommentWithAuthor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Label?>()) {
      return (data != null ? _i24.Label.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.OverAllAnalytics?>()) {
      return (data != null ? _i25.OverAllAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.PinnedBoard?>()) {
      return (data != null ? _i26.PinnedBoard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.RandomAppException?>()) {
      return (data != null ? _i27.RandomAppException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.User?>()) {
      return (data != null ? _i28.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.UserRecentBoards?>()) {
      return (data != null ? _i29.UserRecentBoards.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserToken?>()) {
      return (data != null ? _i30.UserToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Workspace?>()) {
      return (data != null ? _i31.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.WorkspaceMember?>()) {
      return (data != null ? _i32.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.WorkspaceMemberDetails?>()) {
      return (data != null ? _i33.WorkspaceMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == List<_i34.BoardAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i34.BoardAnalytics>(e))
          .toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i35.Attachment>) {
      return (data as List).map((e) => deserialize<_i35.Attachment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<_i36.BoardCard>) {
      return (data as List).map((e) => deserialize<_i36.BoardCard>(e)).toList()
          as T;
    }
    if (t == List<_i37.BoardCardAssignment>) {
      return (data as List)
          .map((e) => deserialize<_i37.BoardCardAssignment>(e))
          .toList() as T;
    }
    if (t == List<_i38.User>) {
      return (data as List).map((e) => deserialize<_i38.User>(e)).toList() as T;
    }
    if (t == List<_i39.BoardDetails>) {
      return (data as List)
          .map((e) => deserialize<_i39.BoardDetails>(e))
          .toList() as T;
    }
    if (t == List<_i40.BoardList>) {
      return (data as List).map((e) => deserialize<_i40.BoardList>(e)).toList()
          as T;
    }
    if (t == List<_i41.BoardMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i41.BoardMemberDetails>(e))
          .toList() as T;
    }
    if (t == List<_i42.Label>) {
      return (data as List).map((e) => deserialize<_i42.Label>(e)).toList()
          as T;
    }
    if (t == List<_i43.CheckList>) {
      return (data as List).map((e) => deserialize<_i43.CheckList>(e)).toList()
          as T;
    }
    if (t == List<_i44.CheckListItem>) {
      return (data as List)
          .map((e) => deserialize<_i44.CheckListItem>(e))
          .toList() as T;
    }
    if (t == List<_i45.CommentWithAuthor>) {
      return (data as List)
          .map((e) => deserialize<_i45.CommentWithAuthor>(e))
          .toList() as T;
    }
    if (t == List<_i46.Board>) {
      return (data as List).map((e) => deserialize<_i46.Board>(e)).toList()
          as T;
    }
    if (t == List<_i47.Workspace>) {
      return (data as List).map((e) => deserialize<_i47.Workspace>(e)).toList()
          as T;
    }
    if (t == List<_i48.WorkspaceMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i48.WorkspaceMemberDetails>(e))
          .toList() as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.Greeting) {
      return 'Greeting';
    }
    if (data is _i5.AppAuthException) {
      return 'AppAuthException';
    }
    if (data is _i6.AppException) {
      return 'AppException';
    }
    if (data is _i7.AppNotFoundException) {
      return 'AppNotFoundException';
    }
    if (data is _i8.AppPermissionException) {
      return 'AppPermissionException';
    }
    if (data is _i9.Attachment) {
      return 'Attachment';
    }
    if (data is _i10.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i11.Board) {
      return 'Board';
    }
    if (data is _i12.BoardAnalytics) {
      return 'BoardAnalytics';
    }
    if (data is _i13.BoardCard) {
      return 'BoardCard';
    }
    if (data is _i14.BoardCardAssignment) {
      return 'BoardCardAssignment';
    }
    if (data is _i15.BoardDetails) {
      return 'BoardDetails';
    }
    if (data is _i16.BoardList) {
      return 'BoardList';
    }
    if (data is _i17.BoardMember) {
      return 'BoardMember';
    }
    if (data is _i18.BoardMemberDetails) {
      return 'BoardMemberDetails';
    }
    if (data is _i19.CardLabel) {
      return 'CardLabel';
    }
    if (data is _i20.CheckList) {
      return 'CheckList';
    }
    if (data is _i21.CheckListItem) {
      return 'CheckListItem';
    }
    if (data is _i22.Comment) {
      return 'Comment';
    }
    if (data is _i23.CommentWithAuthor) {
      return 'CommentWithAuthor';
    }
    if (data is _i24.Label) {
      return 'Label';
    }
    if (data is _i25.OverAllAnalytics) {
      return 'OverAllAnalytics';
    }
    if (data is _i26.PinnedBoard) {
      return 'PinnedBoard';
    }
    if (data is _i27.RandomAppException) {
      return 'RandomAppException';
    }
    if (data is _i28.User) {
      return 'User';
    }
    if (data is _i29.UserRecentBoards) {
      return 'UserRecentBoards';
    }
    if (data is _i30.UserToken) {
      return 'UserToken';
    }
    if (data is _i31.Workspace) {
      return 'Workspace';
    }
    if (data is _i32.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i33.WorkspaceMemberDetails) {
      return 'WorkspaceMemberDetails';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i4.Greeting>(data['data']);
    }
    if (dataClassName == 'AppAuthException') {
      return deserialize<_i5.AppAuthException>(data['data']);
    }
    if (dataClassName == 'AppException') {
      return deserialize<_i6.AppException>(data['data']);
    }
    if (dataClassName == 'AppNotFoundException') {
      return deserialize<_i7.AppNotFoundException>(data['data']);
    }
    if (dataClassName == 'AppPermissionException') {
      return deserialize<_i8.AppPermissionException>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i9.Attachment>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i10.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i11.Board>(data['data']);
    }
    if (dataClassName == 'BoardAnalytics') {
      return deserialize<_i12.BoardAnalytics>(data['data']);
    }
    if (dataClassName == 'BoardCard') {
      return deserialize<_i13.BoardCard>(data['data']);
    }
    if (dataClassName == 'BoardCardAssignment') {
      return deserialize<_i14.BoardCardAssignment>(data['data']);
    }
    if (dataClassName == 'BoardDetails') {
      return deserialize<_i15.BoardDetails>(data['data']);
    }
    if (dataClassName == 'BoardList') {
      return deserialize<_i16.BoardList>(data['data']);
    }
    if (dataClassName == 'BoardMember') {
      return deserialize<_i17.BoardMember>(data['data']);
    }
    if (dataClassName == 'BoardMemberDetails') {
      return deserialize<_i18.BoardMemberDetails>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i19.CardLabel>(data['data']);
    }
    if (dataClassName == 'CheckList') {
      return deserialize<_i20.CheckList>(data['data']);
    }
    if (dataClassName == 'CheckListItem') {
      return deserialize<_i21.CheckListItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i22.Comment>(data['data']);
    }
    if (dataClassName == 'CommentWithAuthor') {
      return deserialize<_i23.CommentWithAuthor>(data['data']);
    }
    if (dataClassName == 'Label') {
      return deserialize<_i24.Label>(data['data']);
    }
    if (dataClassName == 'OverAllAnalytics') {
      return deserialize<_i25.OverAllAnalytics>(data['data']);
    }
    if (dataClassName == 'PinnedBoard') {
      return deserialize<_i26.PinnedBoard>(data['data']);
    }
    if (dataClassName == 'RandomAppException') {
      return deserialize<_i27.RandomAppException>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i28.User>(data['data']);
    }
    if (dataClassName == 'UserRecentBoards') {
      return deserialize<_i29.UserRecentBoards>(data['data']);
    }
    if (dataClassName == 'UserToken') {
      return deserialize<_i30.UserToken>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i31.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i32.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberDetails') {
      return deserialize<_i33.WorkspaceMemberDetails>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i9.Attachment:
        return _i9.Attachment.t;
      case _i11.Board:
        return _i11.Board.t;
      case _i12.BoardAnalytics:
        return _i12.BoardAnalytics.t;
      case _i13.BoardCard:
        return _i13.BoardCard.t;
      case _i14.BoardCardAssignment:
        return _i14.BoardCardAssignment.t;
      case _i15.BoardDetails:
        return _i15.BoardDetails.t;
      case _i16.BoardList:
        return _i16.BoardList.t;
      case _i17.BoardMember:
        return _i17.BoardMember.t;
      case _i18.BoardMemberDetails:
        return _i18.BoardMemberDetails.t;
      case _i19.CardLabel:
        return _i19.CardLabel.t;
      case _i20.CheckList:
        return _i20.CheckList.t;
      case _i21.CheckListItem:
        return _i21.CheckListItem.t;
      case _i22.Comment:
        return _i22.Comment.t;
      case _i24.Label:
        return _i24.Label.t;
      case _i25.OverAllAnalytics:
        return _i25.OverAllAnalytics.t;
      case _i26.PinnedBoard:
        return _i26.PinnedBoard.t;
      case _i28.User:
        return _i28.User.t;
      case _i29.UserRecentBoards:
        return _i29.UserRecentBoards.t;
      case _i30.UserToken:
        return _i30.UserToken.t;
      case _i31.Workspace:
        return _i31.Workspace.t;
      case _i32.WorkspaceMember:
        return _i32.WorkspaceMember.t;
      case _i33.WorkspaceMemberDetails:
        return _i33.WorkspaceMemberDetails.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'karwaan';
}
