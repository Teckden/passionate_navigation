RSpec.describe Vertical, type: :model do
  describe '#validations' do
    subject { FactoryBot.build(:vertical) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
  end
end
