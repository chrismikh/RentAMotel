module RentMotel

class MotelMappinSS extends ScriptableSystem {

    public static persistent let mappinIDs: array<NewMappinID>;

    public func CreateMotelMappin() {
        // Sunset Motel Mappin Creation
        let sunsetMotelMappinPos: Vector4;
        sunsetMotelMappinPos.X = 1662.2933;
        sunsetMotelMappinPos.Y = -785.7644; 
        sunsetMotelMappinPos.Z = 49.84044;   
        sunsetMotelMappinPos.W = 1.0;

        // Create custom mappin data for the motel
        let sunsetMotelRoleData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
        sunsetMotelRoleData.m_range = 100.0;
        sunsetMotelRoleData.m_mappinVisualState = EMappinVisualState.Default;
        sunsetMotelRoleData.m_gameplayRole = EGameplayRole.ServicePoint;
        sunsetMotelRoleData.m_showOnMiniMap = true;
        sunsetMotelRoleData.m_visibleThroughWalls = false;
        
        // Add custom fields for our motel
        sunsetMotelRoleData.m_customUsedMotel = true;
        sunsetMotelRoleData.m_customNameMotel = "Sunset Motel room 102";
        sunsetMotelRoleData.m_customDescMotel = "Rentable for 24 hours - 250€$";
        sunsetMotelRoleData.m_customIconMotel = n"apartment";
        sunsetMotelRoleData.m_customAtlasMotel = r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas";
        sunsetMotelRoleData.m_customTintMotel = new HDRColor(0.8, 0.6, 0.2, 1.0);

        let sunsetMotelMappinData: MappinData = new MappinData();
        sunsetMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        sunsetMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        sunsetMotelMappinData.active = true;
        sunsetMotelMappinData.debugCaption = "Sunset Motel Room Mappin";
        sunsetMotelMappinData.visibleThroughWalls = false;
        sunsetMotelMappinData.scriptData = sunsetMotelRoleData;

        // Register the mappin and store the ID in the array
        let sunsetMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(sunsetMotelMappinData, sunsetMotelMappinPos);
        ArrayPush(this.mappinIDs, sunsetMotelID);

        ////////////////////////////////////////////////////////////////////////////

        // Kabuki Motel Mappin Creation
        let kabukiMotelMappinPos: Vector4;
        kabukiMotelMappinPos.X = -1248.2646;
        kabukiMotelMappinPos.Y = 1982.6512;
        kabukiMotelMappinPos.Z = 12.016251;
        kabukiMotelMappinPos.W = 1.0;

        let kabukiMotelRoleData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
        kabukiMotelRoleData.m_range = 100.0;
        kabukiMotelRoleData.m_mappinVisualState = EMappinVisualState.Default;
        kabukiMotelRoleData.m_gameplayRole = EGameplayRole.ServicePoint;
        kabukiMotelRoleData.m_showOnMiniMap = true;
        kabukiMotelRoleData.m_visibleThroughWalls = false;

        // Custom fields for the new mappin
        kabukiMotelRoleData.m_customUsedMotel = true;
        kabukiMotelRoleData.m_customNameMotel = "Kabuki Motel room 203";
        kabukiMotelRoleData.m_customDescMotel = "Rentable for 24 hours - 500€$";
        kabukiMotelRoleData.m_customIconMotel = n"apartment";
        kabukiMotelRoleData.m_customAtlasMotel = r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas";
        kabukiMotelRoleData.m_customTintMotel = new HDRColor(0.8, 0.6, 0.2, 1.0);

        let kabukiMotelMappinData: MappinData = new MappinData();
        kabukiMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        kabukiMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        kabukiMotelMappinData.active = true;
        kabukiMotelMappinData.debugCaption = "Kabuki Motel Room Mappin";
        kabukiMotelMappinData.visibleThroughWalls = false;
        kabukiMotelMappinData.scriptData = kabukiMotelRoleData;

        let kabukiMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(kabukiMotelMappinData, kabukiMotelMappinPos);
        ArrayPush(this.mappinIDs, kabukiMotelID);

        ////////////////////////////////////////////////////////////////////////////
        
        // Dewdrop Inn Motel Mappin Creation
        let DewdropInnMotelMappinPos: Vector4;
        DewdropInnMotelMappinPos.X = -563.39307;
        DewdropInnMotelMappinPos.Y = -814.91583;
        DewdropInnMotelMappinPos.Z = 8.199997;
        DewdropInnMotelMappinPos.W = 1.0;

        let DewdropInnMotelRoleData: ref<GameplayRoleMappinData> = new GameplayRoleMappinData();
        DewdropInnMotelRoleData.m_range = 100.0;
        DewdropInnMotelRoleData.m_mappinVisualState = EMappinVisualState.Default;
        DewdropInnMotelRoleData.m_gameplayRole = EGameplayRole.ServicePoint;
        DewdropInnMotelRoleData.m_showOnMiniMap = true;
        DewdropInnMotelRoleData.m_visibleThroughWalls = false;

        // Custom fields for the new mappin
        DewdropInnMotelRoleData.m_customUsedMotel = true;
        DewdropInnMotelRoleData.m_customNameMotel = "Dewdrop Inn Motel room 106";
        DewdropInnMotelRoleData.m_customDescMotel = "Rentable for 24 hours - 800€$";
        DewdropInnMotelRoleData.m_customIconMotel = n"apartment";
        DewdropInnMotelRoleData.m_customAtlasMotel = r"base\\gameplay\\gui\\common\\icons\\mappin_icons.inkatlas";
        DewdropInnMotelRoleData.m_customTintMotel = new HDRColor(0.8, 0.6, 0.2, 1.0);

        let DewdropInnMotelMappinData: MappinData = new MappinData();
        DewdropInnMotelMappinData.mappinType = t"Mappins.DefaultStaticMappin";
        DewdropInnMotelMappinData.variant = gamedataMappinVariant.Zzz05_ApartmentToPurchaseVariant;
        DewdropInnMotelMappinData.active = true;
        DewdropInnMotelMappinData.debugCaption = "DewdropInn Motel Room Mappin";
        DewdropInnMotelMappinData.visibleThroughWalls = false;
        DewdropInnMotelMappinData.scriptData = DewdropInnMotelRoleData;

        let DewdropInnMotelID: NewMappinID = GameInstance.GetMappinSystem(GetGameInstance()).RegisterMappin(DewdropInnMotelMappinData, DewdropInnMotelMappinPos);
        ArrayPush(this.mappinIDs, DewdropInnMotelID);
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

    public func SetCustomMapMarkerIcon(mappin: ref<IMappin>, imageWidget: inkImageRef) -> Void {
        if IsDefined(mappin) {
            let mappinData: ref<GameplayRoleMappinData> = mappin.GetScriptData() as GameplayRoleMappinData;
            if IsDefined(mappinData) && mappinData.m_customUsedMotel {
                // Set the atlas resource and texture part consistently
                inkImageRef.SetAtlasResource(imageWidget, mappinData.m_customAtlasMotel);
                inkImageRef.SetTexturePart(imageWidget, mappinData.m_customIconMotel);
                inkWidgetRef.SetTintColor(imageWidget, mappinData.m_customTintMotel);
            }
        }
    }

    public static func GetSS() -> ref<MotelMappinSS> {
        return GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"RentMotel.MotelMappinSS") as MotelMappinSS;
    }
}

