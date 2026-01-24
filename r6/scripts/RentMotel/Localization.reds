module RentMotel.Localization
import Codeware.Localization.*

public class LocalizationProvider extends ModLocalizationProvider {
  public func GetPackage(language: CName) -> ref<ModLocalizationPackage> {
    switch language {
      case n"en-us": return new English();
      case n"ru-ru": return new Russian();
      case n"fr-fr": return new French();
      case n"pt-br": return new BrazilianPortuguese();
      case n"es-es": return new Spanish();
      case n"zh-tw": return new TraditionalChinese();
      case n"zh-cn": return new SimplifiedChinese();
      case n"jp-jp": return new Japanese();
      case n"it-it": return new Italian();
      case n"kr-kr": return new Korean();
      case n"de-de": return new German();
      default: return null;
    }
  }

  public func GetFallback() -> CName {
    return n"en-us";
  }
}

// Original English translation
public class English extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Sunset Motel Room");
    this.Text("RentMotel-Room-Kabuki", "Kabuki Motel Room");
    this.Text("RentMotel-Room-Dewdrop", "Dewdrop Inn Motel Room");
    this.Text("RentMotel-Room-NoTell", "No-Tell Motel Room");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel room 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel room 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel room 106");
    this.Text("RentMotel-Title-NoTell", "No-Tell Motel room 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Rentable for 24 hours - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Rentable for 24 hours - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Rentable for 24 hours - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Rentable for 24 hours - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Open Door");
    this.Text("RentMotel-UI-HallwayDoor", "Hallway Door");
    this.Text("RentMotel-UI-CloseDoor", "Close Door");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Rent for 24 hours - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Not enough money ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Rent for 7 days - {price}€$ (10% off daily)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: Not enough money ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// Russian translation by thomsman69
public class Russian extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Комната Мотеля Сансет");
    this.Text("RentMotel-Room-Kabuki", "Комната Мотеля Кабуки");
    this.Text("RentMotel-Room-Dewdrop", "Комната Мотеля Дьюдроп Инн");
    this.Text("RentMotel-Room-NoTell", "Комната Мотеля Но-Телл");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Мотель Сансет, комната 102");
    this.Text("RentMotel-Title-Kabuki", "Мотель Кабуки, комната 203");
    this.Text("RentMotel-Title-Dewdrop", "Мотель Дьюдроп Инн, комната 106");
    this.Text("RentMotel-Title-NoTell", "Мотель Но-Телл, комната 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Аренда на 24 часа - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Аренда на 24 часа - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Аренда на 24 часа - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Аренда на 24 часа - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Открыть дверь");
    this.Text("RentMotel-UI-HallwayDoor", "Дверь в коридор");
    this.Text("RentMotel-UI-CloseDoor", "Закрыть дверь");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Арендовать на 24 часа - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 ч: Недостаточно денег ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Арендовать на 7 дней - {price}€$ (скидка 10%)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 дн: Недостаточно денег ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// French translation by Angie7938
public class French extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Chambre du Sunset Motel");
    this.Text("RentMotel-Room-Kabuki", "Chambre du Kabuki Motel");
    this.Text("RentMotel-Room-Dewdrop", "Chambre du Dewdrop Inn Motel");
    this.Text("RentMotel-Room-NoTell", "Chambre du No-Tell Motel");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel chambre 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel chambre 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel chambre 106");
    this.Text("RentMotel-Title-NoTell", "No-Tell Motel chambre 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Louable pour 24 heures - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Louable pour 24 heures - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Louable pour 24 heures - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Louable pour 24 heures - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Ouvrir la Porte");
    this.Text("RentMotel-UI-HallwayDoor", "Couloir");
    this.Text("RentMotel-UI-CloseDoor", "Fermer la Porte");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Louer pour 24 heures - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Pas assez d'argent ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Louer pour 7 jours - {price}€$ (10% de réduction)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7j: Pas assez d'argent ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// Brazilian Portuguese translation by KiwamiLorenzo
