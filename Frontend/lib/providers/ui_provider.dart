import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uiProviderProvider = ChangeNotifierProvider((ref) => UIProvider());

class UIProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Define notifyListeners method
  }
}
