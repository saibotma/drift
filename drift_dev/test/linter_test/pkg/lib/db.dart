import 'package:drift/drift.dart';

part 'db.g.dart';

class Users extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
  // expect_lint: drift_build_errors
  late final age = integer();
  // ignore: drift_build_errors
  late final age2 = integer()();
}

class BrokenTable extends Table {
  // expect_lint: drift_build_errors
  IntColumn get unknownRef => integer().customConstraint('CHECK foo > 10')();
}

@DriftDatabase(tables: [Users])
class TestDatabase extends _$TestDatabase {
  TestDatabase(super.e);

  @override
  int get schemaVersion => 1;

  a() async {
    // expect_lint: offset_without_limit
    managers.users.get(offset: 1);
    // expect_lint: offset_without_limit
    managers.users.watch(offset: 1);
    managers.users.get();
    managers.users.get(distinct: true);
    managers.users.get(limit: 1);
    managers.users.get(limit: 1, distinct: true);
    managers.users.get(limit: 1, offset: 1);
    managers.users.get(limit: 1, offset: 1, distinct: true);

    transaction(
      () async {
        // expect_lint: unawaited_futures_in_transaction
        into(users).insert(UsersCompanion.insert(name: 'name'));
      },
    );
  }
}

class A {
  void get() {}
}

void a() {
  A().get();
}
