RSpec.describe 'PUT /api/admin/comments', type: :request do
  let(:journalist)  { create(:journalist)}
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
  let!(:comment) { create(:comment, user_id: journalist.id)}

  describe 'Successfully edits own comment' do
    before do
      put "/api/v1/admin/comments/#{comment.id}",
      params: {
          body: "some new comment content"
      },
      headers: journalist_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it "returns 'some new comment content' in comment body" do
      expect(response_json['body']).to eq "some new comment content"
    end
  end

  describe 'Unsuccessfully edits others comment' do
    let(:publisher)  { create(:publisher)}
    let(:publisher_credentials) { publisher.create_new_auth_token }
    let!(:publisher_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(publisher_credentials) }
    before do
      put "/api/v1/admin/comments/#{comment.id}",
      params: {
          body: "some new comment content"
      },
      headers: publisher_headers
    end
    
    it 'returns a 404 response status' do
      expect(response).to have_http_status 404
    end

    it "returns 'Not authorized!' error" do
      expect(response_json['error']).to eq "Not authorized!"
    end
  end
end