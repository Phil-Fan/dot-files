# VSCode / Cursor 插件同步

## 已安装插件列表

### Cursor 插件

```json
[
  "adelphes.android-dev-ext",
  "anthropic.claude-code",
  "anysphere.cursorpyright",
  "anysphere.pyright",
  "anysphere.remote-ssh",
  "bierner.markdown-emoji",
  "christian-kohler.path-intellisense",
  "cschlosser.doxdocgen",
  "dart-code.dart-code",
  "dart-code.flutter",
  "davidanson.vscode-markdownlint",
  "divyanshuagrawal.competitive-programming-helper",
  "esbenp.prettier-vscode",
  "formulahendry.code-runner",
  "github.vscode-github-actions",
  "iamhyc.overleaf-workshop",
  "james-yu.latex-workshop",
  "janisdd.vscode-edit-csv",
  "kisstkondoros.vscode-gutter-preview",
  "mechatroner.rainbow-csv",
  "mhutchie.git-graph",
  "miguelsolorio.fluent-icons",
  "ms-ceintl.vscode-language-pack-zh-hans",
  "ms-python.black-formatter",
  "ms-python.debugpy",
  "ms-python.python",
  "ms-toolsai.jupyter",
  "ms-toolsai.jupyter-hub",
  "ms-toolsai.jupyter-keymap",
  "ms-toolsai.jupyter-renderers",
  "ms-toolsai.vscode-jupyter-cell-tags",
  "ms-toolsai.vscode-jupyter-slideshow",
  "ms-vscode.cmake-tools",
  "ms-vscode.cpptools-extension-pack",
  "ms-vscode.cpptools-themes",
  "ms-vscode.vscode-typescript-next",
  "mushan.vscode-paste-image",
  "openai.chatgpt",
  "pkief.material-icon-theme",
  "pomdtr.excalidraw-editor",
  "shd101wyy.markdown-preview-enhanced",
  "usernamehw.errorlens",
  "vscjava.vscode-gradle",
  "waderyan.gitblame",
  "yzhang.markdown-all-in-one",
  "zhuangtongfa.material-theme"
]
```

## 同步方法

### 方法一：使用扩展列表文件（推荐）

1. **导出当前插件**

```bash
# Cursor
cursor --list-extensions > softwares/editors/cursor/extensions.txt

# VSCode (需要先安装命令行工具)
code --list-extensions > softwares/editors/vscode/extensions.txt
```

2. **批量安装插件**

```bash
# Cursor
while read extension; do
  cursor --install-extension "$extension"
done < softwares/editors/cursor/extensions.txt

# VSCode
while read extension; do
  code --install-extension "$extension"
done < softwares/editors/vscode/extensions.txt
```

### 方法二：使用 Settings Sync（推荐用于跨设备同步）

#### VSCode - Settings Sync

1. 打开命令面板 (`Cmd+Shift+P`)
2. 输入 `Settings Sync: Turn On`
3. 登录 GitHub 账号
4. 选择要同步的内容（建议全部勾选）
   - Settings
   - Keyboard Shortcuts
   - Extensions
   - User Snippets

#### Cursor - Settings Sync

Cursor 内置支持 GitHub Settings Sync：

1. 打开 Settings (`Cmd+,`)
2. 搜索 `settings sync`
3. 点击 `Turn On`
4. 登录 GitHub 账号

### 方法三：使用同步脚本

创建 `softwares/editors/sync-extensions.sh`：

```bash
#!/bin/bash

# 安装 VSCode 命令行工具
if [[ ! -f "/usr/local/bin/code" ]]; then
    echo "安装 VSCode 命令行工具..."
    # 打开 VSCode，按 Cmd+Shift+P
    # 输入 "Shell Command: Install 'code' command in PATH"
fi

# 导出插件
echo "导出插件列表..."
cursor --list-extensions > softwares/editors/cursor/extensions.txt
code --list-extensions > softwares/editors/vscode/extensions.txt

echo "插件列表已导出"
```

## 插件分类

### 开发必备
- `anthropic.claude-code` - Claude Code AI 助手
- `github.copilot` - GitHub Copilot
- `ms-python.python` - Python 支持
- `ms-vscode.cpptools-extension-pack` - C/C++ 支持

### 编辑器���强
- `usernamehw.errorlens` - 错误提示内联显示
- `pkief.material-icon-theme` - Material 图标主题
- `miguelsolorio.fluent-icons` - Fluent 图��
- `zhuangtongfa.material-theme` - Material 主题

### LaTeX
- `james-yu.latex-workshop` - LaTeX 支持
- `iamhyc.overleaf-workshop` - Overleaf 集成

### Markdown
- `shd101wyy.markdown-preview-enhanced` - 增强预览
- `yzhang.markdown-all-in-one` - Markdown 全能工具
- `davidanson.vscode-markdownlint` - Markdown 语法检查

### Git
- `mhutchie.git-graph` - Git 图形化
- `waderyan.gitblame` - Git Blame

### 其他工具
- `formulahendry.code-runner` - 代码运行器
- `esbenp.prettier-vscode` - 代码格式化
- `ms-python.black-formatter` - Python 格式化
