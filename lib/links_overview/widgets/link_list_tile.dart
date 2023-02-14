import 'package:flutter/material.dart';
import 'package:links_repository/links_repository.dart';

class LinkListTile extends StatelessWidget {
  const LinkListTile({
    super.key,
    required this.link,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final Link link;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.caption?.color;

    return ListTile(
      onTap: onTap,
      title: Text(
        link.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        link.link,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: const Image(
        image: AssetImage('assets/hyperlink.png'),
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }
}
