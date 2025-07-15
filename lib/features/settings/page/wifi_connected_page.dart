import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/app_sub_parent_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class WifiConnectedPage extends StatelessWidget {
  const WifiConnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          SizedBox(height: AppSpacing.xl4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppSpacing.lg),
                    child: const AppBackHeader2(title: 'Wifi'),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.xl3),
                child: AusaButton(
                  backgroundColor: AppColors.primary500,
                  textColor: AppColors.white,
                  text: 'Forget this network',
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl4),
          AppMainContainer(
            child: Column(
              children: [
                AppSubParentContainer(
                  child: Column(
                    children: [
                      _statusWidget('Status', 'Connected', false),
                      _statusWidget('Username', 'user_name', false),
                      _statusWidget('Password', 'password@', false),
                      _statusWidget(
                        'Wifi Address',
                        'E6:A2:15:00:63:23:F8',
                        true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _statusWidget(String label, String value, bool isLast) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: AppTypography.body(
              weight: AppTypographyWeight.regular,
              color: AppColors.gray500,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: AppTypography.body(
              weight: AppTypographyWeight.regular,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
      if (!isLast) ...[
        SizedBox(height: AppSpacing.xl),
        Divider(color: Color(0xff818181).withOpacity(0.2), thickness: 1),
        SizedBox(height: AppSpacing.xl),
      ],
    ],
  );
}
