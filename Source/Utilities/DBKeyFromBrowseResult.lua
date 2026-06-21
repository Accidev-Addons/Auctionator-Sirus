function Auctionator.Utilities.DBKeyFromBrowseResult(result)
    local itemLevel = result.itemKey.itemLevel or 0

    if itemLevel >= Auctionator.Constants.ITEM_LEVEL_THRESHOLD then
      return {
        "g:" .. result.itemKey.itemID .. ":" .. itemLevel,
        tostring(result.itemKey.itemID)
      }
    else
      return {tostring(result.itemKey.itemID)}
    end
end
