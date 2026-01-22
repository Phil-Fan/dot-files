#!/bin/bash

# 编辑器同步脚本 - 同步扩展和配置
# 用法: ./sync-editor.sh <editor> <action>
#
# 编辑器: vscode, cursor
# 操作:
#   extensions-export  - 导出扩展列表
#   extensions-install - 批量安装扩展
#   settings-merge     - 合并配置文件
#   all                - 执行所有同步操作

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
EDITORS_DIR="$PROJECT_ROOT/softwares/editors"
BASE_CONFIG="$EDITORS_DIR/settings.base.json"

# 显示帮助信息
show_help() {
    cat << EOF
用法: $0 <editor> <action>

编辑器:
  vscode    Visual Studio Code
  cursor    Cursor 编辑器

操作:
  extensions-export   导出扩展列表
  extensions-install  批量安装扩展
  settings-merge      合并配置文件
  all                 执行所有同步操作

示例:
  $0 cursor all                # 同步 Cursor 的扩展和配置
  $0 vscode extensions-install # 安装 VSCode 扩展
  $0 cursor settings-merge     # 合并 Cursor 配置

EOF
}

# 检查命令行工具
check_cli() {
    local editor="$1"
    local cmd="$2"

    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}错误: $editor 命令行工具未安装${NC}"
        echo ""
        if [[ "$editor" == "VSCode" ]]; then
            echo -e "${YELLOW}安装方法:${NC}"
            echo "1. 打开 VSCode"
            echo "2. 按 ${YELLOW}Cmd+Shift+P${NC} 打开命令面板"
            echo "3. 输入: ${YELLOW}Shell Command: Install 'code' command in PATH${NC}"
            echo "4. 点击安装"
        else
            echo -e "${YELLOW}Cursor 命令行工具应该已内置，请检查 PATH${NC}"
        fi
        exit 1
    fi
}

# 导出扩展列表
export_extensions() {
    local editor="$1"
    local cmd="$2"
    local output_file="$3"

    echo -e "${BLUE}导出 $editor 扩展列表...${NC}"
    $cmd --list-extensions > "$output_file"
    local count=$(wc -l < "$output_file" | tr -d ' ')
    echo -e "${GREEN}✅ 已导出 $count 个扩展到: $output_file${NC}"
}

# 安装扩展
install_extensions() {
    local editor="$1"
    local cmd="$2"
    local input_file="$3"

    if [[ ! -f "$input_file" ]]; then
        echo -e "${RED}错误: 扩展列表文件不存在: $input_file${NC}"
        exit 1
    fi

    echo -e "${BLUE}从 $input_file 批量安装 $editor 扩展...${NC}"
    echo ""

    local count=0
    local failed=0

    while IFS= read -r extension; do
        if [[ -n "$extension" ]]; then
            count=$((count + 1))
            echo -e "${YELLOW}[$count] 安装: $extension${NC}"
            if $cmd --install-extension "$extension" &> /dev/null; then
                echo -e "  ${GREEN}✅ 成功${NC}"
            else
                echo -e "  ${RED}❌ 失败${NC}"
                failed=$((failed + 1))
            fi
        fi
    done < "$input_file"

    echo ""
    echo -e "${GREEN}=================================${NC}"
    echo -e "${GREEN}安装完成！${NC}"
    echo -e "  总计: $count 个"
    echo -e "  ${GREEN}成功: $((count - failed)) 个${NC}"
    if [[ $failed -gt 0 ]]; then
        echo -e "  ${RED}失败: $failed 个${NC}"
    fi
    echo -e "${GREEN}=================================${NC}"
}

