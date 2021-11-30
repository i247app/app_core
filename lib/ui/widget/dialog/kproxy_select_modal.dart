import 'package:app_core/model/krole.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KProxySelectModal extends StatelessWidget {
  final List<KRole> roles;

  const KProxySelectModal({required this.roles});

  void onRoleClick(BuildContext context, KRole role) {
    print("ROLE ${role.role}");
    Navigator.of(context).pop(role);
  }

  @override
  Widget build(BuildContext context) {
    final children = roles
        .map((r) => _RoleItem(r, onSelect: (r) => onRoleClick(context, r)))
        .toList();

    final body = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );

    return body;
  }
}

class _RoleItem extends StatelessWidget {
  final KRole role;
  final Function(KRole)? onSelect;

  const _RoleItem(this.role, {this.onSelect});

  @override
  Widget build(BuildContext context) {
    final body = InkWell(
      onTap: () => onSelect?.call(role),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            KUserAvatar(
              initial: role.bnm ?? "?",
              imageURL: role.avatarURL,
              size: 32,
            ),
            SizedBox(width: 6),
            Text(
              role.bnm ?? "?",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Text(
              role.role ?? "",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );

    return body;
  }
}
