ESX = nil

local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
	
		if resource ~= 'vace-givecar' then
			
			print("^8------------------------------------------------------------------------------------")
			print("^8------------------------------------------------------------------------------------")
			print("^8ERROR: Please rename "..GetCurrentResourceName().." to vace-givecar, otherwise it might not work properly...")
			print("^8------------------------------------------------------------------------------------")
			print("^8------------------------------------------------------------------------------------^0")
		end
	end
end)


TriggerEvent('es:addGroupCommand', 'givecar', 'admin', function(source, args, user)
	TriggerClientEvent('vace-givecar:spawnVehicleBySql',source,args[1],args[2])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)

RegisterServerEvent('vace-givecar:setVehicleBySql')
AddEventHandler('vace-givecar:setVehicleBySql', function (vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', _source,'addCar:palte:'..vehicleProps.plate)
	end)
end)


TriggerEvent('es:addGroupCommand', 'giveyoucar', 'admin', function(source, args, user)

	TriggerClientEvent('vace-givecar:spawnYouVehicleBySql',source,args[1],args[2],args[3])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)

RegisterServerEvent('vace-givecar:setYouVehicleBySql')
AddEventHandler('vace-givecar:setYouVehicleBySql', function (vehicleProps,youId)
	local _source = youId
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', _source,'addCar:palte:'..vehicleProps.plate)
	end)
end)


TriggerEvent('es:addGroupCommand', 'delcarbyplate', 'admin', function(source, args, user)	
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = args[1]
	})
	TriggerClientEvent('esx:showNotification', source,'delcar:palte:'..args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,'')
end)