# 合并配置文件
merge_settings() {
    local editor="$1"
    local editor_name="$2"
    local append_config="$3"
    local config_dir="$4"

    # 检查基础配置是否存在
    if [[ ! -f "$BASE_CONFIG" ]]; then
        echo -e "${RED}错误: 基础配置文件不存在: $BASE_CONFIG${NC}"
        exit 1
    fi

    # 检查特定配置是否存在
    if [[ ! -f "$append_config" ]]; then
        echo -e "${RED}错误: 编辑器配置文件不存在: $append_config${NC}"
        exit 1
    fi

    echo -e "${BLUE}合并配置...${NC}"
    echo -e "  基础配置: ${YELLOW}$BASE_CONFIG${NC}"
    echo -e "  编辑器配置: ${YELLOW}$append_config${NC}"
    echo -e "  目标目录: ${YELLOW}$config_dir${NC}"
    echo ""

    # 创建目标目录
    mkdir -p "$config_dir"

    # 使用 jq 合并 JSON
    if command -v jq &> /dev/null; then
        jq -s '.[0] * .[1]' "$BASE_CONFIG" "$append_config" > "$config_dir/settings.json"
        echo -e "${GREEN}✅ 配置已合并并保存到: $config_dir/settings.json${NC}"
    else
        echo -e "${YELLOW}⚠️  未安装 jq，使用简单的文件复制${NC}"
        echo -e "${YELLOW}建议安装 jq 以正确合并配置: brew install jq${NC}"
        echo ""
        read -p "$(echo -e ${YELLOW}是否继续（仅复制编辑器特定配置）? [y/N]: ${NC})" -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$append_config" "$config_dir/settings.json"
            echo -e "${GREEN}✅ 配置已保存到: $config_dir/settings.json${NC}"
            echo -e "${YELLOW}⚠️  请手动合并基础配置内容${NC}"
        else
            echo -e "${RED}已取消${NC}"
            exit 1
        fi
    fi

    echo ""
    echo -e "${BLUE}下一步操作:${NC}"
    echo -e "  ${GREEN}1.${NC} 重启 $editor_name"
    echo -e "  ${GREEN}2.${NC} 检查配置是否生效"
}

# 主逻辑
EDITOR="${1:-}"
ACTION="${2:-}"

if [[ -z "$EDITOR" || -z "$ACTION" ]]; then
    show_help
    exit 1
fi

# 根据编辑器设置参数
case "$EDITOR" in
    vscode)
        CMD="code"
        EDITOR_NAME="Visual Studio Code"
        EXTENSIONS_FILE="$EDITORS_DIR/vscode/extensions.txt"
        APPEND_CONFIG="$EDITORS_DIR/vscode/settings.json"
        CONFIG_DIR="$HOME/Library/Application Support/Code/User"
        ;;
    cursor)
        CMD="cursor"
        EDITOR_NAME="Cursor"
        EXTENSIONS_FILE="$EDITORS_DIR/cursor/extensions.txt"
        APPEND_CONFIG="$EDITORS_DIR/cursor/settings.json"
        CONFIG_DIR="$HOME/Library/Application Support/Cursor/User"
        ;;
    *)
        echo -e "${RED}错误: 不支持的编辑器 '$EDITOR'${NC}"
        echo "支持的编辑器: vscode, cursor"
        exit 1
        ;;
esac

# 执行操作
case "$ACTION" in
    extensions-export)
        check_cli "$EDITOR_NAME" "$CMD"
        export_extensions "$EDITOR_NAME" "$CMD" "$EXTENSIONS_FILE"
        ;;
    extensions-install)
        check_cli "$EDITOR_NAME" "$CMD"
        install_extensions "$EDITOR_NAME" "$CMD" "$EXTENSIONS_FILE"
        ;;
    settings-merge)
        merge_settings "$EDITOR" "$EDITOR_NAME" "$APPEND_CONFIG" "$CONFIG_DIR"
        ;;
    all)
        echo -e "${BLUE}=================================${NC}"
        echo -e "${BLUE}开始同步 $EDITOR_NAME${NC}"
        echo -e "${BLUE}=================================${NC}"
        echo ""

        # 导出扩展
        check_cli "$EDITOR_NAME" "$CMD"
        export_extensions "$EDITOR_NAME" "$CMD" "$EXTENSIONS_FILE"
        echo ""

        # 安装扩展
        install_extensions "$EDITOR_NAME" "$CMD" "$EXTENSIONS_FILE"
        echo ""

        # 合并配置
        merge_settings "$EDITOR" "$EDITOR_NAME" "$APPEND_CONFIG" "$CONFIG_DIR"
        echo ""

        echo -e "${GREEN}=================================${NC}"
        echo -e "${GREEN}✅ 同步完成！${NC}"
        echo -e "${GREEN}=================================${NC}"
        ;;
    *)
        echo -e "${RED}错误: 不支持的操作 '$ACTION'${NC}"
        show_help
        exit 1
        ;;
esac
