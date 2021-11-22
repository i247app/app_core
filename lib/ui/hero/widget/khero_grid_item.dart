import 'package:app_core/header/kassets.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/widget/kimage_animation/kimage_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/khero_helper.dart';
import 'package:app_core/value/kstyles.dart';

class KHeroGridItem extends StatefulWidget {
  final KHero hero;
  final GlobalKey draggableKey;
  final Function(KHero) onClick;
  final Function(KHero, KHero) onDrop;
  final bool isAvatar;
  final bool isSelected;

  const KHeroGridItem(
    this.hero, {
    required this.draggableKey,
    required this.onClick,
    required this.onDrop,
    required this.isAvatar,
    required this.isSelected,
  });

  @override
  KHeroGridItemState createState() => KHeroGridItemState();
}

class KHeroGridItemState extends State<KHeroGridItem>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final rawImage =
        (KHeroHelper.isEgg(widget.hero) && KHeroHelper.isHatchable(widget.hero))
            ? KImageAnimation(
                animationType: KImageAnimationType.SHAKE_THE_TOP,
                imageUrls: [widget.hero.eggImageURL ?? ""],
                maxLoop: 0,
              )
            : Image.network(
                KHeroHelper.isEgg(widget.hero)
                    ? widget.hero.eggImageURL!
                    : widget.hero.imageURL!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return Image.asset(
                    KAssets.IMG_HERO_EGG,
                    package: 'app_core',
                  );
                },
              );

    final borderRadius = BorderRadius.circular(6);
    final body = Column(
      key: Key(widget.hero.id!),
      mainAxisSize: MainAxisSize.min,
      children: [
        KHeroHelper.isEgg(widget.hero)
            ? InkWell(
                onTap: () => widget.onClick(widget.hero),
                borderRadius: borderRadius,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: EdgeInsets.all(KHeroHelper.isEgg(widget.hero)
                        ? MediaQuery.of(context).size.width * 0.03
                        : 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: widget.isAvatar
                          ? KStyles.colorPrimary.withOpacity(0.2)
                          : widget.isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.15)
                              : Colors.transparent,
                    ),
                    child: rawImage,
                  ),
                ),
              )
            : DragTarget(
                builder: (context, heroItems, rejectedItems) {
                  return Draggable(
                    data: widget.hero,
                    dragAnchorStrategy: pointerDragAnchorStrategy,
                    feedback: DraggingHeroItem(
                      dragKey: widget.draggableKey,
                      photoUrl: KHeroHelper.isEgg(widget.hero)
                          ? widget.hero.eggImageURL!
                          : widget.hero.imageURL!,
                    ),
                    child: InkWell(
                      onTap: () => widget.onClick(widget.hero),
                      borderRadius: borderRadius,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          padding: EdgeInsets.all(KHeroHelper.isEgg(widget.hero)
                              ? MediaQuery.of(context).size.width * 0.03
                              : 0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            color: widget.isAvatar
                                ? KStyles.colorPrimary.withOpacity(0.2)
                                : widget.isSelected || heroItems.length > 0
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.15)
                                    : Colors.transparent,
                          ),
                          child: rawImage,
                        ),
                      ),
                    ),
                  );
                },
                onAccept: (KHero item) {
                  if (item.id != widget.hero.id) {
                    widget.onDrop(item, widget.hero);
                  }
                },
              ),
        SizedBox(height: 2),
        Text(
          KHeroHelper.isEgg(widget.hero)
              ? "Egg"
              : widget.hero.name ?? "?",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
    return body;
  }
}

class DraggingHeroItem extends StatelessWidget {
  const DraggingHeroItem({
    Key? key,
    required this.dragKey,
    required this.photoUrl,
  }) : super(key: key);

  final String photoUrl;
  final GlobalKey dragKey;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 4;

    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: SizedBox(
        key: dragKey,
        height: size,
        width: size,
        child: Opacity(
          opacity: 0.85,
          child: Image.network(
            photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
