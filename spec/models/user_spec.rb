require 'rails_helper'
RSpec.describe User do
  describe "#recently_visited_items" do
    let(:recently_visited_item_1) { SecureRandom.uuid() }
    let(:recently_visited_item_2) { SecureRandom.uuid() }
    let(:long_visited_item_1) { SecureRandom.uuid() }
    let(:long_visited_item_2) { SecureRandom.uuid() }
    let(:user_id) { SecureRandom.uuid() }

    subject { User[user_id].recently_visited_items }

    it "Returns items that are visited by users in the last 24 hour" do
      time_24_hours_ago = Time.now - 24.hours - 1.minute
      Timecop.travel(time_24_hours_ago)

      User[user_id].visit(long_visited_item_1)
      User[user_id].visit(long_visited_item_2)

      Timecop.return
      User[user_id].visit(recently_visited_item_1)
      User[user_id].visit(recently_visited_item_2)

      expect(subject.size).to eq(2)
      expect(subject).to include(recently_visited_item_1)
      expect(subject).to include(recently_visited_item_2)

    end
  end
end