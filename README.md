# Dotfiles 配置管理

使用 [Chezmoi](https://chezmoi.io/) 管理的个人配置文件，支持 macOS 和 Linux 多环境差异化配置。

## 📋 目录

- [功能特性](#功能特性)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [模块化配置](#模块化配置)
- [日常使用](#日常使用)
- [多环境配置](#多环境配置)
- [故障排除](#故障排除)

## ✨ 功能特性

- ✅ **多平台支持**: macOS 和 Linux 差异化配置
- ✅ **模块化配置**: Zsh 配置分离为独立模块，易于维护
- ✅ **模板系统**: 使用 Go 模板语法实现条件配置
- ✅ **版本控制**: Git 管理，安全可追溯
- ✅ **自动化**: 一键安装软件包和配置
- ✅ **安全性**: 敏感信息不纳入版本控制

## 🚀 快速开始

### 新机器设置

#### 1. 安装 Chezmoi

**macOS**:
```bash
brew install chezmoi
```

**Linux**:
```bash
curl -fsSL https://chezmoi.io/get | sh
```

#### 2. 克隆并初始化

```bash
# 克隆仓库并初始化 chezmoi
chezmoi init https://github.com/Phil-Fan/dot-files.git

# 应用配置
chezmoi apply
```

#### 3. 安装软件包（macOS）

```bash
# 运行快速设置脚本
~/.local/share/chezmoi/scripts/setup.sh

# 或者单独运行工具安装脚本
~/.local/share/chezmoi/scripts/install-macos-tools.sh
```

#### 4. 重新加载 Shell

```bash
exec zsh
# 或
source ~/.zshrc
```

### 从零开始完整安装

```bash
# 1. 安装 chezmoi
brew install chezmoi

# 2. 初始化仓库
chezmoi init https://github.com/Phil-Fan/dot-files.git

# 3. 运行快速设置脚本（会自动应用配置并安装软件）
~/.local/share/chezmoi/scripts/setup.sh

# 4. 重新加载 Shell
exec zsh
```

## 📁 项目结构

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
├── Brewfile                        # Homebrew 包清单
├── scripts/                        # 脚本目录
│   ├── setup.sh.tmpl               # 快速设置脚本
│   └── install-macos-tools.sh.tmpl # macOS 工具安装脚本
└── README.md                       # 本文档
```

## 🔧 模块化配置

本项目采用模块化的 Zsh 配置结构，将不同功能的配置分离到独立文件中：

### 配置模块说明

| 模块 | 文件 | 说明 |
|------|------|------|
| Oh My Zsh | `oh-my-zsh.zsh` | Oh My Zsh 框架和插件配置 |
| 环境变量 | `environment.zsh` | 基础环境变量和 PATH |
| 别名 | `aliases.zsh` | 命令别名定义 |
| 版本管理器 | `version-managers.zsh` | fnm, rbenv, jenv 等 |
| Conda | `conda.zsh` | Python Conda 环境 |
| Autojump | `autojump.zsh` | 智能目录跳转工具 |
| Bun | `bun.zsh` | JavaScript 运行时 |
| Antigravity | `antigravity.zsh` | 开发工具配置 |
| macOS | `macos.zsh` | macOS 特定配置 |
| EnvTools | `envtools.zsh` | Shell 信息显示 |

### 加载顺序

主 `~/.zshrc` 按以下顺序加载模块：

1. `environment.zsh` - 环境变量（最先）
2. `oh-my-zsh.zsh` - Oh My Zsh 框架
3. `version-managers.zsh` - 版本管理器
4. `conda.zsh` - Python 环境
5. `autojump.zsh` - 目录跳转
6. `bun.zsh` - JavaScript 运行时
7. `antigravity.zsh` - 开发工具
8. 平台特定配置 (`macos.zsh` 或 `linux.zsh`)
9. `aliases.zsh` - 别名定义
10. `envtools.zsh` - 信息显示（最后）

### 修改配置

要修改特定功能的配置，编辑对应的模块文件：

```bash
# 编辑别名
chezmoi edit ~/.zsh_config/aliases.zsh

# 编辑 macOS 配置
chezmoi edit ~/.zsh_config/macos.zsh

# 编辑环境变量
chezmoi edit ~/.zsh_config/environment.zsh
```

## 📖 日常使用

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

### Git 操作

```bash
# 在 chezmoi 目录中执行 git 命令
chezmoi git status
chezmoi git add .
chezmoi git commit -m "Update config"
chezmoi git push
```

### 测试模板

```bash
# 测试简单表达式
chezmoi execute-template '{{ .chezmoi.hostname }}'

# 查看渲染后的文件
chezmoi cat ~/.zshrc | less
```

## 🔧 多环境配置

### 配置差异

本项目使用 chezmoi 模板系统实现多环境差异化配置：

| 配置项 | macOS | Linux |
|--------|-------|-------|
| Homebrew | ✅ `/opt/homebrew` | ❌ |
| X11 | ✅ `DISPLAY=:0` | ❌ |
| 代理 | ✅ 条件启用 | ❌ |
| Android SDK | ✅ | ❌ |
| Flutter | ✅ | ❌ |
| 应用别名 | ✅ (如 Typora) | ❌ |

### 自定义配置

编辑 `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    # macOS 特定配置
    [data.macOS]
        homebrewPath = "/opt/homebrew/bin"
        useProxy = true
        proxyUrl = "http://127.0.0.1:7890"

    # Linux 服务器配置
    [data.linux]
        useProxy = false
```

### 条件模板语法

```bash
{{ if eq .chezmoi.os "darwin" }}
# macOS 特定配置
export PATH="/opt/homebrew/bin:$PATH"
{{ else if eq .chezmoi.os "linux" }}
# Linux 特定配置
export PATH="/usr/local/bin:$PATH"
{{ end }}

{{ if .macOS.useProxy }}
# 代理配置
export HTTP_PROXY="{{ .macOS.proxyUrl }}"
{{ end }}
```

## 🛠️ 自动化脚本

### 快速设置脚本

`scripts/setup.sh` - 一键设置整个开发环境：

```bash
~/.local/share/chezmoi/scripts/setup.sh
```

功能：
- 应用所有 chezmoi 配置
- 可选安装 Homebrew 软件包

### macOS 工具安装脚本

`scripts/install-macos-tools.sh` - 自动安装 macOS 开发工具：

```bash
~/.local/share/chezmoi/scripts/install-macos-tools.sh
```

功能：
- 检查并安装 Homebrew
- 更新 Homebrew
- 从 Brewfile 安装所有软件包
- 清理旧版本

## 🔍 故障排除

### 问题 1: 模块未加载

**症状**: 修改模块后没有看到变化

**解决**:
```bash
# 检查模块是否存在
ls -la ~/.zsh_config/

# 重新加载 Shell
source ~/.zshrc

# 检查模块是否被正确加载
echo $ZSH_CONFIG_DIR
```

### 问题 2: 模板不生效

**症状**: 修改模板后没有看到变化

**解决**:
```bash
# 检查文件属性
chezmoi status

# 确保文件有 .tmpl 后缀
chezmoi chattr +template ~/.zshrc
```

### 问题 3: 配置未应用

**症状**: chezmoi apply 后配置没有更新

**解决**:
```bash
# 强制重新应用
chezmoi apply --force

# 检查差异
chezmoi diff
```

### 问题 4: Shell 启动报错

**症状**: 打开终端时出现错误

**解决**:
```bash
# 检查哪个模块有问题
# 逐个加载模块进行测试

# 查看完整的错误信息
zsh -xvs ~/.zshrc 2>&1 | less
```

## 📚 进阶主题

### 添加新的配置模块

1. 在 `dot_zsh_config/` 中创建新文件
2. 在 `dot_zshrc.tmpl` 中添加加载语句
3. 重新应用配置

```bash
# 1. 创建新模块
chezmoi add ~/.zsh_config/my-module.zsh

# 2. 编辑主配置文件
chezmoi edit ~/.zshrc
# 添加: source "$ZSH_CONFIG_DIR/my-module.zsh"

# 3. 应用更改
chezmoi apply
```

### 敏感信息管理

对于 API 密钥、密码等敏感信息：

1. **使用环境变量**:
```bash
export CODEX_API_KEY="your-key"
```

2. **使用密码管理器**（需要配置 chezmoi）:
```go
{{- onepasswordDocument "item-id" | fromJson -}}
```

### 添加新机器

```bash
# 1. 安装 chezmoi
brew install chezmoi

# 2. 克隆仓库
chezmoi init --apply https://github.com/Phil-Fan/dot-files.git

# 3. 运行设置脚本
~/.local/share/chezmoi/scripts/setup.sh
```

## 🔗 相关链接

- [Chezmoi 官方文档](https://chezmoi.io/)
- [模板系统指南](https://chezmoi.io/user-guide/templating/)
- [多环境配置](https://chezmoi.io/user-guide/advanced/manage-machine-to-machine-differences/)
- [声明式包管理](https://chezmoi.io/user-guide/advanced/install-packages-declaratively/)

## 📝 许可证

MIT License

---

**作者**: PhilFan  
**仓库**: https://github.com/Phil-Fan/dot-files
