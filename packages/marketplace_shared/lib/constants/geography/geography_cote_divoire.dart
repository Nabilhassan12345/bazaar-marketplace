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
      countryCode: MarketCountries.coteDivoire,
      names: _n(fr, en: en, ar: ar),
    );

MarketDistrict _d(String id, String regionId, String fr, {String? en, String? ar}) =>
    MarketDistrict(
      id: id,
      regionId: regionId,
      countryCode: MarketCountries.coteDivoire,
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
      countryCode: MarketCountries.coteDivoire,
      names: _n(fr, en: en, ar: ar),
      isCapital: capital,
    );

/// Côte d'Ivoire: 31 régions + 2 districts autonomes, 108 départements.
abstract final class GeographyCoteDivoire {
  static final regions = <MarketRegion>[
    _r('ci-abidjan', 'Abidjan'),
    _r('ci-yamoussoukro', 'Yamoussoukro'),
    _r('ci-gbeke', 'Gbêkê'),
    _r('ci-belier', 'Bélier'),
    _r('ci-bere', 'Béré'),
    _r('ci-bafing', 'Bafing'),
    _r('ci-bagoue', 'Bagoué'),
    _r('ci-bounkani', 'Bounkani'),
    _r('ci-cavally', 'Cavally'),
    _r('ci-folon', 'Folon'),
    _r('ci-gbokle', 'Gbôklê'),
    _r('ci-goh', 'Gôh'),
    _r('ci-gontougo', 'Gontougo'),
    _r('ci-grands-ponts', 'Grands-Ponts'),
    _r('ci-agneby-tiassa', 'Agnéby-Tiassa'),
    _r('ci-guemon', 'Guémon'),
    _r('ci-hambol', 'Hambol'),
    _r('ci-haut-sassandra', 'Haut-Sassandra'),
    _r('ci-iffou', 'Iffou'),
    _r('ci-indenie-djuablin', 'Indénié-Djuablin'),
    _r('ci-kabadougou', 'Kabadougou'),
    _r('ci-la-me', 'La Mé'),
    _r('ci-loh-djiboua', 'Lôh-Djiboua'),
    _r('ci-marahoue', 'Marahoué'),
    _r('ci-moronou', 'Moronou'),
    _r('ci-nzi', 'N\'Zi'),
    _r('ci-nawa', 'Nawa'),
    _r('ci-poro', 'Poro'),
    _r('ci-san-pedro', 'San-Pédro'),
    _r('ci-sud-comoe', 'Sud-Comoé'),
    _r('ci-tchologo', 'Tchologo'),
    _r('ci-tonkpi', 'Tonkpi'),
    _r('ci-worodougou', 'Worodougou'),
  ];

