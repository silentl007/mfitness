import 'package:mfitness/model/services/core/myclass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ClientDatabaseHelper {
  static const String dbName = 'client_management.db';
  static const int dbVersion = 1;

  // Table names
  static const String tableClientData = 'clientData';
  static const String tableClientPaymentData = 'clientPaymentData';

  // ClientData columns
  static const String columnClientId = 'id';
  static const String columnFirstName = 'firstName';
  static const String columnLastName = 'lastName';
  static const String columnEmailAddress = 'emailAddress';
  static const String columnBranch = 'branch';
  static const String columnHeight = 'height';
  static const String columnWeight = 'weight';
  static const String columnIsOldCustomer = 'isOldCustomer';
  static const String columnGender = 'gender';
  static const String columnDateJoined = 'dateJoined';
  static const String columnDateOfBirth = 'dateOfBirth';

  // ClientPaymentData columns
  static const String columnPaymentId = 'id';
  static const String columnPaymentClientId = 'clientId';
  static const String columnPaymentFirstName = 'firstName';
  static const String columnPaymentLastName = 'lastName';
  static const String columnDatePaid = 'datePaid';
  static const String columnExpirationDate = 'expirationDate';
  static const String columnDuration = 'duration';
  static const String columnAmountPaid = 'amountPaid';
  static const String columnPaymentBranch = 'branch';

  static final ClientDatabaseHelper _instance =
      ClientDatabaseHelper._internal();

  factory ClientDatabaseHelper() {
    return _instance;
  }

  ClientDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create clientData table
    await db.execute('''
      CREATE TABLE $tableClientData (
        $columnClientId TEXT PRIMARY KEY,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnEmailAddress TEXT NOT NULL UNIQUE,
        $columnBranch TEXT NOT NULL,
        $columnHeight REAL NOT NULL,
        $columnWeight REAL NOT NULL,
        $columnIsOldCustomer INTEGER DEFAULT 0,
        $columnGender TEXT NOT NULL,
        $columnDateJoined TEXT NOT NULL,
        $columnDateOfBirth TEXT NOT NULL
      )
    ''');

    // Create clientPaymentData table
    await db.execute('''
      CREATE TABLE $tableClientPaymentData (
        $columnPaymentId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnPaymentClientId TEXT NOT NULL,
        $columnPaymentFirstName TEXT NOT NULL,
        $columnPaymentLastName TEXT NOT NULL,
        $columnDatePaid TEXT NOT NULL,
        $columnExpirationDate TEXT NOT NULL,
        $columnDuration INTEGER NOT NULL,
        $columnAmountPaid INTEGER NOT NULL,
        $columnPaymentBranch TEXT NOT NULL,
        FOREIGN KEY ($columnPaymentClientId) REFERENCES $tableClientData ($columnClientId) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_client_dateJoined ON $tableClientData($columnDateJoined)
    ''');

    await db.execute('''
      CREATE INDEX idx_payment_clientId ON $tableClientPaymentData($columnPaymentClientId)
    ''');

    await db.execute('''
      CREATE INDEX idx_payment_datePaid ON $tableClientPaymentData($columnDatePaid)
    ''');

    await db.execute('''
      CREATE INDEX idx_payment_expirationDate ON $tableClientPaymentData($columnExpirationDate)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database version upgrades here
  }

  // ==================== ClientData CRUD Operations ====================

  /// Insert a new client
  Future<bool> insertClient(ClientProfileData client) async {
    try {
      final Database db = await database;
      await db.insert(
        tableClientData,
        {
          columnClientId: client.id,
          columnFirstName: client.firstName,
          columnLastName: client.lastName,
          columnEmailAddress: client.emailAddress,
          columnBranch: client.branch,
          columnHeight: client.height,
          columnWeight: client.weight,
          columnIsOldCustomer: client.isOldCustomer,
          columnGender: client.gender,
          columnDateJoined: client.dateJoined.toIso8601String(),
          columnDateOfBirth: client.dateOfBirth.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error inserting client: $e');
      return false;
    }
  }

  /// Read a client by ID
  Future<ClientProfileData?> getClientById(String clientId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableClientData,
        where: '$columnClientId = ?',
        whereArgs: [clientId],
      );

      if (maps.isNotEmpty) {
        return ClientProfileData.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      print('Error fetching client: $e');
      return null;
    }
  }

  /// Update a client
  Future<bool> updateClient(ClientProfileData client) async {
    try {
      final Database db = await database;
      final int result = await db.update(
        tableClientData,
        {
          columnFirstName: client.firstName,
          columnLastName: client.lastName,
          columnEmailAddress: client.emailAddress,
          columnBranch: client.branch,
          columnHeight: client.height,
          columnWeight: client.weight,
          columnIsOldCustomer: client.isOldCustomer,
          columnGender: client.gender,
          columnDateJoined: client.dateJoined.toIso8601String(),
          columnDateOfBirth: client.dateOfBirth.toIso8601String(),
        },
        where: '$columnClientId = ?',
        whereArgs: [client.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating client: $e');
      return false;
    }
  }

  /// Delete a client (cascade deletes payments)
  Future<bool> deleteClient(String clientId) async {
    try {
      final Database db = await database;
      final int result = await db.delete(
        tableClientData,
        where: '$columnClientId = ?',
        whereArgs: [clientId],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting client: $e');
      return false;
    }
  }

  // ==================== ClientData Query Operations ====================

  /// Fetch all clients
  Future<List<ClientProfileData>> getAllClients() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(tableClientData);
      return maps.map((json) => ClientProfileData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching all clients: $e');
      return [];
    }
  }

  /// Fetch all payment history for a specific client
  Future<List<ClientPaymentData>> getPaymentHistoryByClientId(
      String clientId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        where: '$columnPaymentClientId = ?',
        whereArgs: [clientId],
        orderBy: '$columnDatePaid DESC',
      );
      return maps.map((json) => ClientPaymentData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching payment history: $e');
      return [];
    }
  }

  /// Fetch clients based on date joined filter (within a date range)
  Future<List<ClientProfileData>> getClientsByDateJoinedRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final Database db = await database;
      final String startIso = startDate.toIso8601String();
      final String endIso = endDate.toIso8601String();

      final List<Map<String, dynamic>> maps = await db.query(
        tableClientData,
        where: '$columnDateJoined >= ? AND $columnDateJoined <= ?',
        whereArgs: [startIso, endIso],
        orderBy: '$columnDateJoined DESC',
      );
      return maps.map((json) => ClientProfileData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching clients by date range: $e');
      return [];
    }
  }

  // ==================== ClientPaymentData CRUD Operations ====================

  /// Insert a new payment
  Future<bool> insertPayment(ClientPaymentData payment) async {
    try {
      final Database db = await database;
      await db.insert(
        tableClientPaymentData,
        {
          columnPaymentClientId: payment.clientId,
          columnPaymentFirstName: payment.firstName,
          columnPaymentLastName: payment.lastName,
          columnDatePaid: payment.datePaid.toIso8601String(),
          columnExpirationDate: payment.expirationDate.toIso8601String(),
          columnDuration: payment.duration,
          columnAmountPaid: payment.amountPaid,
          columnPaymentBranch: payment.branch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error inserting payment: $e');
      return false;
    }
  }

  /// Read a payment by ID
  Future<ClientPaymentData?> getPaymentById(int paymentId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        where: '$columnPaymentId = ?',
        whereArgs: [paymentId],
      );

      if (maps.isNotEmpty) {
        return ClientPaymentData.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      print('Error fetching payment: $e');
      return null;
    }
  }

  /// Update a payment
  Future<bool> updatePayment(ClientPaymentData payment) async {
    try {
      final Database db = await database;
      final int result = await db.update(
        tableClientPaymentData,
        {
          columnPaymentClientId: payment.clientId,
          columnPaymentFirstName: payment.firstName,
          columnPaymentLastName: payment.lastName,
          columnDatePaid: payment.datePaid.toIso8601String(),
          columnExpirationDate: payment.expirationDate.toIso8601String(),
          columnDuration: payment.duration,
          columnAmountPaid: payment.amountPaid,
          columnPaymentBranch: payment.branch,
        },
        where: '$columnPaymentId = ?',
        whereArgs: [payment.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating payment: $e');
      return false;
    }
  }

  /// Delete a payment
  Future<bool> deletePayment(int paymentId) async {
    try {
      final Database db = await database;
      final int result = await db.delete(
        tableClientPaymentData,
        where: '$columnPaymentId = ?',
        whereArgs: [paymentId],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting payment: $e');
      return false;
    }
  }

  // ==================== ClientPaymentData Query Operations ====================

  /// Fetch all payments within a date range
  Future<List<ClientPaymentData>> getPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final Database db = await database;
      final String startIso = startDate.toIso8601String();
      final String endIso = endDate.toIso8601String();

      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        where: '$columnDatePaid >= ? AND $columnDatePaid <= ?',
        whereArgs: [startIso, endIso],
        orderBy: '$columnDatePaid DESC',
      );
      return maps.map((json) => ClientPaymentData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching payments by date range: $e');
      return [];
    }
  }

  /// Return all payments before expiration date (payments that are expired)
  Future<List<ClientPaymentData>> getExpiredPayments(DateTime beforeDate) async {
    try {
      final Database db = await database;
      final String beforeIso = beforeDate.toIso8601String();

      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        where: '$columnExpirationDate < ?',
        whereArgs: [beforeIso],
        orderBy: '$columnExpirationDate ASC',
      );
      return maps.map((json) => ClientPaymentData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching expired payments: $e');
      return [];
    }
  }

  /// Get all payments (no filter)
  Future<List<ClientPaymentData>> getAllPayments() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        orderBy: '$columnDatePaid DESC',
      );
      return maps.map((json) => ClientPaymentData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching all payments: $e');
      return [];
    }
  }

  /// Get total amount paid by a client
  Future<int> getTotalPaidByClient(String clientId) async {
    try {
      final Database db = await database;
      final result = await db.rawQuery(
        'SELECT SUM($columnAmountPaid) as total FROM $tableClientPaymentData WHERE $columnPaymentClientId = ?',
        [clientId],
      );

      if (result.isNotEmpty && result.first['total'] != null) {
        return result.first['total'] as int;
      }
      return 0;
    } catch (e) {
      print('Error calculating total paid: $e');
      return 0;
    }
  }

  /// Get payments expiring soon (within next X days)
  Future<List<ClientPaymentData>> getPaymentsExpiringWithin(int days) async {
    try {
      final Database db = await database;
      final DateTime now = DateTime.now();
      final DateTime futureDate = now.add(Duration(days: days));
      final String nowIso = now.toIso8601String();
      final String futureIso = futureDate.toIso8601String();

      final List<Map<String, dynamic>> maps = await db.query(
        tableClientPaymentData,
        where: '$columnExpirationDate >= ? AND $columnExpirationDate <= ?',
        whereArgs: [nowIso, futureIso],
        orderBy: '$columnExpirationDate ASC',
      );
      return maps.map((json) => ClientPaymentData.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching expiring payments: $e');
      return [];
    }
  }

  /// Close the database
  Future<void> closeDatabase() async {
    final Database db = await database;
    await db.close();
    _database = null;
  }
}