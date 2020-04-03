RSpec.describe Article, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :journalist_id }
    it { is_expected.to have_db_column :published }
    it { is_expected.to have_db_column :publisher_id }
    it { is_expected.to have_db_column :location}
    it { is_expected.to have_db_column :category }
    it { is_expected.to have_db_column :likes }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :journalist }
    it { is_expected.to belong_to(:publisher).optional }
  end

  describe 'Factory' do
    it 'should have valid Factory' do
      expect(FactoryBot.create(:article)).to be_valid
    end
  end
end
