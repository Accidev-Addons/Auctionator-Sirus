AuctionatorHistoricalPriceRowMixin = CreateFromMixins(AuctionatorResultsRowTemplateMixin)

local DAILY_HIGHLIGHT_COLOR = {r = 1, g = 0.82, b = 0}
local DEFAULT_TEXT_COLOR = {r = 1, g = 1, b = 1}

function AuctionatorHistoricalPriceRowMixin:Populate(rowData, dataIndex)
  AuctionatorResultsRowTemplateMixin.Populate(self, rowData, dataIndex)

  local wasInDaily = false
  if InnKAuc and InnKAuc.DailyHistory and rowData.rawDay and rowData.itemID then
    wasInDaily = InnKAuc.DailyHistory:WasItemInDailyOnRawDay(rowData.itemID, rowData.rawDay)
  end

  if self.cells then
    for _, cell in ipairs(self.cells) do
      if cell.columnName == "date" and cell.text then
        if wasInDaily then
          cell.text:SetTextColor(DAILY_HIGHLIGHT_COLOR.r, DAILY_HIGHLIGHT_COLOR.g, DAILY_HIGHLIGHT_COLOR.b)
        else
          cell.text:SetTextColor(DEFAULT_TEXT_COLOR.r, DEFAULT_TEXT_COLOR.g, DEFAULT_TEXT_COLOR.b)
        end
        break
      end
    end
  end
end

function AuctionatorHistoricalPriceRowMixin:OnClick(button, ...)
  Auctionator.Debug.Message("AuctionatorHistoricalPriceRowMixin:OnClick()")

  if button == "LeftButton" then
    Auctionator.EventBus
      :RegisterSource(self, "HistoricalPriceRow")
      :Fire(self, Auctionator.Selling.Events.PriceSelected, self.rowData.minSeen)
      :UnregisterSource(self)
  elseif button == "RightButton" then
    Auctionator.EventBus
      :RegisterSource(self, "HistoricalPriceRow")
      :Fire(self, Auctionator.Selling.Events.PriceSelected, self.rowData.maxSeen)
      :UnregisterSource(self)
  end
end
