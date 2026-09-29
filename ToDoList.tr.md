# Pixel Heist — ToDoList (Türkçe sürüm)

Document: `PH-TODO` · Revision: `2026-09-25-r13` · Design: `PH-DESIGN / 2026-09-25-r13`

Asıl kaynak: [İngilizce tasarım](docs/GameDesign.md) ve [İngilizce görev listesi](ToDoList.md). [Türkçe tasarım](docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md). AI modeller önce İngilizce dosyaları okumalıdır.

**Kapsam:** temel 1.0 oyunu fazlarla tamamlamak. İlk oynanabilir vaka, bağımsız hedef seçimi, kalıcı soygundan müzeye döngü ve üretim 3D soygun sunumu, ekonomi/kişisel profil ve mekânsal müze/dosya/haber katmanı dahil P00–P07 tamamlandı; tam oyun henüz bitmedi. **Sıradaki faz: P16 (r13 sade yeniden tasarım, 25 Eylül 2026).** P16, P08–P15'teki çelişen bekleyen görevlerin yerini alır.

**Takip:** `[x]` uygulanmış ve doğrulanmış; `[ ]` kısmen yapılmış olsa bile tamamlanmamış demektir. İki dilde kimlik/durum aynı kalır. Bitirilen işin altına kanıt eklenir. Engeli B-kimliğiyle kaydet; bağımsız işe devam et. Faz kapısı görevler ve kabul koşulu geçince tamamlanır.

**Kapsam kilidi (r13, 25 Eylül 2026):** beş perde / 20 doğrusal bölüm / bölüm başına 5 soygun = 100 soygun / 13 ekran (6 tam + 7 pencere) / yalnız İngilizce. Enerji, uyumlu beş güçlendirici stoğu (oyunda üç düğme), altın, sınırlı reklam ve satın alma r13 tasarımına göredir. r12 kilidi (140 aday, 40 kapanış işi, 20 ekran, dört dil, 600 saniyelik hız bütçesi) geçersizdir.

**Görsel kapsam güncellemesi:** hacimli piksel/küçük drone/taşıyıcı, mekânsal birinci şahıs müze gezintisi, canlı popüler kültür diliyle giriş/başarı ve temalı oyun modalları temel oyun işidir. [Görsel yön ve referanslar](docs/VisualDirection.tr.md). P01–P07 tamamlandı; sıradaki faz P08’dir. Kalan görseller ve kabul P08/P10/P11/P13 içinde sürer.

## Mevcut proje denetimi

20 Eylül 2026 ilk denetimi, P07 çalışma zamanı doğrulamasından sonra güncellendi. Çalıştırılan testler ve platform sınırları [P07 teslim raporunda](docs/P07-Implementation.md).

| Alan | Kanıt | Durum |
| --- | --- | --- |
| Godot projesi | `project.godot`, `scenes/main.tscn`; ayarda Godot 4.7; README önceki 4.7.1 doğrulamasını kaydediyor | Godot 4.7.1 temiz içe aktarma ve ana sahne P01’de doğrulandı |
| İçerik | Eski üç 15 kayıtlı dosya ve ayrı iki hikâye bulmacası/bilgisi/mekânı | 17 eser; ilk hikâye vakası altı seçenek ve sabit final içerir; kalan vakalar yazılacak |
| Bulmaca | `scripts/core/puzzle_state.gd`, `drone_routes.gd` | Paylaşılan yuva, rezervasyon, erişim, geri alma mevcut |
| Sunum | `scripts/ui/`, `scenes/ui/`, `scenes/prototypes/` | Üretim 3D tahta/ekip, giriş, dönüş, birleşme, başarı ve modal ailesi; perspektifli Camera3D müze koridoru, asansörler, yaklaşma ve hafif/azaltılmış hareket seçenekleri |
| Kayıt | `scripts/services/`, `data/content_ids.json` | Kararlı kimlik, dönüşüm, atomik kurtarma, uçuş/geri alma devamı, ayrı hız kaydı ve işlem defteri |
| Yerelleştirme | `localization/`, `scripts/services/localization.gd` | en/tr/es/de içinde 742 kararlı anahtar; kalıcı dil seçimi, bağlam, çoğul ve metin sığdırma |
| Kampanya / tam oyun | `campaign_service.gd`, `campaign_view.gd`, `campaign_targets.json` | İlk vaka, soygun sonrası akış, bağımsız yönler, kişisel profil, kredi görünümleri, on katlı müze, sergiler, dosya ve haber arşivi uygulandı; ticaret/paylaşım, diğer vakalar ve final sürüyor |
| Testler | Eski gruplara ek dil/görsel temel/kampanya ve görüntü yakalama | P08: tam kesit, tempo, hız yenileme ve içerik güncelleme grupları dahil 29 test grubu / 86.557 kontrol; dört dilde ekran/hareket incelemesi |

Benzer demo bileşeni var diye gelecekteki görev tamamlandı işaretlenmez. Mevcut README demo çalıştırma yönergesidir; yayın şartnamesi değildir.

## Faz özeti

| Faz | Bağımlılık | Teslim |
| --- | --- | --- |
| P00 | — | Tasarım ve planlama temeli |
| P01 | P00 | Tekrarlanabilir demo ve mimari sınırlar |
| P02 | P01 | Kararlı içerik kimliği, kayıt ve devam |
| P03 | P02 | Dört dil ve görsel temel |
| P04 | P02, P03 | Hedef ödünleşmeleri ve kampanya seçimi |
| P05 | P02, P03, P04 | Soygundan müzeye tam akış |
| P06 | P02, P04, P05 | Ekonomi, dört yön ve kişisel hatıralar |
| P07 | P03, P05, P06 | Müze, sergiler, dosya ve haberler |
| P08 | P01–P07 | Oynanabilir tam kesit ve tasarım doğrulaması |
| P09 | P02, P03, P06, P08; live integration also B03–B06 | Atölye, kalıcı satın alma ve reklam ödülü |
| P10 | P03, P07, P08 | Kişisel paylaşım ve dışa aktarma |
| P11 | P08; localization from P03 | İçerik üretim hattı ve ilk üç level |
| P12 | P11 | Beş perdelik kampanya ve finallerin tamamı |
| P13 | P09–P12; B01, B02, B06 | Cihaz performansı, erişilebilirlik ve son dil kontrolü |
| P14 | P13; B01–B08 | Yayın adayı ve mağaza hazırlığı |
| P15 | P14; successful distribution | Yayın doğrulaması ve bakım devri |
| P16 | P02, P05, P07; r13 tasarımı | r13 sade yeniden tasarım: en az ekran, doğrusal hikâye, ekonomi |

Faz numarası çalışma sırasıdır, oyun levelı değildir. P09/P10 kesitten sonra içerik çalışmasından bağımsız ilerleyebilir. Denetimde mevcut olduğu belirtilmeyen yeni çalışma zamanı bileşenleri **planlanmıştır**.

## P00 — Tasarım ve planlama temeli

**Bağımlılıklar:** —  
**Dosyalar / çıktılar:** docs/GameDesign.md; docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md; ToDoList.md; ToDoList.tr.md; AGENTS.md

- [x] **P00-01** — İngilizce asıl tasarımı ve Türkçe karşılığını 2026-09-20-r3 revizyonuyla hazırla.
- [x] **P00-02** — Birlikte yükselen teklif/ün örneklerini dört bağımsız motivasyon ve açık fırsat bedelleriyle değiştir.
- [x] **P00-03** — Global kadroyu, en/tr/es/de çıkış dillerini ve yerelleştirme gereksinimlerini tanımla.
- [x] **P00-04** — Gerçek projeyi incele; mevcut demo özelliklerini planlanan üretim sistemlerinden ayır.
- [x] **P00-05** — Eşlenik fazlı görev listelerini ve AI için önce İngilizce okuma girişini oluştur.
- [x] **P00-06** — Belge bağlantılarını, revizyonları, görev kimlik/durumlarını, ekranları, kadroyu ve kampanya toplamlarını doğrula.

**Kabul kapısı:** İki tasarım ve görev listesi gereksinim, kimlik, durum, kadro, ekran ve içerik sayısında tutarlı. Bu kapı yalnız dokümantasyonu doğrular.

Kanıt: tasarım/görev dosyaları, `project.godot`, `scripts/main.gd`, bulmaca/UI kodu ve 15 kayıtlı üç veri dosyasının incelemesi. Yapısal eşlik için `python3 tools/validate_planning_docs.py` çalıştır. Bu kontrol ana dil incelemesi veya çalışma zamanı testi yerine geçmez.

## P01 — Tekrarlanabilir demo ve mimari sınırlar

**Bağımlılıklar:** P00  
**Dosyalar / çıktılar:** project.godot; scenes/main.tscn; scripts/main.gd; tests/; tools/

- [x] **P01-01** — Büyük değişikliklerden önce çalışan Godot sürümünü, komutu, içe/dışa aktarma gereksinimlerini ve sürüm kontrol/yedekleme düzenini kaydet.
- [x] **P01-02** — Mevcut puzzle, flow, drones, expansion, museum, columns, bottom_entry, boost, anticipation ve ambience testlerini çalıştır; log ve platform sınırlarını kaydet.
- [x] **P01-03** — Gerçek çizicide ana ekran/soygun/müze görüntülerini al, sc referanslarını incele; korunacak düzeni ve mekanik sözleşmesini kaydet.
- [x] **P01-04** — Mevcut davranışı kampanya, kayıt, ekonomi, anlatı, dil, ticaret ve paylaşım sorumluluklarına ayır; davranış denetimiyle kademeli düzenle.
- [x] **P01-05** — Oyuncu kaydı yerine yalıtılmış geçici kayıt kullanan deterministik test verisi ve tekrarlanabilir proje doğrulama komutu ekle.
- [x] **P01-06** — Masaüstü/mobil yetenek arayüzlerini ve sağlayıcı yokken davranışı tanımla; dış SDK kodunu bulmaca kurallarından ayır.

