import 'dart:async';
import 'dart:ffi';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:links_api/links_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

enum SortOption { ByTitle, ByNewest }

/// {@template sqflite_links}
/// A Flutter implementation of the Links that uses sqlite.
/// {@endtemplate}
class SqfliteLinks extends LinksApi {
  static const _databaseName = "links.db";
  static const _databaseVersion = 1;
  late Database _db;
  late bool _isDbExist;

  Future<String> getDatabasePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return path;
  }

  Future<io.FileStat> getDatabaseTimestamp() async {
    final file = await getDatabasePath();
    return FileStat.statSync(file);
  }

  String getDatabaseName() {
    return _databaseName;
  }

  Future<void> init() async {
    final path = await getDatabasePath();
    _isDbExist = await io.File(path).exists();

    // await deleteDatabase(path);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    // await _onCreate(_db, _databaseVersion);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS links (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              link TEXT NOT NULL,
              isPrivate INTEGER  DEFAULT 0,
              created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          );
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS folders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          name TEXT NOT NULL
          );
    ''');

    await db.execute('''
        CREATE TABLE IF NOT EXISTS folder_links(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            link_id INTEGER NOT NULL,
            folder_id INTEGER NOT NULL,
            created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(folder_id,link_id)
        );
    ''');

    if (_isDbExist) return;
    await db.execute('''
          INSERT INTO links (title, link, created) VALUES('Google', 'https://google.com', CURRENT_TIMESTAMP);
    ''');
    await db.execute('''
          INSERT INTO links (title, link, created) VALUES('Youtube', 'https://youtube.com', CURRENT_TIMESTAMP);
    ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('icanhascheezburger', 'https://icanhascheezburger.com', CURRENT_TIMESTAMP);
    // ''');

    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Cat Wisdom 101', 'https://catwisdom101.com/', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Cat time', 'https://cattime.com/', CURRENT_TIMESTAMP);
    // ''');

    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Lonely Planet', 'https://www.facebook.com/lonelyplanet', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('National Geographic Travel', ' https://www.facebook.com/natgeotravel', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('TripAdvisor', 'https://www.facebook.com/TripAdvisor', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Airbnb', 'https://www.facebook.com/airbnb', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Booking.com', 'https://www.facebook.com/bookingcom', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Expedia', 'https://www.facebook.com/expedia', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('T-Series', 'https://www.youtube.com/user/tseries', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Justin Bieber', 'https://www.youtube.com/user/JustinBieberVEVO', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Ed Sheeran', 'https://www.youtube.com/user/EdSheeran', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Ariana Grande', 'https://www.youtube.com/user/ArianaGrandeVevo', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Marshmello', 'https://www.youtube.com/user/marshmellomusic', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Luis Fonsi', 'https://www.youtube.com/user/LuisFonsiVEVO', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Shawn Mendes', 'https://www.youtube.com/user/ShawnMendesVEVO', CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO links (title, link, created) VALUES('Taylor Swift', 'https://www.youtube.com/user/taylorswift', CURRENT_TIMESTAMP);
    // ''');

    // await db.execute('''
    //       INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Lovely Cat Folders');
    // ''');
    // await db.execute('''
    //       INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Facebook Links');
    // ''');

    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(1, 1, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(2, 1, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(3, 1, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(4, 1, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(5, 1, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(6, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(7, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(8, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(9, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(10, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(11, 2, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(12, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(13, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(14, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(15, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(16, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(17, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(18, 3, CURRENT_TIMESTAMP);
    // ''');
    // await db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(19, 3, CURRENT_TIMESTAMP);
    // ''');

    await db.execute('''
          INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Movies');
    ''');
    await db.execute('''
          INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Music');
    ''');
    await db.execute('''
          INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Instagram');
    ''');
    await db.execute('''
          INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Youtube');
    ''');
    await db.execute('''
          INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, 'Others');
    ''');
  }

  @override
  Future<void> deleteLink(int id) async {
    await _db.execute(
      '''
          DELETE FROM links where id = ?;
      ''',
      [id],
    );
    await _db.execute(
      '''
          DELETE FROM folder_links where link_id = ?;
      ''',
      [id],
    );
  }

  @override
  Future<List<Link>> getLinks(LinksViewsSort linksViewsSort) async {
    String sql = "select * from links order by created desc";

    if (linksViewsSort == LinksViewsSort.byTitle) {
      sql = "select * from links order by title asc";
    }
    final List<Map<String, dynamic>> maps = await _db.rawQuery(sql);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Link(
        id: int.parse(maps[i]['id'].toString()),
        title: maps[i]['title'].toString(),
        link: maps[i]['link'].toString(),
      );
    });
  }

  @override
  Future<void> saveLink(Link link, List<int> collectionIds) async {
    final batch = _db.batch();

    if (link.id == 0) {
      final linkId = await _db.rawInsert(
        '''
          INSERT INTO links (title, link, created) VALUES(?, ?, CURRENT_TIMESTAMP);
      ''',
        [link.title, link.link],
      );
      for (var collectionId in collectionIds) {
        await _db.execute(
          '''
          INSERT INTO folder_links (link_id, folder_id, created) VALUES(?, ?, CURRENT_TIMESTAMP);
      ''',
          [linkId, collectionId],
        );
      }
    } else {
      batch
        ..rawQuery('''
          UPDATE links
          SET title=?, link=?
          WHERE id=?;
      ''', [link.title, link.link, link.id])
        // delete
        ..rawQuery(
          '''
          DELETE FROM folder_links where link_id = ?;
      ''',
          [link.id],
        );
      for (var collectionId in collectionIds) {
        batch.execute(
          '''
          INSERT INTO folder_links (link_id, folder_id, created) VALUES(?, ?, CURRENT_TIMESTAMP);
      ''',
          [link.id, collectionId],
        );
      }
      await batch.commit();
    }

    // reinsert

    // await _db.execute('''
    //       INSERT INTO folder_links (link_id, folder_id, created) VALUES(?, ?, CURRENT_TIMESTAMP);
    //   ''', [link.id, folderId]);
  }

  @override
  Future<void> deleteCollection(int id) async {
    await _db.execute(
      '''
          DELETE FROM folder_links where folder_id = ?;
      ''',
      [id],
    );
    await _db.execute(
      '''
          DELETE FROM folders where id = ?;
      ''',
      [id],
    );
  }

  @override
  Future<void> deleteLinkFromCollection(int linkId, int collectionId) async {
    await _db.execute(
      '''
          DELETE FROM folder_links where link_id = ? and folder_id = ?;
      ''',
      [linkId, collectionId],
    );
  }

  @override
  Future<List<Collection>> getCollections() async {
    List<int> _folder_ids = [];
    final List<Map<String, dynamic>> folder_ids = await _db.rawQuery('''
    SELECT DISTINCT  f.id, f.id as folder_id, f.name as folder_name FROM folders f  
    LEFT JOIN folder_links fl  ON fl.folder_id  = f.id 
    LEFT JOIN links l on l.id = fl.link_id ; 
    ''');
    for (var folder_id in folder_ids) {
      _folder_ids.add(int.parse(folder_id['id'].toString()));
    }

    final List<Map<String, dynamic>> results = await _db.rawQuery('''
    SELECT f.id as folder_id, f.name as folder_name , l.title as link_title, l.link as link_link FROM folders f  
    LEFT JOIN folder_links fl  ON fl.folder_id  = f.id 
    LEFT JOIN links l on l.id = fl.link_id
    ''');

    return List.generate(
      folder_ids.length,
      (i) {
        List<Link> links = [];
        for (var result in results) {
          // ignore: avoid_dynamic_calls, unrelated_type_equality_checks
          if (result['folder_id'].toString() == _folder_ids[i].toString()) {
            Link link = Link(
              title: result['link_title'].toString(),
              link: result['link_link'].toString(),
            );
            if (link.title != "null") {
              links.add(link);
            }
          }
        }
        return Collection(
          id: int.parse(folder_ids[i]['folder_id'].toString()),
          name: folder_ids[i]['folder_name'].toString(),
          links: links,
        );
      },
    );
  }

  @override
  Future<List<Collection>> getCollectionsByLinkId(int linkId) async {
    final List<Map<String, dynamic>> results = await _db.rawQuery('''
    SELECT l.id as link_id, f.id as folder_id, f.name as folder_name , l.title as link_title, l.link as link_link FROM folders f  
    LEFT JOIN folder_links fl  ON fl.folder_id  = f.id 
    LEFT JOIN links l on l.id = fl.link_id
    WHERE link_id = ?
    ''', [linkId]);
    return List.generate(results.length, (i) {
      return Collection(
        id: int.parse(results[i]['folder_id'].toString()),
        name: results[i]['folder_name'].toString(),
        links: const [],
      );
    });
  }

  @override
  Future<List<Link>> getCollectionLinks(int collectionId) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery(
      '''
    SELECT l.id, l.title, l.link, l.isPrivate FROM links l 
    INNER JOIN folder_links fl on fl.link_id = l.id 
    INNER JOIN folders f on f.id = fl.folder_id 
    WHERE f.id  = ?;
    ''',
      [collectionId],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Link(
        id: int.parse(maps[i]['id'].toString()),
        title: maps[i]['title'].toString(),
        link: maps[i]['link'].toString(),
        isPrivate: int.parse(maps[i]['isPrivate'].toString()),
      );
    });
  }

  @override
  Future<void> editCollectionTitle(String title, int collectionId) async {
    await _db.execute(
      '''
          UPDATE folders 
          SET name = ?
          where id = ?;
      ''',
      [title, collectionId],
    );
  }

  @override
  Future<int> saveCollection(Collection collection) async {
    int folderId;
    if (collection.id == 0) {
      folderId = await _db.rawInsert(
          "INSERT INTO folders (created, name) VALUES(CURRENT_TIMESTAMP, ?)" "",
          [collection.name]);
    } else {
      await _db.rawInsert("""
        UPDATE folders
        SET created=CURRENT_TIMESTAMP, name=?
        WHERE id=?;
        """, [collection.name, collection.id]);
      folderId = collection.id!;

      await _db.execute(
        '''
          DELETE FROM folder_links where folder_id = ?;
      ''',
        [folderId],
      );
    }

    for (var link in collection.links!) {
      await _db.execute('''
          INSERT INTO folder_links (link_id, folder_id, created) VALUES(?, ?, CURRENT_TIMESTAMP);
      ''', [link.id, folderId]);
    }
    return folderId;
  }
}
