import 'package:marketplace_shared/constants/localized_name.dart';
import 'package:marketplace_shared/constants/market_geography.dart';

/// Builds geography entries with French as the primary label.
LocalizedName _n(String fr, {String? en, String? ar}) => LocalizedName(
      en: en ?? fr,
      fr: fr,
      ar: ar ?? fr,
    );

MarketRegion _r(String id, String fr, {String? en, String? ar}) => MarketRegion(
      id: id,
      countryCode: MarketCountries.sudan,
      names: _n(fr, en: en, ar: ar),
    );

MarketDistrict _d(String id, String regionId, String fr, {String? en, String? ar}) =>
    MarketDistrict(
      id: id,
      regionId: regionId,
      countryCode: MarketCountries.sudan,
      names: _n(fr, en: en, ar: ar),
    );

MarketLocality _l(
  String id,
  String districtId,
  String regionId,
  String fr, {
  bool capital = false,
  String? en,
  String? ar,
}) =>
    MarketLocality(
      id: id,
      districtId: districtId,
      regionId: regionId,
      countryCode: MarketCountries.sudan,
      names: _n(fr, en: en, ar: ar),
      isCapital: capital,
    );

/// Sudan: 18 states, local government districts, major cities.
abstract final class GeographySudan {
  static final regions = <MarketRegion>[
    _r('sd-khartoum', 'Khartoum'),
    _r('sd-red-sea', 'Red Sea'),
    _r('sd-kassala', 'Kassala'),
    _r('sd-gedaref', 'Gedaref'),
    _r('sd-river-nile', 'River Nile'),
    _r('sd-northern', 'Northern'),
    _r('sd-north-kordofan', 'North Kordofan'),
    _r('sd-south-kordofan', 'South Kordofan'),
    _r('sd-west-kordofan', 'West Kordofan'),
    _r('sd-white-nile', 'White Nile'),
    _r('sd-blue-nile', 'Blue Nile'),
    _r('sd-sennar', 'Sennar'),
    _r('sd-gezira', 'Gezira'),
    _r('sd-north-darfur', 'North Darfur'),
    _r('sd-west-darfur', 'West Darfur'),
    _r('sd-south-darfur', 'South Darfur'),
    _r('sd-east-darfur', 'East Darfur'),
    _r('sd-central-darfur', 'Central Darfur'),
  ];

  static final districts = <MarketDistrict>[
  // Khartoum
  _d('sd-khartoum-metropole', 'sd-khartoum', 'Khartoum Metropole'),
  _d('sd-khartoum-rural', 'sd-khartoum', 'Khartoum Rural'),

  // Red Sea
  _d('sd-port-sudan', 'sd-red-sea', 'Port Sudan'),
  _d('sd-halaib', 'sd-red-sea', 'Halaib Triangle'),

  // Kassala
  _d('sd-kassala-central', 'sd-kassala', 'Kassala Central'),
  _d('sd-new-halfa', 'sd-kassala', 'New Halfa'),
  _d('sd-west-kassala', 'sd-kassala', 'West Kassala'),

  // Gedaref
  _d('sd-gedaref-central', 'sd-gedaref', 'Gedaref Central'),
  _d('sd-gedaref-rural', 'sd-gedaref', 'Gedaref Rural'),

  // River Nile
  _d('sd-atbara', 'sd-river-nile', 'Atbara'),
  _d('sd-shendi', 'sd-river-nile', 'Shendi'),

  // Northern
  _d('sd-dongola', 'sd-northern', 'Dongola'),
  _d('sd-wadi-halfa', 'sd-northern', 'Wadi Halfa'),

  // North Kordofan
  _d('sd-el-obeid', 'sd-north-kordofan', 'El Obeid'),
  _d('sd-bara', 'sd-north-kordofan', 'Bara'),

  // South Kordofan
  _d('sd-kadugli', 'sd-south-kordofan', 'Kadugli'),
  _d('sd-rashad', 'sd-south-kordofan', 'Rashad'),

  // West Kordofan
  _d('sd-al-fulah', 'sd-west-kordofan', 'Al-Fulah'),
  _d('sd-lagawa', 'sd-west-kordofan', 'Lagawa'),

  // White Nile
  _d('sd-rabak', 'sd-white-nile', 'Rabak'),
  _d('sd-tandalti', 'sd-white-nile', 'Tandalti'),

  // Blue Nile
  _d('sd-ad-damazin', 'sd-blue-nile', 'Ad-Damazin'),
  _d('sd-kurmuk', 'sd-blue-nile', 'Kurmuk'),

  // Sennar
  _d('sd-singa', 'sd-sennar', 'Singa'),
  _d('sd-sennar-rural', 'sd-sennar', 'Sennar Rural'),

  // Gezira
  _d('sd-wad-madani', 'sd-gezira', 'Wad Madani'),
  _d('sd-gezira-central', 'sd-gezira', 'Gezira Central'),

  // North Darfur
  _d('sd-el-fasher', 'sd-north-darfur', 'El Fasher'),
  _d('sd-utash', 'sd-north-darfur', 'Umm Tash'),

  // West Darfur
  _d('sd-el-geneina', 'sd-west-darfur', 'El Geneina'),
  _d('sd-zalingei-wd', 'sd-west-darfur', 'West Darfur Rural'),

  // South Darfur
  _d('sd-nyala', 'sd-south-darfur', 'Nyala'),
  _d('sd-ed-daein-sd', 'sd-south-darfur', 'Ed Daein Area'),

  // East Darfur
  _d('sd-ed-daein', 'sd-east-darfur', 'Ed Daein'),
  _d('sd-abu-karinka', 'sd-east-darfur', 'Abu Karinka'),

  // Central Darfur
  _d('sd-zalingei', 'sd-central-darfur', 'Zalingei'),
  _d('sd-mukjar', 'sd-central-darfur', 'Mukjar'),

  ];

