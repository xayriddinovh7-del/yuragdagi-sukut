class BackendChapter {
  final int index;
  final String id;
  final String title;
  final String content;
  final String? quoteHighlight;

  const BackendChapter({
    required this.index,
    required this.id,
    required this.title,
    required this.content,
    this.quoteHighlight,
  });

  Map<String, dynamic> toJson() => {
        'index': index,
        'id': id,
        'title': title,
        'content': content,
        if (quoteHighlight != null) 'quoteHighlight': quoteHighlight,
        'wordCount': content.split(RegExp(r'\s+')).length,
        'estimatedReadMinutes': (content.split(RegExp(r'\s+')).length / 200).ceil(),
      };
}

class BookContent {
  static const String title = "Yuragdagi Sukut";
  static const String author = "Noma'lum muallif";
  static const String description =
      "Ba'zan insonning eng baland qichqirig'i bu uning sukuti bo'larkan...";

  static final List<BackendChapter> chapters = [
    const BackendChapter(
      index: 0,
      id: '0',
      title: 'Kirish',
      content: '''Ba\'zan insonning eng baland qichqirig\'i bu uning sukuti bo\'larkan. Uni hech kim eshitmaydi. Tunlari ko\'z yosh bilan uxlab, tongda xuddi-ki hech nma bo\'lmagandek kulib yashashda davom etarkansan.

Men ham xuddi shunday yashadim. Tunlari qalbim ming parcha lekin tongda "hammasi yaxshi" degan soxta tabassum ortiga berkingan jajji qizaloq kabi.

Hayot meni ko\'p sinadi. Insonlarga ishonmaslik, ortga nazar tashlamaslik, olg\'a qadam bosish, ketgan narsaga achinmaslik va keladiganlarini sabr va shukr bilan qabul qilish.

Ishongan insonlarim ishonchimni sindirdi, orzularim so\'ndi, yuragim parchalandi va sukut ortiga berkindi. Ammo shu sukut ichida qanchadan-qancha aytolmagan gaplarim, orzularim bor edi.

Hayot menga kuchli bo\'lishni o\'rgatdi. Chunki shunday yaralar bor ular hech qachon bitmaydi aksincha, bizni kuchli va sabrli qiladi.

Ba\'zida ichingdagi dardlaringni hech kimga ayta olmaydigan so\'zlaringni kimgadir aytging keladi lekin aytolmaysan. Aytishga odam topolmaysan. Topgan vaqtingda esa seni tushunishmaydi yoki tushunishni hohlashmaydi. Shunda yurak asta sekin sukutga cho\'kadi.

Men ham bir vaqtlar orzu qilardim mehr to\'la qalblarni, meni tushunadigan insonlarni, samimiy munosabatlarni, meni tashlab ketmaydigan insonlarni.

Lekin hayot biz xohlagan narsalarni emas ularning aksini tayyorlab qo\'yarkan va shu orqali bizni sinarkan. Ko\'nglimga yaqin olganlarim meni birinchi bo\'lib tark etdi, orzularim so\'ndi, odamlardan uzoqlashdim. Xuddi qalbi o\'lgan insondek yashashda davom etdim.

"Yurakdagi Sukunat" — bu shunchaki kitob emas. Aytilmagan hislar, soxta tabassum ortiga berkingan ko\'z yoshlar va sinmagan qalbning sadosi. Balki bu satrlarda siz ham o\'zingizni ko\'rarsiz...''',
      quoteHighlight: "Ba'zan insonning eng baland qichqirig'i bu uning sukuti bo'larkan.",
    ),
    const BackendChapter(
      index: 1,
      id: '1',
      title: 'Sukut ortidagi ko\'zlar',
      content: '''Kech kuz edi.

Shahar osmonini quyuq bulut qoplagan, xiyobondagi daraxtlardan sarg\'aygan yaproqlar sekin yerga tushardi. Havo sovuq bo\'lsa ham odamlar odatdagidek shoshilib yashardi. Kimdir ishga ulgurishga harakat qiladi, kimdir uyiga qaytadi, yana kimdir shunchaki hayotdan qochib yuradi.

Bonu esa avtobus oynasidan tashqariga jimgina qarab ketardi.

Ba\'zan inson atrofidagi minglab odamlar orasida ham o\'zini yolg\'iz his qilarkan.

U ham aynan shunday edi.

Avtobus ichida past ovozda musiqa eshitilar, oynalarga esa yomg\'ir tomchilari mayda iz qoldirardi. Bonu boshini oynaga qo\'yib, asta xo\'rsinib qo\'ydi.

Ko\'zlari charchagan, madori qolmagan edi.

Faqat ishlar va uyqusizlikdan emas...

Yurakdagi og\'riqlardan.

Qo\'lidagi qora muqovali daftarni asta ochdi. Sahifalar orasidan eski bir surat tushib ketdi. U suratga tikulguncha bir lahza qotib qoldi.

Suratda u kulib turardi.

Yonida esa Ali.

Bonuning tabassumi o\'sha surat bilan birga o\'tmishda qolib ketgan edi.

U suratni asta daftar orasiga qaytarib soldi va deraza tomonga qarab oldi.

— Nega hammasi shunday tugadi?.. — dedi u ichida.

Avtobus navbatdagi bekatda to\'xtadi. Odamlar asta sekin chiqib tusha boshladi. Ammo Bonu uchun vaqt ikki yil oldin to\'xtab qolganday edi.

Ikki yil...

Aynan ikki yil oldin Bonuning hayoti o\'zgargan edi.

O\'sha kun hali ham yodida.

Universitet hovlisi odamlar bilan gavjum edi. Daraxtlar gullay boshlagan, atrof bahorning iliq hidiga to\'lgan edi. Bonu qo\'lida kitob bilan kutubxona tomonga ketayotganda ortidan bir ovoz eshitildi.

— Bonu!

U ortiga qaragandi.

Ali yugurib kelardi.

Har doimgidek kulib.

Har doimgidek shoshib.

— Yana kech qoldingmi? — degandi Bonu kulib.

— Seni ko\'rish uchun yugurdim.

Bonu o\'sha paytda baxt nma ekanligini tushungandek bo\'lgandi.

Baxt — oddiy insonning yonida o\'zingni xavfsiz his qilish ekan.

Ali uning yonida boshqacha edi. U bilan gaplashganda vaqt tez o\'tardi. U kulsa, Bonu ham kulardi. Hatto oddiy sukutlari ham yoqimli edi.

Ammo uning baxtli paytida taqdir nimanidir olib qo\'yishini bilmaydi.

— Bekat! Bekat!

Haydovchining ovozi Bonuni xayollaridan qaytardi.

U asta o\'rnidan turib avtobusdan tushdi. Yomg\'ir maydalab yog\'ardi. Sovuq shamol yuziga urilardi.

Bonu kurtkasining yoqasini ko\'tarib oldi.

Uyigacha piyoda yursa 10 daqiqalik yo\'l edi.

Ko\'cha chiroqlari ostida nam asfalt yaltirab turardi. Atrofdagi odamlarning shovqini unga uzoqdan eshitilgandek tuyulardi.

U yo\'lda ketayotib kichik qahvaxona oldida to\'xtadi.

Bu joyga avvallari Ali bilan birga kelishardi.

Bir stol, ikki piyola qahva va tugamaydigan yoqimli suhbat.

Bonu oynadan ichkariga qaradi. Ichkarida kulayotgan juftliklar o\'tirardi. Kimdir sevgan insonining qo\'lidan ushlab gaplashardi.

Bonu asta ko\'zlarini olib qochdi.

Chunki ayrim xotiralar yuragiga pichoqdek botardi.

U yo\'lida davom etdi.

Nihoyat eski ko\'p qavatli uy yoniga yetib keldi. Zinadan sekin ko\'tarildi. Eshikni ochib ichkariga kirishi bilan yana o\'sha jimlik uni qarshi oldi.

Bu uyda hech kim uni kutmasdi.

Hech kim "qalaysan, yaxshi keldingmi" — deb so\'ramasdi.

Bonu chiroqni yoqdi-da, sumkasini divanga tashladi.

Uy ichi sovuq edi.

U deraza yoniga borib tashqariga qaradi. Yomg\'ir kuchaygandi. Ko\'zlari yana stol ustidagi suratga tushdi.

Ali bilan tushgan surat.

Bonu asta uni qo\'liga oldi.

Alining kulishi juda samimiy edi.

— Sen nega ketding?.. — dedi u past ovozda.

Ko\'zlariga yosh to\'ldi.

Ammo yig\'lamasdi.

Chunki u ancha avval yig\'lashdan ham kulishdan ham charchagan edi.

Shu payt telefon titradi.

Notanish raqam.

Bonu biroz ikkilanib qo\'ng\'iroqqa javob berdi.

— Alo?

Bir necha soniya jimlik bo\'ldi.

So\'ng tanish ovoz eshitildi.

— Bonu...

Uning yuragi to\'xtab qolgudek bo\'ldi.

Bu ovozni u minglab ovoz ichidan ham tanib olardi.

Ali.

Bonuning qo\'llari titrab ketdi.

— Raqamimni qayerdan olding?..

Ali chuqur xo\'rsindi.

— Men sen bilan gaplashishim kerak.

Bonu darrov javob bermadi.

Ikki yil davomida kutgan insonining birdan qaytib kelishi... bu quvonchlimi yoki og\'riqli? Buni bilish qiyin.

— Gaplashadigan hech narsa qolmagan.

— Bor. — dedi Ali.

Bonu ko\'zlarini yumdi.

Yuragi yana o\'sha eski hislar bilan urayotgandi.

— Iltimos... bir marta uchrashaylik. — dedi Ali.

Bonu biroz jim turdi.

Ali davom etdi:

— Ertaga eski xiyobonda kutaman.

Va qo\'ng\'iroq tugadi.

Bonu uzoq vaqt telefoniga tikilib qoldi.

Yuragi ichida nimadir uyg\'omgandi.

Unutildi deb o\'ylagan hislar.

Og\'riqli xotiralar.

Va hali ham so\'nmagan sevgi...

Ertasi kun havo ochiq edi...''',
      quoteHighlight: "Ba'zan inson atrofidagi minglab odamlar orasida ham o'zini yolg'iz his qilarkan.",
    ),
    const BackendChapter(
      index: 2,
      id: '2',
      title: 'Ketgan izlar',
      content: '''Kuzning sovuq shamoli xiyobondagi daraxtlarni sekin tebratardi. Yerga to\'kilgan sariq yaproqlar oyoz ostida shitirlab ezilar, uzoqdan bolalarning ovozi eshitilib turardi.

Bonu xiyobon darvozasi oldida to\'xtab qoldi.

Yuragi juda tez urardi.

Ikki yil...

Ikki yil davomida kutmagan uchrashuv bugun sodir bo\'lishi kerak edi.

U asta atrofga qaradi.

Hammasi o\'zgargandi.

Faqat bitta narsa o\'zgarmagandi.

Bu joy Alini eslatardi.

Xiyobonning o\'ng tomonidagi eski favvora. Daraxt tagidagi yog\'och o\'rindiq. Bahor kunlari birga muzqaymoq yegan yo\'laklar...

Har bir joyda xotira bor edi.

Bonu chuqur nafas oldi.

Ammo ketishga ham oyoqlari yurmasdi.

Shu payt orqadan tanish ovoz eshitildi.

— Baribir kelding.

Bonu asta ortiga burildi.

Ali.

U qora palto kiygan, qo\'llarini cho\'ntagiga solib turardi.

Ko\'zlari esa odatdagidek jiddiy edi.

Bir lahza ikkalasi ham jim bo\'lib qolishdi.

Ba\'zan inson eng ko\'p sog\'ingan odamiga nima deyishni bilmay ham qoladi...

Bonu nigohini olib qochdi.

— Tezroq gapir. Ishim bor. — dedi Bonu.

Ali uning gapidagi sovuqlikni sezdi.

Ammo bunga haqli ekanligini ham bilardi.

— Qalaysan?

Bonu bilinar bilinmas kulgandek bo\'ldi.

— Ikki yil yo\'qolib ketib, endi holimni so\'rayabsanmi? — dedi Bonu.

Ali javob topolmadi.

Shamol Bonuning sochlarini yuziga urdi.

Ali beixtiyor qo\'lini uzatmoqchi bo\'ldi, ammo yana to\'xtadi.

Chunki ayrim yaqinliklar vaqt bilan begonalashib ketgandi.

— Men seni hafa qilganimni bilaman. — dedi Ali past ovozda.

Bonu birdan unga qaradi.

Ko\'zlarida yig\'ilib qolgan og\'riq aniq bilinardi.

— Bilasanmi?.. Yo\'q Ali, bilmaysan. — degan ovoz bilan titrab gapirardi.

— Agar bilganingda, ketmasding.

Ali chuqur xo\'rsindi.

— O\'shanda boshqa choram yo\'q edi. — dedi Ali.

— Har doim shunday deysan.

Bonu ortiga burilib ketmoqchi bo\'ldi.

Ammo Ali uni to\'xtatdi.

— Iltimos... hech bo\'lmasa eshit.

Bonu bir necha soniya jim turdi.

So\'ng asta dedi:

— Besh daqiqa.

Ali asta boshini qimirlatib maqulladi.

Ikkalasi eski o\'rindiq tomon yurishdi. Aynan shu joyda ular birinchi marta uzoq gaplashishgan edi.

O\'sha kuni yomg\'ir yog\'ayotgandi.

Bonu soyabon olib kelmagandi.

Ali esa kurtkasini uning boshiga tutib kulgandi.

— Shamollab qolasan.

Bonu o\'shanda ilk bor yuragi boshqacha urganini sezgandi.

— Otam kasal bo\'lib qolgandi. — dedi Ali birdaniga. — Men birdan Toshkentga ketishga majbur bo\'ldim. Ishlashim kerak edi. Oilam mendan boshqa hech kimga suyana olmasdi.

Bonu asta boshini egdi.

Ammo yuragidagi og\'riq hali ham ketmagandi.

— Ketishingni tushunishim mumkin edi, Ali.

U asta unga qaradi.

— Lekin nega indamading?

Ali jim qoldi.

Bu savol eng og\'iri edi.

— Men seni kutib qolishingni istamadim.

Bonu achchiq kuldi.

— Baribir kutdim.

Bu gapdan keyin ikkalasi ham jimib qoldi.

Atrofdagi shamol go\'yo sekinlashgandek edi.

Bonu uzoqqa qarab qoldi.

— Bilasanmi... sen ketganingdan keyin men o\'zimni aybladim. Balki yetarlicha yaxshi bo\'lmagandirman deb o\'yladim. Balki sendan ko\'p narsa talab qilgandirman deb o\'yladim...

Ali darrov boshini chayqadi.

— Yo\'q, Bonu. Muammo senda emasdi.

— Unda nimada edi?!

Bonuning ovozi balandlashdi.

Ko\'zlariga yosh keldi.

— Nega meni sevib turib tashlab ketding?!

Ali javob bera olmadi.

Chunki ba\'zan inson eng to\'g\'ri deb bilgan qarori bilan eng sevgan odamining yuragini sindiradi.

Bonu asta ko\'z yoshlarini artdi.

— Sen ketgan kundan beri men boshqacha bo\'lib qoldim.

U kulishga urindi.

— Oldingi Bonu yo\'q endi.

Ali yuragida nimadir uzilgandek his qildi.

Chunki uning qarshisida turgan qiz avvalgidan ancha sokin edi.

Ammo bu sokinlik ortida katta dard yashardi.''',
      quoteHighlight: "Chunki ba'zan inson eng to'g'ri deb bilgan qarori bilan eng sevgan odamining yuragini sindiradi.",
    ),
    const BackendChapter(
      index: 3,
      id: '3',
      title: 'Yuragdagi Sukut',
      content: '''Shu payt Bonuning telefoni jiringladi.

Dilnoza.

Bonu qo\'ng\'iroqni ko\'tardi.

— Alo?

— Qayerdasan o\'zi? Seni yarim soatdan beri qidiryapman.

Dilnozaning ovozi telefondan xavotir bilan eshitildi.

Bonu bir lahza Aliga qarab turdi-da, nigohini olib qochdi.

— Ishim chiqib qoldi... Hozir boraman.

— Hammasi joyidami?

Bonu javob berishga shoshilmadi.

Ba\'zan "yaxshiman" degan bitta yolg\'on insonni eng ko\'p charchatadi.

— Ha... xavotir olma.

U qo\'ng\'iroqni tugatdi.

Shamol yana kuchaydi. Daraxt yaprog\'lari xiyobon yo\'lagida aylanib uchardi.

Osmon xiralashib yomg\'ir hidi kelayotgandi.

Ali asta dedi:

— Hali ham biron narsa seni qiynasa, ichingga yutarkansan.

Bonu kulgandek bo\'ldi.

— Odam o\'rganib qolarkan.

Ali unga qarab qoldi.

Bonu juda o\'zgargandi.

Avvallari hissiyotlarni yashira olmasdi. Xafa bo\'lsa darrov bilinardi. Kulsa chin yurakdan kulardi.

Hozir esa... uning yuzida sokinlik bor.

Ammo ko\'zlari charchagan edi va aynan o\'sha ko\'zlar Alining yuragini bezovta qilardi.

Chunki insonning eng katta dardi ko\'zida bilinadi.

— Men seni sog\'indim, Bonu.

Bu gap kutilmaganda aytildi. Bonu yuragi bir lahza to\'xtab qolgandek his qildi o\'zini.

Ammo Aliga buni bildirmadi.

— Kech qolding. — dedi Bonu.

Ali boshini egganchuqur xo\'rsinib: — Bilaman — dedi.

Oralarida yana jimlik hukm surdi. Lekin bu jimlik oddiy emasdi.

Unda ikki yil yig\'ilgan sog\'inch, alam va aytilmagan gaplar yashardi.

Bonu asta o\'rnidan turdi.

— Men ketishim kerak.

Ali ham o\'rnidan turdi.

— Yana uchrashamizmi? — deb so\'radi Ali.

Bonu javob bermadi.

U bir necha soniya Alining ko\'zlariga qarab turdi.

Oldin shu ko\'zlarga qarasa o\'zini xavfsiz his qilardi.

Hozir esa aynan shu ko\'zlar yuragini og\'ritardi.

— Bilmayman.

U shunday deb ortiga burildi.

Ali esa uning ortidan jim qarab qoldi.

Bonu uzoqlashib borardi.

Ammo Ali bir narsani his qilgandi.

Bonu hali ham uni sevardi.

Faqat bu sevgining ustini og\'riq bosib ketgan edi.

Kechqurun yomg\'ir boshlandi.

Bonu deraza oldida o\'tirib, qo\'lidagi choy asta sovib borayotganini ham sezmay qolgan edi.

Xonada faqat soatning mayin chiqqilashi eshitilardi.

Stol ustida esa yana o\'sha qora muqovali daftar yotardi.

Bonu uni sekin ochdi.

Sahifalar orasida eski yozuvlar bor edi.

"Ba\'zi insonlar qalbingga sekin kiradi. Keyin esa butun umr chiqib ketolmaydi..."

Bonu sekin kulib qo\'ydi.

Bu yozuvni Ali bilan tanishgan paytda yozgandi.

U qalamni qo\'liga oldi.

Biroz o\'ylanib turdi-da, yangi sahifaga yoza boshladi.

"Bugun uni yana ko\'rdim.

Ikki yil o\'tibdi.

Ammo yuragim hali hamon uni ko\'rganida avvalgidek urdi.

Men uni unutdim deb o\'ylagandim.

Aslida esa faqat sog\'inishga o\'rganibman xolos..."

Bonuning qo\'llari asta titradi.

Ko\'zlarida yosh qalqidi.

— Nega qaytding Ali?.. — dedi u pichirlab.

Shu payt telefoniga xabar keldi.

Ali.

Bonuning yuragi yana bezovta bo\'lib tez ura boshladi.

U xabarni ochdi.

"Bilaman, mendan nafratlanishga, xafa bo\'lishga haqqing bor. Lekin bir narsani bilishingni xohlayman...

Men seni hech qachon sevishdan to\'xtamaganman.

Men doim seni sevishda davom etganman."

Bonu uzoq vaqt telefon ekraniga tikilib qoldi.

Ko\'zidan bir tomchi yosh oqdi.

Chunki u aynan shu gapni ikki yil kutgandi.

Ammo ba\'zan aynan kerakli so\'zlar juda kech aytiladi.

Bonu javob yozmadi.

Telefonini o\'chirib qo\'yib, boshini derazaga qo\'yib ko\'chaga tikilib qoldi.

Ko\'chada yomg\'ir yog\'ardi.

Yomg\'ir esa unga Alini eslatardi.

Sababi Ali bir kun shunday degandi:

— Yomg\'irli kunlarda odamlar ko\'proq rostgo\'y bo\'lib qoladi.

Bonu o\'shanda kulgandi.

— Nega?

— Chunki yomg\'ir Yurakdagi Sukunatni uyg\'otadi.

Bonu asta ko\'zlarini yumdi.

Yurakdagi Sukunat esa yana gapira boshlagandi.

Kech bo\'lib qolgach ko\'zlaridagi yosh bilan sekin uyquga ketdi.''',
      quoteHighlight: "Ba'zan \"yaxshiman\" degan bitta yolg'on insonni eng ko'p charchatadi.",
    ),
    const BackendChapter(
      index: 4,
      id: '4',
      title: 'Yomg\'irdagi xotiralar',
      content: '''Ertasi kuni kitob do\'koni avvalgidan tinch edi.

Bonu javondagi yangi kitoblarni joylayotganda Dilnoza unga yaqinlashdi.

— Kecha yig\'ladingmi?

Bonu kulib: — Shunchalik bilinib turibdimi? — dedi.

Dilnoza yelka qisib: — Seni anchadan beri bilaman. — dedi.

Bonu javob bermadi.

Dilnoza biroz jimlikdan so\'ng asta so\'radi.

— U qaytdimi?

Bonu qo\'lidagi kitobni sekin javonga qo\'ydi.

— Ha. — dedi.

Dilnoza chuqur xo\'rsindi.

— Sening yurating esa yana bezovta bo\'lyabdi shunaqami? — deb so\'radi.

Bu safar Bonu rad javobini bermadi.

Chunki ayrim insonlar seni so\'zsiz ham tushunadi.

Dilnoza sekin dedi:

— Bonu ehtiyot bo\'l.

— Nimadan? — deb savol berdi Bonu.

— Yana sinishdan.

Bonu ko\'zlarini pastga tushirdi.

U aynan shundan qo\'rqayotgandi.

Chunki ayrim yaralar vaqtlar o\'tsa ham bitmasdi.

Ular faqat insonning ichida yashashni o\'rganadi...

Osmon tongdanoq bulutli edi.

Shahar ustini kulrang sukunat qoplagan, shamol daraxtlarning yalang\'och shoxlarini asta tebratardi. Havo yomg\'ir hidiga to\'lgandi.

Bonu kitob do\'konining derazasi yonida turib tashqariga qarardi.

Bugun negadir yuragi yanada bezovta edi.

Ba\'zan inson biror voqea sodir bo\'lishini yuragi bilan sezadi.

Dilnoza kassada o\'tirib unga qaradi.

— Xayoling yana uzoqda.

Bonu sekin kuldi.

— Balki.

Dilnoza boshini chayqadi.

— U seni hali ham yaxshi ko\'rishini sezib turibman.

Bonu javob bermadi.

Chunki yurak his qilgan narsani til bilan inkor qilish qiyin edi.

Shu payt tashqarida yomg\'ir tomchilay boshladi.

Bonu beixtiyor derazaga yaqinlashdi.

Yomg\'ir...

Bu oddiy yomg\'ir emasdi unga.

Har bir tomchi ichida xotira yashardi.

Ali bilan o\'tgan kunlar. Kulgi. Sog\'inch. Va ayriliq.

Bonu asta ko\'zlarini yumdi.

Xotiralari yana uni o\'tmishga olib ketdi.

Bu uch yil oldingi kun edi.

Universitetdan chiqishgan payt osmon birdan qorayib ketgandi.

— Yomg\'ir yog\'adi shekilli, — degandi Bonu osmonga qarab.

Ali kulgandi.

— Sen esa yana soyabonsizsan.

Oradan ko\'p o\'tmay kuchli yomg\'ir boshlandi.

Talabalar yugurib binolarga kirishardi. Kimdir boshini daftar bilan to\'sardi.

Bonu esa kulib yomg\'ir ostida qolib ketgandi.

Ali unga hayron qaragandi.

— Sen doimgidek emassan.

Bonu qoshlarini ko\'tarib Aliga qaradi.

— Nega? — deb so\'radi.

— Hamma yomg\'irdan qochyapti, sen esa kulib turibsan.

Bonu qo\'llarini yomg\'ir tomchilariga tutdi.

— Men yomg\'irni yaxshi ko\'raman.

Ali unga tikilib qolgan edi. Shunchalik uzoq tikilganki, Bonu noqulay bo\'lib ketgandi.

— Nima bo\'ldi?

Ali asta jilmaygandi.

— Hech narsa... shunchaki seni kuzatyapman.

Bonuning yuragi o\'sha payt juda tez urgan edi.

Ali kurtkasini yechib uning boshiga tutdi.

— Shamollab qolasan bunday turma. — deb pana qildi.

— O\'zingchi? — deb so\'radi Bonu.

— Senga biror narsa bo\'lsa yomon bo\'ladi.

Bonu kulib yuborgandi.

Yomg\'ir yog\'ishda davom etardi.

Bonu shu holatda bir necha daqiqa qolib ketdi. Ko\'zlari yoshga to\'lgandi va sekin qadam tashlashni boshladi.

Yo\'l bo\'yi faqat bitta savol.

— Nega?

— Nega?

— Nega?

Shu so\'zni takrorlab yo\'lida davom etdi. Osmon bulutli. Atrof qorong\'u hech kim ko\'rinmasdi.

Xayol bilan uyiga kelganini ham payqamay qoldi.

Doimgidek sovuq va zimiston xona.

Kiyimlarini alishtirib yana deraza tomonga harakatlandi.

Yomg\'ir kuchaygan. Har bir tomchisi xuddikim yuragiga urilgandek bo\'lardi go\'yo.

Qo\'llari muzlagan lekin buni sezmasdi ham.

Yarim tun. Atrof jim jit.

Uxlashga harakat qildi lekin bo\'lmadi.

Qo\'liga yana o\'sha qora muqovali daftarini oldi. Sahifalarni o\'qir ekan orasidan suratni oldi.

O\'sha baxtli kunlar. Samimiy tabassum. Baxtdan quvongan ko\'zlar.

Ko\'zlariga yosh keldi va suratni ko\'ksiga bosib yig\'lab yubordi.

Va birozdan so\'ng shu ko\'z yoshlar bilan uxlab qoldi.''',
      quoteHighlight: "Har bir tomchi ichida xotira yashardi.",
    ),
    const BackendChapter(
      index: 5,
      id: '5',
      title: 'U qaytgan kun',
      content: '''Erta tong osmon musaffo. Ko\'chada yomg\'irdan keyingi nam isi.

Bonu doimgidek universitetdagi kutubxona tomon yo\'l oldi.

Kitoblarni varaqlar ekan ayrim sahifalarda o\'zini hayotini ko\'rgandek bo\'lardi.

Bir burchakda kitob o\'qib o\'tirardi. Bir payt yonida Dilnoza kelib o\'tirdi.

— Nma bo\'ldi? Nimaga xomushsan, ko\'zlaring qizargan? — deb so\'radi Dilnoza.

Yoshga to\'lgan ko\'zlari bilan qarab "hammasi yaxshi" deb javob qaytardi.

— Men seni ogohlantirgandim. — deb sekin bag\'riga bosib oldi.

Ikki dugona universitetdan chiqib qahvaxonaga borishga kelishishdi.

Ikki piyola qahva ustida o\'zaro suhbatlashishdi.

— Xo\'sh nma bo\'ldi gapir. Nimaga yana o\'zgarib qolding. Ali qayerda? U sabab shunaqa tushkun holatga tushib qoldingmi? — so\'radi Dilnoza.

— Bilasanmi u yana ketdi. Qaytishi ham qaytmasligi ham noma\'lum. Hayotimga hohlagan vaqtida kelib, hohlaganida tashlab ketyabdi. Agar sevganida shunaqa qilarmidi? — deya ko\'zlari yoshga to\'lib yig\'lab yuborishdan o\'zini zo\'rg\'a tiyib turdi.

— Hafa bo\'lma shunday bo\'lishi kerak ekan bo\'ldi, o\'ylama. Hali hammasi oldinda. Baxtli kunlar seni kutmoqda. Hali ko\'rmaganday bo\'lib ketasan. — dedi Dilnoza.

Bonu xo\'rsinib javob berdi:

— Qani edi hammasi sen aytganchalik oson bo\'lsa, oson unutilsa. Bilasanmi inson qalbida qolgan yaralarni, ularni paydo qilgan insonlarni hech qachon unutmas ekan.

Balki sen aytganing ham to\'g\'ridir. Sevgi nafratga aylansachi. Uni kechirolmasamchi. Lekin nimaga hammasi aynan meni hayotimda sodir bo\'lyabdi? Nimaga taqdir meni bu yo\'l bilan sinayabdi?

— Dugonajon, men seni yoningdaman, hafa bo\'lma. Hammasi unutasan, hammasi yaxshi bo\'ladi. — deya Bonuni yupatishga harakat qilardi.

Ikki dugona shu bilan uzoq vaqt gaplashib dardlashib olishdi. Va qahvaxonadan chiqishdi.

— Bonu, hohlasang meni uyimga yur, birga uxlaymiz, dars tayyorlaymiz. Balki yengil tortarsan.

— Raxmat dugonajon. O\'zimni uyimga boray, o\'zimga kelib olishim kerak. Kelasi safar borarman faqat hafa bo\'lma.

— Hop Bonu, yaxshi yetib olgin unda. — deb bag\'riga bosib xayrlashishdi.

Bonu bekat tomonga yura boshlarkan, barglar xazon bo\'lgan sevgisi, ishonchi kabi oyog\'i ostida shitirlab ezilardi.

Shu tariqa xayol surib bekatga kelganini ham sezmay qoldi.

Oradan bir necha daqiqa vaqt o\'tib avtobus ham yetib keldi.

Odamlar birma-bir avtobusdan tusha boshlashdi. Bonu esa avtobusning eng oxirgi o\'rindig\'iga borib o\'tirdi.

Oynadan tashqariga qarab bo\'lib o\'tgan ishlarni, keyingi hayotida nimalar bo\'lishi haqida o\'ylab ketardi.

Na atrofdagi shovqinga, na odamlarga e\'tibor bermasdi.

Va uyiga yaqin bir bekatda tushib qoldi. Uyigacha piyoda borganda o\'n daqiqalik yo\'l edi.

Yomg\'ir tomchilari yuziga tushar, esayotgan shamol yuzini silardi xuddikim erkalayotganday.

Bu naqadar yoqimli. Yomg\'irning tomchilari yuziga emas yuragiga tushayotganday his qilardi o\'zini.

Shu hislar bilan uyiga ham yetib keldi. Yana o\'sha qorong\'u, sovuq va kimsasiz uyiga.

U Ali ikki yil avval ketganida yolg\'izlikka o\'rganib qolgandi.

O\'zida na ovqatlanishga, na dars tayyorlashga hohish topolmadi. Shunchaki tinch va xotirjam dam olishni ma\'qul ko\'rdi. Tepaga tikulguncha qanday qilib uxlab qolgani o\'zi ham bilmay qoldi.

Bonuning telefoniga ertalabdan bir xabar keldi. U xabar Alidan edi.

Xabarda shunday yozilgan edi:

"Bonu meni kechir men ataylab qilganim yo\'q. Men shunga majburman. Otamni davolatishim kerak. Seni tashlab ketgim kelmayabdi lekin... Mayli nima bo\'lganda ham bitta narsani unutma.

Men seni chin dildan sevdim, faqat seni. Bundan keyin ham shunday bo\'lib qoladi. Seni yo\'qotgim kelmaydi.

Meni kut men albatta qaytaman. Men o\'n besh daqiqadan keyin uchib ketyabman. O\'zingni ehtiyot qil."

Bonu bu xabarni o\'qir ekan ichidan nimadir uzilganday bo\'ldi. Lekin o\'zini tutib turardi.

Lekin ketishi aniqligini bilardi. Uni olib qolishga harakat qilolmasdi chunki Alining otasi og\'ir ahvolda edi.

Oradan kunlar o\'tdi.

Har bir kun shunday sokin, mazmunsiz o\'tardi. U vaqtlar o\'tib hammasini unutaman deb o\'ylardi lekin tunda uni xayollari, xotiralari qiynardi.

Bunday kechalar Bonuda ko\'p bo\'ldi.

Lekin vaqt o\'tgan sari inson hammasi ko\'nikar ekan. Unuta olmayman degan insonlari, vaqtlari unutilar ekan.''',
      quoteHighlight: "Lekin vaqt o'tgan sari inson hammasi ko'nikar ekan.",
    ),
    const BackendChapter(
      index: 6,
      id: '6',
      title: 'Ali\'ning sukuti',
      content: '''Ali ham ketganidan xursand emasdi. Uyga qaytishini kunlab sanar, pul topish, otasini tezroq davolatish haqida o\'ylardi. Lekin hayot biz hohlagan narsalarni emas, hohlamagan narsalarimizni tayyorlab qo\'yarkan.

Tun sokin edi. Deraza ortida yomg\'ir mayin yog\'ardi. Ali esa xonasining qorong\'u burchagida jim o\'tirardi. Yuragida minglab gaplar bor edi, lekin ularni aytishga kuch topolmasdi.

Ba\'zan inson eng baland sukut ichida yasharkan. Ali ham shunday yashardi. Kulardi, odamlar bilan gaplashardi, ammo yuragidagi og\'riqni hech kim sezmasdi. U bir insonni juda qadrlagan, lekin vaqt ularni uzoqlashtirgandi.

Har kuni eski xabarlarni o\'qib chiqardi. Suratlarni ko\'rib, o\'tgan kunlarni eslardi. Eng og\'iri esa — unutolmaslik edi.

Bir kuni yomg\'ir ostida ko\'chada ketayotib, u bir narsani tushundi: ayrim insonlar hayotdan ketadi, ammo xotiralardan emas. Yurakdagi Sukunat ham aslida sevgi qoldirgan iz ekan.

Ali osmonga qaradi. Yomg\'ir tomchilari yuziga tushardi. U asta jilmaydi. Chunki ba\'zi og\'riqlar vaqt bilan yo\'qolmasa ham, insonni kuchliroq qilishini anglagandi.

Balki haqiqiy sevgi bu xotiralarda, hayollarda yashashdir?!

Oradan kunlar o\'tdi. Ali avvalgidek har kecha eski xotiralar bilan yashamaslikka harakat qildi. Ammo ayrim tunlar yurak yana o\'tmishga qaytarardi.

Bir kuni u eski daftarini topib oldi. Varaqlari orasida sarg\'aygan qog\'oz bor edi. Unda bir jumla yozilgandi:

"Ba\'zi insonlar ketadi, lekin ular o\'rgatgan hislar va xotiralar qoladi."

Ali uzoq o\'sha yozuvga tikilib qoldi. Ko\'z oldiga kulgular, sayrlar, oddiy suhbatlar keldi. U tushundiki, u yo\'qotgan narsa faqat inson emas, balki o\'sha paytdagi o\'zi ham edi.

Shu kundan keyin Ali asta-sekin o\'zini o\'zgartira boshladi. U yana kitob o\'qidi va tonglarni kutishni boshladi. Yuragidagi sukut hali ham bor edi, ammo u endi og\'riq emas, xotira bo\'lib qolayotgandi.

Bir kecha tomga chiqib osmonga qaradi. Yulduzlar charaqlab turardi. U chuqur nafas olib, sekin dedi:

— Balki baxt unutishda emasdir... uning xotirasi bilan yashashda ekan.

Va ilk bor yuragidagi sukut unga qo\'rqinchli emas, yoqimli tuyuldi.''',
      quoteHighlight: "Ba'zi insonlar ketadi, lekin ular o'rgatgan hislar va xotiralar qoladi.",
    ),
    const BackendChapter(
      index: 7,
      id: '7',
      title: 'Qaytish',
      content: '''Qishning sovuq havosi tabiatga ta\'sir qila boshladi. Atrofda qor parchalari. Daraxtlardan barglar to\'kilgan. Kimdir issiq uyiga shoshardi, kimdir qadrli insonlari yoniga, yana kimdir esa ishga. Ali bo\'lsa avtobusga shoshardi.

U Rossiyada yaxshi insonlar, vatandoshlari bilan tanishgandi va ular bilan bir uyda yashay boshlagandi.

Hech bo\'lmaganda uni kutadigan insonlar borligidan baxtiyor edi.

Oradan bir necha yillar o\'tdi.

Ali ham Bonu ham xotiralar bilan yashashni unutishdi. Ularni faqat kelajak qiziqtirardi. Hali hayot oldinda. Baxtli kelajak meni kutyabdi degan kichik bir umid uchquni bilan yashashardi.

Ali yaxshi ishga joylashdi. Otasini mashxur do\'xtirlarga ko\'rsatdi va qisqa muddatda davolatdi.

Endi o\'z yurtimga qaytaman degan hayol uni juda baxtli qilardi.

Va nihoyat O\'zbekistonga qaytish uchun avval ishini ko\'chirdi keyin esa qisqa muddatda uchadigan samolyot uchun bilet oldi.

Ali shunaqangi xursand edi-ki, hamma ishi joyida, otasi sog\'lom, rejalari amalga oshgan va kutgan kuni kelgandi. Lekin hayoliga Bonu keldi. U meni kutganmikan? Oila qurmaganmikan?

Ali tavakkal qilolmasdi va O\'zbekistonga borganda barcha savollarga javob olishga qaror qildi.

Bilet vaqti kelishini intiqlik bilan kutdi. Yana bir kun. Orzularga yetishgan. Savollarga javob olishga atiga bir kun qolgandi.

U shoshilib narsalarni yig\'ishga kirishdi. Yarim tun. Ko\'chada salqin shabada. Mashinalarning ovozi, daraxtlarning sokin tebranishi bular unga xuddi musiqadek tuyulardi.

Deraza yoniga borib biroz muddat toza havodan nafas oldi va uxlashga yotdi.

Ertalab tong soat olti.

Yaxshi kayfiyatda uyg\'onib aeroporttomonga yo\'l oldi.

Bir soatdan keyin O\'zbekistonga uchish kerak. Yurak to\'la hayajon, so\'roq va xotira.

Va nihoyat uchish e\'lon qilindi. Hattoki ota-onasiga ham aytmasdan O\'zbekistonga uchdi.

Oradan bir necha soat vaqt o\'tdi va samolyot Toshkentga kelib qo\'ndi.

Ali birinchi bo\'lib ota-onasining yoniga bordi va ularning duosini olib savollariga javob olish uchun Bonuning yoniga yo\'lga chiqdi. Bonuni xursand qilish uchun bir dasta qizil atirgul olib yo\'lda davom etdi.

Nima deyishni, gapni nimadan boshlashni bilmasdi. Avval borish, Bonuni ko\'rish, uni ko\'zlariga to\'yib qarab olish hayoli bilan ketardi.

Avval universitet kutubxonasiga bordi, Dilnozadan Bonu haqida so\'rashga.

— Salom Dilnoza.

— Salom Ali.

— Menga Bonu kerak edi. Qayerdan topsam bo\'ladi? Unda zarur gapim bor. — dedi Ali.

— Uzur, men senga aytolmayman. Chunki sen sabab Bonu doim aziyat chekyabdi. Doim kelib ketishing sabab u sinyabdi. U hozir baxtli, uni tinch qo\'y. Uni yana baxtsiz qilma. Endi esa ket bu yerdan. — deb Aliga eshikni ko\'rsatdi.

Lekin Ali gapida turib oldi.

— Men shunga majbur edim, iltimos... U menga kerak. Qayerdaligini ayt. — deb bir necha marotaba takrorladi.

Va oxiri Bonu o\'sha eski xiyobonda ekanligini aytdi.

Ali esa shoshilguncha xiyobon tomonga yugurdi.

Uzoqdan Bonuni ko\'rdi. Uning ifori uzoq masofalarda ham bilinib turardi. Ali uning samimiy tabassumi ortiga g\'arq bo\'lgandi go\'yo. Balki takror-takror ishqi tushayotgandir.

Bonuga yaqinlashgani sari Alining yuragi tezlashib borardi. Bonu bir eski o\'rindiqda o\'tirardi.

— Bu yerda hech narsa o\'zgarmagan. Hammasi o\'sha-o\'sha. — degan mayin va yoqimli ovoz eshitildi.

Bonu shu zahoti qotib qoldi. Chunki bu ovozni bir necha yillar avval eshitgandi.

Shunda yoniga Ali kelib o\'tirdi. Ikki tomondan ham bir so\'z aytilmadi. Na sog\'inchni, na afsusni ayta olishmadi. Shu holatda uzoq vaqt qolishdi.

— O\'zgarmabsan, haliyam o\'sha-o\'shasan.

— Sen ham o\'zgarmabsan. Qaytdingmi?

— Ha, qaytdim. Endi butun umrga shu yerdaman. Hozir hammasi yaxshi: uyim, ishim, hammasi bor. Dadam tuzaldi. Va men shu yerga qaytib keldim. — dedi Ali.

— Bu yerda nima qilayapsan? Nima uchun yonimga kelding?

— Seni ko\'rmoqchi edim. Xo\'sh, oila qurdingmi?

— Yo\'q.

— Men sen haqingda ota-onamga aytmoqchiman. Sendan uzoqda ko\'p yashadim. Faqat seni xayoling bilan yashadim. Bu juda qiyin edi. Endi esa seni baxtli qilmoqchiman garchi kech bo\'lsa ham.

Bonu boshini pastga egib biroz jim turdi va dedi:

— Sen avval menga aytmasdan tashlab ketding, qaytdim deb ketding. Oradan shuncha vaqt o\'tib qaytyapsan. Yana qalbim sinishini xohlamayman. To\'g\'ri menga ham oson bo\'lmadi, lekin inson vaqti kelib ko\'narkan. Men ham ko\'nikdim. Hozir hammasi yaxshi. Iltimos, boshqa qaytma.

Ortiga o\'girildi. Ketayotganda Ali uning qo\'lidan tutib qoldi.

— Iltimos... Bonu, menga ishon. Men sen uchun qaytdim va ketmayman. Doim yoningda bo\'laman. Seni baxtli qilaman. Oxirgi marta imkon ber va men sening ishonchingni oqlayman. — dedi.

Bonu esa yosh to\'lgan ko\'zlari bilan Aliga mayus qarab turardi.

Yuragi Aliga quloq solishni, imkon berishni aytsa, aqli voz kechishni unutishni aytardi.

Bonu nima qilishni bilmasdi. Chunki haligacha Alini sevardi. Qancha inkor etsa ham.

— Bonu, nimadir de, jim turma, gapir. — dedi Ali.

— Ali. Men hammasiga ko\'z yumib ketolmayman. Hammasi sen o\'ylaganchalik oson emas. To\'g\'ri, hamma ham ikkinchi imkonga loyiq. Lekin sen yana ketmasligingga men ishonolmayman, chunki ancha avval ishonchim yo\'qolgan. Seni sevishim rost. Lekin sevgi vaqti kelib nafratga aylandi. Sendan xafa emasman, mayli baxtingni top.

— Bonu, men sen bilan baxtimni ko\'rganman, faqat seni sevganman. Men qalbimga buyruq berolmayman. Uni "sevma" deyolmayman. Sen bilan baxtli bo\'lmoqchiman. Mayli senga hozir javob ber demayman. O\'ylab ko\'r. Faqat rad javobini berma. Faqat oxirgi imkonni berib, menga ishonsang bo\'ldi. Hammasi sen orzu qilganingdek bo\'ladi. — dedi Ali.

Bonu biroz sukut saqlab:

— Mayli Ali, o\'ylab ko\'raman. O\'zimga kelib senga javobimni aytaman. Faqat menga vaqt kerak. — dedi.

— Ho\'p, seni tushundim. Hohlasang uyingga kuzatib qo\'yaman. Yolg\'iz o\'zing ketma, kech ham tushdi. Hozir taksi chaqirdim, keladi. Yuraqol, darvoza yoniga chiqib turaylik. — deb darvoza tomonga ketishdi.

Oradan besh daqiqa o\'tib taksi ham yetib keldi.''',
      quoteHighlight: "Men sen uchun qaytdim va ketmayman.",
    ),
    const BackendChapter(
      index: 8,
      id: '8',
      title: 'Kechikkan baxt',
      content: '''Bonuning uyigacha yigirma daqiqalik yo\'l edi. Yo\'l bo\'yi mashina oynasidan tashqariga qarab ketdi.

Ko\'chada sokin hayot, mayin shabada esardi. Odamlar ko\'rinmasdi. Hamma uyda oilasi bilan ovqatlanishga kirishgan degan xayol bilan ketardi.

Va nihoyat Bonu uyiga yetib keldi. Ali bilan xayrlashmasdan mashinadan tushib uyiga kirib ketdi. Tepa qavatga ko\'tarilib, uyining eshigi yoniga turib qoldi.

Uyining eshigi ochiq. Bonu hayratlanib qoldi. Chunki u yolg\'iz yashardi. Hammadan uzoqda. Onasi esa chet davlatda. Uyga kirishga biroz qo\'rqdi.

Nma qilishni bilmay bir necha daqiqa eshik yonida turdi. Oxiri "kim ekan?" deb sekin eshikni ochib uyiga kirdi. Eshikdan kirishi bilan pastda ayol kishining oyoq kiyimi, tepada esa qora palto ilingan edi.

Oshxona tomondan sho\'x musiqa ovozi eshitilib turardi.

Bonu sekin oshxona tomonga yurdi. Oshxonada bir ayol hirgoya qilib ovqat pishirayotgandi. Bonu stol ustida turgan chiroyli bir guldonni oldi va ayol tomonga yura boshladi.

Birdaniga baland ovozda — Kimsiz?! — dedi.

Ayol qo\'rqib ketib orqaga o\'girildi. Bonu ne ko\'z bilan qarasa — qarshisida oyisi turibdi!

— Oyi! — deb qichqirib yubordi. Qo\'lidagi guldonni yerga tashlab yubordi va oyisining bag\'riga o\'zini otdi.

— Bonu, qizalog\'im, seni juda sog\'indim. Katta qiz bo\'lib qolibsan. — deb yuz-ko\'zlaridan o\'pib mahkam quchoqladi.

— Oyijon, bilsangiz edi, sizni juda qattiq sog\'indim. Nega shuncha payt kelmadingiz. Nimaga meni yolg\'iz tashlab ketdingiz? — deb yig\'lardi.

— Bo\'ldi, qizalog\'im. Endi seni hech qayerga tashlab ketmayman. O\'qishim ham tugadi, endi shu yerda sening yoningda bo\'laman. — dedi Bonuning oyisi.

— Ho\'p, oyijon. Endi ketmang, sizsiz juda qiynaldim. Juda yolg\'iz qoldim. — deb ko\'zdagi yoshlarini artardi.

— Hammasi yaxshi bo\'ladi. Qani, endi kel. Ovqat tayyor, birga ovqatlanib olamiz. Qorning ham ochgandir.

— Ha, biroz och. Hozir yuvinib chiqay. — dedi va yuzini yuvishga kirib ketdi.

Bonuning oyisi stol ustida qora muqovali daftarga ko\'zi tushdi. U daftar ichidagi suratni ko\'rdi. Alini tanirdi.

— Qizim, Ali bilan gaplashyabsanmi? Nimagadir baxtli ko\'rinmayabsan. Nima bo\'ldi, kelaqol yonimga. — deb Bonuni chaqirdi.

Bonu ko\'zlari yoshlanib, bo\'lib o\'tgan ishlar haqida aytib berdi.

Oyisi ham nima deyishni bilmasdan Bonuni bag\'riga bosib: — Siqilma qizim, hammasi yaxshi bo\'ladi. — deb yupatdi.

— Oyijon, Ali bugun qaytib keldi. Butunlay qaytganini aytdi. Ketmasligini aytdi. Menga ko\'nglini ochdi. Tushuntirdi. Men tushunishni xohlayman. Lekin endi hammasi joyiga tushganda qaytdi. U menga uylanmoqchi, ota-onasini olib kelmoqchi. Lekin men ketmasligiga ishonolmayabman. Nima qilishni bilmayabman. Va men o\'ylab ko\'rishimni aytdim. Hozir esa nima deb javob berishni bilmayabman. U yana ketsachi? Men shuncha vaqt Yurakdagi Sukunat bilan, xotiralar bilan yashadim. Xotiralar bilan yashashni unutganda, ko\'nikkanda yana paydo bo\'ldi. — deb oyisining oyog\'iga bosh qo\'yib yotdi.

Bonuning oyisi:

— Qizim, hammasi o\'tib ketdi. Sen aytgan gaplarni tushundim. Uni ham tushunish kerak. Otasi betob bo\'lgan ekan. Axir o\'zing tushunasanku, otasiz yashash juda qiyin. Uni tushun, otasi uchun shu narsaga majbur bo\'lgan. Muhimi qaytib keldiku. Kelmasligi ham mumkin ediku. Yaxshilab o\'ylab ish qil. Senga biron narsa deyolmayman. Taqdir o\'z qo\'lingda, uni o\'zing hal qilishing kerak. Faqat to\'g\'ri deb bilganingni qil, keyin pushaymon bo\'lmaslik uchun. Bitta xatoni badalini butun umr to\'lamaslik, o\'zingni ayblamaslik uchun yaxshilab o\'ylab ish qil. — deb Bonu sochlarini silardi.

— Hop bo\'ladi, oyijon. Sizni tushundim. — deb oyisini yuzidan o\'pib qo\'ydi.

— Kech bo\'lib qoldi, qizim, endi yotib dam ol. — deb o\'z xonasiga ketdi.

Bonu joyiga yotdi. Tepaga termulib chuqur o\'yga cho\'mdi.

Alining gaplarini esladi. Aliga rad javob bersa, uni sevishini, ko\'rsa yuragi tezlashishini o\'ylardi. Ho\'p desa, bo\'lib o\'tgan ishlar, qayta-qayta ketishlar, oyisining gaplarini esladi.

Va shularni o\'ylab ancha vaqt uxlolmadi.

Qora muqovali daftar ichidagi rasmni olib unga biroz tikilib turdi va pichirlab:

— Sen mening kechikkan baxtimsan. — deb ko\'ksiga bosdi.

Qo\'liga telefonni olib Alining raqamini qidirdi. "Singan yurak" qilib saqlab qo\'ygan edi va uni topdi.

Tel qilmoqchi bo\'ldi lekin juda kech bo\'lib qolgandi. Shu sababli SMS yozdi:

"Salom Ali, men sen aytgan gaplarni o\'ylab ko\'rdim va bir qarorga keldim. Men roziman, faqat ketmaslikka vada bersang va doim yonimda bo\'lsang. Senga yana bir bora ishondim. Iltimos, bu safar ham ishonchimni yo\'qotma, yuragimni sindirma."

Ali bu paytda Bonu bilan tushgan rasmlarni tomosha qilayotgandi. Va Aliga xabar keldi. Xabar Bonudan edi. Ali xabarni ochib o\'qidi va ko\'zlari charaqlab ketdi. U juda xursand edi, hattoki ko\'zlaridan quvonch ko\'zyoshi oqdi.

Bonuning xabariga javob berdi:

"Raxmat, Bonu, ishonching uchun. Menga ishonaver. Hali seni baxtli qilaman, doim yoningda bo\'laman, seni hech qachon xafa qilmayman va xafa qildirib qo\'ymayman ham. Seni juda qattiq sevaman."

Bonu xabarni o\'qigach sokin uyquga ketdi.

Erta tong osmonda qushlar parvoz qilardi. Daraxtlar mayin tebranardi. Hozirgi tong doimgidek boshlanmadi. Bonuning oyisi Bonu yotgan xonaga kirib derazalarni ochdi, pardalarni ko\'tardi va Bonuning peshonasidan o\'pib:

— Turaqol, malikam, tong otdi. — deb Bonuni uyg\'otdi.

Bonu ancha yillar avval shunaqa uyg\'onardi. Va oradan shuncha yil o\'tib, o\'sha kunlarni yana esladi.

— Xayrli tong, oyijon! Yaxshi dam oldingizmi? — deb quchoqlab qo\'ydi.

— Raxmat, qizalog\'im. Endi tezda ko\'chaga aylangani chiqamiz, birga ovqatlanamiz.

Ko\'chada juftliklar ketishardi. Keksalar o\'rindiqda o\'zaro suhbat qilishardi. Bolalar har xil o\'yinlar o\'ynashardi.

Bonu esa oyisi bilan suhbatlashib xiyobonga ketishardi.

— Oyijon, men o\'ylab ko\'rdim va bir qarorga kelib Aliga javobimni aytdim.

— Xo\'sh, nima deding? — so\'radi oyisi.

— Men unga imkon berdim. Va bu oxirgisi ekanligini aytdim. Ali ham ho\'p dedi.

— Ho\'p, qizalog\'im. Tanloving to\'g\'ri bo\'lsa bo\'ldi. Men qarshilik qilmayman. Menga sening baxting muhimroq. Sen mening yagonamsan. — deb qo\'lidan tutdi.

Bonu ham bu gaplardan baxtiyor edi.

Oldinda yangi hayot, yangi baxt kutardi.''',
      quoteHighlight: "Sen mening kechikkan baxtimsan.",
    ),
  ];
}
