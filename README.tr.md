# HPMedya

[English](README.md) · [Türkçe özellikler ve kısayollar](https://gencturkler.github.io/hur-medya/tr/) · [Son sürüm](https://github.com/gencturkler/hur-medya/releases/latest)

HPMedya, [Tangerine](https://tangerineformac.com/) uygulamasının sürükle ve çark etkileşiminden ilham alan bağımsız, açık kaynaklı bir dosya dönüştürme/düzenleme uygulamasıdır. Web’den medya indirme, QR okuma, geliştirilmiş crop/annotate araçları, klavyeyle medya düzenleme, canlı ilerleme ve imzalı otomatik güncelleme ekler. Tangerine veya LEAP STUDIO ile bağlantılı değildir; referans uygulamanın binary dosyaları veya görselleri dağıtılmaz.

[Etkileşimli web demosunu dene](https://gencturkler.github.io/hur-medya/tr/#playground): örnek dosyaları sürükle, wheel ve kısayolları kullan, 27 aracı keşfet. Desteklenen görsel/PDF/ses çıktıları gerçektir; masaüstüne özel işlemler önizleme olarak işaretlenir.


## İndir ve kullan

- **[Windows x64 ZIP · yerel önizleme](https://github.com/gencturkler/hur-medya/releases/latest/download/HPMedya-Windows-x64.zip):** ZIP’in tamamını kendine ait, yazılabilir bir klasöre çıkar ve HPMedya.exe’yi aç. Ayrıca .NET kurmak gerekmez. Güncelleme için klasörün bütünlüğünü koru. [Windows özellikleri ve farkları](windows/README.md).

İlk açılışta **Kurulumu tamamla → Eksik araçları indir** akışı Medya ve Office araçlarını sırayla kurar. Bilgisayarında bulunan araçlar yeniden indirilmez; iptal veya hata sonrasında yalnızca eksik gruplarla devam edilir. **Araçlar hazır** durumu iki grup da kullanılabilir olduğunda gösterilir. İndirmeler doğrudan upstream’den gelir; hash’leri kurulumdan önce doğrulanır. Temel yerel görsel/PDF işlemleri hemen çalışır. [Sürümler, hash’ler ve lisanslar](docs/dependencies.md).

İlk public build’lerde Apple notarization / Windows Authenticode yayıncı imzası bulunmuyor. İşletim sistemi ilk açılışta onay isteyebilir. HPMedya sistem güvenlik ayarlarını kapatmaz. Resmi yayınlarda SHA-256 dosyası vardır; her CI çıktısı resmi imzalı güncelleme sayılmaz.

## Kısayollar

macOS’ta Finder’da sürüklerken **Shift** dönüşüm, **Command** araçlar, **Control** dosya işlemleri çarkını açar. **Control–Shift–D** kopyalanmış public linki indirir. Sürükleme tuşları özelleştirilebilir. Windows’ta **Ctrl+O** dosya seçer; **Ctrl+Space** seçili dosyaların araç ve dönüşüm çarkını açar. Çarkta **Dönüştür** ile çıktı formatını seçebilirsin. Ana sayfadaki dosya listesinde **Delete**, seçili dosyaları asıllarını silmeden HPMedya’den kaldırır.

Desteklenen medya editörlerinde **Space** oynat/duraklat, **sağ/sol ok** bir saniye ilerle/geri git, **I/O** aralık başlangıcı/sonu. Crop’ta sürükleyerek seç, **Shift** ile oranı kilitle, **Enter** ile kaydet. [Tam kısayol rehberi](https://gencturkler.github.io/hur-medya/tr/#shortcuts).

Dönüştürme ve düzenleme yerelde çalışır. Web indirmeleri seçtiğin siteye bağlanır. Analytics, bulut hesabı veya tarayıcı çerezi aktarma yok. Public güncellemeler GitHub hesabı/token istemez. macOS feed ve arşiv imzasını, Windows arşiv imzasını ve sürümünü doğrular. İşler tamamlanmadan veya iptal edilmeden güncelleme için uygulama kapanmaz. Windows eski uygulama klasörünü geri alınabilir yedek olarak tutar.

Kaynak kod [MIT](LICENSE) lisanslıdır; üçüncü taraf bileşenlerin kendi lisansları geçerlidir. [macOS build adımları](README.md#build) · [Windows build adımları](windows/README.md).
