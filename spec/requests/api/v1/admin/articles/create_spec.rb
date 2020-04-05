RSpec.describe 'POST /api/v1/admin/articles', type: :request do
  let(:journalist)  { create(:journalist)}
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }

  let(:image) do
    {
      type: 'application/image',
      encoder: 'name=article_picture.jpg;base64',
      data: 'iVBORw0KGgoAAAANSUhEUgAABjAAAAOmCAYAAABFYNwHAAAgAElEQVR4XuzdB3gU1cLG8Te9EEgISQi9I71KFbBXbFixN6zfvSiIjSuKInoVFOyIDcWuiKiIol4Q6SBVOtI7IYSWBkm',
      extension: 'jpg'
    }
  end

  describe 'Successfully with valid params and user' do
    before do
      post "/api/v1/admin/articles",
      params: {
        article: {
          title_en: "Article 1",
          body_en: "Some content",
          category: "tech",
          image: image
        }
      },
      headers: journalist_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'shows that an image has been attached successfully' do
      article = Article.find_by(title: "Article 1")
      expect(article.image.attached?).to eq true
    end
  end

  describe 'unsuccessfully with' do
    describe 'no title and content' do
      before do
        post "/api/v1/admin/articles",
        params: {
          article: {
            title: nil,
            body: ""
          }
        },
        headers: journalist_headers
      end
  
      it 'returns a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'returns error message' do
        expect(response_json["error"]).to eq ["Title can't be blank", "Body can't be blank"]
      end
    end

    describe 'has title and content but no image' do
      before do
        post "/api/v1/admin/articles",
        params: {
          article: {
            title_en: "Article 2",
            body_en: "Some Content"
          }
        },
        headers: journalist_headers
      end
  
      it 'returns a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'returns no article' do
        expect(Article.find_by(title: "Article 2")).to eq nil
      end

      it 'returns error message' do
        expect(response_json["error"]).to eq "Please attach an image"
      end
    end

    describe 'non logged in user' do
      let!(:non_authorized_headers) { { HTTP_ACCEPT: 'application/json' } }
      
      describe 'in english' do
        before do
          post "/api/v1/admin/articles",
          params: {
            article: {
              title: 'Title',
              body: "Some content"
            }
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

      describe 'in swedish' do
        before do
          post "/api/v1/admin/articles",
          params: {
            article: {
              title: 'Title',
              body: "Some content"
            },
            locale: :sv
          },
          headers: non_authorized_headers
        end
  
        it 'returns error message in swedish' do
          expect(response_json["errors"][0]).to eq "Du måste bli medlem eller logga in för att fortsätta."
        end
      end
    end

    describe 'user that is not a journalist' do
      let(:regular_user) { create(:user, role: 'user')}
      let(:regular_user_credentials) { regular_user.create_new_auth_token }
      let!(:regular_user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(regular_user_credentials) }
      
      describe 'in english' do
        before do
          post "/api/v1/admin/articles",
          params: {
            article: {
              title: "Title",
              body: "Some content"
            }
          },
          headers: regular_user_headers
        end
    
        it 'returns a 404 response status' do
          expect(response).to have_http_status 404
        end
  
        it 'returns error message' do
          expect(response_json["error"]).to eq "Not authorized!"
        end
      end

      describe 'in swedish' do
        before do
          post "/api/v1/admin/articles",
          params: {
            article: {
              title: "Title",
              body: "Some content"
            },
            locale: :sv
          },
          headers: regular_user_headers
        end

        it 'returns error message in swedish' do
          expect(response_json["error"]).to eq "Åtkomst nekad"
        end
      end
    end
  end
end