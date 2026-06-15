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
      countryCode: MarketCountries.burkinaFaso,
      names: _n(fr, en: en, ar: ar),
    );

MarketDistrict _d(String id, String regionId, String fr, {String? en, String? ar}) =>
    MarketDistrict(
      id: id,
      regionId: regionId,
      countryCode: MarketCountries.burkinaFaso,
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
      countryCode: MarketCountries.burkinaFaso,
      names: _n(fr, en: en, ar: ar),
      isCapital: capital,
    );

/// Burkina Faso: 13 régions, 45 provinces, 351 communes.
abstract final class GeographyBurkinaFaso {
  static final regions = <MarketRegion>[
    _r('bf-boucle-du-mouhoun', 'Boucle du Mouhoun'),
    _r('bf-cascades', 'Cascades'),
    _r('bf-centre', 'Centre'),
    _r('bf-centre-est', 'Centre-Est'),
    _r('bf-centre-nord', 'Centre-Nord'),
    _r('bf-centre-ouest', 'Centre-Ouest'),
    _r('bf-centre-sud', 'Centre-Sud'),
    _r('bf-est', 'Est'),
    _r('bf-hauts-bassins', 'Hauts-Bassins'),
    _r('bf-nord', 'Nord'),
    _r('bf-plateau-central', 'Plateau-Central'),
    _r('bf-sahel', 'Sahel'),
    _r('bf-sud-ouest', 'Sud-Ouest'),
  ];

  static final districts = <MarketDistrict>[
  // Boucle du Mouhoun
  _d('bf-bale', 'bf-boucle-du-mouhoun', 'Balé'),
  _d('bf-banwa', 'bf-boucle-du-mouhoun', 'Banwa'),
  _d('bf-kossi', 'bf-boucle-du-mouhoun', 'Kossi'),
  _d('bf-mouhoun', 'bf-boucle-du-mouhoun', 'Mouhoun'),
  _d('bf-nayala', 'bf-boucle-du-mouhoun', 'Nayala'),
  _d('bf-sourou', 'bf-boucle-du-mouhoun', 'Sourou'),
  // Cascades
  _d('bf-comoe', 'bf-cascades', 'Comoé'),
  _d('bf-leraba', 'bf-cascades', 'Léraba'),
  // Centre
  _d('bf-kadiogo', 'bf-centre', 'Kadiogo'),
  // Centre-Est
  _d('bf-boulgou', 'bf-centre-est', 'Boulgou'),
  _d('bf-koulpelogo', 'bf-centre-est', 'Koulpélogo'),
  _d('bf-kouritenga', 'bf-centre-est', 'Kouritenga'),
  // Centre-Nord
  _d('bf-bam', 'bf-centre-nord', 'Bam'),
  _d('bf-namentenga', 'bf-centre-nord', 'Namentenga'),
  _d('bf-sanmatenga', 'bf-centre-nord', 'Sanmatenga'),
  // Centre-Ouest
  _d('bf-boulkiemde', 'bf-centre-ouest', 'Boulkiemdé'),
  _d('bf-sanguié', 'bf-centre-ouest', 'Sanguié'),
  _d('bf-sissili', 'bf-centre-ouest', 'Sissili'),
  _d('bf-ziro', 'bf-centre-ouest', 'Ziro'),
  // Centre-Sud
  _d('bf-bazega', 'bf-centre-sud', 'Bazèga'),
  _d('bf-nahouri', 'bf-centre-sud', 'Nahouri'),
  _d('bf-zoundweogo', 'bf-centre-sud', 'Zoundwéogo'),
  // Est
  _d('bf-gnagna', 'bf-est', 'Gnagna'),
  _d('bf-gourma', 'bf-est', 'Gourma'),
  _d('bf-komondjari', 'bf-est', 'Komondjari'),
  _d('bf-kompienga', 'bf-est', 'Kompienga'),
  _d('bf-tapoa', 'bf-est', 'Tapoa'),
  // Hauts-Bassins
  _d('bf-houet', 'bf-hauts-bassins', 'Houet'),
  _d('bf-kenedougou', 'bf-hauts-bassins', 'Kénédougou'),
  _d('bf-tuy', 'bf-hauts-bassins', 'Tuy'),
  // Nord
  _d('bf-loroum', 'bf-nord', 'Loroum'),
  _d('bf-pasore', 'bf-nord', 'Passoré'),
  _d('bf-yatenga', 'bf-nord', 'Yatenga'),
  _d('bf-zondoma', 'bf-nord', 'Zondoma'),
  // Plateau-Central
  _d('bf-ganzourgou', 'bf-plateau-central', 'Ganzourgou'),
  _d('bf-kourweogo', 'bf-plateau-central', 'Kourwéogo'),
  _d('bf-oubritenga', 'bf-plateau-central', 'Oubritenga'),
  // Sahel
  _d('bf-oudalan', 'bf-sahel', 'Oudalan'),
  _d('bf-seno', 'bf-sahel', 'Séno'),
  _d('bf-soum', 'bf-sahel', 'Soum'),
  _d('bf-yagha', 'bf-sahel', 'Yagha'),
  // Sud-Ouest
  _d('bf-bougouriba', 'bf-sud-ouest', 'Bougouriba'),
  _d('bf-ioba', 'bf-sud-ouest', 'Ioba'),
  _d('bf-noumbiel', 'bf-sud-ouest', 'Noumbiel'),
  _d('bf-poni', 'bf-sud-ouest', 'Poni'),
  ];

