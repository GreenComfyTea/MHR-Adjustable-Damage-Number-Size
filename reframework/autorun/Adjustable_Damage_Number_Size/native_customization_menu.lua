local this = {};

local utils;
local config;
local customization_menu;
local player_status_icon_fix;

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
local os = os;
local ValueType = ValueType;
local package = package;

local mod_menu_api_package_name = "ModOptionsMenu.ModMenuApi";
local mod_menu = nil;

local native_UI = nil;

local status_icon_mode_descriptions = {
	"Set Status Icon Blinking Mode to Normal.",
	"Set Status Icon Blinking Mode to Always Adjusted.",
	"Set Status Icon Blinking Mode to Adjusted when Visible.",
	"Set Status Icon Blinking Mode to Adjusted when Hidden.",
	"Set Status Icon Blinking Mode to Always Visible.",
	"Set Status Icon Blinking Mode to Always Hidden."
};

local weapon_icon_mode_descriptions = {
	"Set Weapon Icon Blinking Mode to Normal.",
	"Set Weapon Icon Blinking Mode to Always Adjusted.",
};

--no idea how this works but google to the rescue
--can use this to check if the api is available and do an alternative to avoid complaints from users
function this.is_module_available(name)
	if package.loaded[name] then
		return true;
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name);

			if type(loader) == "function" then
				package.preload[name] = loader;
				return true;
			end
		end

		return false;
	end
end

function this.draw()
	local changed = false;
	local config_changed = false;
	local new_value = 0;
	local index = 0; 

	mod_menu.Label("Created by: <COL RED>GreenComfyTea</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");
	mod_menu.Label("Version: <COL RED>" .. config.current_config.version .. "</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");

	--imgui.text("Status: " .. tostring(customization_menu.status));

	if true then
		mod_menu.Header("Global Settings");

		changed, config.current_config.enabled = mod_menu.CheckBox("Enabled", config.current_config.enabled, "Enable/Disable \"Adjustable Damage Number Size\" Mod.\n");
			config_changed = config_changed or changed;

		if mod_menu.Button("", "Reset Config", false, "Reset All Values to Default.") then
			config.reset();
			config_changed = true;

			mod_menu.Repaint();
		end
	end

	if true then
		mod_menu.Header("<COL WHITE_GCT>White</COL> Damage Numbers");

		changed, config.current_config.white_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.white_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for White Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.white_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.white_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for White Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("<COL ORANGE_GCT>Orange</COL> Damage Numbers");

		changed, config.current_config.orange_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.orange_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for <COL ORANGE_GCT>Orange</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.orange_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.orange_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for <COL ORANGE_GCT>Orange</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("<COL ORANGE_GCT>Big Orange</COL> Damage Numbers");

		changed, config.current_config.big_orange_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.big_orange_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for <COL ORANGE_GCT>Big Orange</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.big_orange_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.big_orange_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for <COL ORANGE_GCT>Big Orange</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("<COL GRAY_GCT>Gray</COL> Damage Numbers");

		changed, config.current_config.gray_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.gray_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for <COL GRAY_GCT>Gray</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.gray_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.gray_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for <COL GRAY_GCT>Gray</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("<COL RED_GCT>Red</COL> Damage Numbers");

		changed, config.current_config.red_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.red_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for <COL RED_GCT>Red</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.red_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.red_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for <COL RED_GCT>Red</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("<COL GRAY_GCT>Big Gray</COL> Damage Numbers");

		changed, config.current_config.big_gray_damage_numbers.width_multiplier = mod_menu.FloatSlider("Width Multiplier",
			config.current_config.big_gray_damage_numbers.width_multiplier, 0, 10, "Adjust Width Multiplier for <COL GRAY_GCT>Big Gray</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;

		changed, config.current_config.big_gray_damage_numbers.height_multiplier = mod_menu.FloatSlider("Height Multiplier",
			config.current_config.big_gray_damage_numbers.height_multiplier, 0, 10, "Adjust Height Multiplier for <COL GRAY_GCT>Big Gray</COL> Damage Numbers.\n");
		config_changed = config_changed or changed;
	end

	if config_changed then
		config.save();
	end
end

function this.init_module()
	utils = require("Adjustable_Damage_Number_Size.utils");
	config = require("Adjustable_Damage_Number_Size.config");
	customization_menu = require("Adjustable_Damage_Number_Size.customization_menu");

	if this.is_module_available(mod_menu_api_package_name) then
		mod_menu = require(mod_menu_api_package_name);
	end

	if mod_menu == nil then
		log.info("[Adjustable Damage Number Size] No mod_menu_api API package found. You may need to download it or something.");
		return;
	end

	mod_menu.AddTextColor("WHITE_GCT", "FFFFFF");
	mod_menu.AddTextColor("ORANGE_GCT", "ECB11B");
	mod_menu.AddTextColor("GRAY_GCT", "808080");
	mod_menu.AddTextColor("RED_GCT", "F40D00");

	native_UI = mod_menu.OnMenu(
		"Adjustable Damage Number Size",
		"Allows you to change the size of damage numbers to your liking.",
		this.draw
	);

	native_UI.OnResetAllSettings = config.reset;

end

return this;
