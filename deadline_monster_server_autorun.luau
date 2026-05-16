-- # Server Autorun
local server_module = {}

-- Type Aliases
type luauInstance = {}

-- Constants
local MAP_CONFIG = {gamemode = "NONE", is_day = false, lights_out = true, map = "nuristan_voxel", time = 0}
local MAP_PRESET = "darkworld"
local MONSTER_COUNT = 20
local ENEMY_BOT_COUNT = 0
local PLAYER_SETUP_CODES = {
    primary = {
        {
            Name = "LSW-556",
            WeaponCode = "SA58",
            SetupCode = "4o7n-0252-dhen-23g4-2c87-cmm8-h112-8fg5"
        },
        {
            Name = "AK-102",
            WeaponCode = "AK_545",
            SetupCode = "3nh6-0252-6a3e-n81b-bo2c-f8he-q6eb-8ed7"
        },
        {
            Name = "AK-104",
            WeaponCode = "AK_545",
            SetupCode = "eqqz-0252-he3f-32fd-bhed-hqe5-hn89-m533"
        },
        {
            Name = "AK-105",
            WeaponCode = "AK_545",
            SetupCode = "4g93-0252-fg76-gz2m-e4g0-09aw-8z32-o5z4"
        },
        {
            Name = "AK308k-SD",
            WeaponCode = "AK308",
            SetupCode = "09q4-0252-d3em-5wzw-4cmm-6w2w-12h5-nbdf"
        },
        {
            Name = "HK433",
            WeaponCode = "KF416",
            SetupCode = "22oc-0252-5q19-9geq-915w-nn4f-no3f-43zf"
        },
        {
            Name = "MCX LVAW",
            WeaponCode = "M4A1",
            SetupCode = "bn1g-0252-d0hc-419f-cc93-cm2b-fg2e-498o"
        },
        {
            Name = "MK18 w/ M203",
            WeaponCode = "M4A1",
            SetupCode = "hnfd-0252-326e-8589-603c-6zd4-bn6q-eeqa"
        },
        {
            Name = "PKM",
            WeaponCode = "AK_762",
            SetupCode = "2neq-0252-m6qd-ndb6-wnm0-az6h-17oz-80wn"
        },
        {
            Name = "PTR-308",
            WeaponCode = "G3",
            SetupCode = "9na5-0252-2542-706z-w288-eaw4-a7w7-6f2f"
        },
        {
            Name = "QBB-556",
            WeaponCode = "QBZ95",
            SetupCode = "a1fz-0252-5gch-3h4b-d1bd-27g3-gaca-0543"
        },
        {
            Name = "RFB-308",
            WeaponCode = "QBZ95",
            SetupCode = "2gzw-0252-2chb-02nf-wo3d-m0gg-h7ng-foz9"
        },
        {
            Name = "RPK-308",
            WeaponCode = "AK308",
            SetupCode = "ad9o-0252-93q0-1bb0-hfz9-oobw-bcda-dhm8"
        },
        {
            Name = "SA-58 OSW",
            WeaponCode = "SA58",
            SetupCode = "2w29-0252-g9gf-og72-9wd0-5nbw-o59f-oam7"
        },
        {
            Name = "SCAR308k-SD",
            WeaponCode = "SCAR47",
            SetupCode = "oh75-0252-0w8g-gm78-e184-0ob6-1n6q-g910"
        },
        {
            Name = "SG553",
            WeaponCode = "AK_545",
            SetupCode = "f6c7-0252-qqeo-n8wd-zhq0-5gh3-gn06-9wn5"
        },
        {
            Name = "V308",
            WeaponCode = "Vector",
            SetupCode = "0m5d-0252-8zbe-ac2d-9mmb-eb5o-ww06-fbg6"
        },
    },
    secondary = {
        {
            Name = "MP/15 Hybrid Carbine",
            WeaponCode = "M4A1",
            SetupCode = "750o-0252-1447-n8q3-2o6h-0fz3-b7fn-g21n"
        },
        {
            Name = "P320 Carbine",
            WeaponCode = "P320",
            SetupCode = "q2f2-0252-bbm5-81do-5eoa-3anc-f840-8d53"
        },
        {
            Name = "P320 Carbine Mk. 2",
            WeaponCode = "P320",
            SetupCode = "a8nh-0252-aoqd-2h0z-h1fh-wq7h-a9cq-ca07"
        },
        {
            Name = "P320 Carbine Prototype",
            WeaponCode = "P320",
            SetupCode = "80o2-0252-81b0-nz20-dwom-a33w-92o5-fn8o"
        },
        {
            Name = "P320 Compact Carbine",
            WeaponCode = "P320",
            SetupCode = "92ca-0252-816h-qoeb-6qf9-hdgd-ofob-qcd7"
        },
        {
            Name = "UMP45-SD",
            WeaponCode = "UMP",
            SetupCode = "6aq4-0252-6hwe-qd8e-qna9-zz20-q74q-0mzb"
        },
    }
}

-- Variables
local player_setup_ignore_list = {} --:: {[string]: {["primary" | "secondary"]: {string}}}

