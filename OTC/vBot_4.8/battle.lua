if not storage.BattleList then
  storage.BattleList = {}
end

local settings = storage.BattleList

if settings.enabled == nil then
  settings.enabled = true
end

g_ui.loadUIFromString([[
BotContainer < Panel
  height: 68
  margin-bottom:10

  UIWidget
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
  
  ScrollablePanel
    id: items
    anchors.fill: parent
    padding-top:20
    vertical-scrollbar: scroll
    layout:
      type: grid
      cell-size: 34 34
      flow: true

  BotSmallScrollBar
    id: scroll
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    anchors.right: parent.right
    step: 10
    pixels-scroll: true

BattleListScrollBar < Panel
  height: 28
  margin-top: 3

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 10
    step: 1

BattleListTextEdit < Panel
  height: 40
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 0
    maximum: 10
    step: 1
    text-align: center

BattleListItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right


BattleListCheckBox < BotSwitch
  height: 20
  margin-top: 7

BattleListWindow < MainWindow
  !text: tr('BattleList')
  size: 440 360
  padding: 25

  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: parent.top
    text-align: center

  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

    VerticalSeparator
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  ResizeBorder
    id: bottomResizeBorder
    anchors.fill: separator
    height: 3
    minimum: 260
    maximum: 600
    margin-left: 3
    margin-right: 3
    background: #ffffff88    

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])

-- basic elements
BattleListWindow = UI.createWindow('BattleListWindow', rootWidget)
BattleListWindow:hide()
BattleListWindow.closeButton.onClick = function(widget)
  BattleListWindow:hide()
end

BattleListWindow:setHeight(250)
BattleListWindow:setWidth(450)
BattleListWindow:setText("Battle List")

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Battle List')

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

ui.title:setOn(settings.enabled)
ui.title.onClick = function(widget)
  settings.enabled = not settings.enabled
  widget:setOn(settings.enabled)
end

ui.push.onClick = function(widget)
  BattleListWindow:show()
  BattleListWindow:raise()
  BattleListWindow:focus()
end

-- available options for dest param
local rightPanel = BattleListWindow.content.right
local leftPanel = BattleListWindow.content.left

-- objects made by Kondrah - taken from creature editor, minor changes to adapt
local addCheckBox = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('BattleListCheckBox', dest)
  widget.onClick = function()
    widget:setOn(not widget:isOn())
    settings[id] = widget:isOn()
    
  end
  widget:setText(title)
  widget:setTooltip(tooltip)
  if settings[id] == nil then
    widget:setOn(defaultValue)
  else
    widget:setOn(settings[id])
  end
  settings[id] = widget:isOn()
end

local addItem = function(id, title, defaultItem, dest, tooltip)
  local widget = UI.createWidget('BattleListItem', dest)
  widget.text:setText(title)
  widget.text:setTooltip(tooltip)
  widget.item:setTooltip(tooltip)
  widget.item:setItemId(settings[id] or defaultItem)
  widget.item.onItemChange = function(widget)
    settings[id] = widget:getItemId()
  end
  settings[id] = settings[id] or defaultItem
end

local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('BattleListTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(settings[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    settings[id] = text
  end
  settings[id] = settings[id] or defaultValue or ""
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
  local widget = UI.createWidget('BattleListScrollBar', dest)
  widget.text:setTooltip(tooltip)
  widget.scroll.onValueChange = function(scroll, value)
    widget.text:setText(title .. ": " .. value)
    if value == 0 then
      value = 1
    end
    settings[id] = value
  end
  widget.scroll:setRange(min, max)
  widget.scroll:setTooltip(tooltip)
  if max-min > 1000 then
    widget.scroll:setStep(100)
  elseif max-min > 100 then
    widget.scroll:setStep(10)
  end
  widget.scroll:setValue(settings[id] or defaultValue)
  widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
end

addCheckBox("Monsters", "Monsters", false, leftPanel)
addCheckBox("Players", "Players", false, leftPanel)
addCheckBox("NPC", "NPC", false, leftPanel)
addCheckBox("Druid", "Druid (ED)", false, leftPanel)
addCheckBox("Sorcerer", "Sorcerer (MS)", false, leftPanel)
addCheckBox("Paladin", "Paladin (RP)", false, leftPanel)
addCheckBox("Knight", "Knight (EK)", false, leftPanel)
addCheckBox("Guild", "Guild", false, rightPanel)
addCheckBox("Enemy", "Enemy Guild", false, rightPanel)
addCheckBox("Party", "Party", false, rightPanel)

modules.game_battle.doCreatureFitFilters = function(creature)
  if creature:isLocalPlayer() then
    return false
  end
  
  if creature:getHealthPercent() <= 0 then
    return false
  end
  
  local pos = creature:getPosition()
  if not pos then return false end
  
  if pos.z ~= posz() or not creature:canBeSeen() then return false end
  
  if creature:isMonster() and not settings.Monsters then
    return false
  elseif creature:isNpc() and not settings.NPC then
    return false
  elseif creature == player then
    return false
  elseif creature:isPlayer() then
    local text = creature:getText()
    
    local voc = text:find("ED") and "ED"
    or text:find("MS") and "MS"
    or text:find("RP") and "RP"
    or text:find("EK") and "EK"
    or nil
    
    local anyVocFilter = settings.Druid or settings.Sorcerer or settings.Paladin or settings.Knight
    if anyVocFilter then
      if voc == "ED" and not settings.Druid then return false end
      if voc == "MS" and not settings.Sorcerer then return false end
      if voc == "RP" and not settings.Paladin then return false end
      if voc == "EK" and not settings.Knight then return false end
    end
    
    if not settings.Players then return false end
    
    if creature:getEmblem() == 1 and not settings.Guild then return false end
    if creature:getEmblem() == 2 and not settings.Enemy then return false end
    if creature:isPartyMember() and not settings.Party then return false end
  end
  
  return true
end