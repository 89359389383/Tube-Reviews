require 'rails_helper'

RSpec.describe Video, type: :model do
  describe '.recommended' do
    context 'when an error occurs' do
      let(:video) { create(:video) } # 事前に用意した動画データ

      it 'raises RecommendationError' do
        allow(Video).to receive(:recommended).and_raise(RecommendationError)
        expect { Video.recommended(video) }.to raise_error(RecommendationError)
      end
    end
  end
end
