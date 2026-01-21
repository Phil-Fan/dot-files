# 包管理系统

使用 Homebrew 统一管理 macOS 和 Linux 软件包。

## 📁 文件结构

```
packages/
├── Brewfile              # macOS Homebrew 包清单
├── Brewfile-linux        # Linux Homebrew 包清单
├── Brewfile.dev          # 开发环境额外包清单
├── common-packages.yaml  # 通用包定义（单一数据源）
└── README.md             # 本文档
```

## 🚀 快速开始

### 使用统一脚本（推荐）

```bash
# 自动检测平台并安装对应的软件包
~/.local/share/chezmoi/scripts/install-packages.sh
```

### 手动安装

**macOS**:
```bash
cd ~/.local/share/chezmoi
brew bundle --file=packages/Brewfile
```

**Linux**:
```bash
cd ~/.local/share/chezmoi
brew bundle --file=packages/Brewfile-linux
```

**单个安装**:
```bash
brew install git fzf tmux
```

## 📦 包分类

### 开发工具
- Git, GitHub CLI, Go, Node.js, Ruby
- 版本管理器: fnm, rbenv, jenv

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

## ➕ 添加新软件包

### 修改平台特定文件

```bash
# macOS: 编辑 Brewfile
chezmoi edit ~/.local/share/chezmoi/packages/Brewfile

# Linux: 编辑 Brewfile-linux
chezmoi edit ~/.local/share/chezmoi/packages/Brewfile-linux

# 开发环境额外包: 编辑 Brewfile.dev
chezmoi edit ~/.local/share/chezmoi/packages/Brewfile.dev
```

### 修改通用配置

1. 编辑 `common-packages.yaml`
2. 运行生成脚本（如果实现了自动生成）
3. 提交更改

## 🔧 维护

### 同步包列表

定期检查并更新软件包：

```bash
# macOS: 重新生成 Brewfile
brew bundle dump --file=~/.local/share/chezmoi/packages/Brewfile --force

# Linux: 重新生成 Brewfile-linux
brew bundle dump --file=~/.local/share/chezmoi/packages/Brewfile-linux --force
```

### 清理不需要的包

```bash
# macOS 和 Linux 通用
brew cleanup
brew autoremove
```

## 📝 最佳实践

1. **使用单一数据源**: 尽量在 `common-packages.yaml` 中定义
2. **分类清晰**: 按功能分组包
3. **跨平台考虑**: 优先选择跨平台的工具
4. **版本控制**: 将包清单纳入版本控制
5. **定期更新**: 保持软件包列表最新

## 🔗 相关链接

- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [Ubuntu Packages](https://packages.ubuntu.com/)
- [Chezmoi 包管理](https://chezmoi.io/user-guide/advanced/install-packages-declaratively/)
