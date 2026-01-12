#!/bin/bash
# 脚本预览工具 - 安全地查看脚本会做什么，不执行
# 用法: ./scripts/preview.sh [script-name]

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_NAME="${1:-setup}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   脚本预览工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

SOURCE_DIR="/Users/philfan/CodeSource/dot-files"

# 查找脚本
SCRIPT_PATH=""
for ext in ".sh" ".sh.tmpl"; do
    if [ -f "$SOURCE_DIR/scripts/${SCRIPT_NAME}${ext}" ]; then
        SCRIPT_PATH="$SOURCE_DIR/scripts/${SCRIPT_NAME}${ext}"
        break
    fi
done

if [ -z "$SCRIPT_PATH" ]; then
    echo -e "${YELLOW}未找到脚本: $SCRIPT_NAME${NC}"
    echo ""
    echo "可用脚本:"
    ls -1 "$SOURCE_DIR/scripts/" | sed 's/.tmpl$//'
    exit 1
fi

echo -e "${GREEN}脚本: ${SCRIPT_PATH}${NC}"
echo ""

# 1. 基本信息
echo -e "${BLUE}1. 基本信息${NC}"
echo "文件大小: $(wc -l < "$SCRIPT_PATH") 行"
echo "权限: $(ls -l "$SCRIPT_PATH" | awk '{print $1}')"
echo ""

# 2. 语法检查
echo -e "${BLUE}2. 语法检查${NC}"
if bash -n "$SCRIPT_PATH" 2>&1; then
    echo -e "${GREEN}✓ 语法正确${NC}"
else
    echo -e "${YELLOW}⚠  语法检查未通过${NC}"
fi
echo ""

# 3. 查找关键操作
echo -e "${BLUE}3. 关键操作分析${NC}"

echo "安装命令:"
grep -n "install\|clone" "$SCRIPT_PATH" 2>/dev/null | head -10 || echo "  (无)"

echo ""
echo "删除/清理命令:"
grep -n "rm -\|cleanup\|remove" "$SCRIPT_PATH" 2>/dev/null | head -10 || echo "  (无)"

echo ""
echo "sudo/提权操作:"
grep -n "sudo" "$SCRIPT_PATH" 2>/dev/null | head -10 || echo "  (无)"

echo ""

# 4. 变量使用
echo -e "${BLUE}4. Chezmoi 变量${NC}"
echo "使用的模板变量:"
grep -oE '\{\{[^}]+\}\}' "$SCRIPT_PATH" 2>/dev/null | sort -u | head -10 || echo "  (无)"

echo ""

# 5. 显示脚本内容（前 50 行）
echo -e "${BLUE}5. 脚本内容预览 (前 50 行)${NC}"
echo "-----------------------------------"
head -50 "$SCRIPT_PATH"
echo "-----------------------------------"
echo ""

# 6. 询问是否查看完整内容
echo -e "${YELLOW}是否查看完整内容? [y/N]${NC}"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    less "$SCRIPT_PATH"
fi

echo ""
echo -e "${GREEN}预览完成！${NC}"
echo ""
echo -e "${BLUE}提示:${NC}"
echo "  - 运行: bash $SCRIPT_PATH"
echo "  - 调试: bash -x $SCRIPT_PATH"
echo "  - 干运行: 查看脚本中的 --dry-run 选项"
