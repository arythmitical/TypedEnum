--!strict
--!optimize 2

--[[
	Builds source code into release files
	(ran with lune)
]]

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

if not fs.isFile(process.cwd .. "./src/init.luau") then
	print("couldn't find the module at ./src/init.luau")
	error("couldn't find the module at ./src/init.luau")
end

if not fs.isFile(process.cwd .. "./LICENSE.txt") then
	print("couldn't find the license at ./LICENSE.txt")
	error("couldn't find the license at ./LICENSE.txt")
end

local library = roblox.Instance.new("ModuleScript")
library.Name = "MainModule"

local src = fs.readFile(process.cwd .. "./src/init.luau")
local license = fs.readFile(process.cwd .. "./LICENSE.txt")

library.Source = [=[
--[[
	TypedEnum v1.0.4
	https://github.com/arythmitical/TypedEnum

	Construct custom enums at runtime, with proper autocompletion and typechecking.

]=] .. "\t" .. string.sub(string.gsub(license, "\n", "\n\t"), 0, -2) .. "]]\n\n" .. src

if fs.isFile(process.cwd .. "./example/init.client.luau") then
	local example = roblox.Instance.new("LocalScript")
	example.Source = fs.readFile(process.cwd .. "./example/init.client.luau")

	example.Name = "Example"
	example.Disabled = true
	example.Parent = library
else
	warn("couldn't find the example at ./example/init.client.luau")
end

if not fs.isDir("./build") then
	fs.writeDir("./build")
end

fs.writeFile("./build/TypedEnum.rbxm", roblox.serializeModel({ library }))
fs.writeFile("./build/TypedEnum.luau", library.Source)
