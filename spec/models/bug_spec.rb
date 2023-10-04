require 'rails_helper'

RSpec.describe Bug do
  context "when creating bug" do
    let(:bug) { create(:bug) }

    it "validates bug" do
      expect(bug.valid?).to be(true)
    end
  end
end
