import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/model/krole.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KRolePicker extends StatefulWidget {
  final Function(KRole?)? onChange;

  const KRolePicker({this.onChange});

  @override
  _KRolePickerState createState() => _KRolePickerState();
}

class _KRolePickerState extends State<KRolePicker> {
  List<KRole>? roles;
  KRole? selectedRole;

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  KRole buildSelfPlaceholderRole() => KRole()
    ..puid = KSessionData.me?.puid
    ..bnm = KSessionData.me?.fullName
    ..avatarURL = KSessionData.me?.avatarURL
    ..isMePlaceholder = true;

  void loadRoles() async {
    final response = await KServerHandler.listXFRRoles();
    if (response.isSuccess) {
      setState(() => roles = response.roles ?? []);
    }
  }

  void onProxyClick() async {
    final selfPlaceholder = buildSelfPlaceholderRole();
    final modal = _KProxySelectModal(
      roles: [
        selfPlaceholder,
        ...(roles ?? []),
      ],
    );
    final result = await showModalBottomSheet<KRole?>(
      context: context,
      builder: (_) => modal,
    );

    if (result != null) {
      final trueValue = result.isMePlaceholder ? null : result;
      setState(() => selectedRole = trueValue);
      widget.onChange?.call(trueValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingView = Container(
      // padding: EdgeInsets.all(6),
      // child: AspectRatio(
      //   aspectRatio: 1,
      //   child: `CircularProgressIndicator`(),
      // ),
    );

    final content = () {
      final role = selectedRole ?? buildSelfPlaceholderRole();
      return KUserAvatar(
        initial: role.bnm,
        imageURL: role.avatarURL,
      );
    }.call();

    final body = roles == null
        ? loadingView
        : IconButton(
            onPressed: onProxyClick,
            icon: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: content,
            ),
          );

    return body;
  }
}

class _KProxySelectModal extends StatelessWidget {
  final List<KRole> roles;

  const _KProxySelectModal({required this.roles});

  void onRoleClick(BuildContext context, KRole role) =>
      Navigator.of(context).pop(role);

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
