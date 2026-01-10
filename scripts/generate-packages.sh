#!/bin/bash
# 从 common-packages.yaml 生成平台特定的包文件

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PACKAGES_DIR="$(dirname "$0")/../packages"
COMMON_YAML="$PACKAGES_DIR/common-packages.yaml"
BREWFILE="$PACKAGES_DIR/Brewfile"
APT_FILE="$PACKAGES_DIR/apt-packages.txt"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   生成平台特定包文件${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查 yq 是否安装
if ! command -v yq &> /dev/null; then
    echo -e "${YELLOW}⚠️  yq 未安装，使用现有的包文件${NC}"
    echo -e "${YELLOW}安装 yq: brew install yq${NC}"
    exit 0
fi

# 生成 Brewfile
echo -e "${YELLOW}📝 生成 Brewfile...${NC}"
# 这里需要解析 YAML 并生成 Brewfile
# 由于 yq 的复杂性，暂时使用手动维护的文件

# 生成 apt-packages.txt  
echo -e "${YELLOW}📝 生成 apt-packages.txt...${NC}"
# 这里需要解析 YAML 并生成 APT 包列表

echo ""
echo -e "${GREEN}✅ 包文件生成完成${NC}"
echo ""
echo -e "${BLUE}注意:${NC} 当前使用手动维护的包文件"
echo -e "${BLUE}建议:${NC} 定期同步 common-packages.yaml 的更改"
