--!strict
--!optimize 2

--[=[
	@class TypedEnum

	**TypedEnum** represents an individual enum,
	simillar to Roblox [Enum].
]=]
local TypedEnum = {}

--[=[
	@type TypedEnum<T> { [string]: TypedEnumItem<T,TypedEnum<T>> }
	@within TypedEnum

	**[TypedEnum]**'s type.
	The type argument `T` defines what kind of values are
	in [items](./TypedEnumItem) of this enum.

	**Example**:

	```lua
	local PlayerLocation = TypedEnum.new(function(add)
		return {
			MainMenu = add("MainMenu", 1),
			InRound = add("InRound", 2),
			Shop = add("Shop", 3)
		}
	end)

	local enum: TypedEnum<number> = PlayerLocation -- valid
	local enum: TypedEnum<string> = PlayerLocation -- invalid
	```
]=]
export type TypedEnum<T> = {
	[string]: TypedEnumItem<T, TypedEnum<T>>,
}

--[=[
	Construct a new **[TypedEnum]** using
	the provided *constructor* function.
	
	**Example**:

	```lua
	local PlayerLocation = TypedEnum.new(function(add)
		return {
			MainMenu = add("MainMenu", 1),
			InRound = add("InRound", 2),
			Shop = add("Shop", 3)
		}
	end)
	```

	@param constructor (add: (string, T) -> (TypedEnumItem)) -> TypedEnum<T>
	@return TypedEnum<T>
]=]
function TypedEnum.new<T>(constructor)
	assert(typeof(constructor) == "function", "expected argument #1 to be function")

	local enum

	local items: { TypedEnumItem<T, typeof(enum)> } = {}

	local function add(name: string, value: T): TypedEnumItem<T, typeof(enum)>
		for _, item in pairs(items) do
			assert(item.Name ~= name, "an enum item with this name already exists")
			assert(item.Value ~= value, "an enum item with this value already exists")
		end

		local item = {
			Name = name,
			Value = value,
			Enum = enum, -- currently nil
		}

		table.insert(items, item)

		return item
	end

	enum = constructor(add)

	for _, item in pairs(items) do
		item.Enum = enum
	end

	-- setmetatable(self, TypedEnum)
	-- ^ adding this here will cause TypeErrors

	return table.freeze(enum)
end

--[=[
	Returns a **[TypedEnumItem]** that has the given `value`.
	
	**Example**:

	```lua
	local PlayerLocation = TypedEnum.new(function(add)
		return {
			MainMenu = add("MainMenu", 1),
			InRound = add("InRound", 2),
			Shop = add("Shop", 3)
		}
	end)

	local plrLocation = TypedEnum.fromValue(PlayerLocation, 1)
	print(plrLocation.Name) -- MainMenu
	```

	@param enum TypedEnum<T> -- the enum to search in
]=]
function TypedEnum.fromValue<T>(enum: TypedEnum<T>, value: T?): TypedEnumItem<T, TypedEnum<T>>?
	assert(typeof(enum) == "table", "expected argument #1 to be a table")

	for _, item in pairs(enum) do
		if item.Value == value then
			return item
		end
	end

	return nil
end

--[=[
	@class TypedEnumItem

	**TypedEnumItem** represents an individual enum item,
	simillar to Roblox [EnumItem].
]=]

--[=[
	@prop Name string
	@within TypedEnumItem

	The name of the item.

	**Example**:

	```lua
	local MyEnum = TypedEnum.new(function(add)
		return {
			MyItem = add("MyItem", 1)
		}
	end)

	print(MyEnum.MyItem.Name) -- MyItem
	```
]=]

--[=[
	@prop Value any
	@within TypedEnumItem

	The value that the item holds.

	The type of the value should be the same
	across all items in a **[TypedEnum]**.

	**Example**:

	```lua
	local MyEnum = TypedEnum.new(function(add)
		return {
			MyItem = add("MyItem", 1)
		}
	end)

	print(MyEnum.MyItem.Value) -- 1
	```
]=]

--[=[
	@prop Enum TypedEnum
	@within TypedEnumItem

	The **[TypedEnum]** that the item belongs to.

	**Example**:

	```lua
	local MyEnum = TypedEnum.new(function(add)
		return {
			MyItem = add("MyItem", 1)
		}
	end)

	print(MyEnum.MyItem.Enum == MyEnum) -- true
	```
]=]

--[=[
	@type TypedEnumItem<T,enum> { Name: string, Value: T, Enum: enum }
	@within TypedEnumItem

	The type annotation of **TypedEnumItem**.

	Type argument **`T`** defines what type of value
	is in this item.
	Type argument **`enum`** defines the [TypedEnum]
	that this TypedEnumItem belongs to.

	**Example**:

	```lua
	local PlayerLocation = TypedEnum.new(function(add)
		return {
			MainMenu = add("MainMenu", 1),
			InRound = add("InRound", 2),
			Shop = add("Shop", 3)
		}
	end)

	local item: TypedEnumItem<number, typeof(PlayerLocation)> = PlayerLocation.MainMenu -- valid
	local item: TypedEnumItem<number, typeof(PlayerLocation)> = PlayerLocation.Shop -- valid
	local item: TypedEnumItem<string, typeof(SomeOtherEnum)> = PlayerLocation.Shop -- invalid
	```
]=]
export type TypedEnumItem<T, enum> = {
	Name: string,
	Value: T,
	Enum: enum,
}

return table.freeze(TypedEnum)
