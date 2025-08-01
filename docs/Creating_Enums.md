# Creating Enums

## Creating TypedEnum

A new **TypedEnum** is created using [*`TypedEnum.new`*](../Api/TypedEnum#new).
It accepts a *constructor* function, that is supposed to:

1. create a new enum table (the one that will store items)
2. add items to the enum using the provided *`add`* function

Here's an example:

```lua
local MyEnum = TypedEnum.new(function(add)
    return {
        MyItem = add("MyItem", 1)
    }
end)
```

We just created a new enum named `MyEnum`, with an item named `MyItem`.
Now this enum can be used anywhere:

```lua
local myValue = MyEnum.Item
print(myValue.Name) -- "MyItem"
```

This particular way of creating custom enums allows
[type inference engine](https://luau.org/typecheck)
to properly work, and thus gives **full** autocompletion support!

## Type annotations

TypedEnum also provides some public
[type annotations](https://luau.org/typecheck) that you can use.

```lua
local MyEnum = TypedEnum.new(function(add)
    return {
        EnumItem1 = add("EnumItem1", 1),
        EnumItem2 = add("EnumItem2", 2),
        EnumItem3 = add("EnumItem3", 3)
    }
end)

export type MyEnum = TypedEnum.TypedEnumItem<number, typeof(MyEnum)>
```

In the code above, we defined a type `MyEnum`. It represents all enum items
in `MyEnum`: **`EnumItem1`**, **`EnumItem2`** and **`EnumItem3`**:

```lua
local myValue: MyEnum = MyEnum.EnumItem1 -- ok
local myValue: MyEnum = MyEnum.EnumItem2 -- ok
local myValue: MyEnum = MyEnum.EnumItem3 -- ok

local myValue: MyEnum = 123 -- not ok
local myValue: MyEnum = Enum.AccessoryType.Hat -- not ok
local myValue: MyEnum = MyEnum -- not ok
```

## Enums module

In general, it's a good practice to keep all static data in one place,
and it's *recommended* to have all enums located in a single *Enums* module, like this:

```lua
-- Enums.luau

local Enums = table.freeze({
    Status = TypedEnum.new(function(add)
        return {
            Confusion = add("Confusion", 1),
            Poison = add("Poison", 2)
        }
    end),
})

export type Status = TypedEnum.TypedEnumItem<number, typeof(Enums.Status)>

return Enums
```

Now, you can use this enum from another script:

```lua
-- Example.luau

local Enums = require(path.to.Enums)

local myStatus: Enums.Status = Enums.Status.Confusion
-- wowie!
```

## What's next?

You can check out the **[API reference](../Api)**
to learn more about TypedEnum.

Happy coding!
