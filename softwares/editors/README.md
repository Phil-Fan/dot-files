# Editors Configuration

此目录包含各种编辑器的配置文件，不包含敏感信息（API keys、个人路径等）。

## 目录结构

```
softwares/editors/
├── settings.base.json        # 共享基础配置（VSCode + Cursor）
├── merge-settings.sh          # 配置合并脚本
├── vscode/
│   ├── settings.json          # VSCode 特定设置
│   └── keybindings.json       # VSCode 快捷键
├── cursor/
│   ├── settings.json          # Cursor 特定设置
│   └── keybindings.json       # Cursor 快捷键
└── claude-code/
    └── settings.json          # Claude Code 设置
```

## 配置架构

为了减少重复配置，采用 **基础配置 + 特定配置** 的架构：

- **settings.base.json** - VSCode 和 Cursor 共享的配置（编辑器、终端、LaTeX、Vim 等）
- **vscode/settings.json** - 仅包含 VSCode 特定设置
- **cursor/settings.json** - 仅包含 Cursor 特定设置

## 使用方法

### 方法一：使用合并脚本（推荐）

```bash
# VSCode
cd softwares/editors
./merge-settings.sh vscode

# Cursor
./merge-settings.sh cursor
```

脚本会自动合并 `settings.base.json` 和对应编辑器的特定配置，并保存到正确位置。

### 方法二：手动复制

**注意**: 手动复制需要自己合并基础配置的内容。

```bash
# VSCode
cp softwares/editors/vscode/settings.json ~/Library/Application\ Support/Code/User/
cp softwares/editors/vscode/keybindings.json ~/Library/Application\ Support/Code/User/

# Cursor
cp softwares/editors/cursor/settings.json ~/Library/Application\ Support/Cursor/User/
cp softwares/editors/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/

# Claude Code
cp softwares/editors/claude-code/settings.json ~/.claude/
```

## 配置说明

### 基础配置 (settings.base.json)

包含以下共享设置：

- **编辑器**: 字体大小 25、自动换行、鼠标缩放
- **终端**: 字体 21、回滚 100000 行
- **Vim 模式**: `jj` 映射为 `Esc`，禁用部分 Ctrl 键
- **LaTeX Workshop**: 完整配置，支持 xelatex 和 pdflatex
- **Git**: 自动拉取、禁用同步确认
- **GitHub Copilot**: 全语言启用（除 plaintext/scminput）
- **其他**: Hex Editor、拼写检查、Markdown 预览等

### VSCode 特定配置

- WSL 支持 (`security.allowedUNCHosts`)

### Cursor 特定配置

- Cursor CPP 禁用语言
- Git 智能提交
- Claude Code 集成（优先在���板显示）
- 终端字体: JetBrainsMono Nerd Font Mono

### 快捷键配置

VSCode 和 Cursor 共享相同的快捷键配置（由 keybindings.json 定义）：

- `Ctrl+B` - 切换侧边栏
- `Cmd+D` - 垂直分屏
- `Shift+Cmd+D` - 水平分屏
- `Cmd+[` / `Cmd+]` - 切换分屏焦点
- `Shift+Cmd+R` - LaTeX 编译链选择

## 清理说明

以下内容已从配置中移除：

- ❌ API keys 和 tokens
- ❌ SSH 远程主机列表
- ❌ 个人本地路径
- ❌ 环境变量配置
- ❌ 代理设置

如需完整配置，请根据实际情况添加这些敏感信息。
