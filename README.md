# Dotfiles

## Quick Start

**macOS / Linux** (统一使用 Homebrew):

```bash
# 安装 Homebrew（如果尚未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 chezmoi
brew install chezmoi

# 初始化 dotfiles
chezmoi init https://github.com/Phil-Fan/dot-files.git
chezmoi apply
```

**运行设置脚本**:

```bash
# 快速设置（自动检测平台）
~/.local/share/chezmoi/scripts/setup.sh

# 或单独运行包安装脚本
~/.local/share/chezmoi/scripts/install-packages.sh
```

```bash
source ~/.zshrc
```

## Structure

```
dot-files/
├── .chezmoitemplates/              # 共享模板目录
│   └── common/
│       └── shell-header.zsh       # Shell 通用头部
├── .chezmoidata/                   # 数据文件目录
│   └── packages.yaml               # 包管理清单
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
├── dot_condarc                     # Conda 配置
├── packages/                       # 包管理目录
│   ├── Brewfile                    # macOS Homebrew 包清单
│   ├── Brewfile-linux              # Linux Homebrew 包清单
│   └── Brewfile.dev                # 开发环境额外包清单
├── scripts/                        # 脚本目录
│   ├── setup.sh                    # 快速设置脚本
│   ├── install-packages.sh         # 统一包安装脚本（支持 macOS 和 Linux）
│   ├── install-oh-my-zsh-plugins.sh # Oh My Zsh 插件安装
│   └── preview.sh                  # 配置预览脚本
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
