# Editors Configuration

此目录包含各种编辑器的配置文件，不包含敏感信息（API keys、个人路径等）。

## 目录结构

```
softwares/editors/
├── vscode/
│   ├── settings.json      # VSCode 设置
│   └── keybindings.json   # VSCode 快捷键
├── cursor/
│   ├── settings.json      # Cursor 设置
│   └── keybindings.json   # Cursor 快捷键
└── claude-code/
    └── settings.json      # Claude Code 设置
```

## 使用方法

### VSCode / Cursor

macOS 配置位置：
- **VSCode**: `~/Library/Application Support/Code/User/`
- **Cursor**: `~/Library/Application Support/Cursor/User/`

复制命令：
```bash
# VSCode
cp softwares/editors/vscode/settings.json ~/Library/Application\ Support/Code/User/
cp softwares/editors/vscode/keybindings.json ~/Library/Application\ Support/Code/User/

# Cursor
cp softwares/editors/cursor/settings.json ~/Library/Application\ Support/Cursor/User/
cp softwares/editors/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/
```

### Claude Code

配置位置：`~/.claude/`

```bash
cp softwares/editors/claude-code/settings.json ~/.claude/
```

## 配置说明

### 共同特性

- **字体大小**: 编辑器 25, 终端 21
- **Vim 模式**: 启用，`jj` 映射为 `Esc`
- **Git**: 自动拉取，禁用同步确认
- **终端**: 回滚 100000 行
- **LaTeX Workshop**: 配置完整，支持 xelatex 和 pdflatex

### VSCode / Cursor 特有

- **Copilot**: 全语言启用（除 plaintext/scminput）
- **Ctrl+B**: 切换侧边栏
- **Shift+Cmd+R**: LaTeX 编译链选择
- **代码补全**: 启用内联建议
- **自动换行**: 编辑器和 diff 编辑器

### Cursor 额外配置

- **Cmd+T**: 新建未命名文件
- **Claude Code**: 优先在面板显示
- **终端字体**: JetBrainsMono Nerd Font Mono

### Claude Code 配置

- **输出样式**: engineer-professional
- **已启用插件**:
  - 代码审查 (code-review)
  - Git 提交 (commit-commands)
  - 上下文搜索 (context7)
  - 功能开发 (feature-dev)
  - PR 工具包 (pr-review-toolkit)
  - TypeScript/Python LSP
  - 等 20+ 个插件
- **权限**: Bash 基础命令访问

## 清理说明

以下内容已从配置中移除：

- ❌ API keys 和 tokens
- ❌ SSH 远程主机列表
- ❌ 个人本地路径
- ❌ 环境变量���置
- ❌ 代理设置

如需完整配置，请根据实际情况添加这些敏感信息。
