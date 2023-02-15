local config = {};

local table_helpers;

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

config.current_config = nil;
config.config_file_name = "Adjustable Damage Number Size/config.json";

config.default_config = {};

function config.init()
	config.default_config = {
		enabled = true,

		white_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},

		orange_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},

		big_orange_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},

		gray_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},

		red_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},
		
		big_gray_damage_numbers = {
			width_multiplier = 0.6,
			height_multiplier = 0.6
		},
	};
end

function config.load()
	local loaded_config = json.load_file(config.config_file_name);
	if loaded_config ~= nil then
		log.info("[Adjustable Damage Number Size] config.json loaded successfully");
		config.current_config = table_helpers.merge(config.default_config, loaded_config);
	else
		log.error("[Adjustable Damage Number Size] Failed to load config.json");
		config.current_config = table_helpers.deep_copy(config.default_config);
	end
end

function config.save()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config.config_file_name, config.current_config);
	if success then
		log.info("[Adjustable Damage Number Size] config.json saved successfully");
	else
		log.error("[Adjustable Damage Number Size] Failed to save config.json");
	end
end

function config.init_module()
	table_helpers = require("Adjustable_Damage_Number_Size.table_helpers");

	config.init();
	config.load();
	config.current_config.version = "2.0";
end

return config;
