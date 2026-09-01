// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themes_dao.dart';

// ignore_for_file: type=lint
mixin _$ThemesDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppThemesTable get appThemes => attachedDatabase.appThemes;
  ThemesDaoManager get managers => ThemesDaoManager(this);
}

class ThemesDaoManager {
  final _$ThemesDaoMixin _db;
  ThemesDaoManager(this._db);
  $$AppThemesTableTableManager get appThemes =>
      $$AppThemesTableTableManager(_db.attachedDatabase, _db.appThemes);
}
