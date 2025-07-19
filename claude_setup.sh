#!/bin/bash
# 超简洁版本 - 输入token即可
echo "🚀 Claude Code 快速配置"
echo "使用备用API地址，一次配置永久生效"
echo ""

# 检查是否已配置
if [[ -f ~/.claude_config_done ]] && command -v claude &> /dev/null; then
    echo "✅ 已配置完成，直接启动 Claude Code..."
    source ~/.bashrc 2>/dev/null || true
    exec claude
    exit 0
fi

# 安装 Claude Code（如果未安装）
if ! command -v claude &> /dev/null; then
    echo "📦 安装 Claude Code..."
    npm install -g @anthropic-ai/claude-code || exit 1
fi

# 获取 Token
read -p "请输入 Token (sk-开头): " token
[[ ! $token == sk-* ]] && echo "❌ Token 格式错误" && exit 1

# 一键配置
for file in ~/.bash_profile ~/.bashrc ~/.zshrc; do
    touch "$file"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' '/ANTHROPIC_/d' "$file" 2>/dev/null
    else
        sed -i '/ANTHROPIC_/d' "$file" 2>/dev/null
    fi
    cat >> "$file" << EOF

# Claude Code - Auto Config $(date +%Y%m%d)
export ANTHROPIC_AUTH_TOKEN=$token
export ANTHROPIC_BASE_URL=https://pmpjfbhq.cn-nb1.rainapp.top
EOF
done

# 标记配置完成
echo "Configured on $(date)" > ~/.claude_config_done

# 设置当前环境并启动
export ANTHROPIC_AUTH_TOKEN=$token
export ANTHROPIC_BASE_URL=https://pmpjfbhq.cn-nb1.rainapp.top

echo "✅ 配置完成！启动中..."
exec claude

