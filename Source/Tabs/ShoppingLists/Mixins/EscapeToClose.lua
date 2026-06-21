AuctionatorEscapeToCloseMixin = {}

function AuctionatorEscapeToCloseMixin:OnShow()
  if self:GetName() and self:IsObjectType("Button") then
    SetOverrideBinding(self, true, "ESCAPE", string.format("CLICK %s:RightButton", self:GetName()))
  end
end

function AuctionatorEscapeToCloseMixin:OnHide()
  ClearOverrideBindings(self)
end
