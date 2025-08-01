--!strict

--[[
	Example script
]]

local TypedEnum = require(script.Parent)

local MyEnum = TypedEnum.new(function(add)
	return {
		EnumItem1 = add("EnumItem1", 1),
		EnumItem2 = add("EnumItem2", 2),
		EnumItem3 = add("EnumItem3", 3),
	}
end)

local myField = MyEnum.EnumItem1

if myField == MyEnum.EnumItem1 then
	print("this is a first enum item!")
end
