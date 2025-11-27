module RentMotel

class MotelMappinSS extends ScriptableSystem {

    public static persistent let mappinIDs: array<NewMappinID>;

    public func CreateMotelMappin() {
        // Sunset Motel Mappin Creation
        let sunsetMotelMappinPos: Vector4;
        sunsetMotelMappinPos.X = 1660.8585;
        sunsetMotelMappinPos.Y = -785.79663; 
        sunsetMotelMappinPos.Z = 50.84044;   
        sunsetMotelMappinPos.W = 1.0;

        let sunsetMotelMappinData: MappinData = new MappinData();
        sunsetMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        sunsetMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        sunsetMotelMappinData.active = true;
        sunsetMotelMappinData.debugCaption = "RM_RentMotel|" + GetLocalizedTextByKey(n"RentMotel-Title-Sunset") + "|" + GetLocalizedTextByKey(n"RentMotel-Desc-Sunset");
        sunsetMotelMappinData.visibleThroughWalls = false;

        // Register the mappin and store the ID in the array
        let sunsetMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(sunsetMotelMappinData, sunsetMotelMappinPos);
        ArrayPush(this.mappinIDs, sunsetMotelID);

        ////////////////////////////////////////////////////////////////////////////

        // Kabuki Motel Mappin Creation
        let kabukiMotelMappinPos: Vector4;
        kabukiMotelMappinPos.X = -1249.1337;
        kabukiMotelMappinPos.Y = 1981.7214;
        kabukiMotelMappinPos.Z = 13.016251;
        kabukiMotelMappinPos.W = 1.0;

        let kabukiMotelMappinData: MappinData = new MappinData();
        kabukiMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        kabukiMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        kabukiMotelMappinData.active = true;
        kabukiMotelMappinData.debugCaption = "RM_RentMotel|" + GetLocalizedTextByKey(n"RentMotel-Title-Kabuki") + "|" + GetLocalizedTextByKey(n"RentMotel-Desc-Kabuki");
        kabukiMotelMappinData.visibleThroughWalls = false;

        let kabukiMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(kabukiMotelMappinData, kabukiMotelMappinPos);
        ArrayPush(this.mappinIDs, kabukiMotelID);

        ////////////////////////////////////////////////////////////////////////////
        
        // Dewdrop Inn Motel Mappin Creation
        let DewdropInnMotelMappinPos: Vector4;
        DewdropInnMotelMappinPos.X = -563.10315;
        DewdropInnMotelMappinPos.Y = -813.8557;
        DewdropInnMotelMappinPos.Z = 9.199997;
        DewdropInnMotelMappinPos.W = 1.0;

        let DewdropInnMotelMappinData: MappinData = new MappinData();
        DewdropInnMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        DewdropInnMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        DewdropInnMotelMappinData.active = true;
        DewdropInnMotelMappinData.debugCaption = "RM_RentMotel|" + GetLocalizedTextByKey(n"RentMotel-Title-Dewdrop") + "|" + GetLocalizedTextByKey(n"RentMotel-Desc-Dewdrop");
        DewdropInnMotelMappinData.visibleThroughWalls = false;

        let DewdropInnMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(DewdropInnMotelMappinData, DewdropInnMotelMappinPos);
        ArrayPush(this.mappinIDs, DewdropInnMotelID);

        ////////////////////////////////////////////////////////////////////////////

        // No-Tell Motel Mappin Creation
        let noTellPos: Vector4;
        noTellPos.X = -1137.5416;
        noTellPos.Y = 1320.3446;
        noTellPos.Z = 29.0;
        noTellPos.W = 1.0;

        let noTellData: MappinData = new MappinData();
        noTellData.mappinType = t"Mappins.DefaultStaticMappin";
        noTellData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        noTellData.active = true;
        noTellData.debugCaption = "RM_RentMotel|" + GetLocalizedTextByKey(n"RentMotel-Title-NoTell") + "|" + GetLocalizedTextByKey(n"RentMotel-Desc-NoTell");
        noTellData.visibleThroughWalls = false;

        let noTellID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(noTellData, noTellPos);
        ArrayPush(this.mappinIDs, noTellID);
    }

    public func RemoveMotelMappin() {
        // Remove all mappins in the array
        let mappinSys = GameInstance.GetMappinSystem(GetGameInstance());
        let i: Int32 = 0;
        while i < ArraySize(this.mappinIDs) {
            mappinSys.UnregisterMappin(this.mappinIDs[i]);
            i += 1;
        }
        ArrayClear(this.mappinIDs);
    }

    public static func GetSS() -> ref<MotelMappinSS> {
        return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"RentMotel.MotelMappinSS") as MotelMappinSS;
    }
}

// ---- shared: detect mappins via the debugCaption ----
@addMethod(BaseMappinBaseController)
protected final func __rmIsOurMotelPin() -> Bool {
  let cap: String = this.GetMappin().GetDisplayName();
  let parts: array<String> = StrSplit(cap, "|");
  return ArraySize(parts) > 0 && Equals(parts[0], "RM_RentMotel");
}

// ---- shared: apply the motel icon ----
@addMethod(BaseMappinBaseController)
protected final func __rmApplyMotelIcon(opt forMinimap: Bool) -> Void {
  if !this.__rmIsOurMotelPin() { return; }

  inkImageRef.SetAtlasResource(this.iconWidget, r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas");
  inkImageRef.SetTexturePart(this.iconWidget, n"apartment");

  // Only scale for minimap
  if forMinimap {
    inkWidgetRef.SetScale(this.iconWidget, new Vector2(1.0, 1.0));
  }
}

// Hook into player spawn to create the mappin
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
    let bResult: Bool = wrappedMethod();
    
    // Create motel mappin when player spawns
    let ss: ref<MotelMappinSS> = MotelMappinSS.GetSS();
    ss.CreateMotelMappin();
    
    return bResult;
}

// Clean up mappin when player detaches
@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
    let ss: ref<MotelMappinSS> = MotelMappinSS.GetSS();
    ss.RemoveMotelMappin();
    
    return wrappedMethod();
}

// ===== minimap pin =====
@wrapMethod(MinimapPOIMappinController)
protected final func UpdateIcon() -> Void {
  wrappedMethod();
  this.__rmApplyMotelIcon(true);     // minimap
}

// ===== minimap device controller (for POI pins) =====
@wrapMethod(MinimapDeviceMappinController)
protected func Update() -> Void {
  wrappedMethod();
  this.__rmApplyMotelIcon(true);     // minimap
}

// ===== world *floating* pin (in the game world) =====
@wrapMethod(QuestMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  this.__rmApplyMotelIcon(false);    // world-space
}

// ===== gameplay controller (for tracked pins in world) =====
@wrapMethod(GameplayMappinController)
private func UpdateIcon() -> Void {
  // Let the game handle the default behavior first
  wrappedMethod();

  // Then apply custom icon if it's our pin
  if IsDefined(this.m_mappin) && this.__rmIsOurMotelPin() {
    this.__rmApplyMotelIcon(false);
  }
}

// ===== World Map screen =====
@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() -> Void {
  wrappedMethod();
  this.__rmApplyMotelIcon(false);    // world-map screen
}

// Update tooltip text for world map
@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
  wrappedMethod(data, menu);

  let parts: array<String> = StrSplit(Deref(data).mappin.GetDisplayName(), "|");
  if ArraySize(parts) >= 3 && Equals(parts[0], "RM_RentMotel") {
    inkTextRef.SetText(this.m_titleText, parts[1]); // custom title
    inkTextRef.SetText(this.m_descText,  parts[2]); // custom desc
  }
}