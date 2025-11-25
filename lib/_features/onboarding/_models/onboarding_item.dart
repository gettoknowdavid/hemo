final class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}

const List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    title: 'Donate Blood',
    description:
        '''Your contribution is vital. Easily track your donation history and see the impact you're making.''',
    imagePath: 'assets/images/onboarding-1.png',
  ),
  OnboardingItem(
    title: 'Save Lives',
    description:
        '''Every drop counts. Connect with a network of donors and recipients who need your help.''',
    imagePath: 'assets/images/onboarding-2.png',
  ),
  OnboardingItem(
    title: 'Find Community',
    description:
        '''Find strength in numbers. Participate in community events, challenges, and awareness campaigns.''',
    imagePath: 'assets/images/onboarding-3.png',
  ),
];
