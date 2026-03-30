-- # Server Autorun

-- Constants
local MAP_CONFIG = {gamemode = "NONE", is_day = false, lights_out = true, map = "misc_backrooms", time = 0}
local MAP_PRESET = "blank"
local MONSTER_COUNT = 1

-- Character Property Changes
sharedvars.plr_model = "orchids_pbr_set"
sharedvars.plr_nv_color = Color3.fromRGB(224, 255, 255)
sharedvars.plr_fall_damage = false
sharedvars.plr_enable_markers = false
sharedvars.plr_jump_multiplier = 0
sharedvars.plr_jump_frequency = 0
sharedvars.plr_stamina_run_drain = 0.25
sharedvars.plr_stamina_regen = 0.05
sharedvars.plr_speed = 1.05

-- Game Property Changes
sharedvars.ac_movement = false
sharedvars.editor_mount_anything = true
sharedvars.sv_spawning_enabled = false
chat.set_join_message("The monster is hunting.")
chat.set_spawning_disabled_reason("Be patient.")
map.set_map_from_config(MAP_CONFIG)
map.set_preset(MAP_PRESET)
map.kill_map_lights()

-- Cooldown before game starts
task.wait(10)

-- Start the game, spawn the monster(s).
sharedvars.sv_spawning_enabled = true
chat.set_spawning_disabled_reason("You cannot spawn right now.")
if MONSTER_COUNT > 0 then
    for i = 1, MONSTER_COUNT, 1 do
        spawning.monster(100)
    end
end