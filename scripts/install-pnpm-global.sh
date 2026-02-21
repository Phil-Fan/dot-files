#!/bin/bash
# chezmoi:executable
# 全局 pnpm 包安装脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   全局 pnpm 包安装${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查并安装 pnpm
if ! command -v pnpm &>/dev/null; then
  echo -e "${YELLOW}pnpm 未安装，正在安装...${NC}"
  npm install -g pnpm
  echo -e "${GREEN}✅ pnpm 安装完成: $(pnpm -v)${NC}"
else
  echo -e "${GREEN}✅ pnpm 已安装: $(pnpm -v)${NC}"
fi

# 确保 PNPM_HOME 环境变量设置正确
if [[ -z "$PNPM_HOME" ]]; then
  echo -e "${YELLOW}设置 PNPM_HOME 环境变量...${NC}"
  case "$(uname)" in
    Darwin)
      export PNPM_HOME="$HOME/Library/pnpm"
      ;;
    *)
      export PNPM_HOME="$HOME/.local/share/pnpm"
      ;;
  esac
  export PATH="$PNPM_HOME/bin:$PATH"
fi
echo ""

# 确保 pnpm 全局 bin 目录配置一致
pnpm config set global-bin-dir "$PNPM_HOME/bin"

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PNPMFILE="$SCRIPT_DIR/../softwares/packages/Pnpmfile"

if [ ! -f "$PNPMFILE" ]; then
  echo -e "${RED}❌ 错误: Pnpmfile 不存在于 $PNPMFILE${NC}"
  exit 1
fi

echo -e "${YELLOW}📦 从 Pnpmfile 安装全局包...${NC}"
echo -e "${BLUE}配置文件:${NC} $PNPMFILE"
echo ""

# 读取 Pnpmfile 并安装包
while IFS= read -r line || [ -n "$line" ]; do
  # 跳过注释和空行
  if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line// /}" ]]; then
    continue
  fi

  # 提取包名（去除注释）
  package=$(echo "$line" | sed 's/[[:space:]]*#.*//' | tr -d ' ')

  if [ -n "$package" ]; then
    echo -e "${YELLOW}安装 $package...${NC}"
    pnpm add -g "$package"
  fi
done <"$PNPMFILE"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   🎉 安装完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}已安装的全局包:${NC}"
pnpm list -g --depth=0
echo ""
