FROM ruby:3.0.0

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Bundlerのバージョンを固定
RUN gem install bundler:2.4.17

# アプリケーションディレクトリを作成
RUN mkdir /myapp
WORKDIR /myapp

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# 必要なGemをインストール
RUN bundle _2.4.17_ install

# アプリケーションコードをコピー
COPY . /myapp

# ポートを指定
EXPOSE 10000

# entrypoint.shをコピーして実行権限を付与
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# アプリケーションの起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production", "-p", "10000"]
