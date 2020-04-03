RSpec.describe 'DELETE /api/v1/admin/comments', type: :request do
  let(:journalist)  { create(:journalist)}
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }
  let!(:comment) { create(:comment, user_id: journalist.id) }
  let!(:comment2) { create(:comment) }

  describe 'Successfully delete comment when logged in' do
    before do
      delete "/api/v1/admin/comments/#{comment.id}",
      headers: journalist_headers
    end
    
    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'comment deleted from database' do
      expect(Comment.count).to eq 1
    end
  end

  describe 'Unsuccessfully delete other users comment' do
    before do
      delete "/api/v1/admin/comments/#{comment2.id}",
      headers: journalist_headers
    end
    
    it 'returns a 404 response status' do
      expect(response).to have_http_status 404
    end

    it 'comment deleted from database' do
      expect(Comment.count).to eq 2
    end
  end
end