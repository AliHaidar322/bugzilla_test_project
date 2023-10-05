require 'rails_helper'

RSpec.describe UserProject do
  it { is_expected.to have_attribute(:user_id) }
  it { is_expected.to have_attribute(:project_id) }
end