public class BrazilianPortuguese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Quarto do Motel Sunset");
    this.Text("RentMotel-Room-Kabuki", "Quarto do Motel Kabuki");
    this.Text("RentMotel-Room-Dewdrop", "Quarto da Pousada Dewdrop");
    this.Text("RentMotel-Room-NoTell", "Quarto do Motel No-Tell");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Motel Sunset quarto 102");
    this.Text("RentMotel-Title-Kabuki", "Motel Kabuki quarto 203");
    this.Text("RentMotel-Title-Dewdrop", "Pousada Dewdrop quarto 106");
    this.Text("RentMotel-Title-NoTell", "Motel No-Tell quarto 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Alugável por 24 horas - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Alugável por 24 horas - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Alugável por 24 horas - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Alugável por 24 horas - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir porta");
    this.Text("RentMotel-UI-HallwayDoor", "Porta do corredor");
    this.Text("RentMotel-UI-CloseDoor", "Fechar porta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Aluguel por 24 horas - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Dinheiro insuficiente ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Aluguel por 7 dias - {price}€$ (10% de desconto diariamente)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: Dinheiro insuficiente ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// Spanish translation by Zurent
public class Spanish extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Habitación del Motel Sunset");
    this.Text("RentMotel-Room-Kabuki", "Habitación del Motel Kabuki");
    this.Text("RentMotel-Room-Dewdrop", "Habitación del Motel Dewdrop Inn");
    this.Text("RentMotel-Room-NoTell", "Habitación del Motel No-Tell");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Habitación Disponible - Motel Sunset 102");
    this.Text("RentMotel-Title-Kabuki", "Habitación Disponible - Motel Kabuki 203");
    this.Text("RentMotel-Title-Dewdrop", "Habitación Disponible - Dewdrop Inn 106");
    this.Text("RentMotel-Title-NoTell", "Habitación Disponible - No-Tell Motel 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Alquiler por 24 horas - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Alquiler por 24 horas - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Alquiler por 24 horas - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Alquiler por 24 horas - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir puerta");
    this.Text("RentMotel-UI-HallwayDoor", "Puerta del pasillo");
    this.Text("RentMotel-UI-CloseDoor", "Cerrar puerta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Alquilar por 24 horas - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: No hay suficiente dinero ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Alquilar por 7 días - {price}€$ (10% de descuento diario)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: No hay suficiente dinero ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// Traditional Chinese translation by ZKinGx1764
public class TraditionalChinese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "日落汽車旅館房間");
    this.Text("RentMotel-Room-Kabuki", "歌舞伎町汽車旅館房間");
    this.Text("RentMotel-Room-Dewdrop", "露珠汽車旅館房間");
    this.Text("RentMotel-Room-NoTell", "不語汽車旅館房間");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "日落汽車旅館-102房間");
    this.Text("RentMotel-Title-Kabuki", "歌舞伎町汽車旅館-203房間");
    this.Text("RentMotel-Title-Dewdrop", "露珠汽車旅館-106房間");
    this.Text("RentMotel-Title-NoTell", "不語汽車旅館-206房間");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "可租用24小時 - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "可租用24小時 - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "可租用24小時 - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "可租用24小時 - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "開門");
    this.Text("RentMotel-UI-HallwayDoor", "走廊門");
    this.Text("RentMotel-UI-CloseDoor", "關門");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "租用24小時 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24小時: 沒有足夠的金錢 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "租用7小時 - {price}€$ (每天10%折扣)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7小時: 沒有足夠的金錢 ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// Simplified Chinese translation by caiyidiy 
public class SimplifiedChinese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "日落汽车旅馆房间");
    this.Text("RentMotel-Room-Kabuki", "歌舞伎汽车旅馆房间");
    this.Text("RentMotel-Room-Dewdrop", "露珠旅馆房间");
    this.Text("RentMotel-Room-NoTell", "无名汽车旅馆房间");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "日落汽车旅馆102房间");
    this.Text("RentMotel-Title-Kabuki", "歌舞伎汽车旅馆203房间");
    this.Text("RentMotel-Title-Dewdrop", "露珠旅馆106房间");
    this.Text("RentMotel-Title-NoTell", "无名汽车旅馆206房间");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "可租用24小时 - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "可租用24小时 - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "可租用24小时 - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "可租用24小时 - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "开门");
    this.Text("RentMotel-UI-HallwayDoor", "走廊门");
    this.Text("RentMotel-UI-CloseDoor", "关门");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "租用24小时 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24小时：资金不足 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "租用7天 - {price}€$ (每日享受10%折扣)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7天：资金不足 ({price}€$)");
  }
   
   protected func DefineSubtitles() -> Void {
  }
}

