# VSCode / Cursor 插件同步

使用统一同步脚本 `scripts/sync-editor.sh`：

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

---

## 手动操作（如需要）

### 导出当前插件

```bash
# Cursor
cursor --list-extensions > softwares/editors/cursor/extensions.txt

# VSCode (需要先安装命令行工具)
code --list-extensions > softwares/editors/vscode/extensions.txt
```

### 批量安装插件

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
