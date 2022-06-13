import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.height,
    this.title,
    this.leading,
    this.action,
    this.onAction,
    this.onLeading,
  }) : super(key: key);

  final double? height;
  final Widget? title;
  final Widget? leading;
  final Widget? action;
  final void Function()? onAction;
  final void Function()? onLeading;

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
      ),
      actions: [
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [action!],
              ),
            ),
          )
      ],
      leading: leading != null
          ? InkWell(
              onTap: onLeading,
              child: Stack(
                alignment: Alignment.center,
                children: [leading!],
              ),
            )
          : null,
      title: title,
    );
  }
}
