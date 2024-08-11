ESX = nil
TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)

RegisterServerEvent('shakam:removeargentb') 
AddEventHandler('shakam:removeargentb', function(vehicule)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney() 
    
    if playerMoney >= (vehicule.Price) then 
        xPlayer.removeMoney(vehicule.Price) 
    end 
end)
