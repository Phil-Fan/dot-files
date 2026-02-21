# Editors Configuration

编辑器配置文件（不含敏感信息）。

## 目录结构

```
softwares/editors/
├── settings.base.json        # 共享基础配置
├── vscode/                   # VSCode 特定配置
│   ├── settings.json
│   ├── keybindings.json
│   └── extensions.json
├── cursor/                   # Cursor 特定配置
│   ├── settings.json
│   ├── keybindings.json
│   └── extensions.json
└── claude-code/              # Claude Code 配置
    └── settings.json
```

## 配置架构

**基础配置 + 特定配置** 模式：

- `settings.base.json` - VSCode/Cursor 共享配置
- `{editor}/settings.json` - 编辑器特定设置

## 快速开始

### 统一同步脚本

```bash
# 完全同步 Cursor（扩展 + 配置）
./scripts/sync-editor.sh cursor all

# 完全同步 VSCode
./scripts/sync-editor.sh vscode all

# 单独操作
./scripts/sync-editor.sh cursor extensions-export   # 导出扩展
./scripts/sync-editor.sh cursor extensions-install  # 安装扩展
./scripts/sync-editor.sh cursor settings-merge      # 合并配置
```

### 手动操作

```bash
# VSCode
cp vscode/settings.json ~/Library/Application\ Support/Code/User/
cp vscode/keybindings.json ~/Library/Application\ Support/Code/User/

# Cursor
cp cursor/settings.json ~/Library/Application\ Support/Cursor/User/
cp cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/

# Claude Code
cp claude-code/settings.json ~/.claude/
```

## 配置说明

### 基础配置 (settings.base.json)

- **编辑器**: 字体 25、自动换行、鼠标缩放
- **终端**: 字体 21、回滚 100000 行
- **Vim 模式**: `jj` → `Esc`，禁用部分 Ctrl 键
- **LaTeX**: xelatex/pdflatex 完整配置
- **Git**: 自动拉取、禁用同步确认
- **Copilot**: 全语言启用

### 快捷键

- `Ctrl+B` - 切换侧边栏
- `Cmd+D` - 垂直分屏
- `Shift+Cmd+D` - 水平分屏
- `Cmd+[ / ]` - 切换分屏焦点
- `Shift+Cmd+R` - LaTeX 编译链

## 已移除内容

- API keys、tokens
- SSH 远程主机列表
- 个人本地路径
- 环境变量、代理设置
