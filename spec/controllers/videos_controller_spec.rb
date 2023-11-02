# spec/controllers/videos_controller_spec.rb

require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #search' do
    before do
      @user = create(:user)
      sign_in @user
    end

    context 'when query is present' do
      before do
        @query = 'Sample Video'
      end

      it 'assigns @videos' do
        create(:video, title: 'Sample Video 1')
        create(:video, title: 'Sample Video 2')
        get :search, params: { search_query: @query }
        expect(assigns(:videos)).to all(be_a(Video))
        expect(assigns(:videos).map(&:title)).to include('Sample Video 1', 'Sample Video 2')
      end

      it 'renders the index template' do
        get :search, params: { search_query: @query }
        expect(response).to render_template('index')
      end
    end

    context 'when query is not present' do
      it 'assigns @videos as empty array' do
        get :search
        expect(assigns(:videos)).to eq([])
      end

      it 'renders the index template' do
        get :search
        expect(response).to render_template('index')
      end
    end
  end
end
