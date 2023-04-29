local this = {};
local version = "2.1";

local utils;

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

this.current_config = nil;
this.config_file_name = "Adjustable Damage Number Size/config.json";

this.default_config = {};

function this.init()
	this.default_config = {
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

function this.load()
	local loaded_config = json.load_file(this.config_file_name);
	if loaded_config ~= nil then
		log.info("[Adjustable Damage Number Size] config.json loaded successfully");
		this.current_config = utils.table.merge(this.default_config, loaded_config);
	else
		log.error("[Adjustable Damage Number Size] Failed to load config.json");
		this.current_config = utils.table.deep_copy(this.default_config);
	end
end

function this.save()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(this.config_file_name, this.current_config);
	if success then
		log.info("[Adjustable Damage Number Size] config.json saved successfully");
	else
		log.error("[Adjustable Damage Number Size] Failed to save config.json");
	end
end

function this.reset()
	this.current_config = utils.table.deep_copy(this.default_config);
	this.current_config.version = version;
end

function this.init_module()
	utils = require("Adjustable_Damage_Number_Size.utils");

	this.init();
	this.load();
	this.current_config.version = version;
end

return this;