  static final districts = <MarketDistrict>[
  // Abidjan
  _d('ci-abidjan', 'ci-abidjan', 'Abidjan'),

  // Yamoussoukro
  _d('ci-attiegouakro', 'ci-yamoussoukro', 'Attiégouakro'),
  _d('ci-yamoussoukro', 'ci-yamoussoukro', 'Yamoussoukro'),

  // Gbêkê
  _d('ci-beoumi', 'ci-gbeke', 'Béoumi'),
  _d('ci-botro', 'ci-gbeke', 'Botro'),
  _d('ci-bouake', 'ci-gbeke', 'Bouaké'),
  _d('ci-sakassou', 'ci-gbeke', 'Sakassou'),

  // Bélier
  _d('ci-didievi', 'ci-belier', 'Didiévi'),
  _d('ci-djekanou', 'ci-belier', 'Djékanou'),
  _d('ci-tiebissou', 'ci-belier', 'Tiébissou'),
  _d('ci-toumodi', 'ci-belier', 'Toumodi'),

  // Béré
  _d('ci-dianra', 'ci-bere', 'Dianra'),
  _d('ci-kounahiri', 'ci-bere', 'Kounahiri'),
  _d('ci-mankono', 'ci-bere', 'Mankono'),

  // Bafing
  _d('ci-koro', 'ci-bafing', 'Koro'),
  _d('ci-ouaninou', 'ci-bafing', 'Ouaninou'),
  _d('ci-touba', 'ci-bafing', 'Touba'),

  // Bagoué
  _d('ci-boundiali', 'ci-bagoue', 'Boundiali'),
  _d('ci-kouto', 'ci-bagoue', 'Kouto'),
  _d('ci-tengrela', 'ci-bagoue', 'Tengréla'),

  // Bounkani
  _d('ci-bouna', 'ci-bounkani', 'Bouna'),
  _d('ci-doropo', 'ci-bounkani', 'Doropo'),
  _d('ci-nassian', 'ci-bounkani', 'Nassian'),
  _d('ci-tehini', 'ci-bounkani', 'Téhini'),

  // Cavally
  _d('ci-blolequin', 'ci-cavally', 'Bloléquin'),
  _d('ci-guiglo', 'ci-cavally', 'Guiglo'),
  _d('ci-tai', 'ci-cavally', 'Taï'),
  _d('ci-toulepleu', 'ci-cavally', 'Toulépleu'),

  // Folon
  _d('ci-kaniasso', 'ci-folon', 'Kaniasso'),
  _d('ci-minignan', 'ci-folon', 'Minignan'),

  // Gbôklê
  _d('ci-fresco', 'ci-gbokle', 'Fresco'),
  _d('ci-sassandra', 'ci-gbokle', 'Sassandra'),

  // Gôh
  _d('ci-gagnoa', 'ci-goh', 'Gagnoa'),
  _d('ci-oume', 'ci-goh', 'Oumé'),

  // Gontougo
  _d('ci-bondoukou', 'ci-gontougo', 'Bondoukou'),
  _d('ci-koun-fao', 'ci-gontougo', 'Koun-Fao'),
  _d('ci-sandegue', 'ci-gontougo', 'Sandégué'),
  _d('ci-tanda', 'ci-gontougo', 'Tanda'),
  _d('ci-transua', 'ci-gontougo', 'Transua'),

  // Grands-Ponts
  _d('ci-dabou', 'ci-grands-ponts', 'Dabou'),
  _d('ci-grand-lahou', 'ci-grands-ponts', 'Grand-Lahou'),
  _d('ci-jacqueville', 'ci-grands-ponts', 'Jacqueville'),

  // Guémon
  _d('ci-bangolo', 'ci-guemon', 'Bangolo'),
  _d('ci-duekoue', 'ci-guemon', 'Duékoué'),
  _d('ci-facobly', 'ci-guemon', 'Facobly'),
  _d('ci-kouibly', 'ci-guemon', 'Kouibly'),

  // Hambol
  _d('ci-dabakala', 'ci-hambol', 'Dabakala'),
  _d('ci-katiola', 'ci-hambol', 'Katiola'),
  _d('ci-niakaramadougou', 'ci-hambol', 'Niakaramadougou'),

  // Haut-Sassandra
  _d('ci-daloa', 'ci-haut-sassandra', 'Daloa'),
  _d('ci-issia', 'ci-haut-sassandra', 'Issia'),
  _d('ci-vavoua', 'ci-haut-sassandra', 'Vavoua'),
  _d('ci-zoukougbeu', 'ci-haut-sassandra', 'Zoukougbeu'),

  // Iffou
  _d('ci-daoukro', 'ci-iffou', 'Daoukro'),
  _d('ci-m-bahiakro', 'ci-iffou', 'M\'Bahiakro'),
  _d('ci-prikro', 'ci-iffou', 'Prikro'),

  // Indénié-Djuablin
  _d('ci-abengourou', 'ci-indenie-djuablin', 'Abengourou'),
  _d('ci-agnibilekrou', 'ci-indenie-djuablin', 'Agnibilékrou'),
  _d('ci-bettie', 'ci-indenie-djuablin', 'Bettié'),

  // Kabadougou
  _d('ci-gbeleban', 'ci-kabadougou', 'Gbéléban'),
  _d('ci-madinani', 'ci-kabadougou', 'Madinani'),
  _d('ci-odienne', 'ci-kabadougou', 'Odienné'),
  _d('ci-samatiguila', 'ci-kabadougou', 'Samatiguila'),
  _d('ci-seguelon', 'ci-kabadougou', 'Séguélon'),

  // La Mé
  _d('ci-adzope', 'ci-la-me', 'Adzopé'),
  _d('ci-akoupe', 'ci-la-me', 'Akoupé'),
  _d('ci-alepe', 'ci-la-me', 'Alépé'),
  _d('ci-yakasse-attobrou', 'ci-la-me', 'Yakassé-Attobrou'),

  // Lôh-Djiboua
  _d('ci-divo', 'ci-loh-djiboua', 'Divo'),
  _d('ci-guitry', 'ci-loh-djiboua', 'Guitry'),
  _d('ci-lakota', 'ci-loh-djiboua', 'Lakota'),

  // Marahoué
  _d('ci-bouafle', 'ci-marahoue', 'Bouaflé'),
  _d('ci-sinfra', 'ci-marahoue', 'Sinfra'),
  _d('ci-zuenoula', 'ci-marahoue', 'Zuénoula'),

  // Moronou
  _d('ci-arrah', 'ci-moronou', 'Arrah'),
  _d('ci-bongouanou', 'ci-moronou', 'Bongouanou'),
  _d('ci-m-batto', 'ci-moronou', 'M\'Batto'),

  // N'Zi
  _d('ci-bocanda', 'ci-nzi', 'Bocanda'),
  _d('ci-dimbokro', 'ci-nzi', 'Dimbokro'),
  _d('ci-kouassi-kouassikro', 'ci-nzi', 'Kouassi-Kouassikro'),

  // Nawa
  _d('ci-buyo', 'ci-nawa', 'Buyo'),
  _d('ci-gueyo', 'ci-nawa', 'Guéyo'),
  _d('ci-meagui', 'ci-nawa', 'Méagui'),
  _d('ci-soubre', 'ci-nawa', 'Soubré'),

  // Poro
  _d('ci-dikodougou', 'ci-poro', 'Dikodougou'),
  _d('ci-korhogo', 'ci-poro', 'Korhogo'),
  _d('ci-m-bengue', 'ci-poro', 'M\'Bengué'),
  _d('ci-sinematiali', 'ci-poro', 'Sinématiali'),

  // San-Pédro
  _d('ci-san-pedro', 'ci-san-pedro', 'San-Pédro'),
  _d('ci-tabou', 'ci-san-pedro', 'Tabou'),

  // Sud-Comoé
  _d('ci-aboisso', 'ci-sud-comoe', 'Aboisso'),
  _d('ci-adiake', 'ci-sud-comoe', 'Adiaké'),
  _d('ci-grand-bassam', 'ci-sud-comoe', 'Grand-Bassam'),
  _d('ci-tiapoum', 'ci-sud-comoe', 'Tiapoum'),

  // Tchologo
  _d('ci-ferkessedougou', 'ci-tchologo', 'Ferkessédougou'),
  _d('ci-kong', 'ci-tchologo', 'Kong'),
  _d('ci-ouangolodougou', 'ci-tchologo', 'Ouangolodougou'),

  // Tonkpi
  _d('ci-biankouma', 'ci-tonkpi', 'Biankouma'),
  _d('ci-danane', 'ci-tonkpi', 'Danané'),
  _d('ci-man', 'ci-tonkpi', 'Man'),
  _d('ci-sipilou', 'ci-tonkpi', 'Sipilou'),
  _d('ci-zouan-hounien', 'ci-tonkpi', 'Zouan-Hounien'),

  // Worodougou
  _d('ci-kani', 'ci-worodougou', 'Kani'),
  _d('ci-seguela', 'ci-worodougou', 'Séguéla'),

  // Agnéby-Tiassa
  _d('ci-agboville', 'ci-agneby-tiassa', 'Agboville'),
  _d('ci-sikensi', 'ci-agneby-tiassa', 'Sikensi'),
  _d('ci-taabo', 'ci-agneby-tiassa', 'Taabo'),
  _d('ci-tiassale', 'ci-agneby-tiassa', 'Tiassalé'),

  ];

