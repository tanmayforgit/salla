module Recommendations
  class PeopleAlsoSaw
    def initialize(opts = {})
      @item_id = opts.fetch(:item_id)
    end

    def get_recommendations
      UserAlsoViewed[@item_id].items_by_score_desc
    end
  end
end
