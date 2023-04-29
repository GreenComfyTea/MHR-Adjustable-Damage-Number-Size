local this = {};

local utils;
local config;
local damage_numbers;

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

this.is_opened = false;
this.status = "OK";

this.window_position = Vector2f.new(480, 200);
this.window_pivot = Vector2f.new(0, 0);
this.window_size = Vector2f.new(500, 550);
this.window_flags = 0x10120;

this.color_picker_flags = 327680;
this.decimal_input_flags = 33;

function this.init()
end

function this.draw()
	imgui.set_next_window_pos(this.window_position, 1 << 3, this.window_pivot);
	imgui.set_next_window_size(this.window_size, 1 << 3);

	this.is_opened = imgui.begin_window(
		"Adjustable Damage Number Size v" .. config.current_config.version, this.is_opened, this.window_flags);

	if not this.is_opened then
		imgui.end_window();
		return;
	end

	local changed = false;
	local config_changed = false;

	if imgui.button("Reset Config") then
		config.reset();
		config_changed = true;
	end

	imgui.same_line();
	imgui.text("Status: " .. tostring(this.status));
	
	local index = 1;

	changed, config.current_config.enabled = imgui.checkbox("Enabled", config.current_config.enabled);
	config_changed = config_changed or changed;

	if imgui.tree_node("Damage Numbers") then
		if imgui.tree_node("White") then
			local damage_numbers = config.current_config.white_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
				damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
				damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Orange") then
			local damage_numbers = config.current_config.orange_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
				damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
				damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Big Orange") then
			local damage_numbers = config.current_config.big_orange_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
			damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
			damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Gray") then
			local damage_numbers = config.current_config.gray_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
			damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
			damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Red") then
			local damage_numbers = config.current_config.red_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
			damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
			damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Big Gray") then
			local damage_numbers = config.current_config.big_gray_damage_numbers;
	
			changed, damage_numbers.width_multiplier = imgui.drag_float("Width Multiplier",
			damage_numbers.width_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_multiplier = imgui.drag_float("Height Multiplier",
			damage_numbers.height_multiplier, 0.01, 0, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	imgui.end_window();

	if config_changed then
		config.save();
	end
end

function this.init_module()
	utils = require("Adjustable_Damage_Number_Size.utils");
	config = require("Adjustable_Damage_Number_Size.config");
	damage_numbers = require("Adjustable_Damage_Number_Size.damage_numbers");

	this.init();
end

return this;
