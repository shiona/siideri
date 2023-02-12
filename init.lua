
function split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

seeds = {}

seed_list = ModSettingGet("SRSeed.seed_list" )
if (seed_list ~= "") then
  seeds = split(seed_list, ",")
end

print("Seed list:")
for i, seed in ipairs(seeds) do
  print(" # " .. tostring(i) .. " -> " .. seed)
end

-- Needs to be called on a run before world gen.
-- Sets current world seed and increments the index
-- so that the next run will get the next seed
--
-- if index has run past the given list, does nothing,
-- player gets a random seed and this mod does nothing
function set_next_seed()
  index = tonumber(ModSettingGet("SRSeed.seed_index"))
  print("Read seed index " .. tonumber(index) .. " from settings")
  if(seeds[index] ~= nil)then
    local seed = seeds[index]
    index = index + 1
    print("Doing my best to set next index to " .. tostring(index))
    ModSettingSetNextValue("SRSeed.seed_index", tostring(index), false)
    local next_index = ModSettingGetNextValue("SRSeed.seed_index")
    print("Next index is "..next_index)
    print("Setting seed: "..seed)
    SetWorldSeed(tonumber(seed))
  else
    print("Seed index was nil, playing a random game")
  end
end

function OnModInit()
  print("On Mod Init")
  set_next_seed()
end
