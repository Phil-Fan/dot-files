#!/bin/bash

# 编辑器配置合并脚本
# 用法: ./merge-settings.sh [vscode|cursor]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_CONFIG="$SCRIPT_DIR/settings.base.json"

# 检测编辑器类型
EDITOR="${1:-}"

if [[ -z "$EDITOR" ]]; then
    echo -e "${RED}错误: 请指定编辑器类型${NC}"
    echo "用法: $0 [vscode|cursor]"
    exit 1
fi

# 确定配置路径
case "$EDITOR" in
    vscode)
        CONFIG_DIR="$HOME/Library/Application Support/Code/User"
        APPEND_CONFIG="$SCRIPT_DIR/vscode/settings.json"
        ;;
    cursor)
        CONFIG_DIR="$HOME/Library/Application Support/Cursor/User"
        APPEND_CONFIG="$SCRIPT_DIR/cursor/settings.json"
        ;;
    *)
        echo -e "${RED}错误: 不支持的编辑器 '$EDITOR'${NC}"
        echo "支持的编辑器: vscode, cursor"
        exit 1
        ;;
esac

# 检查基础配置是否存在
if [[ ! -f "$BASE_CONFIG" ]]; then
    echo -e "${RED}错误: 基础配置文件不存在: $BASE_CONFIG${NC}"
    exit 1
fi

# 检查特定配置是否存在
if [[ ! -f "$APPEND_CONFIG" ]]; then
    echo -e "${RED}错误: 编辑器配置文件不存在: $APPEND_CONFIG${NC}"
    exit 1
fi

# 合并 JSON 配置
echo -e "${BLUE}合并配置...${NC}"
echo -e "  基础配置: ${YELLOW}$BASE_CONFIG${NC}"
echo -e "  编辑器配置: ${YELLOW}$APPEND_CONFIG${NC}"
echo -e "  目标目录: ${YELLOW}$CONFIG_DIR${NC}"
echo ""

# 创建目标目录
mkdir -p "$CONFIG_DIR"

# 使用 jq 合并 JSON
if command -v jq &> /dev/null; then
    jq -s '.[0] * .[1]' "$BASE_CONFIG" "$APPEND_CONFIG" > "$CONFIG_DIR/settings.json"
    echo -e "${GREEN}✅ 配置已合并并保存到: $CONFIG_DIR/settings.json${NC}"
else
    echo -e "${YELLOW}⚠️  未安装 jq，使用简单的文件复制${NC}"
    echo -e "${YELLOW}建议安装 jq 以正确合并配置: brew install jq${NC}"
    echo ""
    read -p "$(echo -e ${YELLOW}是否继续（仅复制编辑器特定配置）? [y/N]: ${NC})" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$APPEND_CONFIG" "$CONFIG_DIR/settings.json"
        echo -e "${GREEN}✅ 配置已保存到: $CONFIG_DIR/settings.json${NC}"
        echo -e "${YELLOW}⚠️  请手动合并基础配置内容${NC}"
    else
        echo -e "${RED}已取消${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}下一步操作:${NC}"
echo -e "  ${GREEN}1.${NC} 重启 $EDITOR"
echo -e "  ${GREEN}2.${NC} 检查配置是否生效"
