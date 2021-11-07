import 'package:app_core/header/kassets.dart';
import 'package:app_core/header/kstyles.dart';
import 'package:app_core/helper/koverlay_helper.dart';
import 'package:app_core/helper/ksnackbar_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/khero.dart';
import 'package:app_core/ui/hero/khero_jump_over_game.dart';
import 'package:app_core/ui/hero/widget/kegg_hatch_short_intro.dart';
import 'package:app_core/ui/hero/widget/khero_short_hatch_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_core/helper/khero_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/hero/khero_game.dart';
import 'package:app_core/ui/hero/khero_training.dart';
import 'package:app_core/ui/hero/widget/khero_combine_view.dart';
import 'package:app_core/ui/hero/widget/khero_grid_item.dart';
import 'package:app_core/ui/widget/kstopwatch_label.dart';

import 'khero_jump_game.dart';

final GlobalKey _draggableKey = GlobalKey();

class KHeroListing extends StatefulWidget {
  @override
  _KHeroListingState createState() => _KHeroListingState();
}

class _KHeroListingState extends State<KHeroListing> {
  int? overlayID;
  List<KHero>? heroes;
  KHero? avatarHero;
  KHero? selectedHero;

  bool isHatchingHero = false;
  bool isShowIntro = true;

  @override
  void initState() {
    super.initState();
    loadHeroes();
  }

  void loadHeroes() async {
    final response = await KServerHandler.getHeroes();

    // Try to match current hero with the loaded in KHero's
    KHero? avatar;
    try {
      avatar = response.heroes!
          .where((h) => !h.isEgg)
          .firstWhere((h) => h.imageURL == KSessionData.me?.heroAvatarURL);
    } catch (e) {}

    KHero? selected;
    try {
      selected = response.heroes!.where((h) => !h.isEgg).first;
    } catch (e) {}

    setState(() {
      this.heroes = response.heroes ?? [];
      this.avatarHero = avatar;
      this.selectedHero = selected;
    });
  }

  Future onSetAvatarClick(KHero hero) async {
    if (KHeroHelper.isEgg(hero)) return;

    final response =
        await KServerHandler.modifyUserPersonal(heroAvatarURL: hero.imageURL);

    if (response.isSuccess) {
      setState(() => this.avatarHero = hero);
      KSnackBarHelper.success("Avatar update successful");
    } else {
      KSnackBarHelper.error("Can not save hero avatar");
    }
  }

