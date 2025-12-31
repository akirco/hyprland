#!/usr/bin/env bash

# ================================
# 配置区域
# ================================

# 第一级菜单快捷键
HOTKEY_COPY="Alt-c"      # 复制到剪贴板
HOTKEY_OPEN="Alt-o"      # 在浏览器中打开
HOTKEY_DOWNLOAD="Alt-d"  # 下载媒体内容
HOTKEY_PLAY="Alt-m"      # 播放媒体
HOTKEY_GIST="Alt-g"      # 上传到 Gist
HOTKEY_DELETE="Ctrl-d"   # 删除历史

# 路径与程序配置
VIDEO_DOWNLOAD_DIR="$HOME/Downloads/Videos"
IMAGE_DOWNLOAD_DIR="$HOME/Downloads/Images"
MEDIA_PLAYER="mpv"
DOWNLOADER="yt-dlp"
# 用于查看长文本的终端模拟器，请根据你的系统修改 (kitty, alacritty, foot, gnome-terminal 等)
TERMINAL_EMULATOR="kitty"
GIST_CLI_CMD="gist-paste" # 请替换为你实际使用的 gist 命令

# ================================
# 辅助函数
# ================================

# 快速检测 URL 类型 (使用正则代替外部命令，极大提升速度)
function detect_url_type() {
    local url="$1"
    
    # 定义视频相关的域名或后缀
    local video_domains="(youtube\.com|youtu\.be|bilibili\.com|vimeo\.com|twitch\.tv|twitter\.com|x\.com|tiktok\.com|instagram\.com)"
    local video_ext="(mp4|webm|mkv|mov|m3u8|ts)(\?.*)?$"
    local image_ext="(jpg|jpeg|png|gif|webp|svg)(\?.*)?$"
    
    if [[ "$url" =~ ^https?:// ]]; then
        if [[ "$url" =~ $video_domains || "$url" =~ $video_ext ]]; then
            echo "video"
            elif [[ "$url" =~ $image_ext ]]; then
            echo "image"
        else
            echo "link"
        fi
    else
        echo "text"
    fi
}

# ================================
# 动作执行函数
# ================================

action_copy() {
    local content="$1"
    echo -n "$content" | wl-copy
    notify-send "📋 已复制" "内容已复制到剪贴板" -t 2000
}

action_open_browser() {
    local content="$1"
    if [[ "$(detect_url_type "$content")" != "text" ]]; then
        xdg-open "$content" 2>/dev/null &
        notify-send "🌐 打开链接" "正在浏览器中打开..." -t 2000
    else
        notify-send "❌ 错误" "选中的内容不是有效的 URL" -t 3000
    fi
}

action_download_media() {
    local content="$1"
    local type="$(detect_url_type "$content")"
    
    if [[ "$type" == "video" ]]; then
        notify-send "⬇️ 开始下载" "正在下载视频文件..." -t 2000
        # 确保目录存在
        mkdir -p "$VIDEO_DOWNLOAD_DIR"
        # 使用 nohup 确保下载在后台继续，即使 wofi 关闭
        nohup $DOWNLOADER -P "$VIDEO_DOWNLOAD_DIR" "$content" > /dev/null 2>&1 && \
        notify-send "✅ 下载完成" "视频已保存" -u normal
        elif [[ "$type" == "image" ]]; then
        notify-send "⬇️ 开始下载" "正在下载图片..." -t 2000
        mkdir -p "$IMAGE_DOWNLOAD_DIR"
        nohup gallery-dl -d "$IMAGE_DOWNLOAD_DIR" "$content" > /dev/null 2>&1 && \
        notify-send "✅ 下载完成" "图片已保存" -u normal
    else
        notify-send "❌ 错误" "不支持的 URL 类型或无法识别" -t 3000
    fi
}

action_play_media() {
    local content="$1"
    local type="$(detect_url_type "$content")"
    
    if [[ "$type" == "video" ]]; then
        notify-send "🎬 开始播放" "正在调用 MPV 播放..." -t 2000
        $MEDIA_PLAYER "$content" >/dev/null 2>&1 &
    else
        notify-send "❌ 错误" "无法识别的视频链接" -t 3000
    fi
}

action_upload_gist() {
    local content="$1"
    notify-send "☁️ 上传中" "正在上传到 Gist..." -t 2000
    
    # 示例逻辑：假设你有 gist 命令行工具
    # echo "$content" | $GIST_CLI_CMD -p -f "clipboard-$(date +%s).txt" && \
    #     notify-send "✅ 上传成功" -t 3000 || \
    #     notify-send "❌ 上传失败" -t 3000
    
    # 如果没有配置工具，仅提示
    notify-send "⚠️ 提示" "请在脚本中配置 GIST_CLI_CMD" -t 3000
}

action_delete_history() {
    local selection="$1"
    # cliphist delete 需要接收原始的选中行
    echo "$selection" | cliphist delete
    notify-send "🗑️ 已删除" "已从历史记录中移除" -t 2000
}

action_view_content() {
    local content="$1"
    local len=${#content}
    
    if (( len > 200 )); then
        # 如果内容较长，调用终端模拟器查看
        if command -v "$TERMINAL_EMULATOR" >/dev/null 2>&1; then
            $TERMINAL_EMULATOR -e sh -c 'echo "$1" | less' _ "$content"
        else
            # 回退方案：写入临时文件并用 xdg-open
            local tmpfile=$(mktemp)
            echo "$content" > "$tmpfile"
            xdg-open "$tmpfile"
        fi
    else
        # 短文本直接显示通知
        notify-send "📝 内容预览" "$content" -t 5000
    fi
}

# ================================
# 主程序
# ================================

# 1. 启动第一级菜单
selection=$(cliphist list | wofi --dmenu \
    --prompt="📋 Clipboard History" \
    -D key_custom_0=${HOTKEY_COPY} \
    -D key_custom_1=${HOTKEY_OPEN} \
    -D key_custom_2=${HOTKEY_DOWNLOAD} \
    -D key_custom_3=${HOTKEY_PLAY} \
    -D key_custom_4=${HOTKEY_GIST} \
    -D key_custom_5=${HOTKEY_DELETE} \
--insensitive)

ret=$?
# 解码内容 (供大多数动作使用)
content="$(echo "${selection}" | cliphist decode)"

# 2. 处理快捷键 (wofi 自定义键返回码从 10 开始)
case "$ret" in
    10) action_copy "${content}"; exit ;;
    11) action_open_browser "${content}"; exit ;;
    12) action_download_media "${content}"; exit ;;
    13) action_play_media "${content}"; exit ;;
    14) action_upload_gist "${content}"; exit ;;
    15) action_delete_history "${selection}"; exit ;;
    1) exit ;; # 用户按 Esc 退出
esac

# 3. 处理回车键 (返回码 0) -> 显示第二级菜单
if [[ -n "${selection}" ]]; then
    # 定义第二级菜单选项
    action=$(echo -e "1. 📋 复制到剪贴板\n2. 🌐 在浏览器中打开\n3. ⬇️ 下载媒体\n4. 🎬 MPV播放\n5. ☁️ 上传到Gist\n6. 📝 查看内容\n7. 🗑️ 从历史中删除" | \
    wofi --dmenu --prompt="操作:")
    
    case "${action}" in
        *"复制"*)    action_copy "${content}" ;;
        *"打开"*)    action_open_browser "${content}" ;;
        *"下载"*)    action_download_media "${content}" ;;
        *"播放"*)    action_play_media "${content}" ;;
        *"Gist"*)    action_upload_gist "${content}" ;;
        *"查看"*)    action_view_content "${content}" ;;
        *"删除"*)    action_delete_history "${selection}" ;;
    esac
fi