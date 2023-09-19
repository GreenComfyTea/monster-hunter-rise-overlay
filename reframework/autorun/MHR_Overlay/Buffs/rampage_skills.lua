local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local env_creature;
local player_info;
local time;
local abnormal_statuses;

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
local skills_type_name = type;
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

this.list = {
	kushala_daora_soul = nil,
	chameleos_soul = nil
};

local rampage_skills_type_name = "rampage_skills";

local rampage_skill_ids = {
	chameleos_soul = 250,
	kushala_daora_soul = 251,
};

local kushara_daora_soul_breakpoint = 5;

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Kushala Daora Soul
local hyakuryu_dragon_power_up_count_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpCnt");
local hyakuryu_dragon_power_up_timer_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpTimer");
-- Chameleos Soul
local hyakuryu_onazuti_power_up_interval_field = player_data_type_def:get_field("_HyakuryuHyakuryuOnazutiPowerUpInterval");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.DataDef.PlHyakuryuSkillId)");

function this.update(player_data)

	buffs.update_generic_buff(this.list, rampage_skills_type_name, "kushala_daora_soul", this.get_skill_name,
		player_data, hyakuryu_dragon_power_up_count_field, player_data, hyakuryu_dragon_power_up_timer_field, false, nil, {kushara_daora_soul_breakpoint});

	buffs.update_generic_buff(this.list, rampage_skills_type_name, "chameleos_soul", this.get_skill_name,
		nil, nil, player_data, hyakuryu_onazuti_power_up_interval_field);
end

function this.init_names()
	for rampage_skill_key, skill in pairs(this.list) do
		skill.name = this.get_skill_name(rampage_skill_key);
	end
end

function this.get_skill_name(rampage_skill_key)
	local rampage_skill_name = get_name_method:call(nil, rampage_skill_ids[rampage_skill_key]);
	if rampage_skill_name == nil then
		error_handler.report("rampage_skills.get_skill_name", string.format("Failed to access Data: %s_name", rampage_skill_key));
		return rampage_skill_key;
	end

	return rampage_skill_name;
end

function this.init_dependencies()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	player_info = require("MHR_Overlay.Misc.player_info");
	time = require("MHR_Overlay.Game_Handler.time");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
end

function this.init_module()
end

return this;