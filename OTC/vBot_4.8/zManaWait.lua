-- Mana Wait
local MANA_STOP  = 3000  -- << zatrzymaj CaveBot gdy mana <= tej wartosci
local MANA_START = 6000  -- << wznow CaveBot gdy mana >= tej wartosci

local stoppedByUs = false

macro(500, "Mana Wait", function()
  local mana = player:getMana()

  if mana <= MANA_STOP and not stoppedByUs then
    CaveBot.setOff()
    stoppedByUs = true

  elseif mana >= MANA_START and stoppedByUs then
    CaveBot.setOn()
    stoppedByUs = false
  end
end)