  static List<MarketLocality> get localities => _buildLocalities();

  static List<MarketLocality> _buildLocalities() {
    final list = <MarketLocality>[];
    void addLocalities(String districtId, String regionId, List<(String id, String name, bool cap)> items) {
      for (final (id, name, cap) in items) {
        list.add(_l('ci-$id', districtId, regionId, name, capital: cap));
      }
    }

    // Abidjan
    addLocalities('ci-abidjan', 'ci-abidjan', [
      ('abidjan', 'Abidjan', true),
      ('cocody', 'Cocody', false),
      ('yopougon', 'Yopougon', false),
      ('adjame', 'Adjamé', false),
      ('plateau', 'Plateau', false),
      ('marcory', 'Marcory', false),
      ('treichville', 'Treichville', false),
      ('abobo', 'Abobo', false),
      ('anyama', 'Anyama', false),
      ('bingerville', 'Bingerville', false),
    ]);
    // Attiégouakro
    addLocalities('ci-attiegouakro', 'ci-yamoussoukro', [
      ('attiegouakro', 'Attiégouakro', true),
    ]);
    // Yamoussoukro
    addLocalities('ci-yamoussoukro', 'ci-yamoussoukro', [
      ('yamoussoukro', 'Yamoussoukro', true),
    ]);
    // Béoumi
    addLocalities('ci-beoumi', 'ci-gbeke', [
      ('beoumi', 'Béoumi', true),
    ]);
    // Botro
    addLocalities('ci-botro', 'ci-gbeke', [
      ('botro', 'Botro', true),
    ]);
    // Bouaké
    addLocalities('ci-bouake', 'ci-gbeke', [
      ('bouake', 'Bouaké', true),
      ('beoumi-ville', 'Béoumi', false),
      ('sakassou', 'Sakassou', false),
      ('botro-ville', 'Botro', false),
    ]);
    // Sakassou
    addLocalities('ci-sakassou', 'ci-gbeke', [
      ('sakassou-dept', 'Sakassou', true),
    ]);
    // Didiévi
    addLocalities('ci-didievi', 'ci-belier', [
      ('didievi', 'Didiévi', true),
    ]);
    // Djékanou
    addLocalities('ci-djekanou', 'ci-belier', [
      ('djekanou', 'Djékanou', true),
    ]);
    // Tiébissou
    addLocalities('ci-tiebissou', 'ci-belier', [
      ('tiebissou', 'Tiébissou', true),
    ]);
    // Toumodi
    addLocalities('ci-toumodi', 'ci-belier', [
      ('toumodi', 'Toumodi', true),
      ('tiebissou-ville', 'Tiébissou', false),
      ('didievi-ville', 'Didiévi', false),
    ]);
    // Dianra
    addLocalities('ci-dianra', 'ci-bere', [
      ('dianra', 'Dianra', true),
    ]);
    // Kounahiri
    addLocalities('ci-kounahiri', 'ci-bere', [
      ('kounahiri', 'Kounahiri', true),
    ]);
    // Mankono
    addLocalities('ci-mankono', 'ci-bere', [
      ('mankono', 'Mankono', true),
    ]);
    // Koro
    addLocalities('ci-koro', 'ci-bafing', [
      ('koro', 'Koro', true),
    ]);
    // Ouaninou
    addLocalities('ci-ouaninou', 'ci-bafing', [
      ('ouaninou', 'Ouaninou', true),
    ]);
    // Touba
    addLocalities('ci-touba', 'ci-bafing', [
      ('touba', 'Touba', true),
    ]);
    // Boundiali
    addLocalities('ci-boundiali', 'ci-bagoue', [
      ('boundiali', 'Boundiali', true),
      ('kouto', 'Kouto', false),
      ('tengrela', 'Tengréla', false),
    ]);
    // Kouto
    addLocalities('ci-kouto', 'ci-bagoue', [
      ('kouto-dept', 'Kouto', true),
    ]);
    // Tengréla
    addLocalities('ci-tengrela', 'ci-bagoue', [
      ('tengrela-dept', 'Tengréla', true),
    ]);
    // Bouna
    addLocalities('ci-bouna', 'ci-bounkani', [
      ('bouna', 'Bouna', true),
      ('doropo', 'Doropo', false),
    ]);
    // Doropo
    addLocalities('ci-doropo', 'ci-bounkani', [
      ('doropo-dept', 'Doropo', true),
    ]);
    // Nassian
    addLocalities('ci-nassian', 'ci-bounkani', [
      ('nassian', 'Nassian', true),
    ]);
    // Téhini
    addLocalities('ci-tehini', 'ci-bounkani', [
      ('tehini', 'Téhini', true),
    ]);
    // Bloléquin
    addLocalities('ci-blolequin', 'ci-cavally', [
      ('blolequin', 'Bloléquin', true),
    ]);
    // Guiglo
    addLocalities('ci-guiglo', 'ci-cavally', [
      ('guiglo', 'Guiglo', true),
      ('toulepleu', 'Toulépleu', false),
    ]);
    // Taï
    addLocalities('ci-tai', 'ci-cavally', [
      ('tai', 'Taï', true),
    ]);
    // Toulépleu
    addLocalities('ci-toulepleu', 'ci-cavally', [
      ('toulepleu-dept', 'Toulépleu', true),
    ]);
    // Kaniasso
    addLocalities('ci-kaniasso', 'ci-folon', [
      ('kaniasso', 'Kaniasso', true),
    ]);
    // Minignan
    addLocalities('ci-minignan', 'ci-folon', [
      ('minignan', 'Minignan', true),
    ]);
    // Fresco
    addLocalities('ci-fresco', 'ci-gbokle', [
      ('fresco', 'Fresco', true),
      ('sassandra', 'Sassandra', false),
    ]);
    // Sassandra
    addLocalities('ci-sassandra', 'ci-gbokle', [
      ('sassandra-dept', 'Sassandra', true),
    ]);
    // Gagnoa
    addLocalities('ci-gagnoa', 'ci-goh', [
      ('gagnoa', 'Gagnoa', true),
      ('oume', 'Oumé', false),
    ]);
    // Oumé
    addLocalities('ci-oume', 'ci-goh', [
      ('oume-dept', 'Oumé', true),
    ]);
    // Bondoukou
    addLocalities('ci-bondoukou', 'ci-gontougo', [
      ('bondoukou', 'Bondoukou', true),
      ('tanda', 'Tanda', false),
      ('koun-fao', 'Koun-Fao', false),
    ]);
    // Koun-Fao
    addLocalities('ci-koun-fao', 'ci-gontougo', [
      ('koun-fao-dept', 'Koun-Fao', true),
    ]);
    // Sandégué
    addLocalities('ci-sandegue', 'ci-gontougo', [
      ('sandegue', 'Sandégué', true),
    ]);
    // Tanda
    addLocalities('ci-tanda', 'ci-gontougo', [
      ('tanda-dept', 'Tanda', true),
    ]);
    // Transua
    addLocalities('ci-transua', 'ci-gontougo', [
      ('transua', 'Transua', true),
    ]);
    // Dabou
    addLocalities('ci-dabou', 'ci-grands-ponts', [
      ('dabou', 'Dabou', true),
      ('grand-lahou', 'Grand-Lahou', false),
      ('jacqueville', 'Jacqueville', false),
    ]);
    // Grand-Lahou
    addLocalities('ci-grand-lahou', 'ci-grands-ponts', [
      ('grand-lahou-dept', 'Grand-Lahou', true),
    ]);
    // Jacqueville
    addLocalities('ci-jacqueville', 'ci-grands-ponts', [
      ('jacqueville-dept', 'Jacqueville', true),
    ]);
    // Bangolo
    addLocalities('ci-bangolo', 'ci-guemon', [
      ('bangolo', 'Bangolo', true),
    ]);
    // Duékoué
    addLocalities('ci-duekoue', 'ci-guemon', [
      ('duekoue', 'Duékoué', true),
      ('bangolo-ville', 'Bangolo', false),
      ('facobly', 'Facobly', false),
    ]);
    // Facobly
    addLocalities('ci-facobly', 'ci-guemon', [
      ('facobly-dept', 'Facobly', true),
    ]);
    // Kouibly
    addLocalities('ci-kouibly', 'ci-guemon', [
      ('kouibly', 'Kouibly', true),
    ]);
    // Dabakala
    addLocalities('ci-dabakala', 'ci-hambol', [
      ('dabakala', 'Dabakala', true),
    ]);
    // Katiola
    addLocalities('ci-katiola', 'ci-hambol', [
      ('katiola', 'Katiola', true),
      ('dabakala-ville', 'Dabakala', false),
      ('niakaramadougou', 'Niakaramadougou', false),
    ]);
    // Niakaramadougou
    addLocalities('ci-niakaramadougou', 'ci-hambol', [
      ('niakaramadougou-dept', 'Niakaramadougou', true),
    ]);
    // Daloa
    addLocalities('ci-daloa', 'ci-haut-sassandra', [
      ('daloa', 'Daloa', true),
      ('issia', 'Issia', false),
      ('vavoua', 'Vavoua', false),
      ('zoukougbeu', 'Zoukougbeu', false),
    ]);
    // Issia
    addLocalities('ci-issia', 'ci-haut-sassandra', [
      ('issia-dept', 'Issia', true),
    ]);
    // Vavoua
    addLocalities('ci-vavoua', 'ci-haut-sassandra', [
      ('vavoua-dept', 'Vavoua', true),
    ]);
    // Zoukougbeu
    addLocalities('ci-zoukougbeu', 'ci-haut-sassandra', [
      ('zoukougbeu', 'Zoukougbeu', true),
    ]);
    // Daoukro
    addLocalities('ci-daoukro', 'ci-iffou', [
      ('daoukro', 'Daoukro', true),
      ('mbahiakro', 'M\'Bahiakro', false),
    ]);
    // M'Bahiakro
    addLocalities('ci-m-bahiakro', 'ci-iffou', [
      ('mbahiakro-dept', 'M\'Bahiakro', true),
    ]);
    // Prikro
    addLocalities('ci-prikro', 'ci-iffou', [
      ('prikro', 'Prikro', true),
    ]);
    // Abengourou
    addLocalities('ci-abengourou', 'ci-indenie-djuablin', [
      ('abengourou', 'Abengourou', true),
      ('agnibilekrou', 'Agnibilékrou', false),
      ('bettie', 'Bettié', false),
    ]);
    // Agnibilékrou
    addLocalities('ci-agnibilekrou', 'ci-indenie-djuablin', [
      ('agnibilekrou-dept', 'Agnibilékrou', true),
    ]);
    // Bettié
    addLocalities('ci-bettie', 'ci-indenie-djuablin', [
      ('bettie-dept', 'Bettié', true),
    ]);
    // Gbéléban
    addLocalities('ci-gbeleban', 'ci-kabadougou', [
      ('gbeleban', 'Gbéléban', true),
    ]);
    // Madinani
    addLocalities('ci-madinani', 'ci-kabadougou', [
      ('madinani', 'Madinani', true),
    ]);
    // Odienné
    addLocalities('ci-odienne', 'ci-kabadougou', [
      ('odienne', 'Odienné', true),
      ('minignan-ville', 'Minignan', false),
      ('madinani-ville', 'Madinani', false),
    ]);
    // Samatiguila
    addLocalities('ci-samatiguila', 'ci-kabadougou', [
      ('samatiguila', 'Samatiguila', true),
    ]);
    // Séguélon
    addLocalities('ci-seguelon', 'ci-kabadougou', [
      ('seguelon', 'Séguélon', true),
    ]);
    // Adzopé
    addLocalities('ci-adzope', 'ci-la-me', [
      ('adzope', 'Adzopé', true),
      ('akupe', 'Akoupé', false),
      ('alepe', 'Alépé', false),
    ]);
    // Akoupé
    addLocalities('ci-akoupe', 'ci-la-me', [
      ('akupe-dept', 'Akoupé', true),
    ]);
    // Alépé
    addLocalities('ci-alepe', 'ci-la-me', [
      ('alepe-dept', 'Alépé', true),
    ]);
    // Yakassé-Attobrou
    addLocalities('ci-yakasse-attobrou', 'ci-la-me', [
      ('yakasse-attobrou', 'Yakassé-Attobrou', true),
    ]);
    // Divo
    addLocalities('ci-divo', 'ci-loh-djiboua', [
      ('divo', 'Divo', true),
      ('lakota', 'Lakota', false),
      ('guitry', 'Guitry', false),
    ]);
    // Guitry
    addLocalities('ci-guitry', 'ci-loh-djiboua', [
      ('guitry-dept', 'Guitry', true),
    ]);
    // Lakota
    addLocalities('ci-lakota', 'ci-loh-djiboua', [
      ('lakota-dept', 'Lakota', true),
    ]);
    // Bouaflé
    addLocalities('ci-bouafle', 'ci-marahoue', [
      ('bouafle', 'Bouaflé', true),
      ('sinfra', 'Sinfra', false),
      ('zuenoula', 'Zuénoula', false),
    ]);
    // Sinfra
    addLocalities('ci-sinfra', 'ci-marahoue', [
      ('sinfra-dept', 'Sinfra', true),
    ]);
    // Zuénoula
    addLocalities('ci-zuenoula', 'ci-marahoue', [
      ('zuenoula-dept', 'Zuénoula', true),
    ]);
    // Arrah
    addLocalities('ci-arrah', 'ci-moronou', [
      ('arrah', 'Arrah', true),
    ]);
    // Bongouanou
    addLocalities('ci-bongouanou', 'ci-moronou', [
      ('bongouanou', 'Bongouanou', true),
      ('mbatto', 'M\'Batto', false),
    ]);
    // M'Batto
    addLocalities('ci-m-batto', 'ci-moronou', [
      ('mbatto-dept', 'M\'Batto', true),
    ]);
    // Bocanda
    addLocalities('ci-bocanda', 'ci-nzi', [
      ('bocanda', 'Bocanda', true),
    ]);
    // Dimbokro
    addLocalities('ci-dimbokro', 'ci-nzi', [
      ('dimbokro', 'Dimbokro', true),
      ('bocanda-ville', 'Bocanda', false),
    ]);
    // Kouassi-Kouassikro
    addLocalities('ci-kouassi-kouassikro', 'ci-nzi', [
      ('kouassi-kouassikro', 'Kouassi-Kouassikro', true),
    ]);
    // Buyo
    addLocalities('ci-buyo', 'ci-nawa', [
      ('buyo', 'Buyo', true),
    ]);
    // Guéyo
    addLocalities('ci-gueyo', 'ci-nawa', [
      ('gueyo', 'Guéyo', true),
    ]);
    // Méagui
    addLocalities('ci-meagui', 'ci-nawa', [
      ('meagui', 'Méagui', true),
    ]);
    // Soubré
    addLocalities('ci-soubre', 'ci-nawa', [
      ('soubre', 'Soubré', true),
      ('buyo-nawa', 'Buyo', false),
    ]);
    // Dikodougou
    addLocalities('ci-dikodougou', 'ci-poro', [
      ('dikodougou', 'Dikodougou', true),
    ]);
    // Korhogo
    addLocalities('ci-korhogo', 'ci-poro', [
      ('korhogo', 'Korhogo', true),
      ('sinematiali', 'Sinématiali', false),
      ('mbengue', 'M\'Bengué', false),
    ]);
    // M'Bengué
    addLocalities('ci-m-bengue', 'ci-poro', [
      ('mbengue-dept', 'M\'Bengué', true),
    ]);
    // Sinématiali
    addLocalities('ci-sinematiali', 'ci-poro', [
      ('sinematiali-dept', 'Sinématiali', true),
    ]);
    // San-Pédro
    addLocalities('ci-san-pedro', 'ci-san-pedro', [
      ('san-pedro', 'San-Pédro', true),
      ('sassandra-ville', 'Sassandra', false),
    ]);
    // Tabou
    addLocalities('ci-tabou', 'ci-san-pedro', [
      ('tabou', 'Tabou', true),
    ]);
    // Aboisso
    addLocalities('ci-aboisso', 'ci-sud-comoe', [
      ('aboisso', 'Aboisso', true),
      ('adiake', 'Adiaké', false),
    ]);
    // Adiaké
    addLocalities('ci-adiake', 'ci-sud-comoe', [
      ('adiake-dept', 'Adiaké', true),
    ]);
    // Grand-Bassam
    addLocalities('ci-grand-bassam', 'ci-sud-comoe', [
      ('grand-bassam', 'Grand-Bassam', true),
      ('bonoua', 'Bonoua', false),
    ]);
    // Tiapoum
    addLocalities('ci-tiapoum', 'ci-sud-comoe', [
      ('tiapoum', 'Tiapoum', true),
    ]);
    // Ferkessédougou
    addLocalities('ci-ferkessedougou', 'ci-tchologo', [
      ('ferkessedougou', 'Ferkessédougou', true),
      ('kong', 'Kong', false),
    ]);
    // Kong
    addLocalities('ci-kong', 'ci-tchologo', [
      ('kong-dept', 'Kong', true),
    ]);
    // Ouangolodougou
    addLocalities('ci-ouangolodougou', 'ci-tchologo', [
      ('ouangolodougou', 'Ouangolodougou', true),
    ]);
    // Biankouma
    addLocalities('ci-biankouma', 'ci-tonkpi', [
      ('biankouma', 'Biankouma', true),
    ]);
    // Danané
    addLocalities('ci-danane', 'ci-tonkpi', [
      ('danane', 'Danané', true),
    ]);
    // Man
    addLocalities('ci-man', 'ci-tonkpi', [
      ('man', 'Man', true),
      ('danane-ville', 'Danané', false),
      ('biankouma-ville', 'Biankouma', false),
      ('sipilou', 'Sipilou', false),
    ]);
    // Sipilou
    addLocalities('ci-sipilou', 'ci-tonkpi', [
      ('sipilou-dept', 'Sipilou', true),
    ]);
    // Zouan-Hounien
    addLocalities('ci-zouan-hounien', 'ci-tonkpi', [
      ('zouan-hounien', 'Zouan-Hounien', true),
    ]);
    // Kani
    addLocalities('ci-kani', 'ci-worodougou', [
      ('kani', 'Kani', true),
    ]);
    // Séguéla
    addLocalities('ci-seguela', 'ci-worodougou', [
      ('seguela', 'Séguéla', true),
      ('mankono-ville', 'Mankono', false),
      ('kani-ville', 'Kani', false),
    ]);
    // Agboville
    addLocalities('ci-agboville', 'ci-agneby-tiassa', [
      ('agboville', 'Agboville', true),
      ('tiassale', 'Tiassalé', false),
      ('sikensi', 'Sikensi', false),
    ]);
    // Sikensi
    addLocalities('ci-sikensi', 'ci-agneby-tiassa', [
      ('sikensi-dept', 'Sikensi', true),
    ]);
    // Taabo
    addLocalities('ci-taabo', 'ci-agneby-tiassa', [
      ('taabo', 'Taabo', true),
    ]);
    // Tiassalé
    addLocalities('ci-tiassale', 'ci-agneby-tiassa', [
      ('tiassale-dept', 'Tiassalé', true),
    ]);

    return list;
  }
}
