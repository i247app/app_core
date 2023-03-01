import 'package:app_core/app_core.dart';
import 'package:app_core/model/kuser.dart';
import 'package:app_core/ui/widget/kuser_avatar.dart';
import 'package:flutter/material.dart';

class KUserPicker extends StatefulWidget {
  final Function(KUser?)? onChange;
  final List<KUser> users;
  final KUser? selectedUser;
  final bool? isHaveAllOption;
  final String? allOptionAssetName;

  const KUserPicker({
    this.onChange,
    required this.users,
    this.selectedUser,
    this.isHaveAllOption,
    this.allOptionAssetName,
  });

  @override
  _KUserPickerState createState() => _KUserPickerState();
}

class _KUserPickerState extends State<KUserPicker> {
  bool get isHaveAllOption => widget.isHaveAllOption ?? false;

  @override
  void initState() {
    super.initState();
  }

  KUser buildSelfPlaceholderUser() => KUser();

  void onProxyClick() async {
    final modal = _KProxySelectModal(
      users: widget.users,
      isHaveAllOption: isHaveAllOption,
      allOptionAssetName: widget.allOptionAssetName,
    );
    final result = await showModalBottomSheet<KUser?>(
      context: context,
      builder: (_) => modal,
    );

    if (result != null) {
      final trueValue = result.puid != null ? result : null;
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
    final user = widget.selectedUser;

    final body = IconButton(
      onPressed: onProxyClick,
      icon: Row(
        children: [
          if (user != null) ...[
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: isHaveAllOption &&
                      user.puid == null &&
                      widget.allOptionAssetName != null
                  ? KUserAvatar(
                      initial: null,
                      imagePlaceHolder: Image.asset(widget.allOptionAssetName!),
                    )
                  : KUserAvatar(
                      initial: user.kunm,
                      imageURL: user.avatarURL,
                    ),
            ),
            SizedBox(
              width: 6,
            ),
            Text("${user.kunm ?? ""}"),
          ] else
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(20),
              child: KUserAvatar(
                initial: null,
                showBorder: true,
              ),
            ),
        ],
      ),
    );

    return body;
  }
}

class _KProxySelectModal extends StatelessWidget {
  final List<KUser> users;
  final bool? isHaveAllOption;
  final String? allOptionAssetName;

  const _KProxySelectModal({
    required this.users,
    this.isHaveAllOption,
    this.allOptionAssetName,
  });

  void onUserClick(BuildContext context, KUser user) =>
      Navigator.of(context).pop(user);

  @override
  Widget build(BuildContext context) {
    final children = users
        .map((u) => _UserItem(
              u,
              onSelect: (r) => onUserClick(context, u),
              isHaveAllOption: isHaveAllOption,
              allOptionAssetName: allOptionAssetName,
            ))
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

class _UserItem extends StatelessWidget {
  final KUser user;
  final Function(KUser)? onSelect;
  final bool? isHaveAllOption;
  final String? allOptionAssetName;

  const _UserItem(
    this.user, {
    this.onSelect,
    this.isHaveAllOption,
    this.allOptionAssetName,
  });

  @override
  Widget build(BuildContext context) {
    final body = InkWell(
      onTap: () => onSelect?.call(user),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            if ((isHaveAllOption ?? false) &&
                user.puid == null &&
                allOptionAssetName != null)
              KUserAvatar(
                initial: null,
                imagePlaceHolder: Image.asset(allOptionAssetName!),
                size: 32,
              )
            else
              KUserAvatar(
                initial: user.kunm,
                imageURL: user.avatarURL,
                size: 32,
              ),
            SizedBox(width: 6),
            Text(
              user.kunm ?? "",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Text(
              user.puid ?? "",
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
