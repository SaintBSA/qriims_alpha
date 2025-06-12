import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "qriims.db");

    // This line was removed to prevent the database from being deleted on every launch
    // await deleteDatabase(path);

    bool dbExists = await File(path).exists();
    if (!dbExists) {
      try {
        ByteData data = await rootBundle.load("assets/qriims.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes);
        print("Database copied to $path");
      } catch (e) {
        print("Error copying database: $e");
      }
    } else {
      print("Database already exists at $path");
    }

    return await openDatabase(path, version: 1, onOpen: (db) async {
      print("Database opened at $path");

      await db.execute('''
      CREATE TABLE IF NOT EXISTS peralatan (
        id_alat INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_alat TEXT NOT NULL,
        merek_alat TEXT NOT NULL,
        seri_alat TEXT NOT NULL
      );
      ''');

      // New table to store technician history
      await db.execute('''
      CREATE TABLE IF NOT EXISTS riwayat_input (
        id_riwayat INTEGER PRIMARY KEY AUTOINCREMENT,
        id_alat INTEGER NOT NULL,
        kategori TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        tanggal_input TEXT NOT NULL,
        FOREIGN KEY (id_alat) REFERENCES peralatan (id_alat)
      );
      ''');
    });
  }


  Future<bool> login(String email, String password) async {
    final db = await database;
    var res = await db.rawQuery(
      "SELECT * FROM teknisi WHERE email_teknisi = ? AND pw_teknisi = ?",
      [email, password],
    );
    return res.isNotEmpty;
  }

  Future<void> addTechnician({
    required String nama,
    required int nik,
    required int noTelepon,
    required String email,
    required String password,
  }) async {
    final db = await database;
    await db.insert(
      'teknisi',
      {
        'nama_teknisi': nama,
        'nik_teknisi': nik,
        'no_telepon': noTelepon,
        'email_teknisi': email,
        'pw_teknisi': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> printAllTechnicians() async {
    final db = await database;
    final List<Map<String, dynamic>> teknisiList = await db.query('teknisi');
    for (var teknisi in teknisiList) {
      print(teknisi);
    }
  }
  Future<List<Map<String, dynamic>>> getAllTechnicians() async {
    final db = await database;
    return await db.query('teknisi');
  }

  Future<void> deleteTechnicianById(int id) async {
    final db = await database;
    await db.delete('teknisi', where: 'id_teknisi = ?', whereArgs: [id]);
  }

  Future<void> updateTechnician({
    required int id,
    required String nama,
    required int nik,
    required int noTelepon,
    required String email,
    required String password,
  }) async {
    final db = await database;
    await db.update(
      'teknisi',
      {
        'nama_teknisi': nama,
        'nik_teknisi': nik,
        'no_telepon': noTelepon,
        'email_teknisi': email,
        'pw_teknisi': password,
      },
      where: 'id_teknisi = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertPeralatan({
    required String namaAlat,
    required String merekAlat,
    required String seriAlat,
  }) async {
    final db = await database;

    await db.insert(
      'peralatan',
      {
        'nama_alat': namaAlat,
        'merek_alat': merekAlat,
        'seri_alat': seriAlat,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllPeralatan() async {
    final db = await database;
    return await db.query('peralatan');
  }

  Future<void> insertHistory({
    required int idAlat,
    required String kategori,
    required String deskripsi,
  }) async {
    final db = await database;
    await db.insert(
      'riwayat_input',
      {
        'id_alat': idAlat,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'tanggal_input': DateTime.now().toIso8601String(),
      },
    );
  }

  // METODE BARU DI BAWAH INI
  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    final String query = '''
      SELECT
        r.kategori,
        r.deskripsi,
        r.tanggal_input,
        p.nama_alat,
        p.merek_alat
      FROM riwayat_input r
      INNER JOIN peralatan p ON r.id_alat = p.id_alat
      ORDER BY r.tanggal_input DESC
    ''';
    return await db.rawQuery(query);
  }

  Future<void> updateEquipment({
    required int id,
    required String namaAlat,
    required String merekAlat,
    required String seriAlat,
  }) async {
    final db = await database;
    await db.update(
      'peralatan',
      {
        'nama_alat': namaAlat,
        'merek_alat': merekAlat,
        'seri_alat': seriAlat,
      },
      where: 'id_alat = ?',
      whereArgs: [id],
    );
  }

  /// Menghapus data equipment berdasarkan ID
  Future<void> deleteEquipmentById(int id) async {
    final db = await database;
    await db.delete('peralatan', where: 'id_alat = ?', whereArgs: [id]);
  }

}