  static List<MarketLocality> get localities => _buildLocalities();

  static List<MarketLocality> _buildLocalities() {
    final list = <MarketLocality>[];
    void addCommunes(String districtId, String regionId, List<(String id, String name, bool cap)> items) {
      for (final (id, name, cap) in items) {
        list.add(_l('bf-$id', districtId, regionId, name, capital: cap));
      }
    }

    // Balé (6 communes)
    addCommunes('bf-bale', 'bf-boucle-du-mouhoun', [
      ('boromo', 'Boromo', true),
      ('bagassi', 'Bagassi', false),
      ('ouarkoye', 'Ouarkoye', false),
      ('pompoi', 'Pompoi', false),
      ('poura', 'Poura', false),
      ('siby', 'Siby', false),
    ]);
    // Banwa (6)
    addCommunes('bf-banwa', 'bf-boucle-du-mouhoun', [
      ('solenzo', 'Solenzo', true),
      ('balave', 'Balavé', false),
      ('kouka', 'Kouka', false),
      ('samandeni', 'Samandéni', false),
      ('santidougou', 'Santidougou', false),
      ('tansila', 'Tansila', false),
    ]);
    // Kossi (8)
    addCommunes('bf-kossi', 'bf-boucle-du-mouhoun', [
      ('nouna', 'Nouna', true),
      ('barani', 'Barani', false),
      ('bomborokuy', 'Bomborokuy', false),
      ('djibasso', 'Djibasso', false),
      ('dokuy', 'Dokuy', false),
      ('doumbala', 'Doumbala', false),
      ('kombori', 'Kombori', false),
      ('madouba', 'Madouba', false),
    ]);
    // Mouhoun (9)
    addCommunes('bf-mouhoun', 'bf-boucle-du-mouhoun', [
      ('dedougou', 'Dédougou', true),
      ('bondokuy', 'Bondokuy', false),
      ('dedougou-rural', 'Dédougou (rural)', false),
      ('douroula', 'Douroula', false),
      ('kona', 'Kona', false),
      ('ourikouma', 'Ourikouma', false),
      ('safane', 'Safané', false),
      ('tchériba', 'Tchériba', false),
      ('yaba', 'Yaba', false),
    ]);
    // Nayala (6)
    addCommunes('bf-nayala', 'bf-boucle-du-mouhoun', [
      ('toma', 'Toma', true),
      ('gassan', 'Gassan', false),
      ('gossina', 'Gossina', false),
      ('kougny', 'Kougny', false),
      ('yé', 'Yé', false),
      ('zam', 'Zam', false),
    ]);
    // Sourou (11)
    addCommunes('bf-sourou', 'bf-boucle-du-mouhoun', [
      ('tougan', 'Tougan', true),
      ('gouran', 'Gouran', false),
      ('kassoum', 'Kassoum', false),
      ('kiembara', 'Kiembara', false),
      ('lanfiera', 'Lanfiéra', false),
      ('lankoue', 'Lankoué', false),
      ('toeni', 'Toéni', false),
      ('tougan-rural', 'Tougan (rural)', false),
      ('gossina-sourou', 'Gossina', false),
      ('solenzo-sourou', 'Solenzo', false),
      ('yaba-sourou', 'Yaba', false),
    ]);
    // Comoé (9)
    addCommunes('bf-comoe', 'bf-cascades', [
      ('banfora', 'Banfora', true),
      ('mangodara', 'Mangodara', false),
      ('niangoloko', 'Niangoloko', false),
      ('olerie', 'Olérié', false),
      ('sindou-comoe', 'Sindou', false),
      ('soubakaniédougou', 'Soubakaniédougou', false),
      ('tiefora', 'Tiéfora', false),
      ('wolokonto', 'Wolokonto', false),
      ('banfora-rural', 'Banfora (rural)', false),
    ]);
    // Léraba (7)
    addCommunes('bf-leraba', 'bf-cascades', [
      ('sindou', 'Sindou', true),
      ('dakoro', 'Dakoro', false),
      ('douna', 'Douna', false),
      ('kankalaba', 'Kankalaba', false),
      ('loumana', 'Loumana', false),
      ('niankorodougou', 'Niankorodougou', false),
      ('oulekela', 'Oulékélédougou', false),
    ]);
    // Kadiogo (5)
    addCommunes('bf-kadiogo', 'bf-centre', [
      ('ouagadougou', 'Ouagadougou', true,),
      ('koubri', 'Koubri', false),
      ('pabre', 'Pabré', false),
      ('saaba', 'Saaba', false),
      ('tanghin-dassouri', 'Tanghin-Dassouri', false),
    ]);
    // Boulgou (13)
    addCommunes('bf-boulgou', 'bf-centre-est', [
      ('tenkodogo', 'Tenkodogo', true),
      ('bagre', 'Bagré', false),
      ('bané', 'Bané', false),
      ('béguédo', 'Béguédo', false),
      ('bissiga', 'Bissiga', false),
      ('bittou', 'Bittou', false),
      ('garango', 'Garango', false),
      ('komtoega', 'Komtoèga', false),
      ('koupéla', 'Koupéla', false),
      ('niaogho', 'Niaogho', false),
      ('ouargaye', 'Ouargaye', false),
      ('sabou', 'Sabou', false),
      ('yargatenga', 'Yargatenga', false),
    ]);
    // Koulpélogo (8)
    addCommunes('bf-koulpelogo', 'bf-centre-est', [
      ('ouargaye-kpl', 'Ouargaye', true),
      ('comin-yanga', 'Comin-Yanga', false),
      ('dourtenga', 'Dourtenga', false),
      ('lalgaye', 'Lalgaye', false),
      ('ouargaye-rural', 'Ouargaye (rural)', false),
      ('sangha', 'Sangha', false),
      ('soudougui', 'Soudougui', false),
      ('yondé', 'Yondé', false),
    ]);
    // Kouritenga (13)
    addCommunes('bf-kouritenga', 'bf-centre-est', [
      ('koupele', 'Koupéla', true),
      ('andemtenga', 'Andemtenga', false),
      ('baskuy', 'Baskuy', false),
      ('boussouma', 'Boussouma', false),
      ('dialgaye', 'Dialgaye', false),
      ('gounghin', 'Gounghin', false),
      ('kando', 'Kando', false),
      ('kougri', 'Kougri', false),
      ('pouytenga', 'Pouytenga', false),
      ('sanga', 'Sanga', false),
      ('yargo', 'Yargo', false),
      ('zabré', 'Zabré', false),
      ('zonsé', 'Zonsé', false),
    ]);
    // Bam (12)
    addCommunes('bf-bam', 'bf-centre-nord', [
      ('kongoussi', 'Kongoussi', true),
      ('boursa', 'Boursa', false),
      ('dablo', 'Dablo', false),
      ('guibaré', 'Guibaré', false),
      ('konga', 'Konga', false),
      ('nasséré', 'Nasséré', false),
      ('ourgaye', 'Ourgaye', false),
      ('rouko', 'Rouko', false),
      ('sabcé', 'Sabcé', false),
      ('tikaré', 'Tikaré', false),
      ('zimtanga', 'Zimtanga', false),
      ('zorkoum', 'Zorkoum', false),
    ]);
    // Namentenga (12)
    addCommunes('bf-namentenga', 'bf-centre-nord', [
      ('boulsa', 'Boulsa', true),
      ('boala', 'Boala', false),
      ('boulsa-rural', 'Boulsa (rural)', false),
      ('dargo', 'Dargo', false),
      ('mané', 'Mané', false),
      ('namissiguima', 'Namissiguima', false),
      ('pensa', 'Pensa', false),
      ('pibaoré', 'Pibaoré', false),
      ('tillabéri', 'Tillabéri', false),
      ('yalgo', 'Yalgo', false),
      ('zéguédéguin', 'Zéguédéguin', false),
      ('ziga', 'Ziga', false),
    ]);
    // Sanmatenga (13)
    addCommunes('bf-sanmatenga', 'bf-centre-nord', [
      ('kaya', 'Kaya', true),
      ('barsalogho', 'Barsalogho', false),
      ('boulsa-sanmat', 'Boulsa', false),
      ('dablo-sanmat', 'Dablo', false),
      ('imasgo', 'Imasgo', false),
      ('korsimoro', 'Korsimoro', false),
      ('mané-sanmat', 'Mané', false),
      ('namissiguima-sanmat', 'Namissiguima', false),
      ('pensa-sanmat', 'Pensa', false),
      ('pissila', 'Pissila', false),
      ('tougouri', 'Tougouri', false),
      ('ziga-sanmat', 'Ziga', false),
      ('zorkoum-sanmat', 'Zorkoum', false),
    ]);
    // Boulkiemdé (9)
    addCommunes('bf-boulkiemde', 'bf-centre-ouest', [
      ('koudougou', 'Koudougou', true),
      ('bingo', 'Bingo', false),
      ('imasgho', 'Imasgho', false),
      ('kindi', 'Kindi', false),
      ('kokologho', 'Kokologho', false),
      ('nanoro', 'Nanoro', false),
      ('pella', 'Pella', false),
      ('ramongo', 'Ramongo', false),
      ('sabou-boulk', 'Sabou', false),
    ]);
    // Sanguié (11)
    addCommunes('bf-sanguié', 'bf-centre-ouest', [
      ('reo', 'Réo', true),
      ('didyr', 'Didyr', false),
      ('dassa', 'Dassa', false),
      ('godyr', 'Godyr', false),
      ('kordié', 'Kordié', false),
      ('kyon', 'Kyon', false),
      ('pouni', 'Pouni', false),
      ('réo-rural', 'Réo (rural)', false),
      ('tenado', 'Tenado', false),
      ('zamo', 'Zamo', false),
      ('zawara', 'Zawara', false),
    ]);
    // Sissili (7)
    addCommunes('bf-sissili', 'bf-centre-ouest', [
      ('leo', 'Léo', true),
      ('biéha', 'Biéha', false),
      ('boura', 'Boura', false),
      ('gono', 'Gono', false),
      ('kayao', 'Kayao', false),
      ('léo-rural', 'Léo (rural)', false),
      ('to', 'To', false),
    ]);
    // Ziro (8)
    addCommunes('bf-ziro', 'bf-centre-ouest', [
      ('sapouy', 'Sapouy', true),
      ('bakata', 'Bakata', false),
      ('cassou', 'Cassou', false),
      ('dalo', 'Dalo', false),
      ('gounghin-ziro', 'Gounghin', false),
      ('léo-ziro', 'Léo', false),
      ('sapouy-rural', 'Sapouy (rural)', false),
      ('to-ziro', 'To', false),
    ]);
    // Bazèga (7)
    addCommunes('bf-bazega', 'bf-centre-sud', [
      ('kombissiri', 'Kombissiri', true),
      ('doulougou', 'Doulougou', false),
      ('gaongo', 'Gaongo', false),
      ('ipelcé', 'Ipelcé', false),
      ('kombissiri-rural', 'Kombissiri (rural)', false),
      ('saponé', 'Saponé', false),
      ('toecé', 'Toécé', false),
    ]);
    // Nahouri (5)
    addCommunes('bf-nahouri', 'bf-centre-sud', [
      ('po', 'Pô', true),
      ('guiaro', 'Guiaro', false),
      ('po-rural', 'Pô (rural)', false),
      ('tiébélé', 'Tiébélé', false),
      ('zoundweogo-nahouri', 'Zoundwéogo', false),
    ]);
    // Zoundwéogo (8)
    addCommunes('bf-zoundweogo', 'bf-centre-sud', [
      ('manga', 'Manga', true),
      ('béré', 'Béré', false),
      ('bindé', 'Bindé', false),
      ('gogo', 'Gogo', false),
      ('guiba', 'Guiba', false),
      ('manga-rural', 'Manga (rural)', false),
      ('nobéré', 'Nobéré', false),
      ('saponé-zound', 'Saponé', false),
    ]);
    // Gnagna (8)
    addCommunes('bf-gnagna', 'bf-est', [
      ('bogande', 'Bogandé', true),
      ('bilanga', 'Bilanga', false),
      ('coalla', 'Coalla', false),
      ('liptougou', 'Liptougou', false),
      ('manni', 'Manni', false),
      ('piéla', 'Piéla', false),
      ('thion', 'Thion', false),
      ('yamba', 'Yamba', false),
    ]);
    // Gourma (12)
    addCommunes('bf-gourma', 'bf-est', [
      ('fada-ngourma', "Fada N'gourma", true),
      ('diabo', 'Diabo', false),
      ('diapaga', 'Diapaga', false),
      ('foutouri', 'Foutouri', false),
      ('gayéri', 'Gayéri', false),
      ('logobou', 'Logobou', false),
      ('matiacoali', 'Matiacoali', false),
      ('nadiagou', 'Nadiagou', false),
      ('pama', 'Pama', false),
      ('tibga', 'Tibga', false),
      ('yamba-gourma', 'Yamba', false),
      ('zorkoum-gourma', 'Zorkoum', false),
    ]);
    // Komondjari (4)
    addCommunes('bf-komondjari', 'bf-est', [
      ('gayeri', 'Gayéri', true),
      ('bartiebougou', 'Bartiébougou', false),
      ('foutouri-kom', 'Foutouri', false),
      ('piéla-kom', 'Piéla', false),
    ]);
    // Kompienga (5)
    addCommunes('bf-kompienga', 'bf-est', [
      ('pama-kom', 'Pama', true),
      ('kompienga', 'Kompienga', false),
      ('madjoari', 'Madjoari', false),
      ('moyen-chari', 'Moyen-Chari', false),
      ('kompienga-rural', 'Kompienga (rural)', false),
    ]);
    // Tapoa (8)
    addCommunes('bf-tapoa', 'bf-est', [
      ('diapaga-tap', 'Diapaga', true),
      ('botou', 'Botou', false),
      ('diapaga-rural', 'Diapaga (rural)', false),
      ('kantchari', 'Kantchari', false),
      ('logobou-tap', 'Logobou', false),
      ('partiaga', 'Partiaga', false),
      ('tansarga', 'Tansarga', false),
      ('tansarga-rural', 'Tansarga (rural)', false),
    ]);
    // Houet (15)
    addCommunes('bf-houet', 'bf-hauts-bassins', [
      ('bobo-dioulasso', 'Bobo-Dioulasso', true),
      ('bama', 'Bama', false),
      ('dande', 'Dandé', false),
      ('faramana', 'Faramana', false),
      ('fo', 'Fô', false),
      ('karangasso-vigue', 'Karangasso-Vigué', false),
      ('kourouma', "N'dorola", false),
      ('lena', 'Léna', false),
      ('padema', 'Padéma', false),
      ('peni', 'Péni', false),
      ('satiri', 'Satiri', false),
      ('toussiana', 'Toussiana', false),
      ('bama-rural', 'Bama (rural)', false),
      ('fo-rural', 'Fô (rural)', false),
      ('kourouma-rural', 'Kourouma', false),
    ]);
    // Kénédougou (10)
    addCommunes('bf-kenedougou', 'bf-hauts-bassins', [
      ('orodara', 'Orodara', true),
      ('djigouéra', 'Djigouéra', false),
      ('kangala', 'Kangala', false),
      ('kourinion', 'Kourinion', false),
      ('kourouma-ken', 'Kourouma', false),
      ('morolaba', 'Morolaba', false),
      ('ndorola', "N'dorola", false),
      ('orodara-rural', 'Orodara (rural)', false),
      ('samogohiri', 'Samogohiri', false),
      ('samorogouan', 'Samorogouan', false),
    ]);
    // Tuy (9)
    addCommunes('bf-tuy', 'bf-hauts-bassins', [
      ('hounde', 'Houndé', true),
      ('bereba', 'Béréba', false),
      ('békuy', 'Békuy', false),
      ('founzan', 'Founzan', false),
      ('hounet', 'Hounet', false),
      ('koti', 'Koti', false),
      ('kpuéré', 'Kpuéré', false),
      ('léguéma', 'Léguéma', false),
      ('sono', 'Sono', false),
    ]);
    // Loroum (5)
    addCommunes('bf-loroum', 'bf-nord', [
      ('titao', 'Titao', true),
      ('banh', 'Banh', false),
      ('kalsaka', 'Kalsaka', false),
      ('sollé', 'Sollé', false),
      ('titao-rural', 'Titao (rural)', false),
    ]);
    // Passoré (9)
    addCommunes('bf-pasore', 'bf-nord', [
      ('yako', 'Yako', true),
      ('arbollé', 'Arbollé', false),
      ('bokin', 'Bokin', false),
      ('gourcy', 'Gourcy', false),
      ('kirsi', 'Kirsi', false),
      ('lâ-toden', 'Lâ-Toden', false),
      ('niou', 'Niou', false),
      ('pilimpikou', 'Pilimpikou', false),
      ('thio', 'Thio', false),
    ]);
    // Yatenga (14)
    addCommunes('bf-yatenga', 'bf-nord', [
      ('ouahigouya', 'Ouahigouya', true),
      ('barga', 'Barga', false),
      ('kain', 'Kain', false),
      ('kalsaka-yat', 'Kalsaka', false),
      ('kossouka', 'Kossouka', false),
      ('koumbri', 'Koumbri', false),
      ('namissiguima-yat', 'Namissiguima', false),
      ('ouahigouya-rural', 'Ouahigouya (rural)', false),
      ('rambo', 'Rambo', false),
      ('séguénéga', 'Séguénéga', false),
      ('thion-yat', 'Thion', false),
      ('zogoré', 'Zogoré', false),
      ('zogoré-rural', 'Zogoré (rural)', false),
      ('zorkoum-yat', 'Zorkoum', false),
    ]);
    // Zondoma (7)
    addCommunes('bf-zondoma', 'bf-nord', [
      ('gourcy-zond', 'Gourcy', true),
      ('bassi', 'Bassi', false),
      ('bokin-zond', 'Bokin', false),
      ('gourcy-rural', 'Gourcy (rural)', false),
      ('léba', 'Léba', false),
      ('toéni-zond', 'Toéni', false),
      ('zogoré-zond', 'Zogoré', false),
    ]);
    // Ganzourgou (8)
    addCommunes('bf-ganzourgou', 'bf-plateau-central', [
      ('zorgho', 'Zorgho', true),
      ('boudry', 'Boudry', false),
      ('kogho', 'Kogho', false),
      ('meguet', 'Méguet', false),
      ('mogtédo', 'Mogtédo', false),
      ('salogo', 'Salogo', false),
      ('zam-zorgho', 'Zam', false),
      ('zorgho-rural', 'Zorgho (rural)', false),
    ]);
    // Kourwéogo (6)
    addCommunes('bf-kourweogo', 'bf-plateau-central', [
      ('bousse', 'Boussé', true),
      ('lallé', 'Lallé', false),
      ('niou-kour', 'Niou', false),
      ('ourgou-manega', 'Ourgou-Manega', false),
      ('sourgou', 'Sourgou', false),
      ('toécé-kour', 'Toécé', false),
    ]);
    // Oubritenga (9)
    addCommunes('bf-oubritenga', 'bf-plateau-central', [
      ('ziniare', 'Ziniaré', true),
      ('absouya', 'Absouya', false),
      ('dapelogo', 'Dapélogo', false),
      ('loumbila', 'Loumbila', false),
      ('nagréongo', 'Nagréongo', false),
      ('ourgou-manega-oub', 'Ourgou-Manega', false),
      ('ziniare-rural', 'Ziniaré (rural)', false),
      ('zitenga', 'Zitenga', false),
      ('zoungou', 'Zoungou', false),
    ]);
    // Oudalan (5)
    addCommunes('bf-oudalan', 'bf-sahel', [
      ('gorom-gorom', 'Gorom-Gorom', true),
      ('déou', 'Déou', false),
      ('markoye', 'Markoye', false),
      ('oualata', 'Oualata', false),
      ('tin-akoff', 'Tin-Akoff', false),
    ]);
    // Séno (7)
    addCommunes('bf-seno', 'bf-sahel', [
      ('dori', 'Dori', true),
      ('arbinda', 'Arbinda', false),
      ('bani', 'Bani', false),
      ('dori-rural', 'Dori (rural)', false),
      ('falagountou', 'Falagountou', false),
      ('gorgadji', 'Gorgadji', false),
      ('sampelga', 'Sampelga', false),
    ]);
    // Soum (8)
    addCommunes('bf-soum', 'bf-sahel', [
      ('djibo', 'Djibo', true),
      ('aribinda-soum', 'Aribinda', false),
      ('baraboulé', 'Baraboulé', false),
      ('djibo-rural', 'Djibo (rural)', false),
      ('kelbo', 'Kelbo', false),
      ('koutougou', 'Koutougou', false),
      ('nassoumbou', 'Nassoumbou', false),
      ('tongomayel', 'Tongomayel', false),
    ]);
    // Yagha (6)
    addCommunes('bf-yagha', 'bf-sahel', [
      ('sebba', 'Sebba', true),
      ('boundoré', 'Boundoré', false),
      ('mansila', 'Mansila', false),
      ('sebba-rural', 'Sebba (rural)', false),
      ('solhan', 'Solhan', false),
      ('titabé', 'Titabé', false),
    ]);
    // Bougouriba (5)
    addCommunes('bf-bougouriba', 'bf-sud-ouest', [
      ('diebougou', 'Diébougou', true),
      ('bondigui', 'Bondigui', false),
      ('diebougou-rural', 'Diébougou (rural)', false),
      ('ioba-boug', 'Ioba', false),
      ('noumbiel-boug', 'Noumbiel', false),
    ]);
    // Ioba (5)
    addCommunes('bf-ioba', 'bf-sud-ouest', [
      ('dano', 'Dano', true),
      ('batié', 'Batié', false),
      ('dano-rural', 'Dano (rural)', false),
      ('dissin', 'Dissin', false),
      ('oronkua', 'Oronkua', false),
    ]);
    // Noumbiel (5)
    addCommunes('bf-noumbiel', 'bf-sud-ouest', [
      ('batié-noum', 'Batié', true),
      ('batié-rural', 'Batié (rural)', false),
      ('kpuéré-noum', 'Kpuéré', false),
      ('midebdo', 'Midebdo', false),
      ('perigban', 'Périgban', false),
    ]);
    // Poni (9)
    addCommunes('bf-poni', 'bf-sud-ouest', [
      ('gaoua', 'Gaoua', true),
      ('batié-poni', 'Batié', false),
      ('boukombé', 'Boukombé', false),
      ('gaoua-rural', 'Gaoua (rural)', false),
      ('kampti', 'Kampti', false),
      ('loropéni', 'Loropéni', false),
      ('malba', 'Malba', false),
      ('nako', 'Nako', false),
      ('perigban-poni', 'Périgban', false),
    ]);

    return list;
  }
}
