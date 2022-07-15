import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color,context),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) => ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(onTap: onClicked),
                ),
              ),
            ));

    return image;
  }

  Widget buildEditIcon(Color color,context) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
