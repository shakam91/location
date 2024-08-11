ESX = nil
TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)


local open = false 
local mainMenu = RageUI.CreateMenu(" ", "Location de voiture", X, Y, "menu", "menu")
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  open = false
end


function OpenMenulocation()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu,function() 

            for k, v in pairs(cfg_slocation.Type.vehicule) do
                RageUI.Button(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, {  
                    onSelected = function()
                        ESX.ShowNotification("Location d'une ~r~"..v.Label.."~s~ payer ~g~"..v.Price.."$~s~ vien d'être éffectuer sur votre compte")
                        TriggerServerEvent('shakam:removeargent', v)
                        Citizen.Wait(250)
                        voituredelocation(v.Value)
                        RageUI.CloseAll()
                    end 
                });
            
            end
            end)
  Wait(3)
 end
end)
end
end





--- Ouvrir le menu


Citizen.CreateThread(function()
    while true do

      local wait = 750

      for k, v in pairs(cfg_slocation.loc) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(23, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.6, 0.6, 0.3, 132, 102, 226, 255, false, false, p19, true)   

        
            if dist <= 2.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour ~b~intéragir", 1) 
                if IsControlJustPressed(1,51) then
                    OpenMenulocation()
            end
        end
    end
    end
    Citizen.Wait(wait)
end
end)



--- SPAWN VOITURE

function voituredelocation(car)
    local car = GetHashKey(car)
  
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(5)
    end
  
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, false))
    local vehicle = CreateVehicle(car, x, y, z, GetEntityHeading(playerPed), true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LOCATION"..math.random(1,9000)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleCustomPrimaryColour(vehicle, 0, 25, 25)
    SetVehicleCustomSecondaryColour(vehicle, 0, 25, 25)
end





CreateThread(function ()
    for k, v in pairs(cfg_slocation.loc) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)

    SetBlipSprite(blip, 280)
    SetBlipScale (blip, 0.6)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Location de voiture')
    EndTextCommandSetBlipName(blip)
    end
end)
