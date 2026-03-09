#!/bin/bash

# 脚本说明：修改 SSH 配置文件中的 PermitRootLogin 和 PasswordAuthentication 设置
# 仅适用于 Debian/Ubuntu 系统（使用 systemd 管理服务）

# 备份原始配置文件（可选但推荐）
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "✅ 已备份原始 SSH 配置文件到: /etc/ssh/sshd_config.bak"

# 修改 PermitRootLogin 设置（将 without-password 改为 yes）
sudo sed -i '/^PermitRootLogin/s/without-password/yes/' /etc/ssh/sshd_config
if [[ $? -eq 0 ]]; then
  echo "✅ 已将 PermitRootLogin 设置为 yes"
else
  echo "❌ 未能找到 PermitRootLogin 配置行，请手动检查 /etc/ssh/sshd_config"
  exit 1
fi

# 修改 PasswordAuthentication 设置（若当前值为 no，则改为 yes）
sudo sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
if [[ $? -eq 0 ]]; then
  echo "✅ 已将 PasswordAuthentication 设置为 yes"
else
  echo "❌ 未能找到 PasswordAuthentication 配置行，请手动检查 /etc/ssh/sshd_config"
  exit 1
fi

# 重启 SSH 服务
sudo systemctl restart ssh
if [[ $? -eq 0 ]]; then
  echo "✅ SSH 服务已重启，配置生效"
else
  echo "❌ 重启 SSH 服务失败，请手动执行: sudo systemctl restart ssh"
  exit 1
fi

# 验证配置是否生效（可选）
echo "🔍 验证 SSH 配置是否更新..."
sudo grep "PermitRootLogin" /etc/ssh/sshd_config
sudo grep "PasswordAuthentication" /etc/ssh/sshd_config