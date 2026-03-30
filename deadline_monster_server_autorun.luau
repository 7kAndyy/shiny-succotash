local MAP_CONFIG = {gamemode = "NONE", is_day = false, lights_out = true, map = "misc_backrooms", time = 0}
local MONSTER_COUNT = 1

sharedvars.ac_movement = false
sharedvars.editor_mount_anything = true
sharedvars.plr_nv_color = Color3.fromRGB(224, 255, 255)
sharedvars.plr_speed = 1.05
sharedvars.plr_jump_multiplier = 0
sharedvars.plr_jump_frequency = 0
sharedvars.plr_stamina_run_drain = 0.25
sharedvars.plr_stamina_run_regen = 0.05
sharedvars.plr_stamina_regen = 0.05
sharedvars.plr_fall_damage = false
sharedvars.plr_model = "orchids_pbr_set"
sharedvars.plr_enable_markers = false

task.wait(5)

map.set_map_from_config(MAP_CONFIG)
map.kill_map_lights()

if MONSTER_COUNT > 0 then
    for i = 1, MONSTER_COUNT, 1 do
        spawning.monster(100)
    end
end