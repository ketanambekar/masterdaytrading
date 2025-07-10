import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterdaytrading/modules/home/home_controller.dart';
import 'package:masterdaytrading/modules/home/widgets/about_card.dart';
import 'package:masterdaytrading/modules/home/widgets/app_footer.dart';
import 'package:masterdaytrading/modules/home/widgets/background_video_widget.dart';
import 'package:masterdaytrading/modules/home/widgets/free_bonus_widget.dart';
import 'package:masterdaytrading/modules/home/widgets/instagram_embed_widget.dart';
import 'package:masterdaytrading/modules/home/widgets/intro_benefits_widget.dart';
import 'package:masterdaytrading/modules/home/widgets/master_class_benefits.dart';
import 'package:masterdaytrading/modules/home/widgets/master_class_topics.dart';
import 'package:masterdaytrading/modules/home/widgets/meet_your_mentor.dart';
import 'package:masterdaytrading/modules/home/widgets/what_will_be_covered.dart';
import 'package:masterdaytrading/modules/home/widgets/why_join_this_card.dart';
import 'package:masterdaytrading/services/buy_now/check_out_pop_up.dart';
import 'package:masterdaytrading/services/theme_service.dart';
import 'package:masterdaytrading/theme/app_colors.dart';
import 'package:masterdaytrading/theme/app_text_styles.dart';
import 'package:masterdaytrading/widgets/bottom_bar/bottom_offer_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: controller.showAppBar.value ? kToolbarHeight : 0,
          child: AppBar(
            backgroundColor: AppColors.lightPrimary.withOpacity(0.85),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'title'.tr,
              style: AppTextStyles.headline(context)
                  .copyWith(color: Colors.white),
            ),
          ),
        )),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Background
              SizedBox(
                width: double.infinity,
                height: constraints.maxHeight * 0.6,
                child: const FullScreenVideoBackground(
                  videoUrl:
                  'https://videos.pexels.com/video-files/7579667/7579667-uhd_1440_2732_25fps.mp4',
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: IntroBenefitsWidget(
                  benefits: [
                    'No Webinar',
                    'No Upselling',
                    '100 Points Target in Intraday',
                    'Trade in Just 30 Minutes Daily',
                    'Live 3 Months ka BackTesting',
                    'Full 0.09 Version Strategy Explained',
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AboutCard(
                  name: 'Umesh Bhandari',
                  title: 'SEBI & NISM Certified\nFounder @ MasterTrading2023',
                  imageUrl:
                  'https://media.licdn.com/dms/image/v2/D4D03AQFinXts4Hsh_Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1696345973511?e=2147483647&v=beta&t=wt520Utcpd8R284pRFTHKJZC4GWh-FM02D4YDACtwWk',
                  pricingOld: '₹10,000.00',
                  pricingNew: '999.00',
                  countdown: '00:00',
                  onBuy: showCheckoutSheet,
                ),
              ),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MasterclassTopicsCard(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MasterclassBenefitsCard(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: WhyJoinMasterclassCard(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: WhatWillBeCoveredCard(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FreeBonusesCard(),
              ),
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: MeetYourMentorCard(),
              ),

              const SizedBox(height: 32),

              // Instagram Section
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                color: AppColors.lightPrimary.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📸 Instagram Posts",
                      style: AppTextStyles.headline(context)
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const InstagramEmbedWidget(), // Make this a separate widget that handles the grid/responsive layout
                  ],
                ),
              ),

              const AppFooter(),
            ],
          ),
        );
      }),
      bottomNavigationBar: const BottomOfferBar(
        onPressed: showCheckoutSheet,
      ),
    );
  }
}
