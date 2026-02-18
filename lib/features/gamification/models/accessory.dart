import 'package:flutter/material.dart';

class Accessory {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final IconData icon;

  const Accessory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.icon,
  });
}

const List<Accessory> allAccessories = [
  Accessory(
    id: 'cool_sunglasses',
    name: 'Coole Brille',
    imagePath: 'assets/accessories/sunglasses.png',
    price: 50,
    icon: Icons.wb_sunny_rounded,
  ),
  Accessory(
    id: 'wizard_hat',
    name: 'Zauberhut',
    imagePath: 'assets/accessories/wizard_hat.png',
    price: 100,
    icon: Icons.auto_fix_high_rounded,
  ),
  Accessory(
    id: 'party_hat',
    name: 'Partyhut',
    imagePath: 'assets/accessories/party_hat.png',
    price: 75,
    icon: Icons.celebration_rounded,
  ),
  Accessory(
    id: 'hero_cape',
    name: 'Heldenmantel',
    imagePath: 'assets/accessories/cape.png',
    price: 150,
    icon: Icons.shield_rounded,
  ),
];
