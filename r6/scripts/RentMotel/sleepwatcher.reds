module RentMotel

// ScriptableSystem to track whether the player is sleeping or skipping time
public final class MotelSleepWatcherSS extends ScriptableSystem {
    private let skippingTimeFromHubMenu: Bool = false;
    private let wasSleeping: Bool = false;

    public static func GetInstance(gameInstance: GameInstance) -> ref<MotelSleepWatcherSS> {
        let instance: ref<MotelSleepWatcherSS> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"RentMotel.MotelSleepWatcherSS") as MotelSleepWatcherSS;
        return instance;
    }

    public func SetSkippingTimeFromHubMenu(value: Bool) -> Void {
        this.skippingTimeFromHubMenu = value;
    }

    public func GetSkippingTimeFromHubMenu() -> Bool {
        return this.skippingTimeFromHubMenu;
    }

    public func SetWasSleeping(value: Bool) -> Void {
        this.wasSleeping = value;
    }

    public func OnTimeSkipFinished() -> Void {
        if this.wasSleeping {
            // Player slept in a bed
            // DEBUG MESSAGE - FTLog("[RentMotel] Player slept in a bed. Re-adding motel mappin.");
            let mappinSS: ref<MotelMappinSS> = MotelMappinSS.GetSS();
            if IsDefined(mappinSS) {
                mappinSS.CreateMotelMappin();
            }
        } else {
            // DEBUG MESSAGE - FTLog("[RentMotel] Player skipped time, not sleeping.");
        }
    }
}

// Catch pressing the Skip Time button from the Hub Menu.
@wrapMethod(HubTimeSkipController)
protected cb func OnTimeSkipButtonPressed(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
        MotelSleepWatcherSS.GetInstance(GetGameInstance()).SetSkippingTimeFromHubMenu(true);
    }
    return wrappedMethod(e);
}

// When the Time Skip Popup is initialized, check if the Skipping Time from Hub Menu flag was just set.
@wrapMethod(TimeskipGameController)
protected cb func OnInitialize() -> Bool {
    let sleepWatcher = MotelSleepWatcherSS.GetInstance(GetGameInstance());
    if Equals(sleepWatcher.GetSkippingTimeFromHubMenu(), true) {
        sleepWatcher.SetWasSleeping(false);
    } else {
        sleepWatcher.SetWasSleeping(true);
    }
    return wrappedMethod();
}

// Always clear the "Skipping Time from Hub Menu" flag when the popup is uninitialized.
@wrapMethod(TimeskipGameController)
protected cb func OnUninitialize() -> Bool {
    MotelSleepWatcherSS.GetInstance(GetGameInstance()).SetSkippingTimeFromHubMenu(false);
    return wrappedMethod();
}

// Event that fires after successfully sleeping or skipping time.
@wrapMethod(TimeskipGameController)
protected cb func OnCloseAfterFinishing(proxy: ref<inkAnimProxy>) -> Bool {
    MotelSleepWatcherSS.GetInstance(GetGameInstance()).OnTimeSkipFinished();
    return wrappedMethod(proxy);
}
