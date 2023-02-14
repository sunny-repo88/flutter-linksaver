import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:links_api/links_api.dart';
import 'package:uuid/uuid.dart';

part 'link.g.dart';

/// {@template link}
/// A single link item.
///
/// Contains a [title] and [id]
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Link]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Link extends Equatable {
  /// {@macro link}
  Link({
    this.id = 0,
    this.title = '',
    this.link = '',
    this.isPrivate = 0,
  });

  /// The unique identifier of the link.
  ///
  /// Cannot be empty.
  final int id;

  /// The title of the link.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The link of the link.
  ///
  /// Defaults to an empty string.
  final String link;

  final int isPrivate;

  /// Returns a copy of this link with the given values updated.
  ///
  /// {@macro link}
  Link copyWith({
    int? id,
    String? title,
    String? link,
    int? isPrivate,
  }) {
    return Link(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  /// Deserializes the given [JsonMap] into a [Link].
  static Link fromJson(JsonMap json) => _$LinkFromJson(json);

  /// Converts this [Link] into a [JsonMap].
  JsonMap toJson() => _$LinkToJson(this);

  @override
  List<Object> get props => [id, title, link, isPrivate];
}

@immutable
@JsonSerializable()
class Collection extends Equatable {
  /// {@macro Collection}
  Collection({
    int? this.id = 0,
    required this.name,
    List<Link>? this.links,
  });

  /// The unique identifier of the link.
  ///
  /// Cannot be empty.
  final int? id;

  /// The title of the link.
  ///
  /// Note that the title may be empty.
  final String name;

  final List<Link>? links;

  /// Returns a copy of this link with the given values updated.
  ///
  /// {@macro link}
  Collection copyWith({
    int? id,
    String? name,
    List<Link>? links,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      links: links ?? this.links,
    );
  }

  /// Deserializes the given [JsonMap] into a [Collection].
  static Collection fromJson(JsonMap json) => _$CollectionFromJson(json);

  /// Converts this [Collection] into a [JsonMap].
  JsonMap toJson() => _$CollectionToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        links,
      ];
}

enum LinksViewsSort { byTitle, byNewest }
