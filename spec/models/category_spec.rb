RSpec.describe Category, type: :model do
  describe '#validations' do
    subject { FactoryBot.build(:category) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to belong_to(:vertical) }
    it { is_expected.to have_many(:courses).dependent(:destroy) }
  end
end
