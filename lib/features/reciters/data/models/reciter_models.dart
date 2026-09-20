class MoshafInfo {
  final int id;
  final String name;
  final String server;
  final int surahTotal;
  final List<int> availableSurahs;

  const MoshafInfo({
    required this.id,
    required this.name,
    required this.server,
    required this.surahTotal,
    required this.availableSurahs,
  });

  String getSurahAudioUrl(int surahNumber) {
    final cleanServer = server.endsWith('/') ? server : '$server/';
    final formattedNumber = surahNumber.toString().padLeft(3, '0');
    return '$cleanServer$formattedNumber.mp3';
  }

  factory MoshafInfo.fromJson(Map<String, dynamic> json) {
    final surahListStr = json['surah_list'] as String? ?? '';
    final surahIds = surahListStr
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();

    return MoshafInfo(
      id: json['id'] as int? ?? 1,
      name: json['name'] as String? ?? 'حفص عن عاصم',
      server: json['server'] as String? ?? '',
      surahTotal: json['surah_total'] as int? ?? 114,
      availableSurahs: surahIds.isNotEmpty
          ? surahIds
          : List.generate(114, (index) => index + 1),
    );
  }
}

class Reciter {
  final int id;
  final String name;
  final String letter;
  final List<MoshafInfo> moshafList;

  const Reciter({
    required this.id,
    required this.name,
    required this.letter,
    required this.moshafList,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    final rawMoshaf = json['moshaf'] as List<dynamic>? ?? [];
    return Reciter(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      letter: json['letter'] as String? ?? '',
      moshafList: rawMoshaf
          .map((m) => MoshafInfo.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