  void onTraining(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    if (hero != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => KHeroTraining(hero: hero)));
    }
  }

  void onPlayGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroGame(hero: hero)));
  }

  void onPlayJumpGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroJumpGame(hero: hero)));
  }

  void onPlayJumpOverGame(KHero? hero) {
    if (this.overlayID != null) {
      KOverlayHelper.removeOverlay(this.overlayID!);
      this.overlayID = null;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => KHeroJumpOverGame(hero: hero)));
  }

  void onHeroClick(KHero hero) {
    if (KHeroHelper.isHatchable(hero) && KHeroHelper.isEgg(hero))
      hatchHero(hero);
    else {
      setState(() => this.selectedHero = hero);
      final heroDetailView = _HeroDetail(
        hero,
        onImageClick: hatchHero,
        onDrop: onHeroDrop,
        onSetAvatar: onSetAvatarClick,
        onTraining: onTraining,
        onPlayGame: onPlayGame,
        onPlayJumpGame: onPlayJumpGame,
        isAvatar: this.avatarHero?.id == this.selectedHero?.id,
      );

      final overlay = Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (this.overlayID != null) {
                KOverlayHelper.removeOverlay(this.overlayID!);
                this.overlayID = null;
              }
            },
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                color: Theme.of(context).backgroundColor.withOpacity(1),
                child: heroDetailView,
              ),
            ),
          ),
        ],
      );
      this.overlayID = KOverlayHelper.addOverlay(overlay);
    }
  }

  void onHeroDrop(KHero dragHero, KHero hero) {
    if (dragHero.id != hero.id && !KHeroHelper.isEgg(hero)) {
      showHeroCombineOverlay(
        dragHero,
        hero,
        () {
          if (this.overlayID != null) {
            KOverlayHelper.removeOverlay(this.overlayID!);
            this.overlayID = null;
          }

          this.setState(() {
            (this.heroes ?? []).removeWhere((item) => item.id == dragHero.id);
            this.selectedHero = null;
          });
        },
      );
    }
  }

  void hatchHero(KHero hero) async {
    if (this.isHatchingHero || hero.hatchDate != null) return;

    if (KHeroHelper.isEgg(hero) && KHeroHelper.isHatchable(hero))
      setState(() => this.isHatchingHero = true);

    final since = hero.eggDate!.add(hero.eggDuration!);
    if (!since.difference(DateTime.now()).isNegative) return;

    final response = await KServerHandler.hatchHero(
      id: hero.id ?? "",
      heroID: hero.heroID ?? "",
    );
    print(response);

    if (response.isSuccess && (response.heroes ?? []).isNotEmpty) {
      // Find the array index for this hero
      final index = this.heroes?.lastIndexWhere((h) => h.id == hero.id);
      // Update the local hero array
      if (index != null) {
        final theNewHero = response.heroes!.first;
        showHeroHatchOverlay(
          theNewHero,
          () {
            if (this.overlayID != null) {
              KOverlayHelper.removeOverlay(this.overlayID!);
              this.overlayID = null;
            }

            print(
                "UPDATING LOCAL HERO WITH new hero - is it egg??? ${KHeroHelper.isEgg(theNewHero)}");
            setState(() {
              this.isHatchingHero = false;
              this.heroes![index] = theNewHero;
              this.selectedHero = theNewHero;
            });
          },
        );
      }
    } else
      setState(() => this.isHatchingHero = false);
  }

  void showHeroCombineOverlay(
    KHero dragHero,
    KHero hero,
    Function() onFinish,
  ) async {
    final thePokemonView = KHeroCombineView(
      dragHero: dragHero,
      hero: hero,
      onFinish: onFinish,
    );
    showCustomOverlay(thePokemonView);
  }

  void showHeroHatchOverlay(KHero hero, Function() onFinish) async {
    final thePokemonView = KHeroShortHatchView(
      hero: KHero()
        ..eggImageURL = hero.eggImageURL
        ..imageURL = hero.imageURL,
      onFinish: onFinish,
    );
    showCustomOverlay(thePokemonView);
  }

  void showCustomOverlay(Widget view) {
    final overlay = Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Theme.of(context).backgroundColor.withOpacity(1)),
        Align(
          alignment: Alignment.topCenter,
          child: view,
        ),
      ],
    );
    this.overlayID = KOverlayHelper.addOverlay(overlay);
  }

  @override
  Widget build(BuildContext context) {
    // final heroDetail = Material(
    //   elevation: 1,
    //   color: Theme.of(context).backgroundColor,
    //   child: Container(
    //     padding: EdgeInsets.all(16),
    //     child: _HeroDetail(
    //       this.selectedHero,
    //       onImageClick: hatchHero,
    //       onDrop: onHeroDrop,
    //       onSetAvatar: onSetAvatarClick,
    //       isAvatar: this.avatarHero?.id == this.selectedHero?.id,
    //     ),
    //   ),
    // );

    final stillLoading = Container();

    final nothingHere = Text(
      "No heroes found",
      style: Theme.of(context).textTheme.bodyText1,
    );

    final heroListing = ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: heroes != null && heroes!.length > 0
                        ? () => onTraining(heroes![0])
                        : () {},
                    style: KStyles.squaredButton(
                      KStyles.colorPrimary,
                      textColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("💪"),
                        // SizedBox(width: 10),
                        // Text("Training"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onPlayGame(null),
                    style: KStyles.squaredButton(
                      KStyles.colorPrimary,
                      textColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("👾️"),
                        // SizedBox(width: 10),
                        // Text("Game"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onPlayJumpGame(null),
                    style: KStyles.squaredButton(
                      KStyles.colorPrimary,
                      textColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("🕹"),
                        // SizedBox(width: 10),
                        // Text("Game"),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onPlayJumpOverGame(null),
                    style: KStyles.squaredButton(
                      KStyles.colorPrimary,
                      textColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("🎮"),
                        // SizedBox(width: 10),
                        // Text("Game"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32),
        (this.heroes != null && this.heroes!.isEmpty
            ? Center(child: nothingHere)
            : GridView.count(
                shrinkWrap: true,
                childAspectRatio: 0.65,
                crossAxisCount: 4,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(10),
                children: (this.heroes ?? [])
                    .map(
                      (hero) => Container(
                        key: Key(hero.id!),
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                        child: KHeroGridItem(
                          hero,
                          draggableKey: _draggableKey,
                          onClick: onHeroClick,
                          onDrop: onHeroDrop,
                          isAvatar: hero.id == this.avatarHero?.id,
                          isSelected: hero.id == this.selectedHero?.id,
                        ),
                      ),
                    )
                    .toList(),
              )),
      ],
    );

    final content = this.heroes == null
        ? stillLoading
        : Column(
            children: [
              // heroDetail,
              Expanded(child: heroListing),
            ],
          );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (isShowIntro) ...[
          Container(
            color: Theme.of(context).backgroundColor.withOpacity(1),
          ),
          KEggHatchShortIntro(onFinish: () {
            this.setState(() => this.isShowIntro = false);
          }),
          // HeroIntro(onFinish: () {
          //   this.setState(() => this.isShowIntro = false);
          // }),
        ],
        if (this.isHatchingHero) IgnorePointer(),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("My Heroes")),
      body: SafeArea(child: body),
    );
  }
}

