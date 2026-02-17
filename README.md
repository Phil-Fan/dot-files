# Dotfiles

我的 dotfiles 配置，使用 chezmoi 管理。

用于一键安装 PhilFan 所有使用到的软件和配置。

## Quick Start

### 方法一：一键安装（推荐）

```bash
# 下载并运行安装脚本
bash scripts/setup.sh
```

### CI 验证安装（无交互）

```bash
bash scripts/install-verify.sh
```

该脚本会在隔离的临时 `HOME` 中执行 `chezmoi init/apply`，并校验关键配置文件是否生成、忽略目录是否生效，适合本地和 CI 自动验证。

安装向导将引导您完成以下步骤：

| 步骤 | 内容 | 说明 |
|------|------|------|
| 1/6 | Homebrew | 包管理器 |
| 2/6 | Chezmoi | 配置管理工具 |
| 3/6 | Oh My Zsh | Shell 框架及插件 |
| 4/6 | 软件包 | 开发工具和实用程序 |
| 5/6 | Node.js | NVM + Node.js LTS + pnpm |
| 6/6 | 配置应用 | 应用所有 dotfiles 配置 |

### 方法二：手动安装

适用于 macOS (Apple Silicon/Intel) 和 Linux：

```bash
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=http://127.0.0.1:7890

# 1. 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装 chezmoi
brew install chezmoi

# 3. 初始化 dotfiles（会自动配置平台相关的 Homebrew 路径）
chezmoi init https://github.com/Phil-Fan/dot-files.git
chezmoi apply
```

### 重新加载 Shell

```bash
exec zsh
```

## Structure

```
dot-files/
├── dot_zsh_config/                 # Zsh 模块化配置目录
│   ├── oh-my-zsh.zsh.tmpl          # Oh My Zsh 配置
│   ├── environment.zsh.tmpl        # 环境变量
│   ├── aliases.zsh.tmpl            # 别名定义
│   ├── version-managers.zsh.tmpl   # 版本管理器
│   ├── macos.zsh.tmpl              # macOS 特定配置
│   ├── conda.zsh.tmpl              # Conda 配置
│   ├── bun.zsh.tmpl                # Bun 配置
│   ├── autojump.zsh.tmpl           # Autojump 配置
│   ├── antigravity.zsh.tmpl        # Antigravity 配置
│   └── envtools.zsh.tmpl           # 环境信息显示
├── dot_zshrc.tmpl                  # 主 Zsh 配置（加载模块）
├── dot_zprofile.tmpl               # Zsh Profile
├── dot_p10k.zsh                    # Powerlevel10k 配置
├── dot_gitconfig.tmpl              # Git 配置模板
├── dot_tmux.conf                   # Tmux 终端复用器配置
├── dot_condarc                     # Conda 配置
├── softwares/                      # 软件配置目录
│   ├── packages/                   # 包管理目录
│   │   ├── Brewfile                # macOS Homebrew 包清单
│   │   ├── Brewfile-linux          # Linux Homebrew 包清单
│   │   └── Brewfile.dev            # 开发环境额外包清单
│   ├── editors/                    # 编辑器配置
│   │   ├── vscode/                 # VS Code 设置和快捷键
│   │   ├── cursor/                 # Cursor 编辑器设置
│   │   └── claude-code/            # Claude Code 设置
│   ├── extensions/                 # 浏览器扩展列表
│   └── else/                       # 常用软件下载地址
├── scripts/                        # 脚本目录
│   ├── setup.sh                    # 一键安装向导
│   ├── install-packages.sh         # Homebrew 包安装
│   ├── install-pnpm-global.sh      # 全局 pnpm 包安装
│   └── install-oh-my-zsh-plugins.sh # Oh My Zsh 及插件安装
└── README.md                       # 本文档
```

## Usage

### 查看状态

```bash
# 查看文件状态
chezmoi status

# 查看所有管理的文件
chezmoi managed

# 查看未管理的文件
chezmoi unmanaged
```

### 编辑配置

```bash
# 编辑主配置文件
chezmoi edit ~/.zshrc

# 编辑配置模块
chezmoi edit ~/.zsh_config/macos.zsh

# 编辑后自动应用
chezmoi edit --apply ~/.zshrc
```

### 添加新配置

```bash
# 添加新文件
chezmoi add ~/.vimrc

# 添加为模板
chezmoi add --template ~/.config/nvim/init.vim

# 添加目录
chezmoi add -r ~/.config/tmux
```

### 应用更改

```bash
# 预览更改（不实际应用）
chezmoi apply --dry-run --verbose

# 应用所有更改
chezmoi apply

# 查看差异
chezmoi diff
```

---

**作者**: PhilFan  
**仓库**: https://github.com/Phil-Fan/dot-files
**Lisence**: MIT
