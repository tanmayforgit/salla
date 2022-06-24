require 'rails_helper'
module Recommendations
  RSpec.describe PeopleAlsoSaw do
    let(:subject_item_id) { SecureRandom.uuid() }
    let(:item_id2) { SecureRandom.uuid() }
    let(:item_id3) { SecureRandom.uuid() }
    let(:user_id1) { SecureRandom.uuid() }
    let(:user_id2) { SecureRandom.uuid() }
    let(:user_id3) { SecureRandom.uuid() }
    let(:some_other_user_id) { SecureRandom.uuid() }
    let(:some_other_item_id) { SecureRandom.uuid() }

    before do
      # User 1 and 2 will visit subject_item and item_2
      # User 3 will visit subject_item and item_3

      # Since Item 2 is visited twice as much as item 3 from the users
      # who visit item1, we will assert that item 2 is recommended first
      # and item_3 is recommended second

      # some_other_user will visit some_other_item just to establish that
      # irrelevant item visits do not cause any troubles

      page_view_events = [
        {
          "user_id" => user_id3,
          "item_id" => subject_item_id
        },
        {
          "user_id" => user_id3,
          "item_id" => item_id3
        },
        {
          "user_id" => user_id1,
          "item_id" => subject_item_id
        },
        {
          "user_id" => user_id1,
          "item_id" => item_id2
        },
        {
          "user_id" => user_id2,
          "item_id" => subject_item_id
        },
        {
          "user_id" => user_id2,
          "item_id" => item_id2
        },
        {
          "user_id" => some_other_user_id,
          "item_id" => some_other_item_id
        }
      ].each do |page_view_event|
        EventProcessors::PageView.new(page_view_event).process
      end

    end

    subject { PeopleAlsoSaw.new({ item_id: subject_item_id}).get_recommendations }
    it "Recommends item based on which other items are normally viewed by the end user" do
      # Order of recommendations does matter
      expect(subject).to eq([item_id2, item_id3])
    end
  end
end