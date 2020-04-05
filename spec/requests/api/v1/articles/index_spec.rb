RSpec.describe 'GET /api/v1/articles', type: :request do
  let(:journalist) { create(:journalist) }
  let!(:journalist_headers) { { HTTP_ACCEPT: 'application/json' } }
  let!(:article) do
    10.times do
      create(:article, journalist_id: journalist.id, category: 2, published: true)
    end
    2.times do
      create(:article, journalist_id: journalist.id, location: 'Stockholm', published: true)
    end
    2.times do
      create(:article,
            journalist_id: journalist.id,
            location: 'Stockholm',
            category: 2,
            published: true)
    end
    2.times do
      create(:article,
            journalist_id: journalist.id,
            location: 'Gothenburg',
            category: 3,
            published: false)
    end
    1.times do
      create(:article,
            journalist_id: journalist.id,
            location: 'Malmo',
            category: 4,
            published: true,
            free: true)
    end
  end

  describe 'Get all articles when no category is provided' do
    before do
      get '/api/v1/articles',
          params: {
            category: "all",
          }
    end

    it 'return all articles' do
      expect(response.status).to eq 200
    end

    it 'return all articles index' do
      expect(response_json.count).to eq 17
    end
  end

  describe 'Get full free article' do
    before do
      get '/api/v1/articles',
          params: {
            published: true,
            free: true
          }
    end

    it 'return 1 article with full body' do
      expect(response.status).to eq 200
    end

    it 'return correct article' do
      expect(response_json['location']).to eq 'Malmo'
    end
  end

  describe 'Get first page' do
    before do
      get '/api/v1/articles'
    end

    it 'return a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns 5 articles' do
      expect(response_json['articles'].count).to eq 5
    end

    it 'returns only first 75 characters of each article' do
      expect(response_json['articles'][0]['body'].length).to eq 75
    end

    it 'returns metadata for current page' do
      expect(response_json['meta']['current_page']).to eq 1
    end
  end

  describe 'Get second page' do
    before do
      get '/api/v1/articles', params: { page: 2 }
    end

    it 'return a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns page 2' do
      expect(response_json['meta']['current_page']).to eq 2
    end

    it 'returns page 1 for previous page' do
      expect(response_json['meta']['prev_page']).to eq 1
    end

    it 'returns page 3 for previous page' do
      expect(response_json['meta']['next_page']).to eq 3
    end

    it 'returns total number of published entries' do
      expect(response_json['meta']['total_count']).to eq 14
    end
  end

  describe 'Gets categorized index page' do
    before do
      get '/api/v1/articles', params: { category: 2 }
    end

    it 'return articles of the third category' do
      expect(response_json['articles'][3]['category']).to eq 'tech'
    end

    it 'return all articles with category "Tech"' do
      expect(response_json['meta']['total_count']).to eq 12
    end
  end

  describe 'Gets index page by location' do
    before do
      get '/api/v1/articles', params: { location: 'Stockholm' }
    end

    it 'return all articles with location "Stockholm"' do
      expect(response_json['meta']['total_count']).to eq 4
    end
  end

  describe 'Gets index page by location and category' do
    before do
      get '/api/v1/articles',
          params: {
            location: 'Stockholm',
            category: 2,
            published: true
          }
    end

    it 'return 2 articles with location "Stockholm" and category "tech"' do
      expect(response_json['meta']['total_count']).to eq 2
    end
  end

  describe 'Get index of articles unsuccessfully by category and location' do
    before do
      get '/api/v1/articles',
          params: {
            location: 'Gothenburg',
            published: true
          }
    end

    it 'return 0 articles if no location matches"' do
      expect(response_json['meta']['total_count']).to eq 0
    end

    before do
      get '/api/v1/articles',
          params: {
            category: 3,
            published: true
          }
    end

    it 'return 0 articles if no category matches' do
      expect(response_json['meta']['total_count']).to eq 0
    end

    before do
      get '/api/v1/articles',
          params: {
            location: 'Stockholm',
            category: 3
          }
    end

    it 'return 0 articles if location matches but category is empty' do
      expect(response_json['meta']['total_count']).to eq 0
    end

    before do
      get '/api/v1/articles',
          params: {
            location: 'Gothenburg',
            category: 3
          }
    end

    it 'return 0 articles if no location or category matches' do
      expect(response_json['meta']['total_count']).to eq 0
    end
  end
end