-- Functions
function server_module:getPlayerSetupIgnoreList(playerName: string)
    -- IF NOT found, create it
    local t = nil
    if player_setup_ignore_list[playerName] then
        t = player_setup_ignore_list[playerName]
        print("addToSetupIgnoreList: found", playerName.. "'s setup ignore list")
    else
        warn("addToSetupIgnoreList: could not find", playerName.. "'s setup ignore list")
        player_setup_ignore_list[playerName] = {
            primary = {},
            secondary = {}
        }
        t = player_setup_ignore_list[playerName]
        
        warn("addToSetupIgnoreList: created", playerName.. "'s setup ignore list")
    end

    return t
end

local function addToSetupIgnoreList(playerName: string, weaponCode: string, setupCode: string)
    local t = player_setup_ignore_list[playerName]
    if t then
        local t_slot = t[weaponCode]
        if t_slot then
            table.insert(t_slot, setupCode)
            print("addToSetupIgnoreList: put", setupCode, "in", playerName.. "'s ", weaponCode, " setup ignore list")
        else
            warn("addToSetupIgnoreList: player_setup_ignore_list[".. playerName.. "][".. weaponCode.."] is nil")
        end
    else
        warn("addToSetupIgnoreList: player_setup_ignore_list[".. playerName.. "] is nil")
    end
end

local function setupIgnoreListContainsGun(playerName: string, weaponCode: string, setupCode: string)
    local contains = false
    local t = player_setup_ignore_list[playerName]
    if t then
        local t_slot = t[weaponCode]
        if t_slot then
            if table.find(t_slot, setupCode) then
                contains = true
                print("setupIgnoreListContainsGun: found", setupCode, "in", playerName.. "'s", weaponCode, "setup ignore list")
            end
        else
            warn("addToSetupIgnoreList: player_setup_ignore_list[".. playerName.. "][".. weaponCode.."] is nil")
        end
        
    else
        warn("setupIgnoreListContainsGun: player_setup_ignore_list[".. playerName.. "] is nil")
    end

    return contains
end

local function resetSetupIgnoreList(playerName: string, weaponCode: string)
    warn("Reset function called:")
    if weaponCode then
        local t = player_setup_ignore_list[playerName]
        if t then
            t[weaponCode] = {}
            warn("resetSetupIgnoreList: reset", playerName.. "'s", weaponCode, "setup ignore list")
        else
            warn("resetSetupIgnoreList: player_setup_ignore_list[".. playerName.. "] is nil")
        end
    else
        if player_setup_ignore_list[playerName] then
            player_setup_ignore_list[playerName] = {}
            warn("resetSetupIgnoreList: reset", playerName.. "'s setup ignore list")
        else
            warn("resetSetupIgnoreList: player_setup_ignore_list[".. playerName.. "] is nil")
        end
    end
end

