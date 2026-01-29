#!/bin/bash
# KUSANAGI Docker シェル起動スクリプト
# コンテナ内でkusanagi-dockerコマンドを使えるインタラクティブシェルを起動

# イメージ名
IMAGE_NAME="kusanagi-cli"

# イメージが存在しない場合はビルド
if ! docker image inspect $IMAGE_NAME >/dev/null 2>&1; then
    echo "Building kusanagi-cli image..."
    docker build -f Dockerfile.kusanagi-cli -t $IMAGE_NAME .
fi

echo "Starting KUSANAGI Docker shell..."
echo "You can now use 'kusanagi-docker' commands inside this container."
echo "Type 'exit' to leave the shell."
echo ""

# ホストの絶対パスを取得
HOST_PWD="$(pwd)"

# インタラクティブシェルとして起動
docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$HOST_PWD:/workspace" \
    -w /workspace \
    -e "HOST_WORKSPACE_DIR=$HOST_PWD" \
    --network host \
    --entrypoint /bin/bash \
    --name $IMAGE_NAME \
    $IMAGE_NAME
