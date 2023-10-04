require 'rails_helper'

RSpec.describe Project do
  context "when using project" do
    let(:project) { create(:project) }

    it "validate project" do
      expect(project.valid?).to be(true)
    end
  end
end
