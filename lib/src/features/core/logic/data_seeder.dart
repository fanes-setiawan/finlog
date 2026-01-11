import 'package:finlog/src/features/core/model/core_models.dart';
import 'package:flutter/material.dart';

class DataSeeder {
  static List<CategoryModel> defaultCategories(String userId) {
    return [
      CategoryModel(
          id: 'cat_food',
          userId: userId,
          name: 'Makanan',
          iconCode: Icons.restaurant.codePoint,
          colorValue: Colors.orange.value,
          type: 'expense'),
      CategoryModel(
          id: 'cat_transport',
          userId: userId,
          name: 'Transportasi',
          iconCode: Icons.directions_car.codePoint,
          colorValue: Colors.blue.value,
          type: 'expense'),
      CategoryModel(
          id: 'cat_salary',
          userId: userId,
          name: 'Gaji',
          iconCode: Icons.attach_money.codePoint,
          colorValue: Colors.green.value,
          type: 'income'),
      CategoryModel(
          id: 'cat_entertainment',
          userId: userId,
          name: 'Hiburan',
          iconCode: Icons.movie.codePoint,
          colorValue: Colors.purple.value,
          type: 'expense'),
      CategoryModel(
          id: 'cat_health',
          userId: userId,
          name: 'Kesehatan',
          iconCode: Icons.local_hospital.codePoint,
          colorValue: Colors.red.value,
          type: 'expense'),
    ];
  }

  static List<WalletModel> defaultWallets(String userId) {
    return [
      WalletModel(
          id: 'wallet_cash',
          userId: userId,
          name: 'Tunai',
          balance: 0.0,
          iconCode: Icons.account_balance_wallet.codePoint,
          type: 'cash'),
      WalletModel(
          id: 'wallet_bank',
          userId: userId,
          name: 'Bank BCA',
          balance: 0.0,
          iconCode: Icons.account_balance.codePoint,
          type: 'bank'),
      WalletModel(
          id: 'wallet_seabank',
          userId: userId,
          name: 'SeaBank',
          balance: 0.0,
          iconCode: Icons.account_balance.codePoint,
          type: 'bank'),
      WalletModel(
          id: 'wallet_gopay',
          userId: userId,
          name: 'GoPay',
          balance: 0.0,
          iconCode: Icons.wallet_giftcard.codePoint,
          type: 'ewallet'),
      WalletModel(
          id: 'wallet_shopeepay',
          userId: userId,
          name: 'ShopeePay',
          balance: 0.0,
          iconCode: Icons.shopping_bag.codePoint,
          type: 'ewallet'),
    ];
  }
}
