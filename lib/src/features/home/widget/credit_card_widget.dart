import 'package:finlog/src/commons/constants/app_assets.dart';
import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:finlog/src/commons/utils/app_icon.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;

  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.neutral2,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(AppAssets.worldmap),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIcon(AppAssets.cardHolderIcon, size: 40.0),
              AppIcon(AppAssets.signalIcon, size: 40.0),
            ],
          ),
          const Spacer(),
          Text(
            cardNumber,
            style:  const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Holder Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Card Holder",
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                  Text(
                    cardHolder,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Expiry",
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CVV",
                    style: TextStyle(color: AppColors.white, fontSize: 12),
                  ),
                  Text(
                    cvv,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppIcon(AppAssets.mastercardIcon , size: 40.0)
            ],
          ),
        ],
      ),
    );
  }
}
