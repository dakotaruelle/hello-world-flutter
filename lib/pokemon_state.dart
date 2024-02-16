import 'package:flutter/material.dart';

class PokemonState extends ChangeNotifier {
  final _selectedPokemon = <int, bool>{};

  bool getSelectionState(int dexNumber) {
    return _selectedPokemon[dexNumber] ?? false;
  }

  void toggleSelection(int dexNumber, bool isSelected) {
    _selectedPokemon[dexNumber] = isSelected;
    notifyListeners();
  }
}
