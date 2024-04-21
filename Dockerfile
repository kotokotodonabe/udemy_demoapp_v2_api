# alpineを元に生成されたRubyのベースイメージを使用
FROM ruby:3.3.0-alpine

# app
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# 環境変数を定義
# コンテナ上のRailsからENVコマンドで確認することができる
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# Dockerfileで定義した命令を実行するコンテナ内の作業ディレクトを指定
# 命令をコンテナ内のどのディレクトリで実行するのか
# RUN,COPY,ADD,ENTORYPOINT,CMD
WORKDIR ${HOME}

# ホスト側のファイルをコンテナにコピー
# COPY コピー元(ホスト) コピー先
# コピー元にはDockerfileがあるディレクトリ以下を指定する必要がある
COPY Gemfile* ./

# apk ... Alpine Linuxのコマンド
# apk update ... パッケージの最新リストを取得
RUN apk update && \
    # apk upgrade ... インストールされているパッケージを最新のものにアップグレード
    apk upgrade && \
    # apk add ... パッケージのインストールを実行する
    # --no-cache ... パッケージをキャッシュしない。Dockerイメージを軽量化することができる
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    # --virtual 名前任意(build-dependencies) ... 仮想パッケージ。パッケージをひとまとめにすることができる
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    # -j4 = Gemのインストール処理を並列化するためのオプション。Gemインストールの高速化
    bundle install -j4 && \
    # apk del ... パッケージを削除
    # bundle installを終了するとパッケージが不要になる
    apk del build-dependencies

# M1のRails(Docker)起動時にnokogiriがエラーを吐くため、gcompatをインストール
RUN apk add --no-cache gcompat

# Dockerファイルがあるディレクトリ全てのファイルをコンテナのカレントディレクトリにコピー
COPY . /.

# -b .. プロセスを指定したip(0.0.0.0)アドレスに紐付けする
# 通常rails serverで起動したプロセスはブラウザから参照することができない。そこでipアドレスを紐付けすることで参照できるようにする
CMD ["rails", "server", "-b", "0.0.0.0"]
