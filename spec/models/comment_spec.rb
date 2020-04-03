require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Database table' do
    it { is_expected.to have_db_column :user_id }
    it { is_expected.to have_db_column :body }
    it { is_expected.to have_db_column :article_id}
    it { is_expected.to have_db_column :email}
    it { is_expected.to have_db_column :role}
  end

  describe 'Associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :article }
  end

  describe 'Factory' do
    it 'should have valid Factory' do
      expect(FactoryBot.create(:comment)).to be_valid
    end
  end
end
