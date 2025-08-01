# TypedEnum

Construct custom enums at runtime, with proper autocompletion and typechecking.

- **[Documentation](https://arythmitical.github.io/TypedEnum)**
- **[Wally](https://wally.run/package/arythmitical/typedenum)**
- **[Creator Store](https://create.roblox.com/store/asset/119312214340373)**

---

```lua
local PlayerLocation = TypedEnum.new(function(add)
    return {
        MainMenu = add("MainMenu", 1),
        InRound = add("InRound", 2),
        Shop = add("Shop", 3),
    }
end)

export type PlayerLocation = TypedEnum.TypedEnumItem<number, typeof(PlayerLocation)>

local location: PlayerLocation = PlayerLocation.MainMenu

OnLocationChanged.OnClientEvent:Connect(function(id)
    local newLocation: PlayerLocation? = TypedEnum.fromValue(PlayerLocation, id)

    if newLocation then
        location = newLocation
    end
end)
```
