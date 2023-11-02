# spec/controllers/videos_controller_spec.rb

require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  describe 'GET #show' do
    let(:video) { create(:video) }
    let(:user) { create(:user) }

    context 'ユーザーがログインしている場合' do
      before do
        sign_in user
      end

      it '動画が表示されること' do
        get :show, params: { id: video.id }
        expect(response).to have_http_status(:ok)
        expect(assigns(:video)).to eq(video)
      end

      it '動画が見つからない場合にエラーメッセージが表示されること' do
        get :show, params: { id: 'invalid' }
        expect(response).to redirect_to(videos_path)
        expect(flash[:alert]).to eq('動画が見つかりませんでした。')
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get :show, params: { id: video.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
