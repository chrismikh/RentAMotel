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
    this.Text("RentMotel-Desc-Sunset", "Rentable motel room");
    this.Text("RentMotel-Desc-Kabuki", "Rentable motel room");
    this.Text("RentMotel-Desc-Dewdrop", "Rentable motel room");
    this.Text("RentMotel-Desc-NoTell", "Rentable motel room");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Open Door");
    this.Text("RentMotel-UI-HallwayDoor", "Hallway Door");
    this.Text("RentMotel-UI-CloseDoor", "Close Door");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Rent for 24 hours - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Not enough money ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Rent for 7 days - {price}€$ (10% off daily)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: Not enough money ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Buy permanently - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Permanent: Not enough money ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Room Prices (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Rental Options");
    this.Text("RentMotel-Settings-PermanentCategory", "Permanent Renting");
    this.Text("RentMotel-Settings-SunsetPrice", "Sunset Motel Room 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Default: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Kabuki Motel Room 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Default: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Dewdrop Inn Room 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Default: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "No-Tell Motel Room 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Default: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Extended Rental Duration (Days)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Set the number of days for extended rental option. Default: 7 days. Price includes 10% discount.");
    this.Text("RentMotel-Settings-PermanentToggle", "Enable Permanent Renting");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "When enabled, adds a third option for renting a motel room, with permanent ownership (999999 days). Default: Disabled.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Sunset Motel Permanent Price");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Price for permanent ownership of Sunset Motel Room 102. Default: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Kabuki Motel Permanent Price");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Price for permanent ownership of Kabuki Motel Room 203. Default: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Dewdrop Inn Permanent Price");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Price for permanent ownership of Dewdrop Inn Room 106. Default: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "No-Tell Motel Permanent Price");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Price for permanent ownership of No-Tell Motel Room 206. Default: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Комната мотеля в аренду");
    this.Text("RentMotel-Desc-Kabuki", "Комната мотеля в аренду");
    this.Text("RentMotel-Desc-Dewdrop", "Комната мотеля в аренду");
    this.Text("RentMotel-Desc-NoTell", "Комната мотеля в аренду");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Открыть дверь");
    this.Text("RentMotel-UI-HallwayDoor", "Дверь в коридор");
    this.Text("RentMotel-UI-CloseDoor", "Закрыть дверь");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Арендовать на 24 часа - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 ч: Недостаточно денег ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Арендовать на 7 дней - {price}€$ (скидка 10%)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 дн: Недостаточно денег ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Купить навсегда - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Навсегда: Недостаточно денег ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Цены комнат (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Настройки аренды");
    this.Text("RentMotel-Settings-PermanentCategory", "Постоянная аренда");
    this.Text("RentMotel-Settings-SunsetPrice", "Мотель Сансет, комната 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "По умолчанию: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Мотель Кабуки, комната 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "По умолчанию: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Мотель Дьюдроп Инн, комната 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "По умолчанию: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "Мотель Но-Телл, комната 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "По умолчанию: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Продолжительность аренды (дни)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Количество дней для расширенной аренды. По умолчанию: 7 дней. Цена включает скидку 10%.");
    this.Text("RentMotel-Settings-PermanentToggle", "Включить постоянную аренду");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "При включении добавляет третий вариант аренды с постоянным владением (999999 дней). По умолчанию: Выключено.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Постоянная цена Мотель Сансет");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Цена постоянного владения Мотель Сансет, комната 102. По умолчанию: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Постоянная цена Мотель Кабуки");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Цена постоянного владения Мотель Кабуки, комната 203. По умолчанию: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Постоянная цена Мотель Дьюдроп Инн");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Цена постоянного владения Мотель Дьюдроп Инн, комната 106. По умолчанию: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "Постоянная цена Мотель Но-Телл");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Цена постоянного владения Мотель Но-Телл, комната 206. По умолчанию: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Chambre de motel louable");
    this.Text("RentMotel-Desc-Kabuki", "Chambre de motel louable");
    this.Text("RentMotel-Desc-Dewdrop", "Chambre de motel louable");
    this.Text("RentMotel-Desc-NoTell", "Chambre de motel louable");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Ouvrir la Porte");
    this.Text("RentMotel-UI-HallwayDoor", "Couloir");
    this.Text("RentMotel-UI-CloseDoor", "Fermer la Porte");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Louer pour 24 heures - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Pas assez d'argent ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Louer pour 7 jours - {price}€$ (10% de réduction)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7j: Pas assez d'argent ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Acheter définitivement - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Permanent: Pas assez d'argent ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Prix des chambres (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Options de location");
    this.Text("RentMotel-Settings-PermanentCategory", "Location permanente");
    this.Text("RentMotel-Settings-SunsetPrice", "Sunset Motel Chambre 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Par défaut : 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Kabuki Motel Chambre 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Par défaut : 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Dewdrop Inn Chambre 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Par défaut : 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "No-Tell Motel Chambre 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Par défaut : 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Durée de location prolongée (jours)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Nombre de jours pour la location prolongée. Par défaut : 7 jours. Le prix inclut une réduction de 10%.");
    this.Text("RentMotel-Settings-PermanentToggle", "Activer la location permanente");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "Ajoute une troisième option de location avec propriété permanente (999999 jours). Par défaut : Désactivé.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Prix permanent Sunset Motel");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Prix de propriété permanente du Sunset Motel Chambre 102. Par défaut : 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Prix permanent Kabuki Motel");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Prix de propriété permanente du Kabuki Motel Chambre 203. Par défaut : 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Prix permanent Dewdrop Inn");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Prix de propriété permanente du Dewdrop Inn Chambre 106. Par défaut : 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "Prix permanent No-Tell Motel");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Prix de propriété permanente du No-Tell Motel Chambre 206. Par défaut : 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Quarto de motel para alugar");
    this.Text("RentMotel-Desc-Kabuki", "Quarto de motel para alugar");
    this.Text("RentMotel-Desc-Dewdrop", "Quarto de motel para alugar");
    this.Text("RentMotel-Desc-NoTell", "Quarto de motel para alugar");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir porta");
    this.Text("RentMotel-UI-HallwayDoor", "Porta do corredor");
    this.Text("RentMotel-UI-CloseDoor", "Fechar porta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Aluguel por 24 horas - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: Dinheiro insuficiente ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Aluguel por 7 dias - {price}€$ (10% de desconto diariamente)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: Dinheiro insuficiente ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Comprar permanentemente - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Permanente: Dinheiro insuficiente ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Preços dos quartos (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Opções de aluguel");
    this.Text("RentMotel-Settings-PermanentCategory", "Aluguel permanente");
    this.Text("RentMotel-Settings-SunsetPrice", "Motel Sunset Quarto 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Padrão: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Motel Kabuki Quarto 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Padrão: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Pousada Dewdrop Quarto 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Padrão: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "Motel No-Tell Quarto 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Padrão: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Duração do aluguel prolongado (dias)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Número de dias para o aluguel prolongado. Padrão: 7 dias. O preço inclui 10% de desconto.");
    this.Text("RentMotel-Settings-PermanentToggle", "Ativar aluguel permanente");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "Adiciona uma terceira opção de aluguel com propriedade permanente (999999 dias). Padrão: Desativado.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Preço permanente Motel Sunset");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Preço de propriedade permanente do Motel Sunset Quarto 102. Padrão: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Preço permanente Motel Kabuki");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Preço de propriedade permanente do Motel Kabuki Quarto 203. Padrão: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Preço permanente Pousada Dewdrop");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Preço de propriedade permanente da Pousada Dewdrop Quarto 106. Padrão: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "Preço permanente Motel No-Tell");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Preço de propriedade permanente do Motel No-Tell Quarto 206. Padrão: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Habitación de motel en alquiler");
    this.Text("RentMotel-Desc-Kabuki", "Habitación de motel en alquiler");
    this.Text("RentMotel-Desc-Dewdrop", "Habitación de motel en alquiler");
    this.Text("RentMotel-Desc-NoTell", "Habitación de motel en alquiler");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Abrir puerta");
    this.Text("RentMotel-UI-HallwayDoor", "Puerta del pasillo");
    this.Text("RentMotel-UI-CloseDoor", "Cerrar puerta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Alquilar por 24 horas - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: No hay suficiente dinero ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Alquilar por 7 días - {price}€$ (10% de descuento diario)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: No hay suficiente dinero ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Comprar permanentemente - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Permanente: No hay suficiente dinero ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Precios de habitaciones (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Opciones de alquiler");
    this.Text("RentMotel-Settings-PermanentCategory", "Alquiler permanente");
    this.Text("RentMotel-Settings-SunsetPrice", "Motel Sunset Habitación 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Por defecto: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Motel Kabuki Habitación 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Por defecto: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Dewdrop Inn Habitación 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Por defecto: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "No-Tell Motel Habitación 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Por defecto: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Duración de alquiler extendido (días)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Número de días para el alquiler extendido. Por defecto: 7 días. El precio incluye un 10% de descuento.");
    this.Text("RentMotel-Settings-PermanentToggle", "Activar alquiler permanente");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "Añade una tercera opción de alquiler con propiedad permanente (999999 días). Por defecto: Desactivado.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Precio permanente Motel Sunset");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Precio de propiedad permanente del Motel Sunset Habitación 102. Por defecto: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Precio permanente Motel Kabuki");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Precio de propiedad permanente del Motel Kabuki Habitación 203. Por defecto: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Precio permanente Dewdrop Inn");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Precio de propiedad permanente del Dewdrop Inn Habitación 106. Por defecto: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "Precio permanente No-Tell Motel");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Precio de propiedad permanente del No-Tell Motel Habitación 206. Por defecto: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "可租用的汽車旅館房間");
    this.Text("RentMotel-Desc-Kabuki", "可租用的汽車旅館房間");
    this.Text("RentMotel-Desc-Dewdrop", "可租用的汽車旅館房間");
    this.Text("RentMotel-Desc-NoTell", "可租用的汽車旅館房間");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "開門");
    this.Text("RentMotel-UI-HallwayDoor", "走廊門");
    this.Text("RentMotel-UI-CloseDoor", "關門");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "租用24小時 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24小時: 沒有足夠的金錢 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "租用7小時 - {price}€$ (每天10%折扣)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7小時: 沒有足夠的金錢 ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "永久購買 - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "永久: 沒有足夠的金錢 ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "房間價格 (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "租用選項");
    this.Text("RentMotel-Settings-PermanentCategory", "永久租用");
    this.Text("RentMotel-Settings-SunsetPrice", "日落汽車旅館-102房間");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "預設: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "歌舞伎町汽車旅館-203房間");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "預設: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "露珠汽車旅館-106房間");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "預設: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "不語汽車旅館-206房間");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "預設: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "延長租用天數");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "設定延長租用的天數。預設: 7天。價格包含10%折扣。");
    this.Text("RentMotel-Settings-PermanentToggle", "啟用永久租用");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "啟用後增加第三個永久擁有的租用選項 (999999天)。預設: 停用。");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "日落汽車旅館永久價格");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "日落汽車旅館102房間的永久擁有價格。預設: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "歌舞伎町汽車旅館永久價格");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "歌舞伎町汽車旅館203房間的永久擁有價格。預設: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "露珠汽車旅館永久價格");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "露珠汽車旅館106房間的永久擁有價格。預設: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "不語汽車旅館永久價格");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "不語汽車旅館206房間的永久擁有價格。預設: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "可租用的汽车旅馆房间");
    this.Text("RentMotel-Desc-Kabuki", "可租用的汽车旅馆房间");
    this.Text("RentMotel-Desc-Dewdrop", "可租用的汽车旅馆房间");
    this.Text("RentMotel-Desc-NoTell", "可租用的汽车旅馆房间");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "开门");
    this.Text("RentMotel-UI-HallwayDoor", "走廊门");
    this.Text("RentMotel-UI-CloseDoor", "关门");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "租用24小时 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24小时：资金不足 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "租用7天 - {price}€$ (每日享受10%折扣)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7天：资金不足 ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "永久购买 - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "永久：资金不足 ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "房间价格 (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "租用选项");
    this.Text("RentMotel-Settings-PermanentCategory", "永久租用");
    this.Text("RentMotel-Settings-SunsetPrice", "日落汽车旅馆102房间");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "默认: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "歌舞伎汽车旅馆203房间");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "默认: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "露珠旅馆106房间");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "默认: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "无名汽车旅馆206房间");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "默认: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "延长租用天数");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "设定延长租用的天数。默认: 7天。价格包含10%折扣。");
    this.Text("RentMotel-Settings-PermanentToggle", "启用永久租用");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "启用后增加第三个永久拥有的租用选项 (999999天)。默认: 停用。");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "日落汽车旅馆永久价格");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "日落汽车旅馆102房间的永久拥有价格。默认: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "歌舞伎汽车旅馆永久价格");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "歌舞伎汽车旅馆203房间的永久拥有价格。默认: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "露珠旅馆永久价格");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "露珠旅馆106房间的永久拥有价格。默认: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "无名汽车旅馆永久价格");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "无名汽车旅馆206房间的永久拥有价格。默认: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "レンタル可能なモーテルルーム");
    this.Text("RentMotel-Desc-Kabuki", "レンタル可能なモーテルルーム");
    this.Text("RentMotel-Desc-Dewdrop", "レンタル可能なモーテルルーム");
    this.Text("RentMotel-Desc-NoTell", "レンタル可能なモーテルルーム");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "ドアを開ける");
    this.Text("RentMotel-UI-HallwayDoor", "廊下のドア");
    this.Text("RentMotel-UI-CloseDoor", "ドアを閉める");
 
    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "24時間レンタル - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24h: お金が足りません ({price}€$)");
    this.Text("RentMotel-Choice-7d", "7日間レンタル - {price}€$ (毎日10%オフ)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7d: お金が足りません ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "永久購入 - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "永久: お金が足りません ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "部屋の価格 (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "レンタルオプション");
    this.Text("RentMotel-Settings-PermanentCategory", "永久レンタル");
    this.Text("RentMotel-Settings-SunsetPrice", "サンセット・モーテル 102号室");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "デフォルト: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "カブキ・モーテル 203号室");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "デフォルト: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "デュードロップ・モーテル 106号室");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "デフォルト: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "ノーテル・モーテル 206号室");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "デフォルト: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "延長レンタル日数");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "延長レンタルの日数を設定します。デフォルト: 7日。価格には10%割引が含まれます。");
    this.Text("RentMotel-Settings-PermanentToggle", "永久レンタルを有効にする");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "有効にすると、永久所有(999999日)の第三のオプションが追加されます。デフォルト: 無効。");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "サンセット・モーテル永久価格");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "サンセット・モーテル102号室の永久所有価格。デフォルト: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "カブキ・モーテル永久価格");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "カブキ・モーテル203号室の永久所有価格。デフォルト: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "デュードロップ・モーテル永久価格");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "デュードロップ・モーテル106号室の永久所有価格。デフォルト: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "ノーテル・モーテル永久価格");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "ノーテル・モーテル206号室の永久所有価格。デフォルト: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Stanza di motel affittabile");
    this.Text("RentMotel-Desc-Kabuki", "Stanza di motel affittabile");
    this.Text("RentMotel-Desc-Dewdrop", "Stanza di motel affittabile");
    this.Text("RentMotel-Desc-NoTell", "Stanza di motel affittabile");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Apri la porta");
    this.Text("RentMotel-UI-HallwayDoor", "Porta del corridoio");
    this.Text("RentMotel-UI-CloseDoor", "Chiudi la porta");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Affittabile per 24 ore - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 ore: Non hai abbastanza soldi ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Affittabile per 7 giorni - {price}€$ (10% di sconto giornaliero)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 giorni: non hai abbastanza soldi ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Acquista permanentemente - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Permanente: Non hai abbastanza soldi ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Prezzi delle stanze (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Opzioni di affitto");
    this.Text("RentMotel-Settings-PermanentCategory", "Affitto permanente");
    this.Text("RentMotel-Settings-SunsetPrice", "Sunset Motel Stanza 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Predefinito: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Kabuki Motel Stanza 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Predefinito: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Dewdrop Inn Stanza 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Predefinito: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "No-Tell Motel Stanza 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Predefinito: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Durata affitto prolungato (giorni)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Imposta il numero di giorni per l'affitto prolungato. Predefinito: 7 giorni. Il prezzo include uno sconto del 10%.");
    this.Text("RentMotel-Settings-PermanentToggle", "Abilita affitto permanente");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "Aggiunge una terza opzione con proprietà permanente (999999 giorni). Predefinito: Disabilitato.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Prezzo permanente Sunset Motel");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Prezzo di proprietà permanente del Sunset Motel Stanza 102. Predefinito: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Prezzo permanente Kabuki Motel");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Prezzo di proprietà permanente del Kabuki Motel Stanza 203. Predefinito: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Prezzo permanente Dewdrop Inn");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Prezzo di proprietà permanente del Dewdrop Inn Stanza 106. Predefinito: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "Prezzo permanente No-Tell Motel");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Prezzo di proprietà permanente del No-Tell Motel Stanza 206. Predefinito: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "대여 가능한 모텔 객실");
    this.Text("RentMotel-Desc-Kabuki", "대여 가능한 모텔 객실");
    this.Text("RentMotel-Desc-Dewdrop", "대여 가능한 모텔 객실");
    this.Text("RentMotel-Desc-NoTell", "대여 가능한 모텔 객실");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "문 열기");
    this.Text("RentMotel-UI-HallwayDoor", "복도 문");
    this.Text("RentMotel-UI-CloseDoor", "문 닫기");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "24시간 대여 - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24시간: 에디 부족 ({price}€$)");
    this.Text("RentMotel-Choice-7d", "7일 대여 - {price}€$ (일일 요금 10% 할인)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7일: 에디 부족 ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "영구 구매 - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "영구: 에디 부족 ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "객실 가격 (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "대여 옵션");
    this.Text("RentMotel-Settings-PermanentCategory", "영구 대여");
    this.Text("RentMotel-Settings-SunsetPrice", "선셋 모텔 102호");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "기본값: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "카부키 모텔 203호");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "기본값: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "듀드롭 인 모텔 106호");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "기본값: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "노텔 모텔 206호");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "기본값: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "연장 대여 기간 (일)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "연장 대여의 일수를 설정합니다. 기본값: 7일. 가격에 10% 할인이 포함됩니다.");
    this.Text("RentMotel-Settings-PermanentToggle", "영구 대여 활성화");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "활성화하면 영구 소유(999999일)의 세 번째 옵션이 추가됩니다. 기본값: 비활성화.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "선셋 모텔 영구 가격");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "선셋 모텔 102호의 영구 소유 가격. 기본값: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "카부키 모텔 영구 가격");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "카부키 모텔 203호의 영구 소유 가격. 기본값: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "듀드롭 인 모텔 영구 가격");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "듀드롭 인 모텔 106호의 영구 소유 가격. 기본값: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "노텔 모텔 영구 가격");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "노텔 모텔 206호의 영구 소유 가격. 기본값: 70000€$");
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
    this.Text("RentMotel-Desc-Sunset", "Mietbares Motelzimmer");
    this.Text("RentMotel-Desc-Kabuki", "Mietbares Motelzimmer");
    this.Text("RentMotel-Desc-Dewdrop", "Mietbares Motelzimmer");
    this.Text("RentMotel-Desc-NoTell", "Mietbares Motelzimmer");

    // UI strings
    this.Text("RentMotel-UI-OpenDoor", "Tür Öffnen");
    this.Text("RentMotel-UI-HallwayDoor", "Tür zum Flur");
    this.Text("RentMotel-UI-CloseDoor", "Tür Schließen");

    // Interaction choices with placeholders
    this.Text("RentMotel-Choice-24h", "Für 24 Stunden mieten - {price}€$");
    this.Text("RentMotel-Choice-24h-NoMoney", "24 Stunden: Nicht genug Geld ({price}€$)");
    this.Text("RentMotel-Choice-7d", "Für 7 Tage mieten - {price}€$ (10% Rabatt pro Tag)");
    this.Text("RentMotel-Choice-7d-NoMoney", "7 Tage: Nicht genug Geld ({price}€$)");
    this.Text("RentMotel-Choice-Permanent", "Dauerhaft kaufen - {price}€$");
    this.Text("RentMotel-Choice-Permanent-NoMoney", "Dauerhaft: Nicht genug Geld ({price}€$)");

    // Native Settings UI strings
    this.Text("RentMotel-Settings-TabName", "Rent A Motel");
    this.Text("RentMotel-Settings-PricesCategory", "Zimmerpreise (€$)");
    this.Text("RentMotel-Settings-RentalOptionsCategory", "Mietoptionen");
    this.Text("RentMotel-Settings-PermanentCategory", "Dauerhaftes Mieten");
    this.Text("RentMotel-Settings-SunsetPrice", "Sunset Motel Zimmer 102");
    this.Text("RentMotel-Settings-SunsetPriceDesc", "Standard: 450€$");
    this.Text("RentMotel-Settings-KabukiPrice", "Kabuki Motel Zimmer 203");
    this.Text("RentMotel-Settings-KabukiPriceDesc", "Standard: 700€$");
    this.Text("RentMotel-Settings-DewdropPrice", "Dewdrop Inn Zimmer 106");
    this.Text("RentMotel-Settings-DewdropPriceDesc", "Standard: 1000€$");
    this.Text("RentMotel-Settings-NoTellPrice", "No-Tell Motel Zimmer 206");
    this.Text("RentMotel-Settings-NoTellPriceDesc", "Standard: 700€$");
    this.Text("RentMotel-Settings-ExtendedDays", "Verlängerte Mietdauer (Tage)");
    this.Text("RentMotel-Settings-ExtendedDaysDesc", "Anzahl der Tage für die verlängerte Mietoption. Standard: 7 Tage. Der Preis beinhaltet 10% Rabatt.");
    this.Text("RentMotel-Settings-PermanentToggle", "Dauerhaftes Mieten aktivieren");
    this.Text("RentMotel-Settings-PermanentToggleDesc", "Fügt eine dritte Option mit dauerhaftem Besitz hinzu (999999 Tage). Standard: Deaktiviert.");
    this.Text("RentMotel-Settings-SunsetPermanentPrice", "Sunset Motel Dauerpreis");
    this.Text("RentMotel-Settings-SunsetPermanentPriceDesc", "Preis für dauerhaften Besitz des Sunset Motel Zimmer 102. Standard: 45000€$");
    this.Text("RentMotel-Settings-KabukiPermanentPrice", "Kabuki Motel Dauerpreis");
    this.Text("RentMotel-Settings-KabukiPermanentPriceDesc", "Preis für dauerhaften Besitz des Kabuki Motel Zimmer 203. Standard: 70000€$");
    this.Text("RentMotel-Settings-DewdropPermanentPrice", "Dewdrop Inn Dauerpreis");
    this.Text("RentMotel-Settings-DewdropPermanentPriceDesc", "Preis für dauerhaften Besitz des Dewdrop Inn Zimmer 106. Standard: 100000€$");
    this.Text("RentMotel-Settings-NoTellPermanentPrice", "No-Tell Motel Dauerpreis");
    this.Text("RentMotel-Settings-NoTellPermanentPriceDesc", "Preis für dauerhaften Besitz des No-Tell Motel Zimmer 206. Standard: 70000€$");
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


