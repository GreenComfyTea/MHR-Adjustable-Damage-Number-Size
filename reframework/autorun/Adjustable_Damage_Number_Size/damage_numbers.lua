local damage_numbers = {};

local table_helpers;
local config;
local customization_menu;

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

local num_disp_type_def = sdk.find_type_definition("snow.gui.GuiDamageDisp.NumDisp");
local num_disp_routine_in_method = num_disp_type_def:get_method("routineIn");
local num_disp_routine_wait_method = num_disp_type_def:get_method("routineWait");
local num_disp_routine_out_method = num_disp_type_def:get_method("routineOut");
local num_disp_set_routine_method = num_disp_type_def:get_method("setRoutine");
local num_disp_state_finish_event_method = num_disp_type_def:get_method("stateFinishEvent");

local num_disp_is_execute_method = num_disp_type_def:get_method("isExecute");
local num_disp_damage_text_field = num_disp_type_def:get_field("_DamageText");
local num_disp_damage_disp_type_field = num_disp_type_def:get_field("DispType");

local gui_text_type_def = num_disp_damage_text_field:get_type();
local get_font_size_method = gui_text_type_def:get_method("get_FontSize");
local set_font_size_method = gui_text_type_def:get_method("set_FontSize");

local size_type_def = get_font_size_method:get_return_type();

local width_field_name = "w";
local height_field_name = "h";
local width_field = size_type_def:get_field(width_field_name);
local height_field = size_type_def:get_field(height_field_name);

local cached_nums_disps = {};

local routine_types = {
	SET = 0,
	IN = 1,
	WAIT = 2,
	OUT = 4
};

local color_types = {
	WHITE = 0,
	ORANGE = 1,
	BIG_ORANGE = 2,
	GRAY = 3,
	RED = 4, 
	BIG_GRAY = 5
};

local EPSILON = 0.1;

local function is_same(first, second)
	return math.abs(first - second) < EPSILON;
end

function damage_numbers.on_num_disp_routine(num_disp, routine_type)
	if not config.current_config.enabled then
		return;
	end

	local is_execute = num_disp_is_execute_method:call(num_disp);
	if not is_execute then
		return;
	end

	local damage_text = num_disp_damage_text_field:get_data(num_disp);

	if damage_text == nil then
		customization_menu.status = "No Damage Text";
		return;
	end

	local font_size = get_font_size_method:call(damage_text);

	if damage_text == nil then
		customization_menu.status = "No Damage Text Font Size";
		return;
	end

	local width = width_field:get_data(font_size);
	local height = height_field:get_data(font_size);

	if width == nil then
		customization_menu.status = "No Damage Text Width";
		return;
	end

	if height == nil then
		customization_menu.status = "No Damage Text Height";
		return;
	end

	local disp_type = num_disp_damage_disp_type_field:get_data(num_disp);

	if disp_type == nil then
		customization_menu.status = "No Damage Text Display Type";
		return;
	end

	local damage_number_modifiers = config.current_config.white_damage_numbers;

	if disp_type == color_types.WHITE then
		damage_number_modifiers = config.current_config.white_damage_numbers;

	elseif disp_type == color_types.ORANGE then
		damage_number_modifiers = config.current_config.orange_damage_numbers;

	elseif disp_type == color_types.BIG_ORANGE then
		damage_number_modifiers = config.current_config.big_orange_damage_numbers;

	elseif disp_type == color_types.GRAY then
		damage_number_modifiers = config.current_config.gray_damage_numbers;

	elseif disp_type == color_types.RED then
		damage_number_modifiers = config.current_config.red_damage_numbers;

	elseif disp_type == color_types.BIG_GRAY then
		damage_number_modifiers = config.current_config.big_gray_damage_numbers;
	end

	local new_width = width * damage_number_modifiers.width_modifier;
	local new_height = height * damage_number_modifiers.height_modifier;

	local cached_num_disp = cached_nums_disps[num_disp];
	if cached_num_disp ~= nil then
		if cached_num_disp.event_finished then
			cached_nums_disps[num_disp] = nil;
			return;
		end

		if is_same(width, cached_num_disp.previous_width) and is_same(height, cached_num_disp.previous_height) then
			return;
		end
	end

	font_size:set_field(width_field_name, new_width);
	font_size:set_field(height_field_name, new_height);

	set_font_size_method:call(damage_text, font_size);

	if cached_num_disp ~= nil then
		if cached_num_disp.event_finished then
			cached_nums_disps[num_disp] = nil;
			return;
		end
	end

	cached_nums_disps[num_disp] = {
		previous_width = new_width,
		previous_height = new_height,
		routine_type = routine_type,
		event_finished = false
	};
end

function damage_numbers.on_num_disp_state_finish_event(num_disp)
	local cached_num_disp = cached_nums_disps[num_disp];

	if cached_num_disp == nil then
		return;
	end

	if cached_num_disp.routine_type ~= routine_types.OUT then
		return;
	end

	cached_num_disp.event_finished = true;
end

function damage_numbers.init_module()
	config = require("Adjustable_Damage_Number_Size.config");
	table_helpers = require("Adjustable_Damage_Number_Size.table_helpers");
	customization_menu = require("Adjustable_Damage_Number_Size.customization_menu");

	sdk.hook(num_disp_set_routine_method,
	function(args)
		local num_disp = sdk.to_managed_object(args[2]);
		damage_numbers.on_num_disp_routine(num_disp, routine_types.SET);
	end, function(retval) return retval; end);

	sdk.hook(num_disp_routine_in_method,
	function(args)
		local num_disp = sdk.to_managed_object(args[2]);
		damage_numbers.on_num_disp_routine(num_disp, routine_types.IN);
	end, function(retval) return retval; end);

	sdk.hook(num_disp_routine_wait_method,
	function(args)
		local num_disp = sdk.to_managed_object(args[2]);
		damage_numbers.on_num_disp_routine(num_disp, routine_types.WAIT);
	end, function(retval) return retval; end);

	sdk.hook(num_disp_routine_out_method,
	function(args)
		local num_disp = sdk.to_managed_object(args[2]);
		damage_numbers.on_num_disp_routine(num_disp, routine_types.OUT);
	end, function(retval) return retval; end);

	sdk.hook(num_disp_state_finish_event_method,
	function(args)
		local num_disp = sdk.to_managed_object(args[2]);
		damage_numbers.on_num_disp_state_finish_event(num_disp);
	end, function(retval) return retval; end);
end

return damage_numbers;
