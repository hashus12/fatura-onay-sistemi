# Fatura Onaylama Sistemi

  Merhaba, proje sap abap ile geliştirilmiştir. Proje bir fatura onaylama sistemidir, kayıt edilen faturaların hangi yöneticiler tarafından onaylanıp onaylanmadığını kontrol etmek için tasarlanmıştır. Projede faturaların listelenmesi için OO-ALV, faturanın görüntülenebilmesi için de Smartforms kullanılmıştır. Projede kullanılan veriler sap veritabanına kaydedilmiştir.
# Fatura Giriş Programı
![satfatgir1](https://user-images.githubusercontent.com/53178769/197583251-93a55968-6a7f-4777-8749-888d213d095e.png)
Bu program fatura ekleme programıdır. Bu programda faturanın bilgileri faturanın kalemleri girilebilir. "Yöneticiler" kısmında programa giriş yapan kullanıcının yöneticileri listelenir ve eklenen fatura bu yöneticilerin fatura onaylama programında onaylanmak için ekranlarına düşer.
![satfatgir2](https://user-images.githubusercontent.com/53178769/197584811-93da54b5-2097-4eab-8d0b-9956539b3a0b.png)
# Fatura Onaylama Programı
Bu program fatura onaylama programıdır.
![fatislem1](https://user-images.githubusercontent.com/53178769/197576797-8ea73afe-1e08-4da1-b9ff-b94496adca39.png)
Bu ekran proje ekranıdır. Sol üstte kısımda giriş yapan kullanıcının ekranına düşen faturalar bilgileri ile birlikte listelenmekte "Fatura no" kolonundaki herhangi bir faturaya tıklayınca ekran aşağıdaki gibi olur. 
![fatislem2](https://user-images.githubusercontent.com/53178769/197576834-98eb0766-372c-4ddb-84f9-b6d8700e6db2.png)
Bu ekranda sol alttaki listeye o fatura hakkında yöneticiler ve onay bilgileri, sağ alttaki listeyede faturanın kalemleri gelir en sağdaki kısım da bu faturanın çıktı alınabilecek görüntüsüdür burdan çıktı da alınabilir.
![fatislem5](https://user-images.githubusercontent.com/53178769/197579702-b914d94a-0f8c-4ac9-8714-3ccc170f1d51.png)
Seçilen faturayı "Reddet" butonuna basarak reddeden kullanıcı neden reddettiğini açıklamasını isteyen bir ekranla karşılaşır.
![fatislem6](https://user-images.githubusercontent.com/53178769/197581275-774af091-1a96-4720-8477-fd5d5467d447.png)
Böylelikle reddedilen faturanın durumu ile yapılan açıklama veritabanına kaydedilir ve listeler güncellenir. Aynı şekilde "Onayla" butonuna basarak faturayı onaylayabilirsiniz.
![fatislem8db](https://user-images.githubusercontent.com/53178769/197582510-5f599835-32d6-4bfe-bce5-b4e64d0a2211.png)
Projenin veritabanı tasarımı bu şekildedir.
![fatislem7db](https://user-images.githubusercontent.com/53178769/197582581-a95e5554-96c0-4164-8ac9-359c5317e440.png)
Bu ekranda veritabanındaki veriler bulunmakta.