class _HeroDetail extends StatefulWidget {
  final KHero? hero;
  final Function(KHero, KHero) onDrop;
  final Function(KHero) onImageClick;
  final Future Function(KHero) onSetAvatar;
  final Function(KHero) onTraining;
  final Function(KHero) onPlayGame;
  final Function(KHero) onPlayJumpGame;
  final bool isAvatar;

  const _HeroDetail(
    this.hero, {
    required this.onDrop,
    required this.onImageClick,
    required this.onSetAvatar,
    required this.onTraining,
    required this.onPlayGame,
    required this.onPlayJumpGame,
    required this.isAvatar,
  });

  @override
  State<StatefulWidget> createState() => _HeroDetailState();
}

class _HeroDetailState extends State<_HeroDetail> {
  bool isSettingAvatar = false;

  String? get displayName => widget.hero == null
      ? null
      : (KHeroHelper.isEgg(widget.hero!) ? "Egg" : widget.hero!.name!);

  String? get displayBio => widget.hero == null
      ? null
      : (KHeroHelper.isEgg(widget.hero!)
          ? "I wonder what's inside?"
          : widget.hero!.bio!);

  void setAvatar() async {
    if (widget.hero == null) return;

    setState(() => this.isSettingAvatar = true);
    await widget.onSetAvatar.call(widget.hero!);
    setState(() => this.isSettingAvatar = false);
  }

  @override
  Widget build(BuildContext context) {
    final rawImage = widget.hero == null
        ? Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                width: 0.5,
              ),
            ),
            padding: EdgeInsets.all(6),
            child: Center(
              child: Text(
                "Select a Hero",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          )
        : Image.network(
            KHeroHelper.isEgg(widget.hero!)
                ? widget.hero!.eggImageURL!
                : widget.hero!.imageURL!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Image.asset(
              KAssets.HERO_EGG,
              package: 'app_core',
            ),
            // color: KHeroHelper.isEgg(widget.hero!)
            //     ? Theme.of(context).iconTheme.color
            //     : null,
          );

    final image = widget.hero?.isEgg ?? false
        ? GestureDetector(
            onTap: widget.hero == null
                ? null
                : () => widget.onImageClick.call(widget.hero!),
            child: Container(
              width: 160,
              child: AspectRatio(aspectRatio: 1, child: rawImage),
            ),
          )
        : GestureDetector(
            onTap: widget.hero == null
                ? null
                : () => widget.onImageClick.call(widget.hero!),
            child: Container(
              width: 160,
              child: AspectRatio(aspectRatio: 1, child: rawImage),
            ),
          );

    final name = Text(
      this.displayName ?? "",
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(fontWeight: FontWeight.w600),
    );

    final bioStyle = Theme.of(context).textTheme.bodyText1;
    final bio = widget.hero?.isEgg ?? false
        ? KStopwatchLabel(
            widget.hero!.eggDate!.add(widget.hero!.eggDuration!),
            style: bioStyle,
            formatter: (dur) => "Hatch in ${KUtil.prettyStopwatch(dur)}\n\n",
            doneFormatter: (_) => "Ready to hatch!\n\n",
          )
        : Text(
            (this.displayBio ?? "") +
                "\n\n", // simulate 'minLines' functionality
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: bioStyle,
          );

    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        image,
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              name,
              SizedBox(height: 10),
              bio,
              SizedBox(height: 10),
              Text("Power: ${widget.hero!.power ?? 0}"),
              SizedBox(height: 10),
              Text("Energy: ${widget.hero!.energy ?? 0}"),
              SizedBox(height: 20),
              if (widget.hero != null &&
                  !KHeroHelper.isEgg(widget.hero!) &&
                  !widget.isAvatar) ...[
                // ElevatedButton(
                //   onPressed: this.isSettingAvatar ? null : setAvatar,
                //   style: KStyles.squaredButton(
                //     KStyles.colorPrimary,
                //     textColor: Colors.white,
                //   ),
                //   child: Text("Set Avatar",
                //       style: Theme.of(context)
                //           .textTheme
                //           .bodyText1!
                //           .copyWith(color: Colors.white)),
                // ),
                ElevatedButton(
                  onPressed: () => widget.onTraining(widget.hero!),
                  style: KStyles.squaredButton(
                    KStyles.colorPrimary,
                    textColor: Colors.white,
                  ),
                  child: Text("Training",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return body;
  }
}
