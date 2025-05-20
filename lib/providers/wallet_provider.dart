import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../services/wallet_service.dart';

final walletServiceProvider = Provider<WalletService>((ref) => WalletService());

final walletProvider = StateNotifierProvider<WalletNotifier, AsyncValue<List<Wallet>>>((ref) {
  return WalletNotifier(ref.read(walletServiceProvider));
});

class WalletNotifier extends StateNotifier<AsyncValue<List<Wallet>>> {
  final WalletService _walletService;

  WalletNotifier(this._walletService) : super(const AsyncValue.loading()) {
    loadWallets();
  }

  Future<void> loadWallets() async {
    try {
      final wallets = await _walletService.getWallets();
      state = AsyncValue.data(wallets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addWallet(Wallet wallet) async {
    try {
      final newWallet = await _walletService.addWallet(wallet);
      state.whenData((wallets) {
        state = AsyncValue.data([...wallets, newWallet]);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    try {
      final updatedWallet = await _walletService.updateWallet(wallet);
      state.whenData((wallets) {
        final index = wallets.indexWhere((w) => w.id == wallet.id);
        if (index != -1) {
          final updatedList = [...wallets];
          updatedList[index] = updatedWallet;
          state = AsyncValue.data(updatedList);
        }
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWallet(int id) async {
    try {
      await _walletService.deleteWallet(id);
      state.whenData((wallets) {
        state = AsyncValue.data(
          wallets.where((w) => w.id != id).toList(),
        );
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 