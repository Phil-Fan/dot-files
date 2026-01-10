# Dotfiles 配置管理

使用 [Chezmoi](https://chezmoi.io/) 管理的个人配置文件，支持 macOS 和 Linux 多环境差异化配置。

## 📋 目录

- [功能特性](#功能特性)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [日常使用](#日常使用)
- [多环境配置](#多环境配置)
- [故障排除](#故障排除)

## ✨ 功能特性

- ✅ **多平台支持**: macOS 和 Linux 差异化配置
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

#### 2. 初始化配置

```bash
# 克隆仓库并初始化 chezmoi
chezmoi init https://github.com/Phil-Fan/dot-files.git

# 应用配置
chezmoi apply
```

#### 3. 重新加载 Shell

```bash
source ~/.zshrc
```

### 从零开始安装（包括软件包）

```bash
# 完整安装流程
chezmoi init https://github.com/Phil-Fan/dot-files.git
chezmoi apply

# 运行一次性脚本（安装 Homebrew 软件包）
chezmoi run run_once_install-brewfile.sh.tmpl
```

## 📁 项目结构

```
dot-files/
├── .chezmoi.toml.template          # chezmoi 配置模板
├── .chezmoitemplates/              # 共享模板目录
│   └── common/
│       └── shell-header.zsh       # Shell 通用头部
├── .chezmoidata/                   # 数据文件目录
│   └── packages.yaml               # 包管理清单
├── dot_zshrc.tmpl                  # Zsh 配置模板
├── dot_zprofile.tmpl               # Zsh Profile 模板
├── dot_p10k.zsh                    # Powerlevel10k 配置
├── dot_gitconfig.tmpl              # Git 配置模板
├── dot_condarc                     # Conda 配置
├── Brewfile                        # Homebrew 包清单
├── run_once_install-brewfile.sh.tmpl  # Homebrew 安装脚本
└── README.md                       # 本文档
```

### 文件说明

| 文件 | 说明 |
|------|------|
| `dot_*.tmpl` | chezmoi 模板文件，会被渲染为 `~/.文件名` |
| `Brewfile` | Homebrew Bundle 配置，声明式管理 macOS 软件包 |
| `.chezmoitemplates/` | 可复用的模板片段 |
| `.chezmoidata/` | 模板数据文件 |
| `run_once_*.tmpl` | 仅运行一次的脚本 |

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
# 编辑配置文件（会自动打开源文件）
chezmoi edit ~/.zshrc

# 编辑后自动应用
chezmoi edit --apply ~/.zshrc

# 编辑 chezmoi 配置
chezmoi edit-config
```

### 添加新配置

```bash
# 添加文件
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

### 可用变量

| 变量 | 说明 |
|------|------|
| `{{ .chezmoi.os }}` | 操作系统 (darwin/linux/windows) |
| `{{ .chezmoi.arch }}` | 架构 (arm64/amd64) |
| `{{ .chezmoi.hostname }}` | 主机名 |
| `{{ .chezmoi.home }}` | 家目录路径 |
| `{{ .name }}` | 用户名（自定义） |
| `{{ .email }}` | 邮箱（自定义） |

## 🔍 故障排除

### 问题 1: 模板不生效

**症状**: 修改模板后没有看到变化

**解决**:
```bash
# 检查文件属性
chezmoi status

# 确保文件有 .tmpl 后缀
chezmoi chattr +template ~/.zshrc
```

### 问题 2: 权限错误

**症状**: SSH 等敏感文件权限问题

**解决**:
```bash
# 使用 private_ 前缀
chezmoi chattr +private ~/.ssh/config
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

### 问题 4: 模板变量错误

**症状**: 模板渲染失败

**解决**:
```bash
# 测试模板
chezmoi cat ~/.zshrc

# 检查 chezmoi 配置
chezmoi doctor
```

## 📚 进阶主题

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

# 3. 根据需要修改配置
chezmoi edit-config

# 4. 应用更改
chezmoi apply
```

### 备份和恢复

**备份**:
```bash
chezmoi git push
```

**恢复**:
```bash
chezmoi init https://github.com/Phil-Fan/dot-files.git
chezmoi apply
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
