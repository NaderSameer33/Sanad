import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/di.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../widgets/home_greeting_section.dart';
import '../widgets/home_next_prayer_hero_card.dart';
import '../widgets/home_qibla_mini_card.dart';
import '../widgets/home_quick_access_grid.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_verse_of_day_card.dart';
import '../widgets/home_wird_progress_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeTopBar(),
      body: SafeArea(
        top: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // 1. Greeting & Spiritual Context
                  HomeGreetingSection(
                    timeSlot: state.timeSlot,
                    greeting: state.greeting,
                    location: state.location,
                    hijriDate: state.hijriDate,
                  ),

                  const SizedBox(height: 6),

                  // 2. Prominent Next Prayer & 5 Prayers Timeline Card
                  HomeNextPrayerHeroCard(
                    nextPrayerName: state.nextPrayerName,
                    remainingTime: state.remainingTime,
                    prayerTimes: state.prayerTimes,
                    specialTimes: state.specialTimes,
                  ),

                  const SizedBox(height: 6),

                  // 3. Bento Grid: Verse of the Day with Quranic Script and Tafsir
                  HomeVerseOfDayCard(
                    verse: state.verseOfDay,
                    isExpanded: state.isTafsirExpanded,
                    onToggleExpand: () => cubit.toggleTafsirExpanded(),
                  ),

                  const SizedBox(height: 6),

                  // 4. Asymmetric Columns / Bento: Qibla Mini Card & Wird Progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        HomeQiblaMiniCard(qiblaAngle: state.qiblaAngle),
                        const SizedBox(height: 12),
                        HomeWirdProgressCard(wird: state.wirdProgress),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 5. Quick Access Contemplation Cards (4 Cards Grid)
                  const HomeQuickAccessGrid(),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
