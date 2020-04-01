RSpec.describe 'DELETE /api/admin/articles', type: :request do
  let(:publisher)  { create(:publisher)}
  let(:publisher_credentials) { publisher.create_new_auth_token }
  let!(:publisher_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(publisher_credentials) }
  let!(:article) { create(:article) }

  describe 'Successfully deletes article' do
    before do
      delete "/api/v1/admin/articles/#{article.id}",
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns success message' do
      expect(response_json['message']).to eq "Article has been deleted"
    end

    it 'returns no article' do
      get "/api/v1/articles/#{article.id}",
      headers: { HTTP_ACCEPT: 'application/json' }

      expect(response_json['error']).to eq 'Article not found'
    end
  end

  describe 'unsuccessfully when' do
    describe 'logged in as a journalist' do
      let(:journalist) { create(:user, role: 'journalist')}
      let(:journalist_credentials) { journalist.create_new_auth_token }
      let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
      
      before do
        delete "/api/v1/admin/articles/#{article.id}",
        headers: journalist_credentials
      end

      it 'returns a 404 response status' do
        expect(response).to have_http_status 404
      end

      it 'returns error message' do
        expect(response_json["error"]).to eq "Not authorized!"
      end
    end

    describe 'not logged in' do
      let!(:non_authorized_headers) { { HTTP_ACCEPT: 'application/json' } }
      before do
        get "/api/v1/admin/articles",
        headers: non_authorized_headers
      end
      
      it 'returns a 401 response status' do
        expect(response).to have_http_status 401
      end

      it 'returns error message' do
        expect(response_json["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end
  end
end