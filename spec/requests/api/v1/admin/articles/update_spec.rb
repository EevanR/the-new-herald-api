RSpec.describe 'POST /api/admin/articles', type: :request do
  let(:publisher)  { create(:publisher)}
  let(:publisher_credentials) { publisher.create_new_auth_token }
  let!(:publisher_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(publisher_credentials) }
  let!(:article) { create(:article)}
  let!(:published_article) {create(:article, published: true, publisher: publisher)}

  describe 'Successfully publishes article' do
    before do
      patch "/api/v1/admin/articles/#{article.id}",
      params: {
          "article[published]": true
      },
      headers: publisher_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end
  end

  describe 'successfully set free article' do 
    before do
      patch "/api/v1/admin/articles/#{published_article.id}",
      params: {
          "article[free]": true
      },
      headers: publisher_headers
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end
  end

  describe 'unsuccessfully with' do
    describe 'non logged in user' do
      let!(:non_authorized_headers) { { HTTP_ACCEPT: 'application/json' } }
      before do
        patch "/api/v1/admin/articles/#{article.id}",
        params: {
            "article[published]": true
        },
        headers: non_authorized_headers
      end
      
      it 'returns a 401 response status' do
        expect(response).to have_http_status 401
      end

      it 'returns error message' do
        expect(response_json["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    describe 'user that is not a publisher' do
      let(:journalist) { create(:user, role: 'journalist')}
      let(:journalist_credentials) { journalist.create_new_auth_token }
      let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
    
      before do
        patch "/api/v1/admin/articles/#{article.id}",
        params: {
            "article[published]": true
        },
        headers: journalist_headers
      end
  
      it 'returns a 404 response status' do
        expect(response).to have_http_status 404
      end

      it 'returns error message' do
        expect(response_json["error"]).to eq "Not authorized!"
      end

      describe 'unsuccessfully set free article' do 
        before do
          patch "/api/v1/admin/articles/#{published_article.id}",
          params: {
              "article[free]": true
          },
          headers: journalist_headers
        end
    
        it 'returns a 404 status' do
          expect(response.status).to eq 404
        end
      end
    end
  end

  describe 'can unpublish previously published article' do
    before do
      patch "/api/v1/admin/articles/#{published_article.id}",
      params: {
          "article[published]": false
      },
      headers: publisher_headers
    end

    it 'returns 200' do
      expect(response).to have_http_status 200
    end
    
    it 'has no publisher' do
      expect(published_article.reload.publisher).to eq nil
    end
  end

  describe 'Authenticated user can update articles likes' do
    let(:journalist) { create(:user, role: 'journalist')}
    let(:journalist_credentials) { journalist.create_new_auth_token }
    let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
    describe 'Successfully increase count' do
      before do
        patch "/api/v1/admin/articles/#{published_article.id}",
        params: {
            likes: journalist.email
        },
        headers: journalist_credentials
      end
      
      it 'returns 200' do
        expect(response).to have_http_status 200
      end
      it 'article likes contains 2 user emails' do
        expect(response_json['likes'].count).to eq 2
      end
    end

    describe 'Successfully decrease count' do
      before do
        patch "/api/v1/admin/articles/#{published_article.id}",
        params: {
            likes: "user@mail.com" 
        },
        headers: journalist_credentials
      end
      it 'returns 200' do
        expect(response).to have_http_status 200
      end
      it 'article likes has decreased count by 1' do
        expect(response_json['likes']).to eq []
      end
    end
  end
end