# AWS の初期設定

## 1. IAM で terraform ユーザーを作成

## 2. アカウント設定

```
$ aws configure --profile terraform
AWS Access Key ID [None]:     アクセスキーID
AWS Secret Access Key [None]: シークレットアクセスキー
Default region name [None]:   リージョン名（例：ap-northeast-1）
Default output format [None]: text
```

## 3. アカウント設定

```
$ export AWS_PROFILE=terraform
```

# Terraform 作業ディレクトリの初期化

`development` 環境用のフォルダに移動して `terraform init` を実行

```
$ ./bin/init
```

# インフラストラクチャのビルドや変更

`development` 環境用のフォルダに移動して `terraform apply` を実行

```
$ ./bin/apply
```

# Terraform について

## コマンド

```
0.12upgrade  -- 0.12 以前のモジュールのソースコードを v0.12 用に書き換えます。
apply        -- インフラストラクチャのビルドや変更
console      -- Terraform 補間のためのインタラクティブなコンソール
destroy      -- Terraformが管理するインフラを破壊する
fmt          -- 設定ファイルを正規のフォーマットに書き換える
                =>エディタで自動フォーマットするライブラリ追加したら幸せになれる
get          -- 設定用のモジュールをダウンロードしてインストールする
graph        -- Terraformリソースの視覚的なグラフを作成します。
import       -- 既存のインフラストラクチャをTerraformにインポート
init         -- Terraform作業ディレクトリの初期化
output       -- 状態ファイルから出力を読み込む
plan         -- 実行計画を生成して表示する
providers    -- 設定で使用したプロバイダのツリーを表示します。
push         -- このTerraformモジュールをアトラスにアップロードして実行します。
refresh      -- ローカルの状態ファイルを実際のリソースに対して更新する
show         -- テラフォームの状態や計画を検査する
state        -- 高度な状態管理
taint        -- レクリエーション用のリソースを手動でマークする
untaint      -- 汚染されたリソースのマークを手動で解除する
validate     -- Terraform ファイルを検証する
version      -- Terraform のバージョンを表示します。
workspace    -- ワークスペース管理
```
