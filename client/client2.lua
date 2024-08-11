ESX = nil
TriggerEvent("esx:getSharedObject", function(obj)
	ESX = obj
end)


local open = false 
local mainMenu2 = RageUI.CreateMenu(" ", "Location de bateaux", X, Y, "menu", "menu")
mainMenu2.Display.Header = true 
mainMenu2.Closed = function()
  open = false
end


function OpenMenulocationb()
	if open then 
		open = false
		RageUI.Visible(mainMenu2, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu2, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu2,function() 

            for k, v in pairs(cfg_slocation.Type_bateaux.bateaux) do
                RageUI.Button(v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, {  
                    onSelected = function()
                        ESX.ShowNotification("Location d'une ~r~"..v.Label.."~s~ payer ~g~"..v.Price.."$~s~ vien d'être éffectuer sur votre compte")
                        TriggerServerEvent('shakam:removeargentb', v)
                        Citizen.Wait(250)
                        bateauxdelocation(v.Value)
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

      for k, v in pairs(cfg_slocation.loc_bateaux.menu) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(23, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.6, 0.6, 0.3, 132, 102, 226, 255, false, false, p19, true)   

        
            if dist <= 2.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour ~b~intéragir", 1) 
                if IsControlJustPressed(1,51) then
                    OpenMenulocationb()
            end
        end
    end
    end
    Citizen.Wait(wait)
end
end)



--- SPAWN VOITURE

function bateauxdelocation(bateaux)
    for k, v in pairs(cfg_slocation.loc_bateaux.spawn) do
    local bateaux = GetHashKey(bateaux)
  
    RequestModel(bateaux)
    while not HasModelLoaded(bateaux) do
        RequestModel(bateaux)
        Citizen.Wait(5)
    end
  
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(bateaux, v.x, v.y, v.z, 110.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LOCATION"..math.random(1,9000)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleCustomPrimaryColour(vehicle, 0, 25, 25)
    SetVehicleCustomSecondaryColour(vehicle, 0, 25, 25)
end
  end




CreateThread(function ()
    for k, v in pairs(cfg_slocation.loc_bateaux.blips) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)

    SetBlipSprite(blip, 427)
    SetBlipScale (blip, 0.6)
    SetBlipColour(blip, 14)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Location de bateaux')
    EndTextCommandSetBlipName(blip)
    end
end)