local function getRandomSetupCode(slot_code: string, player: luauInstance | string): (string, string)
    slot_code = slot_code:lower()
    -- if slot_code == "primary" then
        -- return "066q-0252-5z7o-2aoq-5nfn-9208-w1n9-ge54", "AK_762" -- pkm
    -- end

    local setup_code = nil
    local weapon_code = nil

    local setups_table = PLAYER_SETUP_CODES[slot_code]
    if setups_table then
        local random_number = math.random(1, #setups_table)
        local setup = setups_table[random_number]
        
        if player then
            local ignore_list = server_module:getPlayerSetupIgnoreList(player)
            warn(#ignore_list[slot_code], ">=", #PLAYER_SETUP_CODES[slot_code], "=", #ignore_list >= #PLAYER_SETUP_CODES[slot_code])
            if #ignore_list[slot_code] >= #PLAYER_SETUP_CODES[slot_code] then
                resetSetupIgnoreList(player, slot_code)
            end

            local success = false
            local index = 0
            
            repeat
                if setup then
                    setup_code = setup["SetupCode"]
                    weapon_code = setup["WeaponCode"]

                    if setupIgnoreListContainsGun(player, slot_code, setup["SetupCode"]) == false then
                        addToSetupIgnoreList(player, slot_code, setup["SetupCode"])
                        success = true
                    else
                        random_number = math.random(1, #setups_table)
                        setup = setups_table[random_number]
                    end
                else
                    error("Something went seriously wrong while looking for a random setup code")
                end

                index += 1
            until success == true or index > 30
        else
            if setup then
                setup_code = setup["SetupCode"]
                weapon_code = setup["WeaponCode"]
            else
                error("Something went seriously wrong while looking for a random setup code")
            end
        end
    else
        error("Weapon table \""..  slot_code.. "\" not found in PLAYER_SETUP_CODES")
    end

    return setup_code, weapon_code
end

function server_module:setSlotToSetupFromCode(player: luauInstance, slot_code: string, weapon_code: string, setup_string: string)
    local setup = weapons.get_setup_from_code(setup_string)
    local setup_data = "[]" -- blank JSON array to fall back on if setup code is invalid

    if setup.status ~= "_" then
        warn("setup", setup, "is not valid")
    else
        setup_data = setup.data.data
    end

    player.set_weapon(slot_code, weapon_code, setup_data)
end

function server_module:setPlayerModelToTeamModel(player: luauInstance)
    local team = player.get_team()
    local model_set = "main"
    if team == "attacker" then
        model_set = "orchids_pbr_set"
    elseif team == "defender" then
        model_set = "main_backup"
    end

    player.set_model(model_set)
end

local function on_bot_spawned(player: string)
    -- player.bot.set_behavior("FireAtNearestPlayerBehavior")
    player.equip_weapon("primary", true)
end

function server_module.sendSpookyFace()
    -- does not work due to chat filtering
    --[[
    split = FACES["Two"]:split("\n")
    for i, v in split do
        chat.send_announcement(v, Color3.fromRGB(255, 0, 0))
    end
    ]]
end

local function createEntities()
    -- Monster Spawning
    if MONSTER_COUNT > 0 then
        for i = 1, MONSTER_COUNT, 1 do
            spawning.monster()
        end
    end

    -- Bot spawning
    if ENEMY_BOT_COUNT > 0 then
        for i = 1, ENEMY_BOT_COUNT, 1 do
            spawning.bot()
        end
    end
    
    -- Bot property changes
    for _, player in players.get_all() do
        if player.is_bot() then
            player.set_team('attacker')
            player.set_model("orchids_pbr_set")
        end
    end
end

local function gameLoop()
    --[[while true do
        for _, player in players.get_all() do
            if player.is_bot() then
                local active_slot = player.get_active_slot()
                if active_slot then
                    local player_weapon = player.get_weapon_data_from_character(active_slot)
                    if xyz then

                    end

                end

            end
        end

        task.wait(15)
    end]]
end

-- Event functions
local function onPlayerSpawned(name: string)
    print("player spawned:", name)
    local player = players.get(name)
    if player then
        -- local team = player.get_team()
        server_module:setPlayerModelToTeamModel(player)

        local primary_setup_code, primary_weapon_code = getRandomSetupCode("primary", name)
        local secondary_setup_code, secondary_weapon_code = getRandomSetupCode("secondary", name)

        server_module:setSlotToSetupFromCode(player, "primary", primary_weapon_code, primary_setup_code)
        server_module:setSlotToSetupFromCode(player, "secondary", secondary_weapon_code, secondary_setup_code)

        if player.is_bot() then
            task.spawn(on_bot_spawned, player)
        end
    else
        warn("player could not be referenced:", name)
    end
end

local function onPlayerDied(name, position, killer_data, stats_counted)
    local player = players.get(name)
    if player then
        -- stuff
        print(position, killer_data, stats_counted)
    else
        warn("player could not be referenced:", name)
    end
end

local function onPlayerJoined(name)
    print("player joined:", name)
    local player = players.get(name)
    if player then
        server_module:setPlayerModelToTeamModel(player)
        server_module:getPlayerSetupIgnoreList(name)
    else
        warn("player could not be referenced:", name)
    end

    chat.send_ingame_announcement(string.format("%s has joined the server.", name))
end

local function onPlayerLeft(name)
    print("player left:", name)
    chat.send_ingame_announcement(string.format("%s has left the server.", name))
end

-- Runtime
-- Character Property Changes
sharedvars.plr_explosion_blast_pressure = 0;
sharedvars.plr_explosion_damage_multiplier = 0;
sharedvars.plr_model = "main_backup"
sharedvars.plr_nv_color = Color3.fromRGB(224, 255, 255)
sharedvars.plr_fall_damage = false
sharedvars.plr_enable_markers = false
sharedvars.plr_jump_multiplier = 0
sharedvars.plr_jump_frequency = 0
sharedvars.plr_stamina_run_drain = 0.25
sharedvars.plr_stamina_regen = 0.05
sharedvars.plr_speed = 1.05
sharedvars.plr_weapon_clamp_stats_values = false

-- Game Property Changes
chat.set_join_message("The monster is hunting.")
chat.set_spawning_disabled_reason("Be patient.")
sharedvars.ac_movement = false
sharedvars.chat_announce_changes = false
sharedvars.chat_tips_enabled = false
sharedvars.chat_max_history = 200
sharedvars.editor_mount_anything = true
sharedvars.gm_team_balancing_threshold = 1000
sharedvars.sv_spawning_enabled = false
sharedvars.voxel_bullet_destruction_radius = 1
map.set_map_from_config(MAP_CONFIG)
map.set_preset(MAP_PRESET)
map.kill_map_lights()

-- Cooldown before game starts
task.wait(10)

-- Start the game, spawn the monster(s).
sharedvars.sv_spawning_enabled = true
chat.set_spawning_disabled_reason("You cannot spawn right now.")

-- Spawn Entities
task.spawn(createEntities)

-- While Loop
task.spawn(gameLoop)

-- Events
on_player_spawned:Connect(onPlayerSpawned)
on_player_died:Connect(onPlayerDied)
on_player_joined:Connect(onPlayerJoined)
on_player_left:Connect(onPlayerLeft)

shared["server_module"] = server_module

return server_module