  static List<MarketLocality> get localities => _buildLocalities();

  static List<MarketLocality> _buildLocalities() {
    final list = <MarketLocality>[];
    void addLocalities(String districtId, String regionId, List<(String id, String name, bool cap, String ar)> items) {
      for (final (id, name, cap, ar) in items) {
        list.add(_l('sd-$id', districtId, regionId, name, capital: cap, ar: ar));
      }
    }

    // Khartoum — Khartoum Metropole
    addLocalities('sd-khartoum-metropole', 'sd-khartoum', [
      ('khartoum', 'Khartoum', true, 'الخرطوم'),
      ('omdurman', 'Omdurman', false, 'أم درمان'),
      ('bahri', 'Khartoum North (Bahri)', false, 'بحري'),
      ('karari', 'Karari', false, 'كرري'),
      ('sharq-nile', 'Sharq an-Nil', false, 'شرق النيل'),
    ]);
    // Khartoum — Khartoum Rural
    addLocalities('sd-khartoum-rural', 'sd-khartoum', [
      ('omdurman-west', 'Omdurman West', false, 'غرب أم درمان'),
      ('jebel-aulia', 'Jebel Aulia', false, 'جبل أولياء'),
    ]);
    // Red Sea — Port Sudan
    addLocalities('sd-port-sudan', 'sd-red-sea', [
      ('port-sudan', 'Port Sudan', true, 'بورتسودان'),
      ('suakin', 'Suakin', false, 'سواكن'),
      ('tokar', 'Tokar', false, 'طوكر'),
      ('sinkat', 'Sinkat', false, 'سنكات'),
      ('haya', 'Haya', false, 'هيا'),
    ]);
    // Red Sea — Halaib Triangle
    addLocalities('sd-halaib', 'sd-red-sea', [
      ('halaib', 'Halaib', false, 'حلايب'),
    ]);
    // Kassala — Kassala Central
    addLocalities('sd-kassala-central', 'sd-kassala', [
      ('kassala', 'Kassala', true, 'كسلا'),
      ('aroma', 'Aroma', false, 'أروما'),
      ('hamashkoreib', 'Hamashkoreib', false, 'همشكوريب'),
    ]);
    // Kassala — New Halfa
    addLocalities('sd-new-halfa', 'sd-kassala', [
      ('new-halfa', 'New Halfa', false, 'حلفا الجديدة'),
      ('khashm-el-girba', 'Khashm el-Girba', false, 'خشم القربة'),
    ]);
    // Kassala — West Kassala
    addLocalities('sd-west-kassala', 'sd-kassala', [
      ('wagar', 'Wagar', false, 'واقر'),
      ('north-delta', 'North Delta', false, 'دلتا الشمال'),
    ]);
    // Gedaref — Gedaref Central
    addLocalities('sd-gedaref-central', 'sd-gedaref', [
      ('el-gadarif', 'El Gadarif', true, 'القضارف'),
      ('al-faw', 'Al Faw', false, 'الفاو'),
      ('al-huwatah', 'Al Huwatah', false, 'الحواتة'),
      ('gallabat', 'Gallabat', false, 'القلابات'),
    ]);
    // Gedaref — Gedaref Rural
    addLocalities('sd-gedaref-rural', 'sd-gedaref', [
      ('doka', 'Doka', false, 'دوكة'),
      ('al-qurayza', 'Al Qurayza', false, 'القريزه'),
    ]);
    // River Nile — Atbara
    addLocalities('sd-atbara', 'sd-river-nile', [
      ('atbara', 'Atbara', false, 'عطبرة'),
      ('berber', 'Berber', false, 'بربر'),
      ('ed-damer', 'Ed Damer', true, 'الدامر'),
    ]);
    // River Nile — Shendi
    addLocalities('sd-shendi', 'sd-river-nile', [
      ('shendi', 'Shendi', false, 'شندي'),
      ('abu-hamed', 'Abu Hamed', false, 'أبو حمد'),
    ]);
    // Northern — Dongola
    addLocalities('sd-dongola', 'sd-northern', [
      ('dongola', 'Dongola', true, 'دنقلا'),
      ('merowe', 'Merowe', false, 'مروي'),
      ('karima', 'Karima', false, 'كريمة'),
    ]);
    // Northern — Wadi Halfa
    addLocalities('sd-wadi-halfa', 'sd-northern', [
      ('wadi-halfa', 'Wadi Halfa', false, 'وادي حلفا'),
      ('abri', 'Abri', false, 'أبري'),
    ]);
    // North Kordofan — El Obeid
    addLocalities('sd-el-obeid', 'sd-north-kordofan', [
      ('el-obeid', 'El Obeid', true, 'الأبيض'),
      ('umm-ruwaba', 'Umm Ruwaba', false, 'أم روابة'),
      ('rahad', 'Ar-Rahad', false, 'الرهد'),
    ]);
    // North Kordofan — Bara
    addLocalities('sd-bara', 'sd-north-kordofan', [
      ('bara', 'Bara', false, 'بارا'),
      ('en-nuhud', 'En Nuhud', false, 'النهود'),
      ('sodari', 'Sodari', false, 'سودري'),
    ]);
    // South Kordofan — Kadugli
    addLocalities('sd-kadugli', 'sd-south-kordofan', [
      ('kadugli', 'Kadugli', true, 'كادقلي'),
      ('dilling', 'Ad-Dilling', false, 'الدلنج'),
      ('abu-jibeha', 'Abu Jibeha', false, 'أبو جبيهة'),
    ]);
    // South Kordofan — Rashad
    addLocalities('sd-rashad', 'sd-south-kordofan', [
      ('rashad', 'Rashad', false, 'رشاد'),
      ('talodi', 'Talodi', false, 'تلودي'),
      ('habila', 'Habila', false, 'هبيلة'),
    ]);
    // West Kordofan — Al-Fulah
    addLocalities('sd-al-fulah', 'sd-west-kordofan', [
      ('al-fulah', 'Al-Fulah', true, 'الفولة'),
      ('en-nuhud-wk', 'En Nuhud', false, 'النهود'),
      ('al-mujlad', 'Al-Mujlad', false, 'المجلد'),
    ]);
    // West Kordofan — Lagawa
    addLocalities('sd-lagawa', 'sd-west-kordofan', [
      ('lagawa', 'Lagawa', false, 'لقاوة'),
      ('ghubeish', 'Ghubeish', false, 'غبيش'),
    ]);
    // White Nile — Rabak
    addLocalities('sd-rabak', 'sd-white-nile', [
      ('rabak', 'Rabak', true, 'رابك'),
      ('ad-douiem', 'Ad Douiem', false, 'الدويم'),
      ('kosti', 'Kosti', false, 'كوستي'),
    ]);
    // White Nile — Tandalti
    addLocalities('sd-tandalti', 'sd-white-nile', [
      ('tandalti', 'Tandalti', false, 'تندلتي'),
      ('al-giteina', 'Al Giteina', false, 'القطينة'),
    ]);
    // Blue Nile — Ad-Damazin
    addLocalities('sd-ad-damazin', 'sd-blue-nile', [
      ('ad-damazin', 'Ad-Damazin', true, 'الدمازين'),
      ('ar-rosayris', 'Ar-Rosayris', false, 'الروصيرص'),
      ('bau', 'Bau', false, 'باو'),
    ]);
    // Blue Nile — Kurmuk
    addLocalities('sd-kurmuk', 'sd-blue-nile', [
      ('kurmuk', 'Kurmuk', false, 'كرمك'),
      ('geissan', 'Geissan', false, 'قيسان'),
    ]);
    // Sennar — Singa
    addLocalities('sd-singa', 'sd-sennar', [
      ('singa', 'Singa', true, 'سنجة'),
      ('sinnar', 'Sinnar', false, 'سنار'),
      ('ad-dinder', 'Ad-Dinder', false, 'الدندر'),
    ]);
    // Sennar — Sennar Rural
    addLocalities('sd-sennar-rural', 'sd-sennar', [
      ('abu-hujar', 'Abu Hujar', false, 'أبو حجار'),
      ('dali', 'Dali', false, 'دالي'),
    ]);
    // Gezira — Wad Madani
    addLocalities('sd-wad-madani', 'sd-gezira', [
      ('wad-madani', 'Wad Madani', true, 'ود مدني'),
      ('al-hasahisa', 'Al Hasahisa', false, 'الحصاحيصا'),
      ('al-managil', 'Al Managil', false, 'المناقل'),
    ]);
    // Gezira — Gezira Central
    addLocalities('sd-gezira-central', 'sd-gezira', [
      ('rufaah', 'Rufaah', false, 'رفاعة'),
      ('al-kamlin', 'Al Kamlin', false, 'الكاملين'),
      ('sharq-gezira', 'Sharq al-Jazira', false, 'شرق الجزيرة'),
    ]);
    // North Darfur — El Fasher
    addLocalities('sd-el-fasher', 'sd-north-darfur', [
      ('el-fasher', 'El Fasher', true, 'الفاشر'),
      ('kutum', 'Kutum', false, 'كتم'),
      ('kabkabiya', 'Kabkabiya', false, 'كبكابية'),
      ('mellit', 'Mellit', false, 'مليط'),
    ]);
    // North Darfur — Umm Tash
    addLocalities('sd-utash', 'sd-north-darfur', [
      ('saraf-omra', 'Saraf Omra', false, 'سراف أومرة'),
      ('tawila', 'Tawila', false, 'طويلة'),
    ]);
    // West Darfur — El Geneina
    addLocalities('sd-el-geneina', 'sd-west-darfur', [
      ('el-geneina', 'El Geneina', true, 'الجنينة'),
      ('ardamata', 'Ardamata', false, 'أردماتا'),
      ('kulbus', 'Kulbus', false, 'كلبس'),
    ]);
    // West Darfur — West Darfur Rural
    addLocalities('sd-zalingei-wd', 'sd-west-darfur', [
      ('habila-wd', 'Habila', false, 'هبيلة'),
      ('sirba', 'Sirba', false, 'سربا'),
    ]);
    // South Darfur — Nyala
    addLocalities('sd-nyala', 'sd-south-darfur', [
      ('nyala', 'Nyala', true, 'نيالا'),
      ('buram', 'Buram', false, 'برام'),
      ('kas', 'Kas', false, 'كاس'),
      ('gereida', 'Gereida', false, 'قريضة'),
    ]);
    // South Darfur — Ed Daein Area
    addLocalities('sd-ed-daein-sd', 'sd-south-darfur', [
      ('ed-daein', 'Ed Daein', false, 'الضعين'),
      ('sheiria', 'Sheiria', false, 'شيريا'),
    ]);
    // East Darfur — Ed Daein
    addLocalities('sd-ed-daein', 'sd-east-darfur', [
      ('ed-daein-capital', 'Ed Daein', true, 'الضعين'),
      ('sheiria-ed', 'Sheiria', false, 'شيريا'),
      ('adila', 'Adila', false, 'عديلة'),
    ]);
    // East Darfur — Abu Karinka
    addLocalities('sd-abu-karinka', 'sd-east-darfur', [
      ('abu-karinka', 'Abu Karinka', false, 'أبو كارنكا'),
      ('yassin', 'Yassin', false, 'ياسين'),
    ]);
    // Central Darfur — Zalingei
    addLocalities('sd-zalingei', 'sd-central-darfur', [
      ('zalingei', 'Zalingei', true, 'زالنجي'),
      ('um-kedada', 'Um Kedada', false, 'أم كدادة'),
      ('wadi-salih', 'Wadi Salih', false, 'وادي صالح'),
    ]);
    // Central Darfur — Mukjar
    addLocalities('sd-mukjar', 'sd-central-darfur', [
      ('mukjar', 'Mukjar', false, 'مكجر'),
      ('bindisi', 'Bindisi', false, 'بندسي'),
    ]);

    return list;
  }
}
