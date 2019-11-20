RSpec.describe Course, type: :model do
  describe '#validations' do
    subject { FactoryBot.build(:course) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to belong_to(:category) }
  end
end
