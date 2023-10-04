# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User do
  context 'when creating user' do
    let(:user) { create(:user) }

    it 'validate user' do
      expect(user.valid?).to be(true)
    end
  end
end
