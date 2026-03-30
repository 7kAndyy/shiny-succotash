TARGET1_PREFIX = "AK308" :: string
DESTINATION1_PREFIX = "QBZ" :: string
TARGET2_PREFIX = "UMP9" :: string
DESTINATION2_PREFIX = "P320" :: string
SWITCH_SOUNDS = false :: boolean
ONLY_SWAP_VALID_SOUNDs = false :: boolean

local amd_connection: RBXScriptConnection
local anti_monster_device: Part

local function replace_gun_sounds(destination: string, target: string, swap: boolean)
    if swap == nil then
        swap = false
    end

    for name: string, value: any in config.gunshots do
        local is_sound_from_target = name:find(target)
        if is_sound_from_target then
            local target_prefix_length = target:len()
            local original_destination_sound_name = destination.. name:sub(target_prefix_length + 1)

            local original_target_sound = value
            local original_dest_sound = config.gunshots[original_destination_sound_name]

            local is_dest_sound_valid = ONLY_SWAP_VALID_SOUNDs and original_dest_sound ~= nil or true
            if is_dest_sound_valid then
                if SWITCH_SOUNDS then
                    config.gunshots[name] = original_dest_sound
                end

                config.gunshots[original_destination_sound_name] = original_target_sound
            end
        end
    end

    if SWITCH_SOUNDS then
        print("Swapped", destination, "gun sounds with", target, "gun sounds")
    else
        print("Replaced", destination, "gun sounds with", target, "gun sounds")
    end
end

local function createNewShades(): Part
    local AntiMonsterShades: Part = create_instance("Part")
    AntiMonsterShades.Name = "anti-monster device"
    AntiMonsterShades.Transparency = 0
    AntiMonsterShades.BrickColor = BrickColor.Green()
    AntiMonsterShades.CastShadow = false
    AntiMonsterShades.Material = Enum.Material.ForceField
    AntiMonsterShades.Anchored = true
    AntiMonsterShades.CanCollide = false
    AntiMonsterShades.CanQuery = true
    AntiMonsterShades.CanTouch = true
    AntiMonsterShades.Size = Vector3.new(16, 16, 0.5)
    AntiMonsterShades.Parent = get_map_root()

    local light: SpotLight = create_instance("SpotLight")
    light.Angle = 120
    light.Brightness = 1
    light.Range = 16
    light.Enabled = true
    light.Parent = AntiMonsterShades

    return AntiMonsterShades
end

local function on_spawned()
    print("spawned")
    anti_monster_device = createNewShades()
    amd_connection = time.renderstep("AMD_update", function(delta_time)
        if framework.character.is_alive() then
            if anti_monster_device == nil then
                anti_monster_device = createNewShades()
            end
        
            local camera_cframe: CFrame = framework.character.get_camera_cframe()
            local amd_new_cframe: CFrame = camera_cframe + camera_cframe.LookVector * (10)
            local amd_new_position: Vector3 = amd_new_cframe.Position
            local amd_ori_rx, amd_ori_ry, amd_ori_rz: number = amd_new_cframe:ToOrientation()
            local amd_ori_dx, amd_ori_dy, amd_ori_dz: number = math.deg(amd_ori_rx), math.deg(amd_ori_ry), math.deg(amd_ori_rz)
            local amd_new_ori: Vector3 = Vector3.new(amd_ori_dx, amd_ori_dy, amd_ori_dz)

            anti_monster_device.Position = amd_new_position
            anti_monster_device.Orientation = amd_new_ori
        end
    end)
end

local function on_died()
    if amd_connection ~= nil then
        anti_monster_device:Destroy()

        amd_connection:Disconnect()
        amd_connection = nil
    end
end

framework.on_spawned:Connect(on_spawned)
framework.on_died:Connect(on_died)

replace_gun_sounds(DESTINATION1_PREFIX, TARGET1_PREFIX, SWITCH_SOUNDS)
replace_gun_sounds(DESTINATION2_PREFIX, TARGET2_PREFIX, SWITCH_SOUNDS)