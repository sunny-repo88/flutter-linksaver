// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      isPrivate: json['isPrivate'] as int? ?? 0,
    );

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'isPrivate': instance.isPrivate,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      id: json['id'] as int?,
      name: json['name'] as String,
      links: (json['links'] as List<Link>).toList(),
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'links': instance.links,
    };
