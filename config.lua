---------------------------------------
--   ESX_SIMPLEGARAGES by Dividerz   --
-- FOR SUPPORT: Arne#7777 on Discord --
---------------------------------------

Config = {}

Config.Garages = {
    sapcounsel = {
        garageName = "Pillbox Hill",
        getVehicle = vector3(-329.87, -780.40, 33.96),
        spawnPoint = {
            coords = vector3(-334.44, -780.75, 33.96),
            heading = 137.50
        },
        storeVehicle = vector3(-341.72, -767.43, 33.96)
    },
    court = {
        garageName = "Courtbuilding",
        getVehicle = vector3(275.42, -345.27, 45.17),
        spawnPoint = {
            coords = vector3(273.07, -333.91, 44.92),
            heading = 160.15
        },
        storeVehicle = vector3(283.61, -342.54, 44.92)
    },
    canals = {
        garageName = "Vespucci Canals",
        getVehicle = vector3(-1159.14, -740.12, 19.89),
        spawnPoint = {
            coords = vector3(-1149.21, -739.36, 20.0),
            heading = 130.92
        },
        storeVehicle = vector3(-1146.47, -745.94, 19.62)
    },
    paleto = {
        garageName = "Paleto Gas Station",
        getVehicle = vector3(105.21, 6613.74, 32.40),
        spawnPoint = {
            coords = vector3(116.01, 6606.16, 31.93),
            heading = 278.29
        },
        storeVehicle = vector3(119.48, 6599.32, 32.02)
    },
    buffs = {
        garageName = "Pacific Buffs Hotel",
        getVehicle = vector3(-1877.31, -309.57, 49.24),
        spawnPoint = {
            coords = vector3(-1888.87, -306.40, 49.24),
            heading = 53.46
        },
        storeVehicle = vector3(-1894.07, -315.65, 49.24)
    },
    sandyfiredept = {
        garageName = "Sandy Shores Fire Dep",
        getVehicle = vector3(1694.53, 3612.20, 35.31),
        spawnPoint = {
            coords = vector3(1703.03, 3601.48, 35.43),
            heading = 209.88
        },
        storeVehicle = vector3(1692.04, 3605.32, 35.40)
    },
    centralpd = {
        garageName = "PD Parking",
        getVehicle = vector3(472.15, -1078.71, 29.20),
        spawnPoint = {
            coords = vector3(465.10, -1084.54, 29.20),
            heading = 174.99
        },
        storeVehicle = vector3(471.90, -1089.23, 29.20)
    },
    stadium = {
        garageName = "LS Stadium",
        getVehicle = vector3(-169.08, -2144.39, 17.05),
        spawnPoint = {
            coords = vector3(-165.56, -2151.21, 16.70),
            heading = 106.33
        },
        storeVehicle = vector3(-174.06, -2148.14, 16.70)
    }
}

Config.PublicImpounds = {
    ["hayesdepot"] = {
        garageName = "Hayes Depot",
        getVehicle = vector3(491.0, -1314.69, 29.25),
        spawnPoint = {
            coords = vector3(491.0, -1314.69, 29.25),
            heading = 304.50
        }
    }
}

Config.PoliceImpounds = {
    ["policedepot"] = {
        garageName = "Police Impound",
        getVehicle = vector3(409.36, -1622.99, 29.29),
        spawnPoint = {
            coords = vector3(404.84, -1642.51, 29.29),
            heading = 228.84
        },
    }
}

Config.Trim = function(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end
