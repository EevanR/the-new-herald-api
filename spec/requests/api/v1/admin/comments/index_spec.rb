RSpec.describe 'GET /api/v1/admin/comments', type: :request do
  let(:journalist)  { create(:journalist)}
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
  let!(:article) { create(:article) }
  let!(:comment) { create(:comment, article_id: article.id) }

  describe 'Successfully list comments' do
    before do
      get "/api/v1/admin/comments",
      params: {
        article_id: article.id
      }
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 1 comment' do
      expect(response_json.count).to eq 1
    end

    it 'returns comment attributes' do
      expect(response_json[0]['body']).to eq "This is the body of the comment"
    end
  end

end