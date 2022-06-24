require 'rails_helper'
module EventProcessors
  RSpec.describe PageView do
    let(:user_id) { SecureRandom.uuid() }
    let(:item_id) { SecureRandom.uuid() }

    let(:page_view_event) do
      {
        "user_id" => user_id,
        "item_id" => item_id
      }
    end

    it "Adds the item to user viwes item set." do
      PageView.new(page_view_event).process
      expect(User[user_id].recently_visited_items).to include(item_id)
    end

    let(:item_visited_long_ago) { SecureRandom.uuid() }
    let(:item_visited_recently) { SecureRandom.uuid() }

    let(:past_page_view_events) do
      {
        "user_id" => user_id,
        "item_id" => item_visited_long_ago
      }
    end

    let(:recent_page_view_events) do
      {
        "user_id" => user_id,
        "item_id" => item_visited_recently
      }
    end

    it "Increments the score for all recently visited items by 10" do
      Timecop.travel(DURATION_FOR_RECENT_VISIT + 1.minute)
      PageView.new(past_page_view_events).process
      Timecop.return

      PageView.new(recent_page_view_events).process
      PageView.new(page_view_event).process

      expect(UserAlsoViewed[item_id].score(item_visited_long_ago)).to eq(0)
      expect(UserAlsoViewed[item_id].score(item_visited_recently)).to eq(10)
    end
  end
end