// Add custom fields to GameplayRoleMappinData for our motel
@addField(GameplayRoleMappinData)
public let m_customUsedMotel: Bool;

@addField(GameplayRoleMappinData)
public let m_customNameMotel: String;

@addField(GameplayRoleMappinData)
public let m_customDescMotel: String;

@addField(GameplayRoleMappinData)
public let m_customIconMotel: CName;

@addField(GameplayRoleMappinData)
public let m_customAtlasMotel: ResRef;

@addField(GameplayRoleMappinData)
public let m_customTintMotel: HDRColor;

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

// Update mappin icons in minimap
@wrapMethod(MinimapDeviceMappinController)
protected func Update() -> Void {
    wrappedMethod();
    let ss: ref<MotelMappinSS> = MotelMappinSS.GetSS();
    if IsDefined(ss) && IsDefined(this.m_mappin) {
        ss.SetCustomMapMarkerIcon(this.m_mappin, this.iconWidget);
    }
}

// Update mappin icons in world map
@wrapMethod(BaseWorldMapMappinController)
protected func UpdateIcon() -> Void {
    wrappedMethod();
    let ss: ref<MotelMappinSS> = MotelMappinSS.GetSS();
    if IsDefined(ss) && IsDefined(this.m_mappin) {
        ss.SetCustomMapMarkerIcon(this.m_mappin, this.iconWidget);
    }
}

// Update mappin icons in gameplay view
@wrapMethod(GameplayMappinController)
private func UpdateIcon() -> Void {
    if IsDefined(this.m_mappin) {
        let mappinData: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
        if IsDefined(mappinData) && mappinData.m_customUsedMotel {
            inkWidgetRef.SetVisible(this.m_scanningDiamond, false);
            
            let ss: ref<MotelMappinSS> = MotelMappinSS.GetSS();
            if IsDefined(ss) {
                ss.SetCustomMapMarkerIcon(this.m_mappin, this.iconWidget);
            }
            
            // Show/hide based on distance
            let playerPos: Vector4 = GetPlayer(GetGameInstance()).GetWorldPosition();
            let mappinPos: Vector4 = this.m_mappin.GetWorldPosition();
            let distance: Float = Vector4.Distance(playerPos, mappinPos);
            inkWidgetRef.SetVisible(this.iconWidget, distance < mappinData.m_range);
            return;
        }
    }
    wrappedMethod();
}

// Update tooltip text for world map
@wrapMethod(WorldMapTooltipController)
public func SetData(const data: script_ref<WorldMapTooltipData>, menu: ref<WorldMapMenuGameController>) -> Void {
    wrappedMethod(data, menu);
    
    if IsDefined(Deref(data).controller) && IsDefined(Deref(data).mappin) && IsDefined(menu.GetPlayer()) {
        let mappinData: ref<GameplayRoleMappinData> = Deref(data).mappin.GetScriptData() as GameplayRoleMappinData;
        if IsDefined(mappinData) && mappinData.m_customUsedMotel {
            inkTextRef.SetText(this.m_titleText, mappinData.m_customNameMotel);
            inkTextRef.SetText(this.m_descText, mappinData.m_customDescMotel);
        }
    }
}