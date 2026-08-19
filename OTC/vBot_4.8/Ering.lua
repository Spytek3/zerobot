-- E-Ring Auto Equip
local ERING_ID  = 3051  -- << ID energy ring
local HP_ON     = 60    -- << zaloz gdy HP% <= tej wartosci
local HP_OFF    = 80    -- << zdejmij gdy HP% >= tej wartosci
local RING_SLOT = 9     -- << numer slotu ring

macro(250, "E-Ring", function()
  local hp = player:getHealthPercent()
  local ringItem = getSlot(RING_SLOT)
  local ringId = ringItem and ringItem:getId() or 0

  if hp <= HP_ON and ringId ~= ERING_ID then
    -- zaloz e-ring
    for _, container in pairs(g_game.getContainers()) do
      for _, item in ipairs(container:getItems()) do
        if item:getId() == ERING_ID then
          g_game.move(item, {x=65535, y=RING_SLOT, z=0}, 1)
          delay(1000)
          return
        end
      end
    end

  elseif ringId == ERING_ID and (hp >= HP_OFF or player:getManaPercent() < 5) then
    -- zdejmij e-ring do pierwszego wolnego plecaka
    for _, container in pairs(g_game.getContainers()) do
      if not containerIsFull(container) then
        g_game.move(ringItem, container:getSlotPosition(container:getItemsCount()), 1)
        delay(1000)
        return
      end
    end
  end
end)