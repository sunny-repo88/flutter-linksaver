import 'package:links_api/links_api.dart';

/// {@template links_api}
/// The interface for an API that provides access to a list of links.
/// {@endtemplate}
abstract class LinksApi {
  /// {@macro links_api}
  const LinksApi();

  /// Provides a [Stream] of all links.
  Future<List<Link>> getLinks(LinksViewsSort linksViewsSort);

  /// Saves a [todo].
  ///
  /// If a [todo] with the same id already exists, it will be replaced.
  Future<void> saveLink(Link todo, List<int> collectionIds);

  /// Deletes the todo with the given id.
  ///
  /// If no todo with the given id exists, a [LinkNotFoundException] error is
  /// thrown.
  Future<void> deleteLink(int id);

  Future<List<Collection>> getCollections();
  Future<List<Collection>> getCollectionsByLinkId(int collectionId);

  Future<List<Link>> getCollectionLinks(int collectionId);

  /// Saves a [collection].
  ///
  /// If a [collection] with the same id already exists, it will be replaced.
  Future<int> saveCollection(Collection collection);

  /// Deletes the collection with the given id.
  ///
  /// If no collection with the given id exists, a [CollectionNotFoundException] error is
  /// thrown.
  Future<void> deleteCollection(int id);
  Future<void> editCollectionTitle(String title, int id);
  Future<void> deleteLinkFromCollection(int linkId, int collectionId);
}

/// Error thrown when a [Link] with a given id is not found.
class LinkNotFoundException implements Exception {}
