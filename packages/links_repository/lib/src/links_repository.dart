import 'package:links_api/links_api.dart';

/// {@template links_repository}
/// A repository that handles link related requests.
/// {@endtemplate}
class LinksRepository {
  /// {@macro links_repository}
  const LinksRepository({
    required LinksApi linksApi,
  }) : _linksApi = linksApi;

  final LinksApi _linksApi;

  /// Provides a [Stream] of all links.
  Future<List<Link>> getLinks(LinksViewsSort linksViewsSort) =>
      _linksApi.getLinks(linksViewsSort);

  /// Saves a [link].
  ///
  /// If a [link] with the same id already exists, it will be replaced.
  Future<void> saveLink(Link link, List<int> collectionIds) =>
      _linksApi.saveLink(link, collectionIds);

  /// Deletes the link with the given id.
  ///
  /// If no link with the given id exists, a [LinkNotFoundException] error is
  /// thrown.
  Future<void> deleteLink(int id) => _linksApi.deleteLink(id);

  /// Provides a [Stream] of all collections.
  Future<List<Collection>> getCollections() => _linksApi.getCollections();
  Future<List<Collection>> getCollectionsByLinkId(int linkId) =>
      _linksApi.getCollectionsByLinkId(linkId);

  // ignore: lines_longer_than_80_chars
  Future<List<Link>> getCollectionLinks(int collectionId) =>
      _linksApi.getCollectionLinks(collectionId);

  /// Saves a [collection].
  ///
  /// If a [collection] with the same id already exists, it will be replaced.
  Future<int> saveCollection(Collection collection) =>
      _linksApi.saveCollection(collection);

  /// Deletes the collection with the given id.
  ///
  /// If no collection with the given id exists, a [CollectionNotFoundException] error is
  /// thrown.
  Future<void> deleteCollection(int id) => _linksApi.deleteCollection(id);
  Future<void> editCollectionTitle(String title, int id) =>
      _linksApi.editCollectionTitle(title, id);
  Future<void> deleteLinkFromCollection(int link_id, int collection_id) =>
      _linksApi.deleteLinkFromCollection(link_id, collection_id);
}
