import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/app_core.dart';

class KDetailView extends StatelessWidget {
  final Widget header;
  final List<KDetailItem> detailItems;
  final List<Widget>? actions;

  const KDetailView(this.header, this.detailItems, {this.actions});

  @override
  Widget build(BuildContext context) {
    final header = Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!KEmbedManager.of(context).isEmbed) BackButton(),
                Spacer(),
                // Only show Archive if the gig had been started before
                if (this.actions != null)
                  ...this.actions!.intersperse(SizedBox(width: 2)),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: this.header,
            ),
          ],
        ),
      ),
    );
    ;

    final content = ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20).copyWith(
        top: 20,
        bottom: 40,
      ),
      itemCount: this.detailItems.length,
      itemBuilder: (_, i) => this.detailItems[i],
      separatorBuilder: (_, __) => SizedBox(height: 16),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        Expanded(child: content),
      ],
    );

    return KEmbedManager.of(context).isEmbed ? body : Scaffold(body: body);
  }
}

class KDetailItem extends StatelessWidget {
  final String label;
  final String? value;

  const KDetailItem({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.label, style: Theme.of(context).textTheme.subtitle1),
        SizedBox(height: 2),
        Text(this.value ?? "-", style: Theme.of(context).textTheme.bodyText1),
      ],
    );

    return body;
  }
}

class KDetailHeader extends StatelessWidget {
  final String line1;
  final String? line2;

  const KDetailHeader({required this.line1, this.line2});

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.line1,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(color: Colors.white),
        ),
        if (this.line2 != null)
          Text(
            this.line2!,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: Colors.white),
          ),
      ],
    );

    return body;
  }
}
