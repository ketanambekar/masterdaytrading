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
              duration: const Duration(milliseconds: 200),
              height: controller.showAppBar.value ? kToolbarHeight : 0,
              child: AppBar(
                backgroundColor: AppColors.lightPrimary.withOpacity(0.8),
                centerTitle: true,
                title: Text('title'.tr, style: AppTextStyles.headline(context).copyWith(color: Colors.white),),
                // actions: [
                //   IconButton(
                //     tooltip: 'Switch Language',
                //     icon: const Icon(Icons.translate),
                //     onPressed: controller.cycleLanguage,
                //   ),
                //   Obx(() => IconButton(
                //         tooltip: 'Toggle Theme',
                //         icon: Icon(themeService.isDarkMode
                //             ? Icons.wb_sunny_outlined
                //             : Icons.dark_mode_outlined),
                //         onPressed: themeService.toggleTheme,
                //       )),
                // ],
              )
            )),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                // ✅ Full width responsive video with fixed height
                SizedBox(
                  width: double.infinity,
                  height:
                      constraints.maxHeight * 0.5, // Use half the screen height
                  child: const FullScreenVideoBackground(
                    videoUrl:
                        'https://videos.pexels.com/video-files/7579667/7579667-uhd_1440_2732_25fps.mp4',
                  ),
                ),
                const IntroBenefitsWidget(
                  benefits: [
                    'No Webinaar',
                    'No Upselling',
                    '100 Points Target in Intraday',
                    'Trade in Just 30 Minutes Daily',
                    'Live 3 Months ka BackTesting',
                    'Full 0.09 Version Strategy Explained',
                  ],
                ),
                 AboutCard(
                  name: 'Umesh Bhandari',
                  title: 'SEBI & NISM Certified\nFounder @ MasterTrading2023',
                  imageUrl: 'https://media.licdn.com/dms/image/v2/D4D03AQFinXts4Hsh_Q/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1696345973511?e=2147483647&v=beta&t=wt520Utcpd8R284pRFTHKJZC4GWh-FM02D4YDACtwWk',
                  pricingOld: '₹10,000.00',
                  pricingNew: '999.00',
                  countdown: '00:00',
                  onBuy: () {
                   print("lets Go");
                  },
                ),
                const MasterclassTopicsCard(),
                const MasterclassBenefitsCard(),
                const WhyJoinMasterclassCard(),
                const WhatWillBeCoveredCard(),
                const FreeBonusesCard(),
                const MeetYourMentorCard(),
                Container(
                  color: AppColors.lightPrimary.withOpacity(0.7),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "Instagram Posts",
                            style: AppTextStyles.headline(context).copyWith(color: Colors.white),
                          ),
                        ),
                        const Row(
                          children: [
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/878460096/photo/using-a-smartphone-and-pc-to-look-at-financial-data.jpg?s=1024x1024&w=is&k=20&c=Rs7WdnL1yf2SYH3uDvw-Zp4cy36BeVF9CeIl6ig1xV4=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/878460096/photo/using-a-smartphone-and-pc-to-look-at-financial-data.jpg?s=1024x1024&w=is&k=20&c=Rs7WdnL1yf2SYH3uDvw-Zp4cy36BeVF9CeIl6ig1xV4=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2160537640/photo/robot-investment-monitoring-market-volatility-in-financial-market.webp?a=1&b=1&s=612x612&w=0&k=20&c=bAd18tMa22mxl6D01AYtjJnWlevTWAkHSBUOBXT7ScA=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/2192471037/photo/business-professional-interacting-with-ai-powered-analytics-through-a-digital-interface.jpg?s=1024x1024&w=is&k=20&c=2OSRW3rSN_rJfsBRFCirqCcXRO11L0b3DFjYoHDwSmg=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                            InstagramPostWidget(
                              imageUrl:
                                  'https://media.istockphoto.com/id/878460096/photo/using-a-smartphone-and-pc-to-look-at-financial-data.jpg?s=1024x1024&w=is&k=20&c=Rs7WdnL1yf2SYH3uDvw-Zp4cy36BeVF9CeIl6ig1xV4=',
                              postUrl:
                                  'https://www.instagram.com/p/DLnFWQGSPn3/?img_index=1',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const AppFooter(),

              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomOfferBar(
        onPressed: () {
          // Action when Buy Now is pressed
          print("Buy Now pressed");
        },
      ),
    );
  }
}
