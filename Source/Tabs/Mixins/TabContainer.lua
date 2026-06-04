AuctionatorTabContainerMixin = {}

local function ApplyTabButtonBehaviour(frame)
  Mixin(frame, AuctionatorTabMixin)

  local parent = frame:GetParent()
  if not parent.Tabs then
    parent.Tabs = {}
  end
  table.insert(parent.Tabs, frame)

  frame:SetScript("OnShow", function(self)
    self:OnShow()
  end)
end

local function InitializeFromDetails(details)
  local frameName = "AuctionatorTabs_" .. details.name

  local created, frame = pcall(
    CreateFrame,
    "BUTTON",
    frameName,
    AuctionHouseFrame,
    "AuctionHouseFrameDisplayModeTabTemplate"
  )

  if not created or not frame then
    Auctionator.Debug.Message(
      "AuctionatorTabContainer: failed to create tab button, AH tab template unavailable",
      frameName
    )
    return nil
  end

  ApplyTabButtonBehaviour(frame)

  frame:SetText(details.textLabel)

  if not Auctionator.Config.Get(Auctionator.Config.Options.SMALL_TABS) then
    PanelTemplates_TabResize(frame, 20)
  end

  frame:Initialize(details.name, details.tabTemplate, details.tabHeader, {details.tabFrameName})

  return frame
end

function AuctionatorTabContainerMixin:OnLoad()
  Auctionator.Debug.Message("AuctionatorTabContainerMixin:OnLoad()")

  -- Tabs are sorted to avoid inconsistent ordering based on the addon loading
  -- order
  table.sort(
    Auctionator.Tabs.State.knownTabs,
    function(left, right)
      return left.tabOrder < right.tabOrder
    end
  )

  self.Tabs = {}

  for _, details in ipairs(Auctionator.Tabs.State.knownTabs) do
    local frame = InitializeFromDetails(details)
    if frame then
      table.insert(self.Tabs, frame)
    end
  end

  self:HookTabs()
end

function AuctionatorTabContainerMixin:OnShow()
  local padding = 0

  if Auctionator.Config.Get(Auctionator.Config.Options.SMALL_TABS) then
    for i, tab in ipairs(AuctionHouseFrame.Tabs) do
      PanelTemplates_TabResize(tab, padding)
    end
  end
end

function AuctionatorTabContainerMixin:IsAuctionatorFrame(displayMode)
  for _, frame in pairs(self.Tabs) do
    if frame.displayMode == displayMode then
      return true, frame
    end
  end

  return false, nil
end

function AuctionatorTabContainerMixin:HookTabs()
  hooksecurefunc(AuctionHouseFrame, "SetDisplayMode", function(frame)
    Auctionator.Debug.Message("SetDisplayMode", frame.displayMode)

    local isAuctionatorFrame, tab = self:IsAuctionatorFrame(frame.displayMode)

    for _, auctionatorTab in pairs(self.Tabs) do
      if auctionatorTab ~= tab then
        auctionatorTab:DeselectTab()
      end
    end

    -- Bail if our tab was not selected
    if not isAuctionatorFrame then
      return
    end

    tab:Selected()

    -- Idea derived from similar issue found at
    -- https://www.townlong-yak.com/bugs/Kjq4hm-DisplayModeCommunitiesTaint
    -- This way the displayMode ISN'T tainted, its just nil :)
    AuctionHouseFrame.displayMode = nil
  end)
end
