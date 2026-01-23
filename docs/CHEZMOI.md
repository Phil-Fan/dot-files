# Chezmoi 工作原理说明

## 为什么 scripts/ 和 softwares/ 会在 ~ 目录下？

### Chezmoi 的默认行为

Chezmoi 会将仓库中的所有文件应用到你的 home 目录 (`~`)。文件命名规则如下：

| 仓库中的文件 | 应用到 home 目录后 |
|-------------|------------------|
| `dot_zshrc` | `~/.zshrc` |
| `dot_zprofile` | `~/.zprofile` |
| `dot_config_nvim/` | `~/.config/nvim/` |
| `scripts/` | `~/scripts/` |
| `softwares/` | `~/softwares/` |

### 问题

按照这个规则，`scripts/` 和 `softwares/` 目录会被复制到 `~/scripts/` 和 `~/softwares/`，但这通常不是我们想要的：
- 这些是参考文档和脚本
- 它们应该保留在 dotfiles 仓库中
- 不需要复制到用户的 home 目录

### 解决方案：.chezmoiignore

我们在仓库根目录创建了 `.chezmoiignore` 文件，告诉 chezmoi 哪些文件/目录不需要应用：

```
# Chezmoi 忽略文件
scripts/
softwares/
```

这样，`chezmoi apply` 会跳过这些目录，不会将它们复制到 home 目录。

### 当前状态

在添加 `.chezmoiignore` 之后：

- ✅ `dot_zshrc` → `~/.zshrc` （会被应用）
- ✅ `dot_zprofile` → `~/.zprofile` （会被应用）
- ❌ `scripts/` → 不会被复制
- ❌ `softwares/` → 不会被复制

### 访问这些文件

如果你需要访问 scripts 或 softwares 中的文件，可以通过 dotfiles 仓库：

```bash
# 进入 dotfiles 仓库
cd ~/.local/share/chezmoi

# 或者直接访问
~/.local/share/chezmoi/scripts/setup.sh
~/.local/share/chezmoi/softwares/editors/merge-settings.sh
```

### 如果想改变这个行为

如果你希望 `scripts/` 或 `softwares/` 被应用到 home 目录：

1. 编辑 `.chezmoiignore`
2. 删除对应的行
3. 重新运行 `chezmoi apply`

### 相关链接

- [Chezmoi 官方文档](https://chezmoi.io/)
- [Chezmoi ignore 文件](https://chezmoi.io/user-guide/special-files/)