// Japanese translation by KeiSagano
public class Japanese extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "サンセット・モーテルルーム");
    this.Text("RentMotel-Room-Kabuki", "カブキ・モーテルルーム");
    this.Text("RentMotel-Room-Dewdrop", "デュードロップ・モーテルルーム");
    this.Text("RentMotel-Room-NoTell", "ノーテル・モーテルルーム");
 
    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "サンセット・モーテル 102号室");
    this.Text("RentMotel-Title-Kabuki", "カブキ・モーテル 203号室");
    this.Text("RentMotel-Title-Dewdrop", "デュードロップ・モーテル 106号室");
    this.Text("RentMotel-Title-NoTell", "ノーテル・モーテル 206号室");
 
    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "24時間レンタル可 - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "24時間レンタル可 - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "24時間レンタル可 - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "24時間レンタル可 - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "ドアを開ける");
    this.Text("RentMotel-UI-HallwayDoor", "廊下のドア");
    this.Text("RentMotel-UI-CloseDoor", "ドアを閉める");
 
    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "24時間レンタル - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: お金が足りません ({price}€$)");
    this.Text("RentMotel-Choice-7d", "7日間レンタル - {price}€$ (毎日10%オフ)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: お金が足りません ({price}€$)");
  }
 
  protected func DefineSubtitles() -> Void {
  }
}

// Italian translation by micuzzo87
public class Italian extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Stanza del Sunset Motel");
    this.Text("RentMotel-Room-Kabuki", "Stanza del Kabuki Motel");
    this.Text("RentMotel-Room-Dewdrop", "Stanza del Dewdrop Inn Motel");
    this.Text("RentMotel-Room-NoTell", "Stanza del No-Tell Motel");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel stanza 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel stanza 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel stanza 106");
    this.Text("RentMotel-Title-NoTell", "No-Tell Motel stanza 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Affittabile per 24 ore - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Affittabile per 24 ore - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Affittabile per 24 ore - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Affittabile per 24 ore - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Apri la porta");
    this.Text("RentMotel-UI-HallwayDoor", "Porta del corridoio");
    this.Text("RentMotel-UI-CloseDoor", "Chiudi la porta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Affittabile per 24 ore - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 ore: Non hai abbastanza soldi ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Affittabile per 7 giorni - {price}€$ (10% off daily)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 giorni: non hai abbastanza soldi ({price}€$)");
  }
 
  protected func DefineSubtitles() -> Void {
  }
}

// Korean translation by root0555
public class Korean extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "선셋 모텔 객실");
    this.Text("RentMotel-Room-Kabuki", "카부키 모텔 객실");
    this.Text("RentMotel-Room-Dewdrop", "듀드롭 인 모텔 객실");
    this.Text("RentMotel-Room-NoTell", "노텔 모텔 객실");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "선셋 모텔 102호");
    this.Text("RentMotel-Title-Kabuki", "카부키 모텔 203호");
    this.Text("RentMotel-Title-Dewdrop", "듀드롭 인 모텔 106호");
    this.Text("RentMotel-Title-NoTell", "노텔 모텔 206호");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "24시간 대여 가능 - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "24시간 대여 가능 - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "24시간 대여 가능 - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "24시간 대여 가능 - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "문 열기");
    this.Text("RentMotel-UI-HallwayDoor", "복도 문");
    this.Text("RentMotel-UI-CloseDoor", "문 닫기");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "24시간 대여 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24시간: 에디 부족 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "7일 대여 - {price}€$ (일일 요금 10% 할인)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7일: 에디 부족 ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

// German translation by PsycoFun3D
public class German extends ModLocalizationPackage {
  protected func DefineTexts() -> Void {
    // Room titles (for hubs)
    this.Text("RentMotel-Room-Sunset", "Sunset Motel Zimmer");
    this.Text("RentMotel-Room-Kabuki", "Kabuki Motel Zimmer");
    this.Text("RentMotel-Room-Dewdrop", "Dewdrop Inn Motel Zimmer");
    this.Text("RentMotel-Room-NoTell", "No-Tell Motel Zimmer");

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel Zimmer 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel Zimmer 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel Zimmer 106");
    this.Text("RentMotel-Title-NoTell", "No-Tell Motel Zimmer 206");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Für 24 Stunden mieten - 450€$");
    this.Text("RentMotel-Desc-Kabuki", "Für 24 Stunden mieten - 700€$");
    this.Text("RentMotel-Desc-Dewdrop", "Für 24 Stunden mieten - 1000€$");
    this.Text("RentMotel-Desc-NoTell", "Für 24 Stunden mieten - 700€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Tür Öffnen");
    this.Text("RentMotel-UI-HallwayDoor", "Tür zum Flur");
    this.Text("RentMotel-UI-CloseDoor", "Tür Schließen");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Für 24 Stunden mieten - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 Stunden: Nicht genug Geld ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Für 7 Tage mieten - {price}€$ (10% Rabatt pro Tag)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 Tage: Nicht genug Geld ({price}€$)");
  }

  protected func DefineSubtitles() -> Void {
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let ret: Bool = wrappedMethod();
  new LocalizationProvider();
  return ret;
}


