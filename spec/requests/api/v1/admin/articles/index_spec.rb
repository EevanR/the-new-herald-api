RSpec.describe 'GET/api/admin/articles', type: :request do
  let(:publisher)  { create(:publisher)}
  let(:publisher_credentials) { publisher.create_new_auth_token }
  let!(:publisher_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(publisher_credentials) }
  let!(:unpublished_article) do
    3.times do
      create(:article)
    end
  end
  let!(:published_article) { create(:article, published: true) }
  let!(:published_article) { create(:article, published: true, free: true) }

  describe 'Successfully lists unpublished articles' do
    before do
      get '/api/v1/admin/articles',
      params: { published: false },
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 3 articles' do
      expect(response_json['articles'].count).to eq 3
    end

    it 'returns the article writer' do
      expect(response_json['articles'].first['journalist']).to include "user"
    end
  end

  describe 'Successfully lists published articles' do
    before do
      get '/api/v1/admin/articles',
      params: { published: true },
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 1 article' do
      expect(response_json['articles'].count).to eq 1
    end
  end

  describe 'Successfully lists free published article' do
    before do
      get '/api/v1/admin/articles',
      params: { 
        published: true,
        free: true
      },
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 1 article' do
      expect(response_json['articles'].count).to eq 1
    end
  end

  describe 'no articles without params' do
    before do
      get '/api/v1/admin/articles',
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 0 articles' do
      expect(response_json['articles'].count).to eq 0
    end
  end

  describe 'unsuccessfully when' do
    describe 'logged in as a journalist' do
      let(:journalist) { create(:user, role: 'journalist')}
      let(:journalist_credentials) { journalist.create_new_auth_token }
      let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
      
      before do
        get '/api/v1/admin/articles',
        headers: journalist_headers
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