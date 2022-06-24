module EventProcessors
  class PageView
    def initialize(event_hash)
      @user_id = event_hash["user_id"]
      @item_id = event_hash["item_id"]
    end

    def process
      return false unless @user_id && @item_id
      user = User[@user_id]
      user.visit(@item_id)

      recently_visited_items = user.recently_visited_items

      user_also_viwed_weighted_list = UserAlsoViewed[@item_id]

      recently_visited_items.each do |rv_item|
        user_also_viwed_weighted_list.add_or_update_item(rv_item, RECENT_PAGE_VIEW_WEIGHT)
        UserAlsoViewed[rv_item].add_or_update_item(@item_id, RECENT_PAGE_VIEW_WEIGHT)
      end
    end
  end
end