ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function checkItem(itemName, quantity, callback)
    ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
        if playerData and playerData.inventory then
            for _, item in pairs(playerData.inventory) do
                if item.name == itemName and item.count >= quantity then
                    callback(true)
                    return
                end
            end
        end
        callback(false)
    end)
end

CRYSTAL = {}

function CRYSTAL.gridsystem(params)
    local marker = {
        pos = params.pos,
        rot = params.rot or vector3(90.0, 90.0, 90.0),
        scale = params.scale or vector3(1.0, 1.0, 1.0),
        permission = params.permission or ESX.PlayerData.job.name,
        job_grade = params.job_grade or 0,
        textureName = params.textureName or 'marker',
        saltaggio = params.saltaggio or false,
        msg = params.msg or 'Premi [E] per interagire',
        action = params.action,
        key = params.key or 38,
        requestitem = params.requestitem or nil
    }

    local function loadMarkerTexture(dict)
        if not HasStreamedTextureDictLoaded(dict) then
            RequestStreamedTextureDict(dict, false)
            local timeout = 500
            for _ = 1, timeout do
                if HasStreamedTextureDictLoaded(dict) then
                    return dict
                end
                Wait(0)
            end
            print(("ERRORE: TEXTURE NON CARICATA '%s' DOPO %s TEMPO"):format(dict, timeout))
            return nil
        end
        return dict
    end

    local function drawMarker(marker)
        local dict = loadMarkerTexture('marker')
        if dict then
            DrawMarker(
                9,
                marker.pos.x, marker.pos.y, marker.pos.z,
                0, 0, 0,
                marker.rot.x, marker.rot.y, marker.rot.z,
                marker.scale.x, marker.scale.y, marker.scale.z,
                255, 255, 255, 255,
                marker.saltaggio,
                true,
                2,
                true,
                dict,
                marker.textureName,
                false
            )
        end
    end

    local function isKeyJustPressed(key)
        return IsControlJustReleased(0, key)
    end

    local function getPlayerJobAndGrade()
        local playerData = ESX.PlayerData
        local playerJob = playerData.job and playerData.job.name or nil
        local playerJobGrade = playerData.job and playerData.job.grade or 0
        return playerJob, playerJobGrade
    end

    Citizen.CreateThread(function()
        while true do
            Wait(0)

            local playerCoords = GetEntityCoords(PlayerPedId())
            local playerJob, playerJobGrade = getPlayerJobAndGrade()

            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, marker.pos.x, marker.pos.y, marker.pos.z)

            if distance < 20.0 then
                if playerJob == marker.permission and playerJobGrade >= marker.job_grade then
                    drawMarker(marker)

                    if distance < 2.0 then
                        ESX.ShowHelpNotification(params.msg)

                        if isKeyJustPressed(marker.key) then
                            if marker.requestitem then
                                checkItem(marker.requestitem, 1, function(hasItem)
                                    if hasItem then
                                        marker.action()
                                    else
                                        ESX.ShowNotification('Non hai l\'oggetto richiesto.')
                                    end
                                end)
                            else
                                marker.action()
                            end
                        end
                    end
                end
            else
                Wait(1000)
            end
        end
    end)
end

exports('CRYSTAL', function ()
    return CRYSTAL
end)