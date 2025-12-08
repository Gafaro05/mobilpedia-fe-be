import 'package:flutter/material.dart';

class FavoriteCar {
  final String brandName;
  final String brandLogoPath;
  final String carName;
  final String series;
  final String model;

  FavoriteCar({
    required this.brandName,
    required this.brandLogoPath,
    required this.carName,
    required this.series,
    required this.model,
  });
}

class FavoriteManager {
  static final List<FavoriteCar> _favorites = [];

  static List<FavoriteCar> get favorites => List.unmodifiable(_favorites);

  static void addFavorite(FavoriteCar car) {
    final exists = _favorites.any(
      (c) => c.brandName == car.brandName && c.carName == car.carName,
    );
    if (!exists) {
      _favorites.add(car);
    }
  }

  static void removeFavorite(String brandName, String carName) {
    _favorites.removeWhere(
      (c) => c.brandName == brandName && c.carName == carName,
    );
  }

  static bool isFavorite(String brandName, String carName) {
    return _favorites.any(
      (c) => c.brandName == brandName && c.carName == carName,
    );
  }
}
