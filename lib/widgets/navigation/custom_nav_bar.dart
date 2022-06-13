import 'package:flutter/material.dart';
import 'package:flutter_cat/resources/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.currentTab,
    required this.onSelect,
  }) : super(key: key);

  final int currentTab;
  final void Function(int) onSelect;

  static const List<_BottomNavigationBarItem> _items = [
    _BottomNavigationBarItem(
      iconPath: AppIcons.homeIcon,
      title: 'Cats',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.favoriteIcon,
      title: 'Favorite cats',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.profileIcon,
      title: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: kBottomNavigationBarHeight,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((e) {
          final int i = _items.indexOf(e);

          return Flexible(
            child: SizedBox(
              width: double.infinity,
              height: kBottomNavigationBarHeight,
              child: Material(
                color: Colors.amber[800],
                child: InkWell(
                  onTap: () => onSelect(i),
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (i == currentTab) ...[
                        SvgPicture.asset(
                          e.iconPath,
                          width: 32.0,
                        ),
                      ] else ...[
                        SvgPicture.asset(
                          e.iconPath,
                          width: 26.0,
                        ),
                      ],
                      const SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        e.title,
                        style: TextStyle(
                          fontSize: i == currentTab ? 13.0 : 11.0,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavigationBarItem {
  const _BottomNavigationBarItem({
    required this.iconPath,
    required this.title,
  });

  final String iconPath;
  final String title;
}
