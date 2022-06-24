require 'rails_helper'
RSpec.describe UserVisitedItems do
  describe "adding and fetching" do
    let(:user_id) { SecureRandom.uuid() }
    let(:item_id) { SecureRandom.uuid() }

    it "Does something" do
      UserVisitedItems.add(user_id, item_id)
      expect(UserVisitedItems[user_id]).to eq([item_id])
    end
  end
end
