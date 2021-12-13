import 'package:app_core/header/no_overscroll.dart';
import 'package:app_core/helper/ksnackbar_helper.dart';
import 'package:app_core/helper/kutil.dart';
import 'package:app_core/model/khero.dart';
import 'package:flutter/material.dart';
import 'package:app_core/helper/khero_helper.dart';
import 'package:app_core/helper/ksession_data.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/ui/hero/widget/khero_portrait.dart';
import 'package:app_core/ui/widget/kstopwatch_label.dart';

class KHeroBasicPicker extends StatefulWidget {
  @override
  _KHeroesState createState() => _KHeroesState();
}

class _KHeroesState extends State<KHeroBasicPicker> {
  List<KHero>? heroes;
  KHero? selectedHero;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadHeroes();
  }

  void loadHeroes() async {
    final response = await KServerHandler.getHeroes();
    var filteredHeroes = (response.heroes ?? [])
        .where((hero) => hero.hatchDate != null)
        .toList();
    final ids = Set();
    filteredHeroes.retainWhere((hero) => ids.add(hero.heroID));
    setState(() => this.heroes = filteredHeroes);

    // Try to match current hero with the loaded in KHero's
    try {
      KHero? myHero = this
          .heroes!
          .firstWhere((h) => h.imageURL == KSessionData.me?.heroAvatarURL);
      setState(() => this.selectedHero = myHero);
    } catch (e) {}
  }

  void onHeroClick(KHero hero) async {
    if (this.selectedHero?.id == hero.id) return;

    setState(() {
      this.selectedHero = hero;
      this.isLoading = true;
    });
    final response =
        await KServerHandler.modifyUserPersonal(heroAvatarURL: hero.imageURL);

    if (response.isSuccess) {
      Navigator.of(context).pop();
    } else {
      KSnackBarHelper.error("Can not save hero avatar");
    }
    setState(() => this.isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final heroListing = ScrollConfiguration(
      behavior: NoOverscroll(),
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 0.75,
        crossAxisCount: 4,
        children: (this.heroes ?? [])
            .map(
              (hero) => Container(
                padding: EdgeInsets.all(3),
                child: _HeroGridItem(
                  hero,
                  onClick: onHeroClick,
                  isSelected: hero.id == this.selectedHero?.id,
                ),
              ),
            )
            .toList(),
      ),
    );

    final nothingHere = Text(
      "No heroes found",
      style: Theme.of(context).textTheme.bodyText1,
    );

    final content = this.heroes != null && this.heroes!.isEmpty
        ? Center(child: nothingHere)
        : Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 32),
                Expanded(child: heroListing),
              ],
            ),
          );

    final body = Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (this.isLoading) Center(child: CircularProgressIndicator()),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Hero Avatar")),
      body: SafeArea(child: body),
    );
  }
}

class _HeroGridItem extends StatelessWidget {
  final KHero hero;
  final Function(KHero) onClick;
  final bool isSelected;

  const _HeroGridItem(
    this.hero, {
    required this.onClick,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => this.onClick(hero),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: this.isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: this.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  width: 0.5,
                ),
              ),
              child: Image.network(
                KHeroHelper.isEgg(this.hero)
                    ? this.hero.eggImageURL!
                    : this.hero.imageURL!,
                fit: BoxFit.cover,
                color: KHeroHelper.isEgg(this.hero)
                    ? Theme.of(context).iconTheme.color
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        Text(
          KHeroHelper.isEgg(this.hero) ? "Egg" : this.hero.name ?? "?",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );

    return body;
  }
}

class _HeroDetail extends StatefulWidget {
  final KHero? hero;
  final Function(KHero) onImageClick;

  const _HeroDetail(this.hero, {required this.onImageClick});

  @override
  State<StatefulWidget> createState() => _HeroDetailState();
}

class _HeroDetailState extends State<_HeroDetail> {
  String? get displayName => widget.hero == null
      ? null
      : (KHeroHelper.isEgg(widget.hero!) ? "Egg" : widget.hero!.name!);

  String? get displayBio => widget.hero == null
      ? null
      : (KHeroHelper.isEgg(widget.hero!)
          ? "I wonder what's inside?"
          : widget.hero!.bio!);

  @override
  Widget build(BuildContext context) {
    final rawImage = widget.hero == null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerTheme.color!,
                width: 0.5,
              ),
              color: Colors.grey.shade200,
            ),
          )
        : KHeroPortrait(hero: widget.hero!);

    final image = GestureDetector(
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
          .copyWith(fontWeight: FontWeight.bold),
    );

    final bioStyle = Theme.of(context).textTheme.bodyText1;

    final bio = widget.hero?.isEgg ?? false
        ? KStopwatchLabel(
            widget.hero!.eggDate!.add(widget.hero!.eggDuration!),
            formatter: (dur) => "Hatch in ${KUtil.prettyStopwatch(dur)}",
            style: bioStyle,
          )
        : Text(
            // simulate 'minLines' functionality
            (this.displayBio ?? "") + "\n\n",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [name, SizedBox(height: 10), bio],
          ),
        ),
      ],
    );

    return body;
  }
}
