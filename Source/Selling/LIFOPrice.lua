local function userPrefersPercentage()
  return
    Auctionator.Config.Get(Auctionator.Config.Options.LIFO_AUCTION_SALES_PREFERENCE) ==
    Auctionator.Config.SalesTypes.PERCENTAGE
end

local function getPercentage()
  return (100 - Auctionator.Config.Get(Auctionator.Config.Options.LIFO_UNDERCUT_PERCENTAGE)) / 100
end

local function getSetAmount()
  return Auctionator.Config.Get(Auctionator.Config.Options.LIFO_UNDERCUT_STATIC_VALUE)
end


function Auctionator.Selling.CalculateLIFOPriceFromPrice(basePrice)
  Auctionator.Debug.Message(" AuctionatorItemSellingMixin:CalculateItemPriceFromResult")
  local value

  if userPrefersPercentage() then
    local percentage = getPercentage()
    value = basePrice * percentage

    Auctionator.Debug.Message("Percentage calculation", basePrice, percentage, value)
  else
    local setAmount = getSetAmount()
    value = basePrice - setAmount

    Auctionator.Debug.Message("Static value calculation", basePrice, setAmount, value)
  end

  --Ensure the value is at least 1s
  if value < 100 then
    value = 100
  end

  return value
end
