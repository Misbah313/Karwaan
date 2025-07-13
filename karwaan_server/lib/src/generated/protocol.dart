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
import 'greeting.dart' as _i3;
import 'attachment.dart' as _i4;
import 'auth_response.dart' as _i5;
import 'board.dart' as _i6;
import 'board_details.dart' as _i7;
import 'board_list.dart' as _i8;
import 'board_member.dart' as _i9;
import 'card.dart' as _i10;
import 'card_label.dart' as _i11;
import 'checklist.dart' as _i12;
import 'checklist_item.dart' as _i13;
import 'comment.dart' as _i14;
import 'label.dart' as _i15;
import 'user.dart' as _i16;
import 'user_token.dart' as _i17;
import 'workspace.dart' as _i18;
import 'workspace_member.dart' as _i19;
import 'package:karwaan_server/src/generated/board_details.dart' as _i20;
import 'package:karwaan_server/src/generated/board_list.dart' as _i21;
import 'package:karwaan_server/src/endpoints/board_member_details.dart' as _i22;
import 'package:karwaan_server/src/generated/card.dart' as _i23;
import 'package:karwaan_server/src/generated/label.dart' as _i24;
import 'package:karwaan_server/src/generated/user.dart' as _i25;
import 'package:karwaan_server/src/generated/workspace.dart' as _i26;
import 'package:karwaan_server/src/endpoints/workspace_member_details.dart'
    as _i27;
