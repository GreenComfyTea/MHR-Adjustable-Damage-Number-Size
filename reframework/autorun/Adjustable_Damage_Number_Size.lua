local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;

local table_helpers = require("Adjustable_Damage_Number_Size.table_helpers");
local config = require("Adjustable_Damage_Number_Size.config");

local customization_menu = require("Adjustable_Damage_Number_Size.customization_menu");

local damage_numbers = require("Adjustable_Damage_Number_Size.damage_numbers");

table_helpers.init_module();
config.init_module();
customization_menu.init_module();
damage_numbers.init_module();

log.info("[Adjustable Damage Number Size] Loaded.");

re.on_draw_ui(function()
	if imgui.button("Adjustable Damage Number Size v" .. config.current_config.version) then
		customization_menu.is_opened = not customization_menu.is_opened;
	end
end);

re.on_frame(function()
	if not reframework:is_drawing_ui() then
		customization_menu.is_opened = false;
	end

	if customization_menu.is_opened then
		pcall(customization_menu.draw);
	end
end);