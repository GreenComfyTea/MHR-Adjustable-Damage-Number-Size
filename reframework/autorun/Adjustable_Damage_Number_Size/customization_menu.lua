local customization_menu = {};

local table_helpers;
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

customization_menu.is_opened = false;
customization_menu.status = "OK";

customization_menu.window_position = Vector2f.new(480, 200);
customization_menu.window_pivot = Vector2f.new(0, 0);
customization_menu.window_size = Vector2f.new(500, 550);
customization_menu.window_flags = 0x10120;

customization_menu.color_picker_flags = 327680;
customization_menu.decimal_input_flags = 33;

function customization_menu.init()
end

function customization_menu.draw()
	imgui.set_next_window_pos(customization_menu.window_position, 1 << 3, customization_menu.window_pivot);
	imgui.set_next_window_size(customization_menu.window_size, 1 << 3);

	customization_menu.is_opened = imgui.begin_window(
		"Adjustable Damage Number Size v" .. config.current_config.version, customization_menu.is_opened, customization_menu.window_flags);

	if not customization_menu.is_opened then
		imgui.end_window();
		return;
	end

	imgui.text("Status: " .. tostring(customization_menu.status));

	local changed = false;
	local config_changed = false;

	local index = 1;

	changed, config.current_config.enabled = imgui.checkbox("Enabled", config.current_config.enabled);
	config_changed = config_changed or changed;

	if imgui.tree_node("Damage Numbers") then
		if imgui.tree_node("White") then
			local damage_numbers = config.current_config.white_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
				damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
				damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Orange") then
			local damage_numbers = config.current_config.orange_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
				damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
				damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Big Orange") then
			local damage_numbers = config.current_config.big_orange_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
			damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
			damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Gray") then
			local damage_numbers = config.current_config.gray_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
			damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
			damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Red") then
			local damage_numbers = config.current_config.red_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
			damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
			damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
	
			imgui.tree_pop();
		end
	
		if imgui.tree_node("Big Gray") then
			local damage_numbers = config.current_config.big_gray_damage_numbers;
	
			changed, damage_numbers.width_modifier = imgui.drag_float("Width Modifier",
			damage_numbers.width_modifier, 0.01, 0.1, 10, "%.2f");
			config_changed = config_changed or changed;
		
			changed, damage_numbers.height_modifier = imgui.drag_float("Height Modifier",
			damage_numbers.height_modifier, 0.01, 0.1, 10, "%.2f");
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

function customization_menu.init_module()
	table_helpers = require("Adjustable_Damage_Number_Size.table_helpers");
	config = require("Adjustable_Damage_Number_Size.config");
	damage_numbers = require("Adjustable_Damage_Number_Size.damage_numbers");

	customization_menu.init();
end

return customization_menu;
