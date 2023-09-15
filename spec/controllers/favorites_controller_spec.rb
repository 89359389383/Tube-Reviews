# spec/controllers/favorites_controller_spec.rb
require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  let(:user) { create(:user) } # Factoryを使用してUserを作成する
  let(:video) { create(:video) } # Factoryを使用してVideoを作成する

  describe 'POST #create' do
    context 'when not logged in' do
      it 'does not add the video to favorites' do
        expect do
          post :create, params: { video_id: video.id }
        end.not_to change(Favorite, :count)
      end

      it 'redirects to login page' do
        post :create, params: { video_id: video.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      before { sign_in user } # Deviseを使用している場合のログインの方法

      it 'adds the video to favorites' do
        expect do
          post :create, params: { video_id: video.id }
        end.to change(Favorite, :count).by(1)
      end

      it 'does not add the video to favorites if it is already added' do
        user.favorite_videos << video
        expect do
          post :create, params: { video_id: video.id }
        end.not_to change(Favorite, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:favorite) { create(:favorite, user: user, video: video) }

    context 'when not logged in' do
      it 'does not remove the video from favorites' do
        expect do
          delete :destroy, params: { id: favorite.id }
        end.not_to change(Favorite, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: favorite.id }
        expect(response).to redirect_to(login_path)
      end
    end

    context 'when logged in' do
      before { sign_in user }

      it 'removes the video from favorites' do
        expect do
          delete :destroy, params: { id: favorite.id }
        end.to change(Favorite, :count).by(-1)
      end

      it 'does not remove video from another user\'s favorites' do
        other_user_favorite = create(:favorite) # 別のユーザーのお気に入りを作成
        expect do
          delete :destroy, params: { id: other_user_favorite.id }
        end.not_to change(Favorite, :count)
      end
    end
  end

  describe 'GET #index' do
    let!(:other_user_favorite) { create(:favorite) }

    before do
      user.favorite_videos << video
      sign_in user
      get :index
    end

    it 'only displays the logged-in user\'s favorite videos' do
      expect(assigns(:favorites)).to include(favorite)
      expect(assigns(:favorites)).not_to include(other_user_favorite)
    end
  end
end
