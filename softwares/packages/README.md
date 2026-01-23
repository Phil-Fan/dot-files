# 包管理系统

使用 Homebrew 统一管理 macOS 和 Linux 软件包，使用 pnpm 管理全局 Node.js 包。

## 文件结构

```
softwares/packages/
├── Brewfile          # macOS Homebrew 包清单
├── Brewfile-linux    # Linux Homebrew 包清单
├── Brewfile.dev      # 开发环境额外包清单
├── Pnpmfile          # 全局 pnpm 包清单
└── README.md         # 本文档
```

## 快速开始

### 使用一键安装脚本（推荐）

```bash
# 运行安装向导，包含所有包管理步骤
bash scripts/setup.sh
```

### 使用独立脚本

```bash
# 安装 Homebrew 包（包含 NVM）
~/.local/share/chezmoi/scripts/install-packages.sh

# 安装全局 pnpm 包
~/.local/share/chezmoi/scripts/install-pnpm-global.sh
```

### 手动安装

**Homebrew 包**:

**macOS/Linux** (使用通用 Brewfile):
```bash
cd ~/.local/share/chezmoi
brew bundle --file=softwares/packages/Brewfile
```

**单个安装**:
```bash
# NVM 现在通过 Homebrew 管理
brew install nvm

# 其他软件包
brew install git fzf tmux
```

**全局 pnpm 包**:
```bash
# 使用脚本安装（推荐）
~/.local/share/chezmoi/scripts/install-pnpm-global.sh

# 手动安装
pnpm add -g @anthropic-ai/claude-code codex opencode-ai
```

## 包分类

### 开发工具
- Git, GitHub CLI, Go, Ruby, Mercurial
- 版本管理器: NVM (通过 Homebrew), rbenv, jenv

### AI 工具 (通过 pnpm 全局包管理)
- @anthropic-ai/claude-code - Anthropic Claude Code CLI
- @openai/codex - OpenAI Codex CLI
- opencode-ai - OpenCode AI CLI

### 命令行工具
- fzf (模糊查找)
- fd (更好的 find)
- ripgrep (更好的 grep)
- tree (目录树)
- tmux (终端复用)
- autojump (智能跳转)

### 系统工具
- htop/btop (系统监控)
- neofetch (系统信息)
- build-essential (编译工具)

### 网络工具
- curl, wget, nmap
- net-tools, iputils-ping

### 特定平台

#### macOS 独有
- 移动开发: cocoapods, carthage, fvm, xcodegen
- GUI 应用: DevToys, MacTeX, OpenInTerminal

#### Linux 独有
- 终端文件管理器: yazi
- 额外工具: jq, sevenzip, poppler, resvg, imagemagick

## 添加新软件包

### 修改平台特定文件

```bash
# macOS: 编辑 Brewfile
chezmoi edit ~/.local/share/chezmoi/softwares/packages/Brewfile

# Linux: 编辑 Brewfile-linux
chezmoi edit ~/.local/share/chezmoi/softwares/packages/Brewfile-linux

# 开发环境额外包: 编辑 Brewfile.dev
chezmoi edit ~/.local/share/chezmoi/softwares/packages/Brewfile.dev

# 全局 pnpm 包: 编辑 Pnpmfile
chezmoi edit ~/.local/share/chezmoi/softwares/packages/Pnpmfile
```

## 维护

### 同步包列表

定期检查并更新软件包：

**Homebrew 包**:
```bash
# macOS: 重新生成 Brewfile
brew bundle dump --file=~/.local/share/chezmoi/softwares/packages/Brewfile --force

# Linux: 重新生成 Brewfile-linux
brew bundle dump --file=~/.local/share/chezmoi/softwares/packages/Brewfile-linux --force
```

**全局 pnpm 包**:
```bash
# 查看已安装的全局包
pnpm list -g --depth=0

# 手动更新 Pnpmfile（将包名添加到文件中）
chezmoi edit ~/.local/share/chezmoi/softwares/packages/Pnpmfile
```

### 清理不需要的包

```bash
# Homebrew 包清理
brew cleanup
brew autoremove

# pnpm 全局包清理
pnpm remove -g <package>
```

## 最佳实践

1. **分类清晰**: 按功能分组包
2. **跨平台考虑**: 优先选择跨平台的工具
3. **版本控制**: 将包清单纳入版本控制
4. **定期更新**: 保持软件包列表最新

## 相关链接

- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [Chezmoi 包管理](https://chezmoi.io/user-guide/advanced/install-packages-declaratively/)