export 'greeting.dart';
export 'attachment.dart';
export 'auth_response.dart';
export 'board.dart';
export 'board_details.dart';
export 'board_list.dart';
export 'board_member.dart';
export 'card.dart';
export 'card_label.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'comment.dart';
export 'label.dart';
export 'user.dart';
export 'user_token.dart';
export 'workspace.dart';
export 'workspace_member.dart';

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
          referenceTable: 'card',
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
          isNullable: true,
          dartType: 'String?',
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
      name: 'card',
      dartName: 'Card',
      schema: 'public',
      module: 'karwaan',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'card_id_seq\'::regclass)',
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
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'card_fk_0',
          columns: ['createdBy'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'card_fk_1',
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
          indexName: 'card_pkey',
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
          referenceTable: 'card',
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
          name: 'name',
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
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'check_list_fk_0',
          columns: ['card'],
          referenceTable: 'card',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
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
        )
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
          referenceTable: 'card',
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
          name: 'name',
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
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.Greeting) {
      return _i3.Greeting.fromJson(data) as T;
    }
    if (t == _i4.Attachment) {
      return _i4.Attachment.fromJson(data) as T;
    }
    if (t == _i5.AuthResponse) {
      return _i5.AuthResponse.fromJson(data) as T;
    }
    if (t == _i6.Board) {
      return _i6.Board.fromJson(data) as T;
    }
    if (t == _i7.BoardDetails) {
      return _i7.BoardDetails.fromJson(data) as T;
    }
    if (t == _i8.BoardList) {
      return _i8.BoardList.fromJson(data) as T;
    }
    if (t == _i9.BoardMember) {
      return _i9.BoardMember.fromJson(data) as T;
    }
    if (t == _i10.Card) {
      return _i10.Card.fromJson(data) as T;
    }
    if (t == _i11.CardLabel) {
      return _i11.CardLabel.fromJson(data) as T;
    }
    if (t == _i12.CheckList) {
      return _i12.CheckList.fromJson(data) as T;
    }
    if (t == _i13.CheckListItem) {
      return _i13.CheckListItem.fromJson(data) as T;
    }
    if (t == _i14.Comment) {
      return _i14.Comment.fromJson(data) as T;
    }
    if (t == _i15.Label) {
      return _i15.Label.fromJson(data) as T;
    }
    if (t == _i16.User) {
      return _i16.User.fromJson(data) as T;
    }
    if (t == _i17.UserToken) {
      return _i17.UserToken.fromJson(data) as T;
    }
    if (t == _i18.Workspace) {
      return _i18.Workspace.fromJson(data) as T;
    }
    if (t == _i19.WorkspaceMember) {
      return _i19.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.Greeting?>()) {
      return (data != null ? _i3.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Attachment?>()) {
      return (data != null ? _i4.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthResponse?>()) {
      return (data != null ? _i5.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Board?>()) {
      return (data != null ? _i6.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BoardDetails?>()) {
      return (data != null ? _i7.BoardDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BoardList?>()) {
      return (data != null ? _i8.BoardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.BoardMember?>()) {
      return (data != null ? _i9.BoardMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Card?>()) {
      return (data != null ? _i10.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CardLabel?>()) {
      return (data != null ? _i11.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CheckList?>()) {
      return (data != null ? _i12.CheckList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CheckListItem?>()) {
      return (data != null ? _i13.CheckListItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Comment?>()) {
      return (data != null ? _i14.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Label?>()) {
      return (data != null ? _i15.Label.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.User?>()) {
      return (data != null ? _i16.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserToken?>()) {
      return (data != null ? _i17.UserToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Workspace?>()) {
      return (data != null ? _i18.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.WorkspaceMember?>()) {
      return (data != null ? _i19.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i20.BoardDetails>) {
      return (data as List)
          .map((e) => deserialize<_i20.BoardDetails>(e))
          .toList() as T;
    }
    if (t == List<_i21.BoardList>) {
      return (data as List).map((e) => deserialize<_i21.BoardList>(e)).toList()
          as T;
    }
    if (t == List<_i22.BoardMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i22.BoardMemberDetails>(e))
          .toList() as T;
    }
    if (t == List<_i23.Card>) {
      return (data as List).map((e) => deserialize<_i23.Card>(e)).toList() as T;
    }
    if (t == List<_i24.Label>) {
      return (data as List).map((e) => deserialize<_i24.Label>(e)).toList()
          as T;
    }
    if (t == List<_i25.User>) {
      return (data as List).map((e) => deserialize<_i25.User>(e)).toList() as T;
    }
    if (t == List<_i26.Workspace>) {
      return (data as List).map((e) => deserialize<_i26.Workspace>(e)).toList()
          as T;
    }
    if (t == List<_i27.WorkspaceMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i27.WorkspaceMemberDetails>(e))
          .toList() as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.Greeting) {
      return 'Greeting';
    }
    if (data is _i4.Attachment) {
      return 'Attachment';
    }
    if (data is _i5.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i6.Board) {
      return 'Board';
    }
    if (data is _i7.BoardDetails) {
      return 'BoardDetails';
    }
    if (data is _i8.BoardList) {
      return 'BoardList';
    }
    if (data is _i9.BoardMember) {
      return 'BoardMember';
    }
    if (data is _i10.Card) {
      return 'Card';
    }
    if (data is _i11.CardLabel) {
      return 'CardLabel';
    }
    if (data is _i12.CheckList) {
      return 'CheckList';
    }
    if (data is _i13.CheckListItem) {
      return 'CheckListItem';
    }
    if (data is _i14.Comment) {
      return 'Comment';
    }
    if (data is _i15.Label) {
      return 'Label';
    }
    if (data is _i16.User) {
      return 'User';
    }
    if (data is _i17.UserToken) {
      return 'UserToken';
    }
    if (data is _i18.Workspace) {
      return 'Workspace';
    }
    if (data is _i19.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.Greeting>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i4.Attachment>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i5.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i6.Board>(data['data']);
    }
    if (dataClassName == 'BoardDetails') {
      return deserialize<_i7.BoardDetails>(data['data']);
    }
    if (dataClassName == 'BoardList') {
      return deserialize<_i8.BoardList>(data['data']);
    }
    if (dataClassName == 'BoardMember') {
      return deserialize<_i9.BoardMember>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i10.Card>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i11.CardLabel>(data['data']);
    }
    if (dataClassName == 'CheckList') {
      return deserialize<_i12.CheckList>(data['data']);
    }
    if (dataClassName == 'CheckListItem') {
      return deserialize<_i13.CheckListItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i14.Comment>(data['data']);
    }
    if (dataClassName == 'Label') {
      return deserialize<_i15.Label>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i16.User>(data['data']);
    }
    if (dataClassName == 'UserToken') {
      return deserialize<_i17.UserToken>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i18.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i19.WorkspaceMember>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.Attachment:
        return _i4.Attachment.t;
      case _i6.Board:
        return _i6.Board.t;
      case _i8.BoardList:
        return _i8.BoardList.t;
      case _i9.BoardMember:
        return _i9.BoardMember.t;
      case _i10.Card:
        return _i10.Card.t;
      case _i11.CardLabel:
        return _i11.CardLabel.t;
      case _i12.CheckList:
        return _i12.CheckList.t;
      case _i13.CheckListItem:
        return _i13.CheckListItem.t;
      case _i14.Comment:
        return _i14.Comment.t;
      case _i15.Label:
        return _i15.Label.t;
      case _i16.User:
        return _i16.User.t;
      case _i17.UserToken:
        return _i17.UserToken.t;
      case _i18.Workspace:
        return _i18.Workspace.t;
      case _i19.WorkspaceMember:
        return _i19.WorkspaceMember.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'karwaan';
}
