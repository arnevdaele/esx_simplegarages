---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_simplegarages:callback:GetPlayerCashAmount", function(source, cb)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local amount = sourcePlayer.getMoney()

    cb(amount)
end)

ESX.RegisterServerCallback("esx_simplegarages:callback:CheckIfPlateExists", function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `plate` = @plate', {['@plate'] = plate}, function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback("esx_simplegarages:callback:GetUserVehicles", function(source, cb, garage)
    local myCars = {}
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `garage` = @garage AND `type` = @type', {['@owner'] = identifier, ['@garage'] = garage, ['@type'] = 'car'}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                vehicle = json.decode(v.vehicle)
                table.insert(myCars, {vehicle = vehicle, fuel = v.fuel, engine = v.engine, stored = v.stored, plate = v.plate})
            end
            cb(myCars)
        else
            sourcePlayer.showNotification("You don't have any car parked in this garage...")
        end
    end)
end)

ESX.RegisterServerCallback("esx_simplegarages:callback:GetPoliceImpoundedVehicles", function(source, cb)
    local PoliceImpoundCars = {}
    local sourcePlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `stored` = 2 AND `type` = @type', {['@type'] = 'car'}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                vehicle = json.decode(v.vehicle)
                table.insert(PoliceImpoundCars, {vehicle = vehicle, fuel = v.fuel, engine = v.engine, plate = v.plate})
            end
            cb(PoliceImpoundCars)
        else
            sourcePlayer.showNotification("There aren't any impounded vehicles")
        end
    end)
end)

ESX.RegisterServerCallback("esx_simplegarages:callback:GetImpoundedVehicles", function(source, cb)
    local ImpoundedVehicles = {}
    local sourcePlayer = ESX.GetPlayerFromId(source)
    local identifier = sourcePlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `stored` = 0 AND `type` = @type', {['@owner'] = identifier, ['@type'] = 'car'}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                vehicle = json.decode(v.vehicle)
                table.insert(ImpoundedVehicles, {vehicle = vehicle, fuel = v.fuel, engine = v.engine, price = v.price, plate = v.plate})
            end
            cb(ImpoundedVehicles)
        else
            sourcePlayer.showNotification("You don't have any impounded vehicles")
        end
    end)
end)

RegisterNetEvent('esx_simplegarages:server:updateCarStoredState')
AddEventHandler('esx_simplegarages:server:updateCarStoredState', function(plate, stored)
    MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate", { ['@stored'] = stored, ['@plate'] = plate })
end)

RegisterNetEvent('esx_simplegarages:server:updateCarState')
AddEventHandler('esx_simplegarages:server:updateCarState', function(plate, fuel, engine)
    MySQL.Async.execute("UPDATE owned_vehicles SET `fuel` = @fuel, `engine`= @engine WHERE `plate` = @plate", { ['@fuel'] = fuel, ['@engine'] = engine, ['@plate'] = plate })
end)

RegisterNetEvent('esx_simplegarages:server:updateCarGarageLocation')
AddEventHandler('esx_simplegarages:server:updateCarGarageLocation', function(plate, garage)
    MySQL.Async.execute("UPDATE owned_vehicles SET `garage` = @garage WHERE `plate` = @plate", { ['@garage'] = garage, ['@plate'] = plate })
end)

RegisterNetEvent('esx_simplegarages:server:takeVehicleToPoliceImpound')
AddEventHandler('esx_simplegarages:server:takeVehicleToPoliceImpound', function(plate)
    local sourcePlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = 2 WHERE `plate` = @plate", { ['@plate'] = plate })
    sourcePlayer.showNotification("Vehicle with plate " .. plate .. " has been impounded.")
end)

RegisterNetEvent('esx_simplegarages:server:takeVehicleToImpound')
AddEventHandler('esx_simplegarages:server:takeVehicleToImpound', function(plate, price)
    local sourcePlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = 0, `price` = @price WHERE `plate` = @plate", {['@price'] = price, ['@plate'] = plate})
    sourcePlayer.showNotification("Vehicle with plate " .. plate .. " has been sent to the depot for ~g~$" .. price .. "~w~.")
end)

RegisterNetEvent('esx_simplegarages:server:PayImpoundBill')
AddEventHandler('esx_simplegarages:server:PayImpoundBill', function(price)
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.removeMoney(price)

    sourcePlayer.showNotification("You've paid ~g~$" .. price .. "~w~ to get your vehicle back.")
end)

RegisterCommand('policeimpound', function(src, args, raw)
    local sourcePlayer = ESX.GetPlayerFromId(src)

    if sourcePlayer.job.name == 'police' then
        TriggerClientEvent('esx_simplegarages:client:takeVehicleToPoliceImpound', src)
    else
        sourcePlayer.showNotification("You're not a Police officer...")
    end
end)

RegisterCommand('impound', function(source, args, raw)
    local src = source
    local sourcePlayer = ESX.GetPlayerFromId(src)
    local price = tonumber(args[1])

    if price ~= nil or price ~= 0 then
        if sourcePlayer.job.name == 'police' or sourcePlayer.job.name == 'mechanic' then
            TriggerClientEvent('esx_simplegarages:client:takeVehicleToImpound', src, price)
        else
            sourcePlayer.showNotification("You're not a mechanic or Police officer...")
        end
    else
        sourcePlayer.showNotification("Please enter a valid amount.")
    end
end)
