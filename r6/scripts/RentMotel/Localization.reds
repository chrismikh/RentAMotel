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

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel room 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel room 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel room 106");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Rentable for 24 hours - 250€$");
    this.Text("RentMotel-Desc-Kabuki", "Rentable for 24 hours - 500€$");
    this.Text("RentMotel-Desc-Dewdrop", "Rentable for 24 hours - 800€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Open Door");
    this.Text("RentMotel-UI-HallwayDoor", "Hallway Door");

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

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Мотель Сансет, комната 102");
    this.Text("RentMotel-Title-Kabuki", "Мотель Кабуки, комната 203");
    this.Text("RentMotel-Title-Dewdrop", "Мотель Дьюдроп Инн, комната 106");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Аренда на 24 часа - 250€$");
    this.Text("RentMotel-Desc-Kabuki", "Аренда на 24 часа - 500€$");
    this.Text("RentMotel-Desc-Dewdrop", "Аренда на 24 часа - 800€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Открыть дверь");
    this.Text("RentMotel-UI-HallwayDoor", "Дверь в коридор");

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

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Sunset Motel chambre 102");
    this.Text("RentMotel-Title-Kabuki", "Kabuki Motel chambre 203");
    this.Text("RentMotel-Title-Dewdrop", "Dewdrop Inn Motel chambre 106");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Louable pour 24 heures - 250€$");
    this.Text("RentMotel-Desc-Kabuki", "Louable pour 24 heures - 500€$");
    this.Text("RentMotel-Desc-Dewdrop", "Louable pour 24 heures - 800€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Ouvrir la Porte");
    this.Text("RentMotel-UI-HallwayDoor", "Couloir");

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

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Motel Sunset quarto 102");
    this.Text("RentMotel-Title-Kabuki", "Motel Kabuki quarto 203");
    this.Text("RentMotel-Title-Dewdrop", "Pousada Dewdrop quarto 106");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Alugável por 24 horas - 250€$");
    this.Text("RentMotel-Desc-Kabuki", "Alugável por 24 horas - 500€$");
    this.Text("RentMotel-Desc-Dewdrop", "Alugável por 24 horas - 800€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir porta");
    this.Text("RentMotel-UI-HallwayDoor", "Porta do corredor");

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

    // Mappin titles
    this.Text("RentMotel-Title-Sunset", "Habitación Disponible - Motel Sunset 102");
    this.Text("RentMotel-Title-Kabuki", "Habitación Disponible - Motel Kabuki 203");
    this.Text("RentMotel-Title-Dewdrop", "Habitación Disponible - Dewdrop Inn 106");

    // Mappin descriptions
    this.Text("RentMotel-Desc-Sunset", "Alquiler por 24 horas - 250€$");
    this.Text("RentMotel-Desc-Kabuki", "Alquiler por 24 horas - 500€$");
    this.Text("RentMotel-Desc-Dewdrop", "Alquiler por 24 horas - 800€$");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir puerta");
    this.Text("RentMotel-UI-HallwayDoor", "Puerta del pasillo");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Alquilar por 24 horas - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: No hay suficiente dinero ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Alquilar por 7 días - {price}€$ (10% de descuento diario)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: No hay suficiente dinero ({price}€$)");
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


