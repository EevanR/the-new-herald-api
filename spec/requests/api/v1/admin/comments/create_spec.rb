RSpec.describe 'POST /api/v1/admin/comments', type: :request do
  let(:journalist)  { create(:journalist)}
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
  let!(:article) { create(:article) }

  describe 'Successfully create comment with valid article and user' do
    before do
      post "/api/v1/admin/comments",
      params: {
        comment: {
          body: "This is the body of the comment",
          user_id: journalist.id,
          article_id: article.id,
          email: journalist.email,
          role: journalist.role
        }
      },
      headers: journalist_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns the body of the comment' do
      expect(response_json['body']).to eq "This is the body of the comment"
    end
  end

  describe 'Unsuccessfully create comment with valid article and no valid user' do
    before do
      post "/api/v1/admin/comments",
      params: {
        comment: {
          body: "This is the body of the comment",
          article_id: article.id
        }
      }
    end
    
    it 'returns a 401 response status' do
      expect(response).to have_http_status 401
    end
  end

  describe 'Unsuccessfully create comment with valid article and valid user and no body' do
    before do
      post "/api/v1/admin/comments",
      params: {
        comment: {
          user_id: journalist.id,
          article_id: article.id,
          email: journalist.email,
          role: journalist.role
        }
      },
      headers: journalist_headers
    end
    
    it 'returns a 401 response status' do
      expect(response).to have_http_status 422
    end

    it 'returns a 401 response status' do
      expect(response_json['error'][0]).to eq "Body can't be blank"
    end
  end
end