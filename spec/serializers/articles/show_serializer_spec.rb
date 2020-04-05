RSpec.describe Articles::ShowSerializer, type: :serializer do
  let!(:article) { create(:article,
                          title: 'Breaking News',
                          body: 'Some breaking content') }
  let(:serialization) { Articles::ShowSerializer
    .new(article, scope: create(:user), scope_name: :current_user)}
  subject { JSON.parse(serialization.to_json) }

  it 'contains id, title, body, image, journalist, category, location and likes' do
    expected_keys = ['id', 'title', 'body', 'image', 'category', 'location', 'journalist', 'created_at', 'likes']
    expect(subject.keys).to match expected_keys
  end
end