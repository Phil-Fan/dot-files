# 脚本安全测试指南

本文档说明如何安全地测试 dotfiles 脚本，避免破坏现有系统。

## 🛡️ 测试原则

1. **始终先备份** - 测试前备份重要配置
2. **从简单开始** - 先测试小功能，再测试完整流程
3. **使用干运行** - 在不影响系统的情况下预览
4. **隔离环境** - 使用容器或虚拟机进行完整测试

---

## 📋 测试检查清单

### 阶段 1: 静态检查（不运行脚本）

#### 1.1 语法检查

```bash
# 检查 Bash 语法错误
bash -n script.sh

# 检查所有脚本
find ~/.local/share/chezmoi/scripts -name "*.sh" -exec bash -n {} \;

# 使用 Shellcheck（推荐）
brew install shellcheck
shellcheck script.sh
```

#### 1.2 模板渲染检查

```bash
# 查看渲染后的脚本内容（不执行）
chezmoi cat ~/.local/share/chezmoi/scripts/setup.sh | less

# 检查变量是否正确替换
chezmoi execute-template '{{ .chezmoi.os }}'
chezmoi execute-template '{{ .chezmoi.hostname }}'
```

#### 1.3 权限和危险命令检查

```bash
# 检查脚本是否有执行权限
ls -l ~/.local/share/chezmoi/scripts/

# 查找潜在危险命令
grep -r "rm -rf" ~/.local/share/chezmoi/scripts/
grep -r "sudo" ~/.local/share/chezmoi/scripts/
grep -r "apt install" ~/.local/share/chezmoi/scripts/
grep -r "brew install" ~/.local/share/chezmoi/scripts/
```

### 阶段 2: 干运行测试（不修改系统）

#### 2.1 Chezmoi 干运行

```bash
# 预览将会应用的所有更改
chezmoi apply --dry-run --verbose

# 查看特定文件的差异
chezmoi diff ~/.zshrc
chezmoi diff ~/.gitconfig
```

#### 2.2 脚本调试模式

```bash
# 使用 bash -x 查看脚本执行的每一步
bash -x script.sh 2>&1 | head -50

# 仅查看脚本会执行什么，不实际执行
bash -c 'set -x; source script.sh'
```

#### 2.3 创建测试包装器

```bash
# test-wrapper.sh
#!/bin/bash
echo "=== 测试模式 ==="
echo "将执行: $@"
echo "按回车继续，Ctrl+C 取消"
read

# 模拟执行
echo "[TEST] 会执行: $@"
```

### 阶段 3: 分步测试

#### 3.1 测试单个模块

```bash
# 测试环境变量模块
source ~/.zsh_config/environment.zsh
echo $ZSH_CONFIG_DIR  # 应该输出 ~/.zsh_config

# 测试 Oh My Zsh 模块
source ~/.zsh_config/oh-my-zsh.zsh
echo $ZSH  # 应该输出 ~/.oh-my-zsh
```

#### 3.2 测试插件加载

```bash
# 测试插件是否正确加载
autoload -Uz compinit
compinit

# 检查插件是否可用
which zsh-autosuggestions
which zsh-syntax-highlighting
```

#### 3.3 测试软件包（仅列出）

```bash
# macOS: 查看 brew bundle 会安装什么
brew bundle list --file=Brewfile

# Linux: 查看会安装什么包
cat apt-packages.txt | grep -v "^#"
```

### 阶段 4: 增量应用

#### 4.1 先应用非关键配置

```bash
# 1. 先应用别名和环境变量
chezmoi apply ~/.zsh_config/aliases.zsh
chezmoi apply ~/.zsh_config/environment.zsh

# 2. 测试这些配置
source ~/.zsh_config/aliases.zsh
alias ll  # 应该显示 ll=ls -lh

# 3. 再应用 Oh My Zsh 配置
chezmoi apply ~/.zsh_config/oh-my-zsh.zsh

# 4. 最后应用主配置
chezmoi apply ~/.zshrc
```

#### 4.2 使用新 Shell 测试

```bash
# 不修改当前 Shell，启动新 Shell 测试
zsh -df

# 或者使用临时目录
HOME=/tmp/test_home zsh -df
```

---

## 🧪 完整测试流程

### 测试新脚本

```bash
# 1. 静态检查
bash -n script.sh
shellcheck script.sh

# 2. 查看脚本内容
less script.sh

# 3. 干运行
chezmoi apply --dry-run

# 4. 分步应用
chezmoi apply ~/.zsh_config/environment.zsh
# 测试...

# 5. 完整应用
chezmoi apply

# 6. 新 Shell 测试
zsh -df
```

### 测试 Oh My Zsh 插件安装

```bash
# 1. 语法检查
bash -n ~/.local/share/chezmoi/scripts/install-oh-my-zsh-plugins.sh

# 2. 查看会安装什么
grep "git clone" ~/.local/share/chezmoi/scripts/install-oh-my-zsh-plugins.sh

# 3. 手动执行克隆（测试）
mkdir -p /tmp/test_omz_plugins
git clone https://github.com/zsh-users/zsh-autosuggestions /tmp/test_omz_plugins/zsh-autosuggestions

# 4. 确认无误后运行实际脚本
~/.local/share/chezmoi/scripts/install-oh-my-zsh-plugins.sh
```

---

## 🔧 测试工具

### Shellcheck

```bash
# 安装
brew install shellcheck

# 检查单个脚本
shellcheck script.sh

# 检查所有脚本
find . -name "*.sh" -exec shellcheck {} +
```

### 创建测试脚本

```bash
#!/bin/bash
# test-all.sh

echo "=== 运行所有测试 ==="

# 语法检查
echo "1. 语法检查..."
for script in scripts/*.sh scripts/*.tmpl; do
    if bash -n "$script" 2>&1; then
        echo "  ✓ $script"
    else
        echo "  ✗ $script 有语法错误"
    fi
done

# 模板渲染检查
echo "2. 模板检查..."
chezmoi apply --dry-run > /tmp/chezmoi-dry-run.log
if [ $? -eq 0 ]; then
    echo "  ✓ 模板渲染成功"
else
    echo "  ✗ 模板渲染失败"
    cat /tmp/chezmoi-dry-run.log
fi

echo "=== 测试完成 ==="
```

---

## 🚨 如果出错了

```bash
# 1. 立即停止
Ctrl+C

# 2. 查看错误信息
# 读取错误输出，找出问题

# 3. 恢复备份
cp ~/.zshrc.backup ~/.zshrc

# 4. 回滚 Git
cd ~/.local/share/chezmoi
git checkout HEAD~1

# 5. 手动清理
sudo apt remove package-name
brew uninstall package-name

# 6. 重新应用
chezmoi apply --force
```

---

## ✅ 测试完成清单

- [ ] 所有脚本通过语法检查 (bash -n)
- [ ] 所有脚本通过 Shellcheck
- [ ] 干运行输出符合预期
- [ ] 分步应用测试通过
- [ ] 新 Shell 启动正常
- [ ] 所有必要工具可访问
- [ ] 备份已创建并验证

---

## 📝 最佳实践

1. **小步快跑** - 每次只修改一小部分，测试后再继续
2. **版本控制** - 每次修改后提交，方便回滚
3. **详细日志** - 记录测试过程和结果
4. **自动化测试** - 创建测试脚本自动化检查
5. **环境隔离** - 使用虚拟机或容器进行完整测试
