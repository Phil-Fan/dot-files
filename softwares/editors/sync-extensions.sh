#!/bin/bash

# 编辑器扩展同步脚本
# 用法: ./sync-extensions.sh [vscode|cursor] [export|install]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 显示帮助信息
show_help() {
    echo "用法: $0 [vscode|cursor] [export|install]"
    echo ""
    echo "示例:"
    echo "  $0 cursor export      # 导出 Cursor 扩展列表"
    echo "  $0 cursor install     # 批量安装 Cursor 扩展"
    echo "  $0 vscode export      # 导出 VSCode 扩展列表"
    echo "  $0 vscode install     # 批量安装 VSCode 扩展"
    echo ""
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

# 主逻辑
EDITOR="${1:-}"
ACTION="${2:-}"

if [[ -z "$EDITOR" || -z "$ACTION" ]]; then
    show_help
    exit 1
fi

case "$EDITOR" in
    vscode)
        CMD="code"
        OUTPUT_FILE="$SCRIPT_DIR/vscode/extensions.txt"
        INPUT_FILE="$OUTPUT_FILE"
        ;;
    cursor)
        CMD="cursor"
        OUTPUT_FILE="$SCRIPT_DIR/cursor/extensions.txt"
        INPUT_FILE="$OUTPUT_FILE"
        ;;
    *)
        echo -e "${RED}错误: 不支持的编辑器 '$EDITOR'${NC}"
        echo "支持的编辑器: vscode, cursor"
        exit 1
        ;;
esac

case "$ACTION" in
    export)
        check_cli "$EDITOR" "$CMD"
        export_extensions "$EDITOR" "$CMD" "$OUTPUT_FILE"
        ;;
    install)
        check_cli "$EDITOR" "$CMD"
        install_extensions "$EDITOR" "$CMD" "$INPUT_FILE"
        ;;
    *)
        echo -e "${RED}错误: 不支持的操作 '$ACTION'${NC}"
        show_help
        exit 1
        ;;
esac