**Kabul kapısı:** Temiz kopya kararlaştırılan Godot sürümünde açılır, düzenlenebilir ana sahne görünür, mevcut testler çalışır ve bulmaca davranışı korunur.

Kanıt: [P01 teslim raporu](docs/P01-Implementation.md), [geliştirme/yedekleme düzeni](docs/Development.md), [mimari sınırlar](docs/Architecture.md). Godot 4.7.1 temiz içe aktarma/açılış geçti; on eski test ve yeni servis testi başarılı (15.146 kontrol). Gerçek çizicide altı ekran durumu ve dört sc referansı incelendi. Log, görüntü ve kaynak özetleri: `artifacts/validation/p01-validation/`; son çalıştırıcı doğrulaması: `artifacts/validation/p01-final/`. Kayıt biçimi ve bulmaca kuralları korundu. Cihaz doğrulaması bekliyor; P02 kayıt/devam kanıtı aşağıdadır.

## P02 — Kararlı içerik kimliği, kayıt ve devam

**Bağımlılıklar:** P01  
**Dosyalar / çıktılar:** scripts/main.gd; scripts/core/puzzle_state.gd; data/*.json; planned SaveService and content schemas

- [x] **P02-01** — Sürümlü şemaları ve art_id, level_id, character_id, event_id, pack_id kimliklerini tanımla; 15 eski sayısal indeksi açıkça eşle.
- [x] **P02-02** — Kampanya adımları, edinilmiş eserler, güncel sahiplik, fiziksel/anı sergisi, kanıt, etiket, haber, cüzdan ve gelişim kazanımlarını ayır.
- [x] **P02-03** — Atomik kayıt/yedek, şema dönüşümü, doğrulama, bozuk kayıt kurtarma ve açık demo/hikâye modu ayrımını uygula.
- [x] **P02-04** — Yarım soygunun tahta, kuyruk, taşıyıcı, ayrılmış/alınmış/teslim piksel aşaması, kuyruk süreleri, sabit gizli kutuları ve geri alma anlık durumunu kaydet.
- [x] **P02-05** — Uçuş görsellerini kayıtlı mantıksal durumdan güvenle sürdür; alınmış pikseli yeniden ödüllendirme veya teslim yükünü tekrar taşıma.
- [x] **P02-06** — Gerçek zamanlı hız harcamasını geri almadan ayır; güvenli nokta, arka plana geçiş, çıkış ve süre bitiminde kaydet.
- [x] **P02-07** — Tamamlama, inceleme, eser kararı, ödül, paket ve reklam için tekrara dayanıklı işlem kimlikleri oluştur; kesilen/tekrarlanan geri çağrıları test et.

**Kabul kapısı:** Eski demo kaydı kayıpsız dönüşür; alım, teslim, inceleme ve satış sırasında kapat/aç piksel, eser, kredi veya hız hakkını kaybetmez/çoğaltmaz.

Kanıt: [P02 teslim raporu](docs/P02-Implementation.md), [şema ve devam sözleşmesi](docs/Persistence.md). Yedi görev; yalıtılmış dönüşüm/kurtarma kayıtları, alma/teslim sırasında ve altı işlem türünün üç yazma aşamasında gerçek süreç sonlandırma, tekrarlanan bildirim ve 15 eserin kayıt/devam kontrolleriyle uygulandı. Destekleyici çalışma zamanı kanıtı: `artifacts/validation/p02-callbacks/`; tam kontrol: `artifacts/validation/p02-final/`. İnceleme/ekonomi/ticaret oyuncu akışları P05/P06/P09 işleridir; canlı sağlayıcı açılmadı. Mobil yaşam döngüsü ve depolama performansı cihazda doğrulanmalıdır.

## P03 — Dört dil ve görsel temel

**Bağımlılıklar:** P02  
**Dosyalar / çıktılar:** project.godot; scripts/; scenes/; data/; localization/; docs/Localization.md; docs/RenderingDecision.md; scenes/prototypes/

- [x] **P03-01** — Oyuncuya görünen sahne/kod/içerik metinlerini kararlı anahtar ve İngilizce kaynağa taşı; bağlam/çoğul destekli CSV/gettext iş akışını seç.
- [x] **P03-02** — en/tr/es/de kataloglarını, İngilizce geri dönüşü, desteklenen cihaz dili varsayılanını ve kalıcı elle dil seçimini ekle.
- [x] **P03-03** — Kanonik kadro ve konuşmacı kimliklerini gerçek sanatçı/yer adlarını değiştirmeden taşı; çevrilmeyen konuşmacı verisinde sır açığa çıkarma.
- [x] **P03-04** — Adlandırılmış yer tutucu, doğru çoğul ve yerel sayı biçimi kullan; mağaza ülke/fiyatını seçilen dilden türetme.
- [x] **P03-05** — Fontları, Türkçe büyük/küçük harfi, İspanyolca noktalama işaretlerini, uzun Almanca metni, canlı yerleşimi ve sahte çevirili ekranları denetle.
- [x] **P03-06** — Gelecek hikâye/mağaza metinleri için eksik anahtar, yer tutucu ve dil eşliği denetimleri ile bağlam sözlüğü ekle.

- [x] **P03-07** — Canlı tasarım oyuncağı/popüler kültür görsel sistemini tanımla: hacim, ışık, malzeme, tipografi, palet, özgün motif ve ortak düğme/modal durumları; docs/VisualDirection.tr.md esas alınır.
- [x] **P03-08** — Hacimli tablo pikseli, küçük drone, beş taşıyıcı ve perspektifli müze odasını prototiple; 2D bulmaca durumunu koruyarak gerçek zamanlı 3D ile 2.5D üretim maliyetini karşılaştır.
- [x] **P03-09** — Giriş, soygun, müze, temalı modal ve başarı için ayrıntılı taslaklar ile kısa hareket denemesi hazırla; P05/P07 görsellerinden önce çizim yöntemini belirle.

**Kabul kapısı:** Mevcut 15 eserlik demo en/tr/es/de arasında karışık dil, eksik anahtar, değişen kayıt, bozuk yer tutucu veya kesik denetim olmadan geçer. Görsel taslak ve temsilci hacim prototipi de P05/P07 öncesinde okunaklı malzemeyi ve müze kamera yaklaşımını belirler.

Kanıt: [P03 teslim raporu](docs/P03-Implementation.md), [dil sözleşmesi/sözlüğü](docs/Localization.md), [çizim kararı](docs/RenderingDecision.md). Dokuz görev uygulandı: dört katalogda 352 anahtar, kalıcı dil seçimi, kanonik görünen konuşmacı adları, yerleşim/glif kontrolleri, ortak görsel değerler, aynı bulmaca durumunda iki çizici, beş çerçeveli perspektifli oda, beş ekran çalışması ve 16 saniyelik hareket kaydı. Tam oyun/kayıt kontrolü: `artifacts/validation/p03-final/`; son prototip düzeltmesi: `artifacts/validation/p03-presentation-final/`. Üretim görselleri P05/P07; anadil editörlüğü ve gerçek cihaz performansı P11/P13 işleridir.

## P04 — Hedef ödünleşmeleri ve kampanya seçimi

**Bağımlılıklar:** P02, P03  
**Dosyalar / çıktılar:** S03–S05; scripts/ui/campaign_view.gd; scripts/services/campaign_service.gd; data/campaign_targets.json; story_* verisi; tests/

- [x] **P04-01** — Bağımsız teklif aralığı, sabit tanınırlık, yazılmış araştırma bağı, etiket ve bağlamsal sergi uyumunu hedef verisine ekle.
- [x] **P04-02** — İlk level için pahalı/az bilinen ve meşhur/düşük teklif örnekleri içeren altı seçilebilir hedef ile bir final yaz.
- [x] **P04-03** — Üç farklı öneri ve ücretsiz Diğer adayları uygula; satın alınan temayı değil gerçek koleksiyonu değerlendir.
- [x] **P04-04** — Satarsan beklenen teklif, araştırma/sergi gerekçesi, anlamlı kazanç ve fırsat bedelini göster; boş koleksiyon ve azalan adayları dürüstçe ele al.
- [x] **P04-05** — Teklif aralığı karşılaştırmalı baskınlık ve bağımsız eksen doğrulaması ekle; zayıf farkı uyar, canlı sahte bonus yaratma.
- [x] **P04-06** — Dört farklı seçmeli iş, sabit final açılışı, ertelenen iki eser ve ayrı tümü açık demo davranışını uygula.
- [x] **P04-07** — Her level için 360 seçim sırasını kampanya durumunda dene; tam bulmaca akışını örnekle ve dört tek-motivasyon stratejisini simüle et.

**Kabul kapısı:** Oyuncu tek evrensel en iyi kart olmadan servet/şöhret/araştırma/koleksiyonu karşılaştırır; tüm geçerli altıdan dört seçim sırası sabit finale ulaşır.

Kanıt: [P04 teslim raporu](docs/P04-Implementation.md) ve [kampanya sözleşmesi](docs/Campaign.md). `artifacts/validation/p04-verified/` içinde temiz içe aktarma/açılış, 17 test grubu / 26.671 kontrol ve 89 görüntü geçti. Yazılmış tek vakanın 360 sırasının tamamı sabit finale ulaşıyor; dört tek-motivasyon stratejisi, eklenen iki bulmaca ve finalin gerçek uçuşları geçiyor. Eski demonun mekanik/verisi ve kayıtları korundu. Toplam 17 bulmaca tanımı ve dört dilde 459 anahtar var. Diğer 19 vaka başlığında içeriğin bulunmadığı açıklanır; yazımları ve 360 sıra kontrolleri P11/P12 işidir. Sıradaki faz P05; tüm kampanya finali, satış akışı, üretim müzesi veya yayın tamamlandı denmez.

## P05 — Soygundan müzeye tam akış

**Bağımlılıklar:** P02, P03, P04  
**Dosyalar / çıktılar:** S01, S06–S11, S17; scenes/; planned transition/narrative views

- [x] **P05-01** — 20 ekranın düzenlenebilir sahne iskeletini ve gezinme/geri kurallarını kur; bu fazın ekranlarını yükleme/boş/hata durumlarıyla uygula.
- [x] **P05-02** — Başarı gösteriminden önce tamamlamayı kaydet, tek ana devam eylemi göster; isteğe bağlı bildirimleri üst üste modal açmadan sırala.
- [x] **P05-03** — Kozmetik bağlantısı, atlama, azaltılmış hareket, durmuş hız süresi ve en fazla iki balonla şehir temalı araç dönüşünü uygula.
- [x] **P05-04** — Hızlı birleşme ve dört yazılmış inceleme sonucunu uygula; satmadan kanıtı arşivle, uydurma kesin ipucu gösterme.
- [x] **P05-05** — Tut/sat/iade/emanet uygunluğunu, tek sonuç onayını, Şimdilik depoya koy ve bekleyen incelemeye devamı uygula.
- [x] **P05-06** — Aktif seçimi kesmeden geri dönen oyuncu özeti, ilk iş öğretimi, duraklama/kilit açıklaması ve dil uyumlu erişilebilir ayarları ekle.

- [x] **P05-07** — Tablo piksellerini üst/yan yüzey ve temas gölgeli pahlı blok olarak çiz; alımda alt tepsiyi ve yükseliği göster, doluluk/erişim kuralını değiştirme.
- [x] **P05-08** — Hacimli küçük drone gövdesi, pervane yuvası, malzeme ışığı ve manyetik kaldırılan yük oluştur; en yakın erişilebilir hedefi, kendi taşıyıcısına dönüşü ve ASMR zamanını koru.
- [x] **P05-09** — Büyük sayılı tam hacimli taşıyıcı drone ve biçimli yuva oluştur; sırada/beklerken pervane kapalı, ilk kalkışta açık olur; sıfır yük kameraya yükselip yandan çıkar.
- [x] **P05-10** — Düz giriş yerine hacimli logo, hareketli gece soygunu dioraması, imza drone ve belirgin Oyna/Devam Et kur; açılış için girdiyi bekletme.
- [x] **P05-11** — Hazırlık, inceleme, haber, başarı, ayar ve eser kararı/satın alma için ortak oyun modalı ailesi uygula: resimli başlık, dokunulası düğme, derinlik, güvenli odak/geri ve dört dilde kaydırma düzeni.
- [x] **P05-12** — S08 son teslim → eser gösterimi → başarı rozeti/drone konfeti → temel ödül/Devam akışını erken atlama, yumuşak ses ve azaltılmış hareketle kur; S18 için kişisel müze finali hazırla.

**Kabul kapısı:** Bir tamamlanmış soygun başarı, atlanabilir dönüş, birleşme, inceleme, eser kararı ve müzeyi her aşamada doğru kayıtla tamamlar. Hacimli tahta/ekip, tasarlanmış giriş, temalı modal ve başarı akışı bulmaca sonucunu değiştirmeden görsel şartı karşılar.

Kanıt: [P05 teslim raporu](docs/P05-Implementation.md). `artifacts/validation/p05-final/` içinde temiz içe aktarma/açılış, 19 test grubu / 27.229 kontrol, 167 görüntü ve 10,5 saniye hareket geçti. Son giriş düzeltmesi `artifacts/validation/p05-presentation-final/` içinde doğrulandı. Tamamlama, yazılmış inceleme ve satış üç yazma aşamasındaki gerçek süreç sonlandırmalarından kurtuluyor. Dört dilde akış, uygun kararlar, arşiv kanıtı, soğuk açılışta devam, dokunma alanı izdüşümü ve GPU piksel kaldırma geçti. 534 yerelleştirilmiş anahtar var. S18 kayıt verisine dayalı sunumdur; tam final yolu P12’ye kadar kilitlidir. Haber/satın alma ortak bileşen iskeletleri test edildi; içerik/sağlayıcıları P07/P09 işleridir. Yalnız ilk vaka yazılmıştır. Sıradaki faz P06; gerçek cihaz performansı, anadil editörlüğü ve gözlemlenen oyuncu testleri açıktır.

## P06 — Ekonomi, dört yön ve kişisel hatıralar

**Bağımlılıklar:** P02, P04, P05  
**Dosyalar / çıktılar:** S11, S12, S15, S19; ekonomi servisi/panelleri; data/economy.json; ekonomi testleri/görüntüleri

- [x] **P06-01** — Tek harcanabilir kredi cüzdanı, temel iş ödemesi ve yazılmış alıcı tekliflerini uygula; koşullu satış gelirini ayrı göster.
- [x] **P06-02** — Yalnız wealth/renown/insight/curation yönlerini uygula; kişi güvenini ayrı tut ve eski dört beceri varsayımını kaldır.
- [x] **P06-03** — Reklam kredisi, ücretli kozmetik ve test hibelerini ömür boyu Servetten çıkar; harcamada Serveti azaltma.
- [x] **P06-04** — İlk olay kazanım defteri, yön basamak dengesi ve masterwork_eligible işleri tanımla; tekrar, geri alma, sergi yeniden kurma ve satış döngüsünü test et.
- [x] **P06-05** — Altı kişisel etiketi, eser başına tek ana etiketi, üç sabitlenmiş işi ve seçime dayalı profil özetlerini uygula.
- [x] **P06-06** — Kredi dekor fiyatlarını ve ilk anlamlı ücretsiz alımı yaz; tutma, satış, araştırma ve şöhret ağırlıklı ekonomileri simüle et.

**Kabul kapısı:** Tutma, satma, iade ve araştırma görünür bedeller yaratır; ücretsiz oyun kopya kazanım veya stat kilidi olmadan kampanyayı bitirir.

Kanıt: [P06 teslim raporu](docs/P06-Implementation.md) ve [ekonomi sözleşmesi](docs/Economy.md). `artifacts/validation/p06-regression/` içinde 21 test grubu / 85.454 kontrol ve 235 görüntü geçti; son sabitleme hatası bildirimi `p06-final-check/` içinde 117 ekonomi kontrolüyle doğrulandı. Dört yaklaşım × ilk vakanın 360 sırası ücretli/reklam geliri veya stat kilidi olmadan tamamlanıyor. Altı etiket, üç sabit iş, beşer unvanlı dört yön, ayrı kişi güveni ve altı kredi görünümü 622 en/tr/es/de anahtarıyla uygulandı. Atomik alım kesintisi, P05 dönüşümü, gerçek uçuşta tekrar/geri alma ve fiziksel eser/anı kazanımları geçti. Yalnız ilk vaka yazılmıştır: 100 ücret hesabı açıkça sentetik projeksiyondur; tam kampanya dengesi/tamamlanması P08/P11/P12/P13’te sürer. Sıradaki faz P07.

## P07 — Müze, sergiler, dosya ve haberler

**Bağımlılıklar:** P03, P05, P06  
**Dosyalar / çıktılar:** S02, S12–S16; scripts/ui/gallery.gd; scenes/ui/gallery.tscn; planned archive/news data

- [x] **P07-01** — Level kimliğini müze katı/eser indeksinden ayır; on kat/beş çerçeve, 140+ depo ve mevcut asansör hareketini destekle.
- [x] **P07-02** — Özgün, satılmış, iade, emanet ve anı sergisi durumlarını uygula; fotoğraf fiziksel koleksiyon koşulunu karşılamasın.
- [x] **P07-03** — Tema seçimi, dokunarak yerleştirme/sürükleme seçenekleri, ilk sergi başarıları ve güncel/geçmiş tamamlanma ayrımını uygula.
- [x] **P07-04** — Kaynaklı gerçek eser bilgisini kurmaca görev sahipliğinden ayrı, kategori/etiket ve yerel okuma düzeniyle kur.
- [x] **P07-05** — Beş parçalı dosyayı otomatik doğrulanmış bağlantı, bilinen/bilinmeyen özeti ve isteğe bağlı özel notla kur.
- [x] **P07-06** — Yazılmış haber tetiklerini, farklı sesleri, kalıcı arşivi, isteğe bağlı albümü, üç öne çıkan kupürü ve tekil kazanımı uygula.

- [x] **P07-07** — Zemin/duvar derinliği, kalın çerçeve, spot ve hacimli asansör girişleriyle mekânsal Gece Müzesi odası kur; beş konum ve hırsız figürsüz birinci şahıs görünümü koru.
- [x] **P07-08** — Paralakslı kontrollü perspektif kamera ile koridor gezintisi, esere yaklaşma/geri dönüş ve asansöre giriş uygula; kat/odak/seçili çerçeveyi koru, dokunma ve klavye sun.
- [x] **P07-09** — Hareket konforu ve düşük kalite oda seçeneklerini uygula: varsayılan baş sallama yok, kısa/kararmalı geçiş, azaltılmış gölge maliyeti ve görünür hacim; belirsiz düz kart listesine dönme.

**Kabul kapısı:** Oyuncu on bağımsız katı düzenler, özgün eser/anıyı inceler, dosya/haber okur ve sahipliği kaybetmeden sonraki işe döner. Kamera gezintisi, esere yaklaşma ve asansöre giriş normal/azaltılmış harekette oda derinliğini görünür kılar.

Kanıt: [P07 teslim raporu](docs/P07-Implementation.md) ve [eser kaydı kaynak denetimi](docs/P07-ArtSources.md). `artifacts/validation/p07-final/` içinde temiz içe aktarma/açılış ve 25 test grubu / 86.288 kontrol sıfır hatayla geçti (Godot 4.7.1, yalıtılmış kayıtlar). `p07-museum-faults/` 180 eserlik depo, 50 çerçeve kimliği, fiziksel/anı kuralı, satış/emanet/iade, dönüşüm ve yerleştirme sırasında üç atomik yazma aşamasında süreç sonlandırmayı kapsar. `p07-visual-linux/` en/tr/es/de ve yapay uzatılmış metinde 184 görüntü ile müze hareket kaydını içerir; incelemede kesilme veya eksik anahtar bulunmadı. Eski 15 çerçeve düzenine ve katı emanet yönü eşitliğine göre yazılmış dört test beklentisi on kat sözleşmesine ve tek seferlik koleksiyonculuk kazanımlarına göre düzeltildi. Görüntüler yazılımsal çiziciyle (Mesa llvmpipe) alındı; gerçek GPU/cihaz kare maliyeti, gözlenen kullanılabilirlik ve anadil incelemesi P08/P11/P13’te sürer. Yalnız ilk vaka yazılmıştır; tam kampanya haber/parçaları P12 işidir. Sıradaki faz P08.

## P08 — Oynanabilir tam kesit ve tasarım doğrulaması

**Bağımlılıklar:** P01–P07  
**Dosyalar / çıktılar:** One complete level/seven candidates; artifacts/; new playtest report

- [ ] **P08-01** — İlk level eserlerini, yazılmış kuyrukları, dört ortak adımı, finali ve ertelenen iki hedefi temsil edici kalitede tamamla.
- [x] **P08-02** — Yeni ve dönüşmüş demo kaydıyla seçim, bulmaca, hikâye, ekonomi ve müzeyi kapsayan tam kesiti çalıştır.
- [x] **P08-03** — Tüm ekran durumlarını sc kaynaklı etkileşim düzeni ve güncel görsel yönle karşılaştır; kesilme, kontrast ve girdi sorunlarını kaydet/düzelt.
- [ ] **P08-04** — Gerçek oyuncuların bağımsız motivasyonlar arasında seçimini gözle; yalnız tıklama sayısı yerine gerekçelerini topla.
- [x] **P08-05** — İş süresi, çalışmayan bekleme, 3× bitişi ve tekrarlanan geçiş toleransını ölç; temel kuralları gizlice değiştirmeden içerik/tempoyu düzelt.
- [ ] **P08-06** — Kalan kataloğu üretmeden kesit kapısını kanıtla doğrula; çözümsüz konuları kimlikli görevlere taşı.

- [x] **P08-07** — Varlıkları çoğaltmadan hacimli piksel/küçük drone/taşıyıcı, perspektifli müze, giriş, uzun içerikli temalı modal ve başarının normal/azaltılmış hareket görüntü ve kayıtlarını incele.
- [x] **P08-08** — Yeni görsel katmanın çözüm sonuçlarını, dokunma hedefini, beş yuva okunaklılığını, gizli/açık kutuyu, kapalı kenar rotasını ve bağımsız ödül/hız zamanını koruduğunu doğrula.
- [ ] **P08-09** — Soygun ekranını (S06) onaylı "Bit'lerin gece soygunu" oyuncak diline (arka plan, HUD, eser çerçevesi, taşıyıcılar, alt bar) `artifacts/artifacts/heist-v2-level1.png` referansına göre yeniden çiz; tüm bulmaca/kayıt/dokunma hedefi kuralları ve mevcut test sonuçları değişmesin.

**Kabul kapısı:** Dört dilde beş işlik tam dosya çalışır; gözlenen oyuncular bedelleri açıklar, dönüş akışını sever ve sonraki eylemi bulur. Toplu varlık üretiminden önce sabit ve hareketli kanıt görsel yön kabulünü geçmelidir.

Kanıt (sürüyor): [P08 raporu](docs/P08-Implementation.md) ve [oyuncu testi yönergesi](docs/P08-Playtest.md). `artifacts/validation/p08-final-a/`–`c/` 27 test grubu / 86.468 kontrolden geçer. `test_slice.gd` (93 kontrol) ilk vakayı yeni hikâye kaydı ve dönüştürülmüş demo kaydıyla dört dilde tüm ekranlardan geçirerek bitirir. `test_slice_tempo.gd` (87 kontrol) 17 tahtanın hepsinde hız ve azaltılmış hareketin sonucu değiştirmediğini kanıtlar, dokunma alanı ve yuva ayrımını denetler, tempoyu kaydeder. Ekran/hareket incelemesinde S16 düğme metninin küçülmesi ve iki görüntü düzeneği hatası bulunup düzeltildi. 23 Eylül kullanıcı kararları uygulandı ve `p08r2-final-a/`, `-b2/`, `-c/` içinde doğrulandı (29 test grubu / 86.557 kontrol): temel tempo iki katına çıktı; biten 3× hakkı 240 kazanılmış krediye 120 saniye yenilenebilir (kalıcı dönem defteri); Güneş Mührü ve Safir Kupa için yalnız hikâyede 432/418 piksellik tahtalar; kuyruk üreticisi ve testler üst üste oynamada kilitlenen rotaları reddeder (dört Level 3 tahtası yeniden üretildi); değişen tahta kaydı kilitlemez, yalnız ilgili yarım soygunu bırakır. Kalan: P08-01 — Fildişi Seyahat Saati ve Atölye Numuneleri artık kısa tahtalardır (≈1,5 dk) ve ara sahneler tek satırdır; P08-04/P08-06 gözlenen oyuncu ister.

## P09 — Atölye, kalıcı satın alma ve reklam ödülü

**Bağımlılıklar:** P02, P03, P06, P08; live integration also B03–B06  
**Dosyalar / çıktılar:** S08, S19; planned commerce adapters/ledger; platform configuration

- [ ] **P09-01** — Krediyle dekor kataloğunu ve iki açık içerikli kalıcı paketi kur: Night Signature ve Art Deco Salon; görev rengi okunaklılığını koru.
- [ ] **P09-02** — Kendi müze/drone/araç önizlemesini geri alınabilir ve sahiplik duyarlı yap; ilk çıkışta kopya/çakışan paket kullanma.
- [ ] **P09-03** — Önce sahte sağlayıcı, sonra yerel fiyat, bekleme/iptal/hata/başarı, geri yükleme ve iade/iptal hak uzlaşması içeren doğrulanmış platform ödeme arayüzü kullan.
- [ ] **P09-04** — Paket doğrulaması, güvenli platform işlemi, çevrimdışı son bilinen sahiplik ve cihazlar/hesaplar arası sınırları açıkça tanımla.
- [ ] **P09-05** — İlk soygunda gösterilmeyen, iş başına bir ödüllü ve önerilen günde iki/UTC sınırına sahip tek isteğe bağlı reklam yerini uygula.
- [ ] **P09-06** — Yalnız doğrulanmış reklam bonusunu ver; kopya/geç olay ve gün sınırını uzlaştır, ses/oyun/hızı durdur, yok/çevrimdışı/iptal yollarını test reklamıyla dene.
- [ ] **P09-07** — Canlı kimlikten önce kitle/gizlilik ayarını ve sağlayıcı davranışını doğrula; ödeme hatası/reklam reddini kampanya kilidi yapma.

**Kabul kapısı:** Deneme satın alma/geri yükleme/iade ve reklam hataları doğru; temel oyun çevrimdışı kullanılabilir; testte canlı ödeme oluşmaz.

## P10 — Kişisel paylaşım ve dışa aktarma

**Bağımlılıklar:** P03, P07, P08  
**Dosyalar / çıktılar:** S20; S08/S12/S14/S15 entry points; planned sharing adapter

- [ ] **P10-01** — Gerçek kayıt verisiyle ücretsiz soygun manşeti, beş eserlik sergi ve eser kararı hatıra şablonlarını uygula.
- [ ] **P10-02** — Yerel önizleme, isteğe bağlı çağrı adı, açık sahiplik etiketi, oyun imzası ve uygun paylaşım boyunda güvenli görsel dışa aktarımı ekle.
- [ ] **P10-03** — İptal/hata ve masaüstü alternatifiyle platform paylaş/kaydet arayüzü kur; otomatik gönderme veya ödül için paylaşımı şart koşma.
- [ ] **P10-04** — Sır içermeyen şablon ve özel veri dışlamasını doğrula; paylaşım ekranı açılmasını dışarıda gönderildi sayma.
- [ ] **P10-05** — Hedefler varsa yalnız doğrulanmış mağaza/eser önizleme bağlantısı ekle; kapalı levelı atlatma veya uygulanmamış kurulum sonrası dönüş sözü verme.

- [ ] **P10-06** — Gerçek eser rengi, sahiplik ve sır korumasını sürdürerek paylaşım kartlarına özgün popüler kültür/çıkartma tipografisi ve hacimli müze/ekip çerçevesi uygula.

**Kabul kapısı:** Kart gerçek seçimi yansıtır, yerel kaydedilir ve otomatik gönderim/özel not/sır sızıntısı olmadan desteklenen paylaşım ekranını açar.

## P11 — İçerik üretim hattı ve ilk üç level

**Bağımlılıklar:** P08; localization from P03  
**Dosyalar / çıktılar:** data/; tools/build_content.py; tools/rebuild_queues.gd; tools/chapter_two.py; tools/chapter_three.py; asset credits

- [ ] **P11-01** — Eser/hak/kaynak kaydı, görsel taslak, kurmaca görev, dört eksen, tema, bulmaca parametresi ve sabit kanıt kimliği içeren onaylı katalog şeması oluştur.
- [ ] **P11-02** — Mevcut 15 eseri koruyarak taşı, altı aday ekle; üretim girdisiyle üretilen çıktıyı ayır.
- [ ] **P11-03** — Üretilen her tahtada palet okunaklılığı, renk başına kapasite dengesi, rota uygunluğu, referans çözüm ve gerçek drone tamamlanmasını otomatik denetle.
- [ ] **P11-04** — İlk üç levelin İngilizce son metinlerini/eser bilgilerini ve dört dil içeriğini yaz; gerçek bilgiyi birincil müze kaynağıyla doğrula.
- [ ] **P11-05** — Her eser, font, şehir deseni, ses ve paket parçası için kullanım hakkı/atıf ve özgün kurmaca etiketlerini tut.
- [ ] **P11-06** — Her yeni eseri 1×/3× ve alttan giriş/bekleyen renk durumlarında oyna/incele; gözlemle zorluğu ayarla.

- [ ] **P11-07** — Ölçülmüş kalite kademeleriyle tekrar kullanılabilir pahlı piksel malzemesi, drone/taşıyıcı varyantı, modüler oda/asansör ve resimli modal/düğme varlıkları oluştur; kanonik renk ve kaynaklar düzenlenebilir kalsın.

**Kabul kapısı:** 21 aday ve 15 ana iş tamam, çözülebilir, yerelleştirilmiş ve hikâyeyle tutarlı; yeniden üretim yazılmış değişiklikleri silmez.

## P12 — Beş perdelik kampanya ve finallerin tamamı

**Bağımlılıklar:** P11  
**Dosyalar / çıktılar:** Level catalog; narrative/news/exhibition data; S17, S18

- [ ] **P12-01** — Level 8 sonuna genişlet: 56 aday/40 ana iş, ilk iki perde ve Level 2/6 parçaları.
- [ ] **P12-02** — Level 12 sonuna genişlet: 84 aday/60 ana iş, 10’da Mr. Frost kimliği ve 11–12’de insan ilişkisi/sergi.
- [ ] **P12-03** — Level 16 sonuna genişlet: 112 aday/80 ana iş, basın sonuçları, 15’te parça ve emanet alternatifi.
- [ ] **P12-04** — Level 17–20’yi bitir: 140 aday/100 ana iş, 19’da cihaz geçmişi, 20’de beşinci parça ve kesin sonuç.
- [ ] **P12-05** — Üç final yaklaşımını önceki satış/iade/tutma/yayın farklılıkları ve gerçek son müze düzeniyle uygula.
- [ ] **P12-06** — Ertelenen 40 tamamlayıcı işi ve final sonrası bağlamını yaz; ana kanıtı tekrar verme veya finali geriye dönük değiştirme.
- [ ] **P12-07** — 20 final haberi, yaklaşık 25 olay haberi, sergi temaları, etiket ve dört dil kataloğunu süreklilik/hak incelemesiyle tamamla.
- [ ] **P12-08** — Kampanya seçim sıralarını, dört motivasyon ekonomi simülasyonunu, her tahta çözümünü ve perde/final başına uçtan uca örnekleri çalıştır.

**Kabul kapısı:** 140 farklı aday 100 ana ve 40 hikâye sonrası işi destekler; üç final gizemi çözer ve önceki kararları yansıtır.

## P13 — Cihaz performansı, erişilebilirlik ve son dil kontrolü

**Bağımlılıklar:** P09–P12; B01, B02, B06  
**Dosyalar / çıktılar:** Exports; device captures; full test suite; localization catalogs; audio/assets

- [ ] **P13-01** — Gerçek minimum/temsilci cihaz ve bütçeleri seç; FPS/kare süresi, bellek, ısınma/pil, yükleme ve paket boyutunu ölç.
- [ ] **P13-02** — Tüm kritik akışta güvenli alan, uzun/dar ekran, dokunma hedefi, çoklu dokunma/iptal, arka plan/devam ve OS kesintisini dene.
- [ ] **P13-03** — Metin ölçeği, kontrast, odak/klavye, azaltılmış hareket ve bağımsız ses/müziği doğrula; sayıları harfle değiştirmeden erişilebilir renk ayrımı sun.
- [ ] **P13-04** — Ana dil editörlerine en/tr/es/de diyalog, eser bağlamı, espri, sözlük, mağaza ve tüm ekran kesilmelerini kontrol ettir; eksik metinleri tamamla.
- [ ] **P13-05** — Hoparlör/kulaklıkta ses tepe/miks ve tekrarlı ASMR dinleme kontrolü yap; üst üste drone alımlarında yumuşaklığı koru.
- [ ] **P13-06** — Bozuk kayıt/dönüşüm, dolu depo, sıfır hız hakkı, kesilen satın alma/reklam/paylaşım, çevrimdışı açılış ve uzun oturumları zorla; hatayı düzeltip ilgili regresyonu dene.
- [ ] **P13-07** — Tam kampanya oyuncu oturumuyla 10–16 saat hedefi ve ödünleşme kanıtını yeniden değerlendir; otomatik testle ilgi/gelir doğrulandı deme.

- [ ] **P13-08** — Hedef cihazda tam tahta hacim çizimi, eşzamanlı dronelar, beş taşıyıcı, müze kamera geçişi ve başarı parçacığını ölç; pikseli saklamadan/simülasyon zamanını değiştirmeden maliyeti düşür.
- [ ] **P13-09** — En küçük ekranda dokunulası modal/düğme durumunu, ışık altında renk kimliğini, dört dil metin uzamasını, hacim okunaklılığını, hareket konforunu ve azaltılmış hareketli kutlamayı doğrula.

**Kabul kapısı:** Dört dil ve kritik akışlar kararlaştırılan minimum/temsilci Android/iOS cihazlarda ölçülmüş kare/bellek bütçesiyle geçer; çıkışı engelleyen hata kalmaz.

## P14 — Yayın adayı ve mağaza hazırlığı

**Bağımlılıklar:** P13; B01–B08  
**Dosyalar / çıktılar:** Export presets; signing setup; localized store assets; release checklist

- [ ] **P14-01** — Paket/uygulama kimliği, sürümleme, dışa aktarım, sertifika/imza ve mağaza hesaplarını sahibin sağladığı bilgilerle güvenli tamamla.
- [ ] **P14-02** — Yerel mağaza metni, doğru ekran görüntüsü/tanıtım, ikon, içerik derecesi, destek, gizlilik açıklaması ve medya atıflarını üret.
- [ ] **P14-03** — Güncel platform ödeme/reklam/gizlilik şartları ve pazara özel kullanılabilirliği tekrar denetle; ürün kimlikleri, inceleme notu ve geri yükleme gösterimini hazırla.
- [ ] **P14-04** — İmzalı iç test sürümlerinde kur/güncelle/yeniden kur, paket geri yükle, eski kayıt dönüştür ve çevrimdışı temel akış testlerini çalıştır.
- [ ] **P14-05** — Canlı log/çökme raporu, asgari olay ölçümü, saklama/silme, SDK kapatma anahtarları ve destek/kurtarma yönergelerini tanımla.
- [ ] **P14-06** — Somut yayın adayını, bilinen sorun ve kapsamı gözden geçir; yalnız sahibin yetkilendirdiği yayın eylemi kapsamında gönder/yayınla.

**Kabul kapısı:** İmzalı yayın adayları doğru kurulur/güncellenir; mağaza ürünleri, açıklamalar, gizlilik/destek ve inceleyici erişimi yer tutucu canlı kimlik olmadan hazırdır.

## P15 — Yayın doğrulaması ve bakım devri

**Bağımlılıklar:** P14; successful distribution  
**Dosyalar / çıktılar:** Release evidence; support/runbooks; changelog; ToDoList.md

- [ ] **P15-01** — Yetkisiz satın alma yapmadan gerçek mağaza indirme, temiz açılış, güncelleme, çevrimdışı oyun ve hesap bazlı paket davranışını doğrula.
- [ ] **P15-02** — Çökme/kayıt/ödeme/reklam hataları ile gerçek geri bildirimi incele; sınırlı düzeltme ve güvenli geri alma/yetenek kapatmayı hazırla.
- [ ] **P15-03** — Kaynak/derleme yönergeleri, varlık/kaynak dökümü, şema dönüşüm geçmişi, bilinen sınırlar ve destek belgesini tamamla.
- [ ] **P15-04** — İki görev listesini kanıtla güncelle; kalan işi sessizce tamamlandı saymak yerine açık erteleme olarak sınıflandır.

**Kabul kapısı:** Dağıtılan sürüm doğrulanmış, kritik sorunlar giderilmiş, geri yükleme/destek kullanılabilir ve 1.0 bitiş tanımı kanıtlanmıştır.

## P16 — r13 sade yeniden tasarım: en az ekran, doğrusal hikâye, ekonomi

**Bağımlılıklar:** P02, P05, P07; tasarım revizyonu 2026-09-25-r13; canlı ticaret için ayrıca B03–B06  
**Dosyalar / çıktılar:** docs/GameDesign.md; docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md; AGENTS.md; scripts/main.gd; scripts/ui/lobby.gd; scenes/ui/; scripts/services/; data/; tests/

25 Eylül 2026 dönüşümünü uygular: 6 tam ekran + 7 pencere, 20 doğrusal bölüm × 5 soygun, otomatik Gallery, güçlendiriciler, enerji, altın, sınırlı reklam ve satın alma, yalnız İngilizce. P08–P15'teki çelişen bekleyen görevlerin yerini alır. Safehouse lobisi (S1) zaten var.

- [x] **P16-01** — İngilizce tasarım ve Türkçe eşini 2026-09-25-r13 revizyonu olarak yeniden yaz; r12'yi arşivle; AGENTS.md, iki görev listesi ve planlama doğrulayıcısını güncelle.
- [x] **P16-02** — Çalışma kodu değişmeden önce projenin tamamını yedekle.
- [x] **P16-03** — Play sıradaki soygunu doğrudan açar; S01, S03, S04, S05 ve brifing modalı atlanır.
- [x] **P16-04** — Bölümleri doğrusal yap: 20 × 5 = 100 soygun; mevcut 15 eser Bölüm 1–3'ü doldurur; seçilmeyen 40 aday çıkar; eski tamamlamalar yeni sıraya taşınır.
- [x] **P16-05** — İnceleme ve sakla/sat/iade/ödünç akışını kaldır; edinilen her eser Gallery'de görünür, r12'de satılan/iade edilen/ödünç verilenler dahil.
- [x] **P16-06** — Kaldırılan ekran ve sistemleri sil (S01, S03–S05, S09–S20, ekran kaydı, akış panelleri, haberler, dava dosyası, anı stüdyosu, dört yol, kişi güveni, sergi temaları, van görünümleri) ve testlerini; demoyu geliştirici menüsüne taşı.
- [x] **P16-07** — Oyunu İngilizceye sabitle; dil seçiciyi ve cihaz dili algılamayı kaldır.
- [x] **P16-08** — Soygun üst çubuğunu sadeleştir: Pause, zorluk etiketli level kurdelesi, ücretsiz 2× düğmesi; 3× bütçesi, dolum, ses, yardım, undo ve restart kalkar.
- [x] **P16-09** — Extra Dock, Zap, Scout Fly ve Master Key'i kayıtlı stok ve otomatik testlerle uygula.
- [x] **P16-10** — Tıkanan soygunu algıla ve P2 Out of Space'i göster (Continue +1 Dock, Watch Ad, Retry, Home).
- [x] **P16-11** — Soygun 1–4 için el işaretli eğitim ipuçları.
- [x] **P16-12** — Safehouse bakır/pirinç tarzında ortak pencere kalıbı.
- [x] **P16-13** — Pause ile birleşik P1 Settings (Resume, Home −1 enerji).
- [x] **P16-14** — S3 Level Complete: tablo animasyonu, kazanma balonu, ekip kartı, ödül satırı, Continue, 2× Coins yeri.
- [x] **P16-15** — Hikâye metinlerini İngilizce yaz: 100 kazanma balonu, 20 × 3 çizgi roman karesi, açılış karesi ve üç son.
- [x] **P16-16** — S4 Story: kareler, Skip, bölüm sandığı, parça panosu, son kartları.
- [x] **P16-17** — S5 Gallery (bölüm başına bir kat Paintings koridoru, Crew sekmesi) ve Share'li P7 Painting Detail.
- [x] **P16-18** — Safehouse bağlantıları: Play üstünde level numarası, rozetler, avatar → Crew, gizli Event butonu, Gallery sekmesi.
- [x] **P16-19** — Altın ve enerji: kazanma ödülleri, yıldızlar, 20 dakikada dolan 10 enerji, P3 Out of Energy.
- [x] **P16-20** — Sandıklar ve P4 Reward: Daily, Star Chest, Chapter Chest.
- [x] **P16-21** — Önce yalnız altınla alınan ögelerle S6 Shop ve P6 Get Booster.
- [x] **P16-22** — Sahte sağlayıcılı satın alma arayüzü, yedi paket, geri yükleme, P5 Offer.
- [x] **P16-23** — Sahte sağlayıcılı reklam arayüzü, dört ödüllü yer, sınırlı geçiş reklamı, No Ads.
- [ ] **P16-24** — Sahibin ayrı onayından sonra gerçek mağaza ve reklam SDK entegrasyonu (B03–B06).
- [ ] **P16-25** — Arayüz görselleri: Gallery sekme ikonu, sandık durumları, pencere çerçevesi, tamamlama rozeti, Out of Space ve enerji görselleri.
- [ ] **P16-26** — Karakterler: on ekip böceği ve Rocco/Sprocket balon portreleri.
- [ ] **P16-27** — Çizgi roman kareleri: 20 × 3 ve açılış ile sonlar; önce bir bölümün tarzı onaylanır. *Sürüyor:* Bölüm 1 (açılış + 3 kare) boyandı, onaylandı ve oyuna bağlandı (`assets/story/`, `tools/build_chapters.py` içindeki `STORY_ART`); tarz ve karakterler `docs/Characters.md` içinde.
- [x] **P16-28** — Otomatik testler: akış, r12 kayıt geçişi, ekonomi simülasyonu; tüm paketler yeşil.
- [ ] **P16-29** — iOS ve Android cihaz testi; oynanış testinden sonra enerji, fiyat ve zorluk ayarı.
- [ ] **P16-30** — Bölüm 4–20 için 85 soygun bulmacasını ve eserini üret (eser hakları, piksel tahtaları, çözülebilir kuyruklar, bilgiler); o zamana kadar oyun Bölüm 3'ten sonra "More heists coming soon!" ile durur. *Araştırma, 27 Eylül 2026:* [100 açık erişim eser adayı](docs/research/PublicDomainArt100.tr.md), eser başına müze hak kaydı ve görsel kaynaklarıyla hazırlandı; 100 oynanabilir soygun değil, seçim havuzudur. Asıl görseller ve level/kat yerleşimi P16-39 kapsamında ele alındı (kullanıcının yalnız görsel isteği); yayın ülkelerine göre hak değerlendirmesi, piksel tahtaları, çözülebilir kuyruklar ve tam oyun/hikâye içeriği açık.
- [ ] **P16-31** — 26 Eylül 2026 soygun geri bildirimi: her tabloda yalnız alttan giriş (Bölüm 2 kuyrukları yeniden yazıldı), yalnız karıncalara etki eden 2× ve yarı hızlı 1× karıncalar, kapıdan giriş-çıkış ve kapı parlaması, alt çerçeve geçitleri, yalnız kalkışta açılan pervaneler ve yan yatan kalkış, çok renkli tuzak paketleri, ince süre çubuğu, küp boyunda seçim çerçevesi, yeni level plakası ve 2× düğmesi, titreşimli yumuşak tahta toplama sesi, macera müziği. *Kod hazır; Godot `tools/validate_project.py` çalıştırması, görsel kontrol ve cihazda his testi gerekiyor.*
- [x] **P16-32** — Onaylı v4 oyun ekranı: müze görseli, beş platform, üç sütunlu kuyruk, kısa üç özellikli menü, Row Beam ve uyumlu kayıt devamı. Masaüstü uygulama, altı GPU görüntüsü ve altı regresyon paketi doğrulandı (7.329 kontrol; ses paketi CoreAudio ile tekrar geçti); [devir notu](docs/HeistV4Implementation.md). Gerçek cihaz kabulü P16-29’da kalır.
- [x] **P16-33** — Son oyun geri bildirimi: yinelenen yerel yazı olmadan kalın tipografi, kutu renginde üstten yürüyen karıncalar, tıklama çerçevesinin kaldırılması, tam piksel bütçeli 20–45 paketler, güvenli eski kuyruk dönüşümü, çalışma kapısı ışığı ve yalnız kalkışta açılan pervaneler/karınca simgesi. Yedi paket / 8.014 kontrol ve dört GPU görüntüsü geçti; cihaz kabulü P16-29’da. [Kayıt](docs/HeistFeedbackImplementation.md).
- [x] **P16-34** — Mesafeyle senkron eklemli yürüyüş, görünür Row Beam piksel aktarımı/dağılması, duraklatma/azaltılmış hareket ve son satır ödül zamanlaması. Sekiz test grubu / 8.038 kontrol geçti; son 24 kontrollük tekrar ve GPU animasyon kaydı başarılı. [Kayıt](docs/MotionFeedbackImplementation.md).
- [x] **P16-35** — Kızıl arı soygun açılışı: asıl eser, alttan gelen ve alt kuyrukta bekleyen tepeden görünümlü taşıyıcı, üstten çıkıştan önce kapağına dönen ışınlı on arı, piksel panosunun açılması ve ardından küp kuyrukları; duraklatma/kayıttan dönüş/azaltılmış hareket ve mevcut 15 eserin görsel eşleri. İlk uygulamada altı paket / 1.189 kontrol doğrulandı; son tepeden görünüş ve dönüş düzeltmesinde 39 açılış kontrolü ve 216 GPU karesi geçti; 100 eser üretimi P16-30, cihaz kabulü P16-29 kapsamında açık. [Kayıt](docs/HeistIntroImplementation.md).
- [x] **P16-36** — Onaylı müze/ekip ana ekranı, gerçek bölüm/bakiye/ilerleme, Shop/Home/Museum menüsü, korunan enerji/ödüller ve salt okunur Case File hikâye tekrarı. 17 ana ekran kontrolü, 353 mevcut akış kontrolü ve üç masaüstü GPU kaydı başarılı; [kayıt](docs/LobbyReferenceImplementation.md).
- [x] **P16-37** — 10 isimli stage / 100 level yeri, orijinal/piksel geçişli on müze katı, kayıtlı on eserlik koleksiyon ve temiz PNG fotoğraf aktarımı. Mevcut içerik/kayıt kimlikleri korunur; üretilmemiş 85 bulmaca ve yerel mobil paylaşım ayrı kalır. On bir test grubu / 8.156 kontrol ve on bir GPU çıktısı başarılı; [kayıt](docs/StagesMuseumImplementation.md).
- [x] **P16-38** — Yatay kat koridorunu, oranı korunan çerçevelerle iki sütunlu dikey sergiye çevir; kaynağı belirlenmiş kilitli orijinalleri yalnız kilit durumuyla göster, tabloya dokunarak ayrıntı aç ve koleksiyon işlemlerini kazanılmış eserlere sınırla. Kat sırası, kilit davranışı, dikey/yatay oranlar ve masaüstü görüntüleri başarılı: 72 müze + 353 akış kontrolü ve 16 GPU görüntüsü. [Kayıt](docs/MuseumGridImplementation.md).
- [x] **P16-39** — İndirilen 85 müze görselini Level 16–100 içine yerleştir, ilk 15 eseri koru ve piksel panosu veya oynanabilir kuyruk üretmeden on katı doldur. Görsel kaynaklarını, kalıcı yerleşimi, yalnız önizleme davranışını ve bağımsız kayıtla regresyon kontrollerini doğrula; [kayıt](docs/OriginalArtworkPlacement.md).
- [x] **P16-40** — Müze sekmelerini, alt menüyü, kat, orijinal/piksel, koleksiyon ve fotoğraf kontrollerini ayırt edilebilir yalnız simgeli düğmelere çevir; kat/biçim bilgilerini düğme olmayan metinler ve üzerine gelince görünen açıklamalarla koru. Bağımsız müze/akış doğrulaması (90 + 353 kontrol) ve 16 GPU görüntüsü başarılı; [kayıt](docs/MuseumIconNavigation.md).
- [x] **P16-41** — Sun Seal üzerinde kaynaktan piksel örnekleme denemesi: 32×32 asıl görselden RGB kareler, dört ayrı dron eşleşme grubu, çözülebilir kuyruklar, tutarlı müze/oyun/taşınan piksel görünümü ve eski pano kayıt uyumluluğu. Gerçek uçuşlarla tam kazanım ve yan yana görüntülerle doğrula; [kayıt](docs/SunSealSourcePixels.md).
- [x] **P16-42** — Sun Seal piksellerini 16×16 ile büyüt, geçişleri beş oynanabilir renge indir, üç küp yüzünü ve karşıt soğuk zemini göster; 32×32 ve eski kayıtları koru, tam kazanım ve görüntüleri doğrula. [Kayıt](docs/SunSealLargeCubes.md).
- [x] **P16-43** — Sun Seal hücrelerini 18×18 / 324 piksel ile biraz küçült; üç gölgeli yüzü ve beş ortak rengi koruyarak hücre arası tüm zemin boşluklarını kaldır, eski kayıtları koru ve çözülebilirliği/görüntüleri doğrula. [Kayıt](docs/SunSealGapless.md).
- [x] **P16-44** — Sun Seal panosunu piksel boyutunu koruyarak 32×32 büyüt; daha ince karıncaları izin verilen en kısa yaklaşımda doğrudan yürüt, eski kayıtları koru, bitirilebilirliği ve GPU yerleşimini doğrula. [Record](docs/SunSealExpanded.md).
- [x] **P16-45** — Sun Seal’i piksel boyutunu koruyarak 15×15 yap; küplerin ön yüzünü belirginleştir, karıncaları büyüt, çoğu bekleyen küpün rengini göster, alt sıraları yaklaştır, ad ve sayacı tablonun üstüne taşı, hız yazısını düzelt ve kayıt/süre sonu testli 300 altınlık beş dakikalık 3× ekle. [Record](docs/SunSeal15Speed.md).
- [x] **P16-46** — Eser ayrıntısında orijinal/piksel kontrolü yalnızca tablo görselini yerinde değiştirirken modal açık kalsın; koleksiyon düzenlemesinde güncel görünüm korunsun, iki yön bağımsız kayıtlarla ve GPU görüntüleriyle doğrulansın. [Kayıt](docs/MuseumDetailInPlaceToggle.md).
- [x] **P16-47** — Sun Seal'in ekrandaki hücre ölçüsünü The Gleaners ile eşitle; kare asıl görselini orantılı 22×22 / 484 hücreli panoya örnekle, eski kayıtları koru, tam kazanımı ve dikey ekran GPU görüntülerini doğrula. [Record](docs/SunSealGleanersScale.md).
- [x] **P16-48** — Kazanılmış ve oynanabilir eserlerin müze detayına Play Again ekle; seçilen eserin yeni heistini mevcut enerji denetimiyle başlat, kilitli/panosu olmayan eserlerde düğmeyi gizle, geçişi ve mobil yerleşimi izole kayıtlarla doğrula. [Record](docs/MuseumDetailReplay.md).
- [x] **P16-49** — Müzenin üst ve alt menülerini ana sayfanın alt menüsüne uyarla; kat okları/sistem listesi yerine sağdan açılan temalı kat rehberi ekle; seçim, kapatma, kayıt yalıtımı ve dikey yerleşimleri doğrula. [Kayıt](docs/MuseumHomeNavigation.md).
- [x] **P16-50** — Sapphire Cup'ı asıl görselinden Sun Seal'in ölçeği ve kurallarıyla uyumlu 22×22, beş renkli kabarık piksel panosu olarak yeniden oluştur; eski kayıtları koru, çözülebilir kuyruk yaz ve tam kazanımı dikey görüntülerle doğrula. [Kayıt](docs/SapphireCupSourcePixels.md).
- [ ] **P16-51** — Stage 1 Level 3–10 piksel sanatını mevcut bulmacaların üstünde son geri bildirime uygun, 32 satırlık ve renkleri okunur bir sunuma dönüştür; kayıt kimliklerini koru ve gerçek soygun/müze çerçevelerini doğrula. 22 satırlık pano değişimi ve 48 satırlık görsel sürüm kalite nedeniyle reddedildi. [Kayıt](docs/StageOneSourcePixels.md).
- [x] **P16-52** — Ortak heist eser adı ve ilerleme yerleşimini oynanabilir tüm tablolara ve eski kayıttan sürdürülen panolara uygula; pano boyutlarını ve alttaki karınca geçitlerini koru, yalıtılmış yerleşim testleri ve dikey görüntülerle doğrula. [Kayıt](docs/SharedHeistHud.md).
- [x] **P16-53** — Ana sayfanın görselli alt menüsünü müzeyle ortak kullan; müze görselleri ve tipografisini canlandır, yeniden kullanılabilir ekran stilini belgele. Ek düzenleme: sergi başlığını tek satıra indir, toplanan eser sayılarını kat rehberine taşı. 479 yalıtılmış masaüstü kontrolü başarılı; 25 GPU/PNG çıktısı doğrulandı; [kayıt](docs/MuseumSharedStyle.md).
- [x] **P16-54** — Müze sekme alt çizgisini ve tablo ayrıntısı kontrollerini düzelt; Collection araç satırlarını ayır, eski kayıt uyumluluğuyla üç kayıtlı diziliş ve oda üzerinden yer değiştirme/sıralama ekle. 648 izole kontrol ve 28 GPU/PNG çıktısı geçti; [kayıt](docs/CollectionLayouts.md).
- [x] **P16-55** — Müze alt menüsünü kaldır, Edit/Photo modlarından önce çıkan sol üst Safehouse geri gezinmesini ekle ve kazanılan yüksekliği tablolara ayır. 590 izole kontrol ve 28 GPU/PNG çıktısı geçti; [kayıt](docs/MuseumBackNavigation.md).
- [x] **P16-56** — Settings/Pause, Crew ve Rewards alanlarını ortak lacivert/pirinç stile uyarla; yerinde kaydedilen anahtarlar, ayrı ekip portreleri ve okunaklı seçim/kilit kartları, açık ödül durumları ve doğru adetli ödül kutuları ekle. 712 kontrol geçti; 50 görüntü üretildi ve temsilî durumlar görsel olarak incelendi; cihaz kabulü P16-29 kapsamında. [Kayıt](docs/SettingsCrewRewards.md).
- [x] **P16-57** — Level Complete ekranını ortak başarı kartı, sevinçli kanonik Rocco/Sprocket görseli, sonlu konfeti, sıralı yıldızlar ve reduced-motion desteğiyle yenile; kazanma ödüllerini, isteğe bağlı reklamları ve Story yönlendirmesini koru. 481 izole kontrol, 10 dikey ekran görüntüsü ve 84 animasyon karesi geçti; cihaz kabulü P16-29 kapsamında. [Kayıt](docs/LevelCompleteCelebration.md).
- [x] **P16-58** — Ödül pencerelerine sonlu konfeti ve sandık hareketi ekle; anında kapatma, reduced motion, askıya alma ve tek seferlik ödül kaydını koru. 146 izole kontrol, altı dikey ekran görüntüsü ve 84 animasyon karesi geçti; cihaz kabulü P16-29 kapsamında. [Kayıt](docs/RewardCelebration.md).
- [x] **P16-59** — Case File bölümünü spoiler kilitli giriş/özetler, dönüm noktası tekrarı, okunaklı sahneler, önceki/sonraki gezinme ve seçilmiş final tekrarı içeren on stage dosyası olarak yenile; tüm kayıt ve ödül kimliklerini koru. 455 izole kontrol başarılı; 22 dikey ekran görüntüsü alındı ve temsili görseller incelendi. Gerçek cihaz kabulü P16-29 kapsamında bekliyor; [kayıt](docs/CaseFileStages.md).
- [x] **P16-60** — Stage 1 başlangıç/bitiş görsellerini ve kısa konuşmaları üret; Case File uzun raporlarını eser tamamlanmasına göre açılan doğrudan sahne görünümüne dönüştür, Stage 1 canlı akışını kayıt/ödül kimliklerini koruyarak bağla. 419 izole kontrol başarılı; 14 dikey GPU görüntüsü alındı ve temsili görseller incelendi; [kayıt](docs/StageOneStoryScenes.md).
- [x] **P16-61** — Stage 1 başlangıç/bitiş konuşmalarını görsel üzerindeki isimli konuşma balonlarına taşı; canlı Story ve Case File alt metin alanını kaldır, kırpılmayan görseli ve gezinmeyi koru. 51 izole Case File kontrolü başarılı; 14 dikey görüntü alındı ve temsili görseller incelendi; [kayıt](docs/StageOneStoryScenes.md).
- [x] **P16-62** — Safehouse’a altı büyük görsel ödül/reklam/No Ads kısayolu, iki sütunlu ödül kartları ve uyumlu makbuz/teklif görselleri ekle; ödül/sağlayıcı sınırlarını ve odağı koru. 505 izole masaüstü kontrolü başarılı; 29 dikey GPU görüntüsü alındı ve temsili görseller incelendi. Cihaz kabulü P16-29’da kalır. [Kayıt](docs/IllustratedRewards.md).
- [x] **P16-63** — Onaylanan sade Safehouse arka planını uygula, mevcut düğmeleri ve ödül akışlarını koru; normal/uzun dikey ekran okunurluğunu doğrula. [Kayıt](docs/SimplifiedSafehouse.md). 38 izole ana ekran kontrolü ve yedi GPU görüntüsü başarılı; normal/uzun ekran düzenleri incelendi.
- [x] **P16-64** — Safehouse, ödüller ve tekliflerde süslü madalyonları onaylanan saten-emaye obje ikonlarıyla değiştir; kısayol yazılarını siluetlerin altına taşı ve dikey ekranları doğrula. [Kayıt](docs/EnamelRewardIcons.md). 80 izole kontrol ve 29 GPU görüntüsü başarılı; normal/uzun ekran düzenleri incelendi.
- [ ] **P16-65** — Alt menü ve Case File ikonlarını saten-emaye ailesine uyarla, gereksiz bakır sandığı kaldır, Start Heist düğmesini doğru devre dışı More Soon durumuyla yenile. Gezinme, odak, ödüller ve dikey düzenleri doğrula. [Kayıt](docs/HomeControlsEnamel.md).

**Kabul kapısı:** Yeni oyuncu aynı anda en fazla bir pencereyle Safehouse → Heist → Level Complete → Safehouse yolunu izler; her bölüm finali Story gösterir; 13 ekranın tamamı İngilizce çalışır; r12 kayıtları tamamlanmış eser kaybetmeden taşınır; testlerde gerçek satın alma veya reklam olmaz.

Kanıt P16-01: r13 tasarımları, docs/archive/ içindeki arşiv kopyaları, güncellenmiş AGENTS.md ve doğrulayıcı; `python3 tools/validate_planning_docs.py` geçer. Kanıt P16-02: `.backups/pre-redesign-2026-09-25.tgz` (.godot dışında projenin tamamı).

Kanıt P16-03–P16-23, P16-28: [P16 uygulama kaydı](docs/P16-Implementation.md). `tools/validate_project.py` geçiyor (test_puzzle 6.579, test_r13_store 72, test_r13_boosters 34, test_r13_flow 351 kontrol; 0 hata). Kalan: P16-24 gerçek SDK'lar için sahibin onayını bekler; P16-25–27 yalnız kodla çizilmiş geçici görsellere sahip; P16-29 gerçek cihaz gerektirir; P16-30 içerik üretimi.

## Üretim kararları ve dış girdiler

Bu maddeler P01–P08 çalışmasını durdurma nedeni değildir. İlgili iş başladığında çözülür; kimlik bilgisi, gerçek cihaz erişimi, insan incelemesi ve mağaza onayı kod yazarak uydurulamaz.

| Kimlik | Karar / girdi | Etki |
| --- | --- | --- |
| B01 | Dağıtım platformları ve ilk mağaza ülkeleri | Dikey Android+iOS varsayımı; dışa aktarım/SDK seçiminden önce netleştir. |
| B02 | Minimum cihaz, OS sürümü, performans bütçesi | P13 kabulünden önce temsilci cihaz gerekir. |
| B03 | Yayıncı hesapları, uygulama kimliği, imza erişimi | Sahip/platform girdisi; kimlik bilgisi uydurma. |
| B04 | Fiyat kademeleri, ürün kimliği, mağaza ürünleri | Tasarım örnek fiyatı canlı fiyat değildir. |
| B05 | Ödeme/reklam arayüzleri ve doğrulama servisi | Godot uyumu, destek maliyeti ve test/canlı ayrımını değerlendir. |
| B06 | Kitle derecesi, gizlilik, izin ve yayıncı metinleri | Gerçek SDK ayarı ve mağaza yayını için gerekli. |
| B07 | Ana dil incelemesi ve varlık hakkı kanıtı | Taslak çeviri ve kaynak bağlantısı editör/hak kontrolünü tek başına bitirmez. |
| B08 | Onaylı yayın kapsamı ve gönderim zamanı | Somut imzalı adayı incele; görev listesi kendi başına yayın yapmaz. |

## Bitiş tanımı — temel 1.0

25 Eylül 2026'da r13 için yenilendi; r12 tanımının yerini alır.

- 100 tablonun ayrı kimliği, geçerli eser/hak kaydı, tek satırlık bilgisi ve 20 doğrusal bölümde çözülebilir yazılmış kuyruğu vardır.
- 13 ekran ve geçişleri İngilizce çalışır; ilgili çevrimdışı, iptal, hata ve devam durumları dahildir.
- Beş sabit parça, 100 kazanma balonu, bölüm Story kareleri ve üç son eksiksiz ve tutarlıdır. Bitirmek için satın alma veya reklam gerekmez.
- r12 kayıt geçişi ve soygun ortasında devam güvenlidir; kesintide eser, altın, enerji, güçlendirici, yıldız veya hak kaybı/çoğalması yoktur.
- Enerji, güçlendiriciler, sandıklar, Shop, geri yüklemeli yedi paket ve sınırlı ödüllü/geçiş reklamları doğru çevrimdışı ve hata davranışıyla çalışır.
- Otomatik kontroller ve kararlaştırılan gerçek cihaz kabulü kayıtlıdır; yayın engeli kalmaz.
- İmzalı sürümler, mağaza/destek/gizlilik varlıkları ve geri yükleme seçili platformlarda hazırdır; gerçek yayın P14–P15 ile yapılır.

## Açıkça 1.0 sonrası

Canlı etkinlikler (gizli Event: Apples butonu), sezon kartı, bağımsız Venedik macerası, video dışa aktarma, hesap/bulut eşitleme ve İngilizce dışındaki her dil. Kullanıcı kapsamı genişletmedikçe temel bitiş hesabına katma.

## Her fazın devir notu

Bitirilen görev kimlikleri, değişen dosyalar, çalıştırılan kontrol/sonuçlar, yararlı ekran görüntüleri, açık hata/kararlar, kayıt uyumu ve sonraki fazı kaydet. Aynı değişiklikte önce İngilizceyi sonra Türkçeyi güncelle. Kod derlendi diye görevi bitmiş işaretleme.
