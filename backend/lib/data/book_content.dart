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
  static const String title = "Aytilmagan gaplar";
  static const String author = "Noma'lum muallif";
  static const String description =
      "Ba'zan insonning eng baland qichqirig'i bu uning sukuti bo'larkan...";

  static final List<BackendChapter> chapters = [
    const BackendChapter(
      index: 0,
      id: '0',
      title: 'Kirish',
      content: '''Ba'zan insonning eng baland qichqirig'i bu uning sukuti bo'larkan. Uni hech kim eshitmaydi. Tunlari ko'z yosh bilan uxlab, tongda xuddi-ki hech nma bo'lmagandek kulib yashashda davom etarkansan.

Men ham xuddi shunday yashadim. Tunlari qalbim ming parcha lekin tongda "hammasi yaxshi" degan soxta tabassum ortiga berkingan jajji qizaloq kabi.

Hayot meni ko'p sinadi. Insonlarga ishonmaslik, ortga nazar tashlamaslik, olg'a qadam bosish, ketgan narsaga achinmaslik va keladiganlarini sabr va shukr bilan qabul qilish.

Ishongan insonlarim ishonchimni sindirdi, orzularim so'ndi, yuragim parchalandi va sukut ortiga berkindi. Ammo shu sukut ichida qanchadan-qancha aytolmagan gaplarim, orzularim bor edi.

Hayot menga kuchli bo'lishni o'rgatdi. Chunki shunday yaralar bor ular hech qachon bitmaydi aksincha, bizni kuchli va sabrli qiladi.

Ba'zida ichingdagi dardlaringni hech kimga ayta olmaydigan so'zlaringni kimgadir aytging keladi lekin aytolmaysan. Aytishga odam topolmaysan. Topgan vaqtingda esa seni tushunishmaydi yoki tushunishni hohlashmaydi. Shunda yurak asta sekin sukutga cho'kadi.

Men ham bir vaqtlar orzu qilardim mehr to'la qalblarni, meni tushunadigan insonlarni, samimiy munosabatlarni, meni tashlab ketmaydigan insonlarni.

Lekin hayot biz xohlagan narsalarni emas ularning aksini tayyorlab qo'yarkan va shu orqali bizni sinarkan. Ko'nglimga yaqin olganlarim meni birinchi bo'lib tark etdi, orzularim so'ndi, odamlardan uzoqlashdim. Xuddi qalbi o'lgan insondek yashashda davom etdim.

"Yurakdagi Sukunat" — bu shunchaki kitob emas. Aytilmagan hislar, soxta tabassum ortiga berkingan ko'z yoshlar va sinmagan qalbning sadosi. Balki bu satrlarda siz ham o'zingizni ko'rarsiz...''',
      quoteHighlight: "Ba'zan insonning eng baland qichqirig'i bu uning sukuti bo'larkan.",
    ),
    const BackendChapter(
      index: 1,
      id: '1',
      title: 'Sukut ortidagi ko\'zlar',
      content: '''Kech kuz edi.

Shahar osmonini quyuq bulut qoplagan, xiyobondagi daraxtlardan sarg'aygan yaproqlar sekin yerga tushardi. Havo sovuq bo'lsa ham odamlar odatdagidek shoshilib yashardi. Kimdir ishga ulgurishga harakat qiladi, kimdir uyiga qaytadi, yana kimdir shunchaki hayotdan qochib yuradi.

Bonu esa avtobus oynasidan tashqariga jimgina qarab ketardi.

Ba'zan inson atrofidagi minglab odamlar orasida ham o'zini yolg'iz his qilarkan.

U ham aynan shunday edi.

Avtobus ichida past ovozda musiqa eshitilar, oynalarga esa yomg'ir tomchilari mayda iz qoldirardi. Bonu boshini oynaga qo'yib, asta xo'rsinib qo'ydi.

Ko'zlari charchagan, madori qolmagan edi.

Faqat ishlar va uyqusizlikdan emas...

Yurakdagi og'riqlardan.

Qo'lidagi qora muqovali daftarni asta ochdi. Sahifalar orasidan eski bir surat tushib ketdi. U suratga tikulguncha bir lahza qotib qoldi.

Suratda u kulib turardi.

Yonida esa Ali.

Bonuning tabassumi o'sha surat bilan birga o'tmishda qolib ketgan edi.

U suratni asta daftar orasiga qaytarib soldi va deraza tomonga qarab oldi.

— Nega hammasi shunday tugadi?.. — dedi u ichida.

Avtobus navbatdagi bekatda to'xtadi. Odamlar asta sekin chiqib tusha boshladi. Ammo Bonu uchun vaqt ikki yil oldin to'xtab qolganday edi.

Ikki yil...

Aynan ikki yil oldin Bonuning hayoti o'zgargan edi.

O'sha kun hali ham yodida.

Universitet hovlisi odamlar bilan gavjum edi. Daraxtlar gullay boshlagan, atrof bahorning iliq hidiga to'lgan edi. Bonu qo'lida kitob bilan kutubxona tomonga ketayotganda ortidan bir ovoz eshitildi.

— Bonu!

U ortiga qaragandi.

Ali yugurib kelardi.

Har doimgidek kulib.

Har doimgidek shoshib.

— Yana kech qoldingmi? — degandi Bonu kulib.

— Seni ko'rish uchun yugurdim.

Bonu o'sha paytda baxt nma ekanligini tushungandek bo'lgandi.

Baxt — oddiy insonning yonida o'zingni xavfsiz his qilish ekan.

Ali uning yonida boshqacha edi. U bilan gaplashganda vaqt tez o'tardi. U kulsa, Bonu ham kulardi. Hatto oddiy sukutlari ham yoqimli edi.

Ammo uning baxtli paytida taqdir nimanidir olib qo'yishini bilmaydi.

— Bekat! Bekat!

Haydovchining ovozi Bonuni xayollaridan qaytardi.

U asta o'rnidan turib avtobusdan tushdi. Yomg'ir maydalab yog'ardi. Sovuq shamol yuziga urilardi.

Bonu kurtkasining yoqasini ko'tarib oldi.

Uyigacha piyoda yursa 10 daqiqalik yo'l edi.

Ko'cha chiroqlari ostida nam asfalt yaltirab turardi. Atrofdagi odamlarning shovqini unga uzoqdan eshitilgandek tuyulardi.

U yo'lda ketayotib kichik qahvaxona oldida to'xtadi.

Bu joyga avvallari Ali bilan birga kelishardi.

Bir stol, ikki piyola qahva va tugamaydigan yoqimli suhbat.

Bonu oynadan ichkariga qaradi. Ichkarida kulayotgan juftliklar o'tirardi. Kimdir sevgan insonining qo'lidan ushlab gaplashardi.

Bonu asta ko'zlarini olib qochdi.

Chunki ayrim xotiralar yuragiga pichoqdek botardi.

U yo'lida davom etdi.

Nihoyat eski ko'p qavatli uy yoniga yetib keldi. Zinadan sekin ko'tarildi. Eshikni ochib ichkariga kirishi bilan yana o'sha jimlik uni qarshi oldi.

Bu uyda hech kim uni kutmasdi.

Hech kim "qalaysan, yaxshi keldingmi" — deb so'ramasdi.

Bonu chiroqni yoqdi-da, sumkasini divanga tashladi.

Uy ichi sovuq edi.

U deraza yoniga borib tashqariga qaradi. Yomg'ir kuchaygandi. Ko'zlari yana stol ustidagi suratga tushdi.

Ali bilan tushgan surat.

Bonu asta uni qo'liga oldi.

Alining kulishi juda samimiy edi.

— Sen nega ketding?.. — dedi u past ovozda.

Ko'zlariga yosh to'ldi.

Ammo yig'lamasdi.

Chunki u ancha avval yig'lashdan ham kulishdan ham charchagan edi.

Shu payt telefon titradi.

Notanish raqam.

Bonu biroz ikkilanib qo'ng'iroqqa javob berdi.

— Alo?

Bir necha soniya jimlik bo'ldi.

So'ng tanish ovoz eshitildi.

— Bonu...

Uning yuragi to'xtab qolgudek bo'ldi.

Bu ovozni u minglab ovoz ichidan ham tanib olardi.

Ali.

Bonuning qo'llari titrab ketdi.

— Raqamimni qayerdan olding?..

Ali chuqur xo'rsindi.

— Men sen bilan gaplashishim kerak.

Bonu darrov javob bermadi.

Ikki yil davomida kutgan insonining birdan qaytib kelishi... bu quvonchlimi yoki og'riqli? Buni bilish qiyin.

— Gaplashadigan hech narsa qolmagan.

— Bor. — dedi Ali.

Bonu ko'zlarini yumdi.

Yuragi yana o'sha eski hislar bilan urayotgandi.

— Iltimos... bir marta uchrashaylik. — dedi Ali.

Bonu biroz jim turdi.

Ali davom etdi:

— Ertaga eski xiyobonda kutaman.

Va qo'ng'iroq tugadi.

Bonu uzoq vaqt telefoniga tikilib qoldi.

Yuragi ichida nimadir uyg'omgandi.

Unutildi deb o'ylagan hislar.

Og'riqli xotiralar.

Va hali ham so'nmagan sevgi...

Ertasi kun havo ochiq edi...''',
      quoteHighlight: "Ba'zan inson atrofidagi minglab odamlar orasida ham o'zini yolg'iz his qilarkan.",
    ),
    const BackendChapter(
      index: 2,
      id: '2',
      title: 'Ketgan izlar',
      content: '''Kuzning sovuq shamoli xiyobondagi daraxtlarni sekin tebratardi. Yerga to'kilgan sariq yaproqlar oyoz ostida shitirlab ezilar, uzoqdan bolalarning ovozi eshitilib turardi.

Bonu xiyobon darvozasi oldida to'xtab qoldi.

Yuragi juda tez urardi.

Ikki yil...

Ikki yil davomida kutmagan uchrashuv bugun sodir bo'lishi kerak edi.

U asta atrofga qaradi.

Hammasi o'zgargandi.

Faqat bitta narsa o'zgarmagandi.

Bu joy Alini eslatardi.

Xiyobonning o'ng tomonidagi eski favvora. Daraxt tagidagi yog'och o'rindiq. Bahor kunlari birga muzqaymoq yegan yo'laklar...

Har bir joyda xotira bor edi.

Bonu chuqur nafas oldi.

Ammo ketishga ham oyoqlari yurmasdi.

Shu payt orqadan tanish ovoz eshitildi.

— Baribir kelding.

Bonu asta ortiga burildi.

Ali.

U qora palto kiygan, qo'llarini cho'ntagiga solib turardi.

Ko'zlari esa odatdagidek jiddiy edi.

Bir lahza ikkalasi ham jim bo'lib qolishdi.

Ba'zan inson eng ko'p sog'ingan odamiga nima deyishni bilmay ham qoladi...

Bonu nigohini olib qochdi.

— Tezroq gapir. Ishim bor. — dedi Bonu.

Ali uning gapidagi sovuqlikni sezdi.

Ammo bunga haqli ekanligini ham bilardi.

— Qalaysan?

Bonu bilinar bilinmas kulgandek bo'ldi.

— Ikki yil yo'qolib ketib, endi holimni so'rayabsanmi? — dedi Bonu.

Ali javob vaqtida topolmadi.

Shamol Bonuning sochlarini yuziga urdi.

Ali beixtiyor qo'lini uzatmoqchi bo'ldi, ammo yana to'xtadi.

Chunki ayrim yaqinliklar vaqt bilan begonalashib ketgandi.

— Men seni hafa qilganimni bilaman. — dedi Ali past ovozda.

Bonu birdan unga qaradi.

Ko'zlarida yig'ilib qolgan og'riq aniq bilinardi.

— Bilasanmi?.. Yo'q Ali, bilmaysan. — degan ovoz bilan titrab gapirardi.

— Agar bilganingda, ketmasding.

Ali chuqur xo'rsindi.

— O'shanda boshqa choram yo'q edi. — dedi Ali.

— Har doim shunday deysan.

Bonu ortiga burilib ketmoqchi bo'ldi.

Ammo Ali uni to'xtatdi.

— Iltimos... hech bo'lmasa eshit.

Bonu bir necha soniya jim turdi.

So'ng asta dedi:

— Besh daqiqa.

Ali asta boshini qimirlatib maqulladi.

Ikkalasi eski o'rindiq tomon yurishdi. Aynan shu joyda ular birinchi marta uzoq gaplashishgan edi.

O'sha kuni yomg'ir yog'ayotgandi.

Bonu soyabon olib kelmagandi.

Ali esa kurtkasini uning boshiga tutib kulgandi.

— Shamollab qolasan.

Bonu o'shanda ilk bor yuragi boshqacha urganini sezgandi.

— Otam kasal bo'lib qolgandi. — dedi Ali birdaniga. — Men birdan Toshkentga ketishga majbur bo'ldim. Ishlashim kerak edi. Oilam mendan boshqa hech kimga suyana olmasdi.

Bonu asta boshini egdi.

Ammo yuragidagi og'riq hali ham ketmagandi.

— Ketishingni tushunishim mumkin edi, Ali.

U asta unga qaradi.

— Lekin nega indamading?

Ali jim qoldi.

Bu savol eng og'iri edi.

— Men seni kutib qolishingni istamadim.

Bonu achchiq kuldi.

— Baribir kutdim.

Bu gapdan keyin ikkalasi ham jimib qoldi.

Atrofdagi shamol go'yo sekinlashgandek edi.

Bonu uzoqqa qarab qoldi.

— Bilasanmi... sen ketganingdan keyin men o'zimni aybladim. Balki yetarlicha yaxshi bo'lmagandirman deb o'yladim. Balki sendan ko'p narsa talab qilgandirman deb o'yladim...

Ali darrov boshini chayqadi.

— Yo'q, Bonu. Muammo senda emasdi.

— Unda nimada edi?!

Bonuning ovozi balandlashdi.

Ko'zlariga yosh keldi.

— Nega meni sevib turib tashlab ketding?!

Ali javob bera olmadi.

Chunki ba'zan inson eng to'g'ri deb bilgan qarori bilan eng sevgan odamining yuragini sindiradi.

Bonu asta ko'z yoshlarini artdi.

— Sen ketgan kundan beri men boshqacha bo'lib qoldim.

U kulishga urindi.

— Oldingi Bonu yo'q endi.

Ali yuragida nimadir uzilgandek his qildi.

Chunki uning qarshisida turgan qiz avvalgidan ancha sokin edi.

Ammo bu sokinlik ortida katta dard yashardi.''',
      quoteHighlight: "Chunki ba'zan inson eng to'g'ri deb bilgan qarori bilan eng sevgan odamining yuragini sindiradi.",
    ),
  ];
}
