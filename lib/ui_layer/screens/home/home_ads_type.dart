enum HomeAdsType {

  hot(name: 'hot', value: 2519),
  video(name: 'video', value: 2520),
  live(name: 'live', value: 2521),
  eatingMelons(name: 'eatingMelons', value: 2522),
  ;
  final String name;
  final int value;

  const HomeAdsType({required this.name, required this.value});



}