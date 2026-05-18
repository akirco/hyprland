#!/usr/bin/env bash

# =============================================================================
# Bili-Term - B站终端客户端
# 版本: v2.0.0
# 作者: akirco
# 描述: 终端中的B站客户端，支持视频播放、UP主搜索、历史记录等功能
# =============================================================================

set -Eo pipefail

# ===========================================
# 区域 1: 常量定义
# ===========================================

readonly BILI_TERM_VERSION="v0.2.0"
readonly BILI_TERM_NAME="Bili-Term"
readonly BILI_TERM_GITHUB="https://github.com/akirco/bili-term"

readonly MENU_RECOMMEND="    推荐视频"
readonly MENU_POPULAR="    热门视频"
readonly MENU_SEARCH_VIDEO="    搜索视频"
readonly MENU_SEARCH_UP="    搜索UP主"
readonly MENU_HISTORY="  󰇚  历史记录"
readonly MENU_WATCHLATER="    稍后观看"
readonly MENU_SETTINGS="    配置管理"
readonly MENU_LOGIN="    扫码登录"
readonly MENU_ABOUT="    关于帮助"
readonly MENU_EXIT="    退出程序"

readonly SETTINGS_OPEN_DIR="    打开配置目录"
readonly SETTINGS_EDIT_CONFIG="    编辑配置文件"
readonly SETTINGS_RESET_CONFIG="    重置配置文件"
readonly SETTINGS_CLEAR_CACHE="    清除缓存文件"
readonly SETTINGS_SYS_INFO="    查看系统信息"
readonly SETTINGS_BACK=" 󰌑  返回主菜单"

readonly API_UP_VIDEOS="https://api.bilibili.com/x/space/arc_search"
readonly API_UP_SEARCH="https://api.bilibili.com/x/web-interface/search/type"
readonly API_RECOMMEND="https://api.bilibili.com/x/web-interface/index/top/feed/rcmd"
readonly API_POPULAR="https://api.bilibili.com/x/web-interface/popular"
readonly API_VIDEO_SEARCH="https://api.bilibili.com/x/web-interface/search/all/v2"
readonly API_HISTORY="https://api.bilibili.com/x/v2/history"
readonly API_WATCHLATER="https://api.bilibili.com/x/v2/history/toview"
readonly API_NAV="https://api.bilibili.com/x/web-interface/nav"
readonly API_LOGIN_QR_GENERATE="https://passport.bilibili.com/x/passport-login/web/qrcode/generate"
readonly API_LOGIN_QR_POLL="https://passport.bilibili.com/x/passport-login/web/qrcode/poll"

readonly DEFAULT_MAX_RETRY=3
readonly DEFAULT_MAX_POLL=60

# 内部常量（用户通常不需要修改）
readonly DEFAULT_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
readonly DEFAULT_VIDEO_PLAYER="mpv"
readonly DEFAULT_PLAYER_ARGS="--border=no --ontop --geometry=960x540+50+50"
readonly DEFAULT_DOWNLOAD_FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]"
readonly DEFAULT_DOWNLOAD_THREADS=4
readonly DEFAULT_ENABLE_PREVIEW=true
readonly DEFAULT_PREVIEW_WIDTH="50%"
readonly DEFAULT_PREVIEW_HEIGHT=20
readonly DEFAULT_FZF_COLOR="bg+:#101115,bg:#0E1011,border:#FB7299,fg:#c0caf5,hl:#bb9af7,fg+:#c0caf5,hl+:#bb9af7,info:#7dcfff,prompt:#7aa2f7,pointer:#bb9af7,marker:#bb9af7,spinner:#7dcfff,header:#bb9af7"
readonly DEFAULT_CACHE_DURATION=3600
readonly DEFAULT_API_TIMEOUT=10
readonly DEFAULT_API_RETRY=2
readonly DEFAULT_SEARCH_MAX_RESULTS=100
readonly DEFAULT_VIDEO_DETAIL_PAGE_SIZE=1
readonly DEFAULT_UP_DETAIL_PAGE_SIZE=1
readonly DEFAULT_KEY_PLAY="enter"
readonly DEFAULT_KEY_PLAY_ALL="alt-enter"
readonly DEFAULT_KEY_DOWNLOAD="ctrl-d"
readonly DEFAULT_KEY_REFRESH="ctrl-r"
readonly DEFAULT_KEY_BACK="esc"
readonly DEFAULT_PREVIEW_COLUMNS_VIDEO=80
readonly DEFAULT_PREVIEW_LINES_VIDEO=20
readonly DEFAULT_PREVIEW_COLUMNS_UP=60
readonly DEFAULT_PREVIEW_LINES_UP=15

# ===========================================
# 区域 2: 变量定义（颜色、路径、配置）
# ===========================================

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

CONFIG_DIR="$XDG_CONFIG_HOME/bili-term"
CONFIG_FILE="$CONFIG_DIR/config"
COOKIE_FILE="$CONFIG_DIR/cookies.txt"

CACHE_BASE_DIR="$XDG_CACHE_HOME/bili-term"
CACHE_DIR="$CACHE_BASE_DIR/$$"

DOWNLOAD_DIR="$HOME/Videos/bilibili"

LOGIN_STATUS=""

SIZES="$(tput lines)"

# ===========================================
# 区域 3: 默认配置模板
# ===========================================

DEFAULT_CONFIG="# Bili-Term 配置文件
# 用户代理
USER_AGENT=\"$DEFAULT_USER_AGENT\"

# 下载目录
DOWNLOAD_DIR=\"$DOWNLOAD_DIR\"

# 播放器设置
VIDEO_PLAYER=\"$DEFAULT_VIDEO_PLAYER\"
PLAYER_ARGS=\"$DEFAULT_PLAYER_ARGS\"

# 下载设置
DOWNLOAD_FORMAT=\"$DEFAULT_DOWNLOAD_FORMAT\"
DOWNLOAD_THREADS=$DEFAULT_DOWNLOAD_THREADS

# 界面设置
ENABLE_PREVIEW=$DEFAULT_ENABLE_PREVIEW
PREVIEW_WIDTH=$DEFAULT_PREVIEW_WIDTH
PREVIEW_HEIGHT=$DEFAULT_PREVIEW_HEIGHT
SHOW_STATISTICS=true
COLOR_SCHEME=\"default\"
FZF_COLOR=\"$DEFAULT_FZF_COLOR\"

# 缓存设置
CACHE_DURATION=$DEFAULT_CACHE_DURATION

# API设置
API_TIMEOUT=$DEFAULT_API_TIMEOUT
API_RETRY=$DEFAULT_API_RETRY

# 搜索设置
SEARCH_PAGE_SIZE=\"$SIZES\"
SEARCH_MAX_RESULTS=$DEFAULT_SEARCH_MAX_RESULTS
RECOMMEND_PAGE_SIZE=\"$SIZES\"
POPULAR_PAGE_SIZE=\"$SIZES\"
PERSONAL_PAGE_SIZE=\"$SIZES\"
VIDEO_DETAIL_PAGE_SIZE=$DEFAULT_VIDEO_DETAIL_PAGE_SIZE
UP_DETAIL_PAGE_SIZE=$DEFAULT_UP_DETAIL_PAGE_SIZE

# 快捷键设置
KEY_PLAY=\"$DEFAULT_KEY_PLAY\"
KEY_PLAY_ALL=\"$DEFAULT_KEY_PLAY_ALL\"
KEY_DOWNLOAD=\"$DEFAULT_KEY_DOWNLOAD\"
KEY_REFRESH=\"$DEFAULT_KEY_REFRESH\"
KEY_BACK=\"$DEFAULT_KEY_BACK\"

# 代理设置（如需）
# HTTP_PROXY=\"http://127.0.0.1:7890\"
# HTTPS_PROXY=\"http://127.0.0.1:7890\"
"

# ===========================================
# 区域 4: 配置管理
# ===========================================

load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        mkdir -p "$CONFIG_DIR"
        echo "$DEFAULT_CONFIG" >"$CONFIG_FILE"
        echo -e "${GREEN}已创建默认配置文件: $CONFIG_FILE${NC}"
    fi

    if [ -f "$CONFIG_FILE" ]; then
        # shellcheck source=/dev/null
        if ! source "$CONFIG_FILE" 2>/dev/null; then
            echo -e "${RED}配置文件语法错误，使用默认配置${NC}"
        fi
    fi

    USER_AGENT="${USER_AGENT:-$DEFAULT_USER_AGENT}"
    DOWNLOAD_DIR="${DOWNLOAD_DIR:-$HOME/Videos/bilibili/downloads}"
    VIDEO_PLAYER="${VIDEO_PLAYER:-$DEFAULT_VIDEO_PLAYER}"
    ENABLE_PREVIEW="${ENABLE_PREVIEW:-$DEFAULT_ENABLE_PREVIEW}"
    SHOW_STATISTICS="${SHOW_STATISTICS:-true}"
    SEARCH_PAGE_SIZE="${SEARCH_PAGE_SIZE:-20}"
    RECOMMEND_PAGE_SIZE="${RECOMMEND_PAGE_SIZE:-20}"
    POPULAR_PAGE_SIZE="${POPULAR_PAGE_SIZE:-20}"
    PERSONAL_PAGE_SIZE="${PERSONAL_PAGE_SIZE:-20}"
    VIDEO_DETAIL_PAGE_SIZE="${VIDEO_DETAIL_PAGE_SIZE:-$DEFAULT_VIDEO_DETAIL_PAGE_SIZE}"
    UP_DETAIL_PAGE_SIZE="${UP_DETAIL_PAGE_SIZE:-$DEFAULT_UP_DETAIL_PAGE_SIZE}"
    API_TIMEOUT="${API_TIMEOUT:-$DEFAULT_API_TIMEOUT}"

    mkdir -p "$DOWNLOAD_DIR"
    mkdir -p "$CACHE_BASE_DIR"

    if [ -z "$FZF_COLOR" ]; then
        FZF_COLOR="$DEFAULT_FZF_COLOR"
    fi
}

# ===========================================
# 区域 5: 工具函数
# ===========================================

check_dependency() {
    local missing=()
    local required=("curl" "jq" "fzf" "chafa" "mpv" "yt-dlp" "qrencode")

    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}错误: 缺少必要的依赖:${NC}"
        for cmd in "${missing[@]}"; do
            echo -e "  ${YELLOW}- $cmd${NC}"
        done
        exit 1
    fi
}

urlencode() {
    echo -n "$1" | jq -sRr @uri
}

timestamp_to_date() {
    local timestamp="$1"
    if [ -n "$timestamp" ] && [ "$timestamp" != "null" ] && [ "$timestamp" -gt 0 ]; then
        date -d "@$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null ||
            date -r "$timestamp" "+%Y-%m-%d %H:%M" 2>/dev/null ||
            echo "$timestamp"
    else
        echo "未知"
    fi
}

format_number() {
    local num="$1"
    if [ -n "$num" ] && [ "$num" != "null" ]; then
        if [ "$num" -ge 100000000 ]; then
            local yi=$((num / 100000000))
            local decimal=$(((num % 100000000) * 10 / 100000000))
            echo "${yi}.${decimal}亿"
        elif [ "$num" -ge 10000 ]; then
            local wan=$((num / 10000))
            local decimal=$(((num % 10000) * 10 / 10000))
            echo "${wan}.${decimal}万"
        else
            echo "$num"
        fi
    else
        echo "0"
    fi
}

format_duration() {
    local seconds="$1"
    if [ -n "$seconds" ] && [ "$seconds" != "null" ] && [ "$seconds" -gt 0 ]; then
        local hours=$((seconds / 3600))
        local minutes=$(((seconds % 3600) / 60))
        local secs=$((seconds % 60))

        if [ $hours -gt 0 ]; then
            printf "%d:%02d:%02d" $hours $minutes $secs
        else
            printf "%d:%02d" $minutes $secs
        fi
    else
        echo "0:00"
    fi
}

seconds_to_hms() {
    local total_seconds="${1:-0}"
    if ! [[ "$total_seconds" =~ ^[0-9]+$ ]]; then
        echo "0秒"
        return
    fi
    if [ "$total_seconds" -eq 0 ]; then
        echo "0秒"
        return
    fi

    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))

    local res=""
    ((hours > 0)) && res+="${hours}小时"
    ((minutes > 0)) && res+="${minutes}分钟"
    ((seconds > 0 || (hours == 0 && minutes == 0))) && res+="${seconds}秒"
    echo "$res"
}

log() {
    if [ "$DEBUG" = "true" ]; then
        printf "%s\n" "$1" >&2
    fi
}

validate_json() {
    echo "$1" | jq empty 2>/dev/null
}

cache_key_hash() {
    local input="$1"
    printf '%s' "$input" | cksum | cut -d' ' -f1
}

is_cache_valid() {
    local cache_file="$1"
    local duration="${2:-${CACHE_DURATION:-3600}}"
    if [ ! -f "$cache_file" ] || [ ! -s "$cache_file" ]; then
        return 1
    fi
    local now
    now=$(date +%s)
    local file_mtime
    file_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
    if [ -z "$file_mtime" ]; then
        return 1
    fi
    local age=$((now - file_mtime))
    [ "$age" -lt "$duration" ]
}

# ===========================================
# 区域 6: 网络请求
# ===========================================

curl_bili() {
    local url="$1"
    shift
    local headers=(
        "User-Agent: $USER_AGENT"
        "Referer: https://www.bilibili.com"
        "Origin: https://www.bilibili.com"
        "Accept: application/json, text/plain, */*"
        "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8"
        "Connection: keep-alive"
    )

    local curl_cmd=("curl" "-s" "--connect-timeout" "$API_TIMEOUT" "--max-time" "$((API_TIMEOUT * 2))")

    if [ -f "$COOKIE_FILE" ] && [ -s "$COOKIE_FILE" ]; then
        curl_cmd+=("-b" "$COOKIE_FILE" "-c" "$COOKIE_FILE")
    fi

    for header in "${headers[@]}"; do
        curl_cmd+=("-H" "$header")
    done

    if [ -n "$API_RETRY" ] && [ "$API_RETRY" -gt 0 ]; then
        curl_cmd+=("--retry" "$API_RETRY")
    fi

    if [ -n "$HTTP_PROXY" ]; then
        curl_cmd+=("--proxy" "$HTTP_PROXY")
    fi

    curl_cmd+=("$@" "$url")

    "${curl_cmd[@]}"
}

show_qr() {
    local url="$1"
    if command -v qrencode &>/dev/null; then
        echo ""
        qrencode -t ANSI256UTF8 -s 1 -m 2 "$url"
        echo ""
    else
        echo -e "\n${YELLOW}请访问以下链接扫码登录:${NC}"
        echo "$url"
        echo ""
    fi
}

# ===========================================
# 区域 7: 数据解析（jqx 函数）
# ===========================================

jqx_video_detail() {
    local res="$1"
    echo "$res" | jq -r '
        .data | "\(.bvid)\t\(.title)\t\(.pic)\t\(.owner.name)\t\(.stat.view)\t\(.stat.like)\t\(.stat.favorite)\t\(.pubdate)"
    ' 2>/dev/null | sed 's/http:/https:/g'
}

jqx_up_detail() {
    local res="$1"
    echo "$res" | jq -r '
        .data | "\(.mid)\t\(.name)\t\(.sign)\t\(.fans)\t\(.level)\t\(.official.title)\t\(.vip.label.text)\t\(.face)"
    ' 2>/dev/null | sed 's/http:/https:/g'
}

jqx_up_videos() {
    local res="$1"
    echo "$res" | jq -r '
        .data.list.vlist[] | "\(.bvid)\t\(.title)\t\(.pic)\t\(.author)\t\(.play)\t\(.comment)\t\(.review)\t\(.created)"
    ' 2>/dev/null | sed 's/http:/https:/g'
}

jqx_up_videos_total() {
    local res="$1"
    echo "$res" | jq -r '.data.page.count // 0'
}

jqx_up_search() {
    local res="$1"
    echo "$res" | jq -r '.data.result[] | "\(.mid)\t\(.uname)\t\(.usign // "")\t\(.fans // 0)\t\(.videos // 0)\t\(.upic // "")"' 2>/dev/null | sed 's#^//#https://#' | grep -v "^$"
}

jqx_videos() {
    local res="$1"
    echo "$res" | jq -r '.data.result[] | select(.result_type == "video") | .data[] | "\(.bvid // "")\t\(.title // "")\t\(.pic // "")\t\(.author // .uname // "")\t\(.play // 0)\t\(.video_review // .review // 0)\t\(.favorites // 0)\t\(.pubdate // 0)"' 2>/dev/null | sed -e 's/<[^>]*>//g' -e 's/http:/https:/g' | grep -v "^$"
}

jqx_recommend() {
    local res="$1"
    echo "$res" | jq -r '
        if .data.item then .data.item[] | "\(.bvid // "")\t\(.title // "")\t\(.pic // "")\t\(.owner.name // "")\t\(.stat.view // 0)\t\(.stat.like // 0)\t-\t\(.pubdate // 0)"
        elif .data then .data[] | "\(.bvid // "")\t\(.title // "")\t\(.pic // "")\t\(.owner.name // "")\t\(.stat.view // 0)\t\(.stat.like // 0)\t-\t\(.pubdate // 0)"
        else "" end
    ' 2>/dev/null | grep -v "^$" | sed 's/http:/https:/g'
}

jqx_popular() {
    local res="$1"
    echo "$res" | jq -r '
        .data.list[] | "\(.bvid)\t\(.title)\t\(.pic)\t\(.owner.name)\t\(.stat.view)\t\(.stat.like // 0)\t\(.stat.favorite // 0)\t\(.pubdate // 0)"
    ' 2>/dev/null | grep -v "^$" | sed 's/http:/https:/g'
}

jqx_history() {
    local res="$1"
    echo "$res" | jq -r '
        .data[] | "\(.bvid // "")\t\(.title // "")\t\(.pic // "")\t\(.owner.name // "")\t\(.view_at // 0)\t0\t0\t0"
    ' 2>/dev/null | grep -v "^$" | sed 's/http:/https:/g'
}

jqx_watchlater() {
    local res="$1"
    echo "$res" | jq -r '
        .data.list[] | "\(.bvid // "")\t\(.title // "")\t\(.pic // "")\t\(.owner.name // "")\t0\t0\t0\t0"
    ' 2>/dev/null | grep -v "^$" | sed 's/http:/https:/g'
}

jqerr() {
    local res="$1"
    local code
    code=$(echo "$res" | jq -r '.code // -1')

    local message
    message=$(echo "$res" | jq -r '.message // "未知错误"')

    if [ "$code" != "0" ]; then
        echo "ERROR:$message"
        return 1
    fi
    return 0
}

# ===========================================
# 区域 8: 数据获取（fetch 函数）
# ===========================================

_fetch_recommend() {
    local page_size="$1"
    local res
    local retry=0
    while [ $retry -lt $DEFAULT_MAX_RETRY ]; do
        res=$(curl_bili "${API_RECOMMEND}?ps=${page_size}")
        if validate_json "$res"; then
            break
        fi
        retry=$((retry + 1))
        sleep 1
    done
    if [ $retry -eq $DEFAULT_MAX_RETRY ]; then
        return 1
    fi
    jqx_recommend "$res"
}

fetch_recommend() {
    _fetch_recommend "${RECOMMEND_PAGE_SIZE:-20}"
}

fetch_popular() {
    local page_size="${POPULAR_PAGE_SIZE:-20}"
    local res
    res=$(curl_bili "${API_POPULAR}?ps=${page_size}")
    validate_json "$res" || return 1
    jqx_popular "$res"
}

fetch_videos() {
    local keyword="$1"
    local res
    keyword=$(urlencode "$keyword")
    local page_size="${SEARCH_PAGE_SIZE:-20}"

    res=$(curl_bili "${API_VIDEO_SEARCH}?keyword=${keyword}&page=1&page_size=${page_size}")
    validate_json "$res" || {
        echo -e "${RED}搜索视频失败，请检查网络连接${NC}" >&2
        return 1
    }
    jqx_videos "$res"
}

_fetch_api() {
    local url="$1"
    local jqx_func="$2"
    local err_msg="${3:-请求失败}"
    local res
    res=$(curl_bili "$url")
    validate_json "$res" || {
        echo "ERROR:${err_msg}"
        return 1
    }
    local code
    code=$(echo "$res" | jq -r '.code // -1')
    if [ "$code" != "0" ]; then
        local message
        message=$(echo "$res" | jq -r '.message // "未知错误"')
        echo "ERROR:${err_msg}: $message"
        return 1
    fi
    "$jqx_func" "$res"
}

fetch_history() {
    _fetch_api "${API_HISTORY}?ps=20" "jqx_history" "获取历史记录失败"
}

fetch_watchlater() {
    _fetch_api "$API_WATCHLATER" "jqx_watchlater" "获取稍后观看失败"
}

fetch_up_search() {
    local keyword="$1"
    keyword=$(urlencode "$keyword")
    _fetch_api "${API_UP_SEARCH}?search_type=bili_user&keyword=${keyword}&page=1&page_size=20" "jqx_up_search" "搜索UP主失败"
}

fetch_up_videos() {
    local mid="$1"
    local page="${2:-1}"
    local page_size="${UP_DETAIL_PAGE_SIZE:-30}"
    if [ -z "$mid" ]; then
        echo -e "${RED}缺少UP主ID${NC}"
        return 1
    fi
    _fetch_api "${API_UP_VIDEOS}?mid=${mid}&pn=${page}&ps=${page_size}&order=pubdate" "jqx_up_videos" "获取UP主视频失败"
}

add_to_watchlater() {
    local bvid="$1"
    local csrf
    local res
    local code
    local msg
    if [ -z "$bvid" ]; then
        echo -e "${RED}缺少视频BV号${NC}"
        return 1
    fi

    if [ ! -f "$COOKIE_FILE" ] || [ ! -s "$COOKIE_FILE" ]; then
        echo -e "${RED}请先登录后再操作${NC}"
        return 1
    fi

    chmod 600 "$COOKIE_FILE" 2>/dev/null

    csrf=$(grep "bili_jct" "$COOKIE_FILE" | awk '{print $7}' | head -1)
    if [ -z "$csrf" ]; then
        csrf=$(grep "bili_jct" "$COOKIE_FILE" | cut -f5 | head -1)
    fi

    res=$(curl_bili "https://api.bilibili.com/x/v2/history/toview/add" \
        -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "bvid=${bvid}&csrf=${csrf}")
    code=$(echo "$res" | jq -r '.code // -1')
    if [ "$code" = "0" ]; then
        echo -e "${GREEN}已添加到稍后观看${NC}"
        sleep 2
    else
        msg=$(echo "$res" | jq -r '.message // "未知错误"')
        echo -e "${RED}添加失败: $msg${NC}"
    fi
}

# ===========================================
# 区域 9: 预览处理
# ===========================================

preview_video() {
    local line="$1"
    local bvid title pic_url author views likes favorites pubdate
    IFS=$'\t' read -r bvid title pic_url author views likes favorites pubdate <<<"$line"

    echo -e "${YELLOW}标题:${NC} $title"
    echo -e "${BLUE}UP主:${NC} $author"
    echo -e "${GREEN}播放:${NC} $(format_number "$views")"
    echo -e "${RED}点赞:${NC} $(format_number "$likes")"
    echo -e "${PURPLE}收藏:${NC} $([ "$favorites" = "-" ] && echo "-" || format_number "$favorites")"
    echo -e "${CYAN}发布日期:${NC} $(timestamp_to_date "$pubdate")"

    echo ""

    if [ "$ENABLE_PREVIEW" = "true" ] && [ -n "$pic_url" ] && [ "$pic_url" != "null" ] && [[ "$pic_url" == http* ]]; then
        local cache_key
        cache_key=$(cache_key_hash "$pic_url")
        local image_cache="$CACHE_DIR/images/$cache_key.jpg"
        mkdir -p "$CACHE_DIR/images"
        if [ ! -f "$image_cache" ]; then
            curl -s -H "User-Agent: $USER_AGENT" "$pic_url" -o "$image_cache" 2>/dev/null
        fi
        if [ -f "$image_cache" ]; then
            chafa -s "${FZF_PREVIEW_COLUMNS:-$DEFAULT_PREVIEW_COLUMNS_VIDEO}x${FZF_PREVIEW_LINES:-$DEFAULT_PREVIEW_LINES_VIDEO}" "$image_cache"
        else
            echo "无封面"
        fi
    else
        echo "无封面"
    fi
}

preview_up() {
    local line="$1"

    local mid uname usign fans videos upic
    mid=$(echo "$line" | cut -d$'\t' -f1)
    uname=$(echo "$line" | cut -d$'\t' -f2)
    usign=$(echo "$line" | cut -d$'\t' -f3)
    fans=$(echo "$line" | cut -d$'\t' -f4)
    videos=$(echo "$line" | cut -d$'\t' -f5)
    upic=$(echo "$line" | cut -d$'\t' -f6)

    echo -e "${YELLOW}UP主:${NC} $uname"
    echo -e "${BLUE}MID:${NC} $mid"
    echo -e "${GREEN}粉丝:${NC} $(format_number "$fans")"
    echo -e "${RED}视频数:${NC} $(format_number "$videos")"

    if [ -n "$usign" ] && [ "$usign" != "null" ] && [ "$usign" != "" ]; then
        echo -e "${CYAN}签名:${NC} $usign"
    fi

    echo ""

    if [ "$ENABLE_PREVIEW" = "true" ] && [ -n "$upic" ] && [ "$upic" != "null" ] && [[ "$upic" == http* ]]; then
        curl -s -H "User-Agent: $USER_AGENT" "$upic" 2>/dev/null |
            chafa -s "${FZF_PREVIEW_COLUMNS:-$DEFAULT_PREVIEW_COLUMNS_UP}x${FZF_PREVIEW_LINES:-$DEFAULT_PREVIEW_LINES_UP}" -
    else
        echo "无头像"
    fi
}

preview_handler() {
    local line="$1"
    local preview_type="$2"

    case "$preview_type" in
    "video") preview_video "$line" ;;
    "up") preview_up "$line" ;;
    *) echo "未知预览类型" ;;
    esac
}

# ===========================================
# 区域 10: 登录相关
# ===========================================

check_login() {
    local res
    res=$(curl_bili "${API_NAV}" 2>/dev/null)

    if ! validate_json "$res"; then
        echo -e "${YELLOW}未登录 (API响应异常)${NC}"
        return 1
    fi

    local is_login
    is_login=$(echo "$res" | jq -r '.data.isLogin' 2>/dev/null)

    if [ "$is_login" = "true" ]; then
        local uname
        uname=$(echo "$res" | jq -r '.data.uname' 2>/dev/null)
        echo -e "${GREEN}已登录: $uname${NC}"
        return 0
    else
        echo -e "${YELLOW}未登录 ${NC}"
        return 1
    fi
}

do_login() {
    if [ -f "$COOKIE_FILE" ] && [ -s "$COOKIE_FILE" ]; then
        local res
        res=$(curl_bili "${API_NAV}" 2>/dev/null)
        if validate_json "$res"; then
            local is_login
            is_login=$(echo "$res" | jq -r '.data.isLogin // "false"' 2>/dev/null)
            if [ "$is_login" = "true" ]; then
                echo -e "${GREEN}已登录，无需重复登录${NC}"
                return 0
            fi
        fi
    fi

    : >"$COOKIE_FILE"
    chmod 600 "$COOKIE_FILE"
    echo "正在获取登录二维码..."

    local qr_res
    qr_res=$(curl -s -c "$COOKIE_FILE" \
        -H "User-Agent: $USER_AGENT" \
        -H "Referer: https://www.bilibili.com" \
        "${API_LOGIN_QR_GENERATE}")

    if ! validate_json "$qr_res"; then
        echo -e "${RED}错误: API返回无效响应${NC}"
        return 1
    fi

    local code
    code=$(echo "$qr_res" | jq -r '.code // 1')
    if [ "$code" != "0" ]; then
        echo -e "${RED}错误: 获取二维码失败 (code: $code)${NC}"
        return 1
    fi

    local qr_url
    qr_url=$(echo "$qr_res" | jq -r '.data.url // "null"')
    local qr_key
    qr_key=$(echo "$qr_res" | jq -r '.data.qrcode_key // "null"')

    if [ -z "$qr_url" ] || [ "$qr_url" = "null" ] || [ -z "$qr_key" ]; then
        echo -e "${RED}错误: 无法获取二维码信息${NC}"
        return 1
    fi

    echo -e "${GREEN}获取二维码成功${NC}"
    show_qr "$qr_url"
    echo -e "${YELLOW}请使用 Bilibili 手机端扫码登录${NC}"
    echo -e "${BLUE}提示: 扫码后需要在手机上确认登录${NC}"
    echo ""

    echo -n "等待扫码"
    local poll_count=0
    local max_poll=$DEFAULT_MAX_POLL

    while [ $poll_count -lt $max_poll ]; do
        sleep 3
        poll_count=$((poll_count + 1))

        local poll_res
        poll_res=$(curl -s -b "$COOKIE_FILE" -c "$COOKIE_FILE" \
            -H "User-Agent: $USER_AGENT" \
            -H "Referer: https://www.bilibili.com" \
            "${API_LOGIN_QR_POLL}?qrcode_key=$qr_key")

        if ! validate_json "$poll_res"; then
            echo -n "!"
            continue
        fi

        local poll_code
        poll_code=$(echo "$poll_res" | jq -r '.code // 1')
        local data_code
        data_code=$(echo "$poll_res" | jq -r '.data.code // 86101')

        if [ "$poll_code" != "0" ]; then
            echo -n "?"
            continue
        fi

        case $data_code in
        0)
            echo -e "\n${GREEN}登录成功！${NC}"
            echo -e "${GREEN}Cookie 已保存至 $COOKIE_FILE${NC}"
            if check_login; then
                LOGIN_STATUS="true"
                return 0
            else
                echo -e "${YELLOW}登录状态未确认${NC}"
                LOGIN_STATUS="false"
                return 1
            fi
            ;;
        86038)
            echo -e "\n${RED}二维码已失效${NC}"
            return 1
            ;;
        86090)
            [ $poll_count -eq 2 ] && echo -e "\n${GREEN}已扫码，请确认${NC}"
            echo -n "✓"
            ;;
        86101) echo -n "." ;;
        *) echo -n "?" ;;
        esac
    done
    echo -e "\n${YELLOW}扫码超时${NC}"
    return 1
}

_init_login_status() {
    if [ -f "$COOKIE_FILE" ] && [ -s "$COOKIE_FILE" ]; then
        local res
        res=$(curl_bili "${API_NAV}" 2>/dev/null)
        if validate_json "$res"; then
            local is_login
            is_login=$(echo "$res" | jq -r '.data.isLogin // false' 2>/dev/null)
            if [ "$is_login" = "true" ]; then
                LOGIN_STATUS="true"
                return 0
            fi
        fi
    fi
    LOGIN_STATUS="false"
    return 1
}

# ===========================================
# 区域 11: FZF 界面
# ===========================================

_fetch_data_by_mode() {
    local mode="$1"
    local query="$2"

    case $mode in
    rec) fetch_recommend ;;
    popular) fetch_popular ;;
    search) fetch_videos "$query" ;;
    history) fetch_history ;;
    watchlater) fetch_watchlater ;;
    up_videos) fetch_up_videos "$query" ;;
    up_search) fetch_up_search "$query" ;;
    *) return 1 ;;
    esac
}

run_fzf_video_list() {
    local mode="$1"
    local query="$2"

    local prompt

    case $mode in
    rec) prompt="推荐视频" ;;
    popular) prompt="热门视频" ;;
    search) prompt="搜索: $query" ;;
    history) prompt="历史记录" ;;
    watchlater) prompt="稍后观看" ;;
    up_videos) prompt="UP主视频" ;;
    *) return 1 ;;
    esac

    local cache_key
    cache_key="${mode}_$(cache_key_hash "$query")"
    local cache_file="$CACHE_DIR/$cache_key"

    local key_play="${KEY_PLAY:-enter}"
    local key_play_all="${KEY_PLAY_ALL:-alt-enter}"
    local key_download="${KEY_DOWNLOAD:-ctrl-d}"
    local key_refresh="${KEY_REFRESH:-ctrl-r}"
    local key_watchlater="${KEY_WATCHLATER:-ctrl-w}"

    local out

    if is_cache_valid "$cache_file" "${CACHE_DURATION:-3600}"; then
        out=$(cat "$cache_file")
    else
        out=$(_fetch_data_by_mode "$mode" "$query" 2>/dev/null)
        if [ -n "$out" ]; then
            echo "$out" >"$cache_file"
        fi
    fi

    while true; do
        if echo "$out" | grep -q "^ERROR:"; then
            local error_msg
            error_msg=$(echo "$out" | sed 's/^ERROR://')
            echo -e "${RED}获取数据失败: $error_msg${NC}"
            read -p "按回车键继续..."
            return 1
        fi

        if [ -z "$out" ]; then
            echo -e "${RED}获取数据失败，请检查网络连接${NC}"
            read -p "按回车键继续..."
            return 1
        fi

        local filtered_out
        filtered_out=$(echo "$out" | awk -F'\t' '{if ($1 != "" && $2 != "") print $0}')

        local fzf_out
        fzf_out=$(echo "$filtered_out" |
            fzf --ansi --style full \
                --color="$FZF_COLOR" \
                --delimiter=$'\t' \
                --with-nth=2 \
                --border \
                --prompt="❯ " \
                --header="BiliTerm - $prompt" \
                --layout=reverse \
                --preview "bash \"$0\" --preview video {}" \
                --preview-window="right:${PREVIEW_WIDTH:-50%}:wrap" \
                --expect="$key_play_all" \
                --bind "esc:abort" \
                --bind '?:change-preview-window:hidden|right' \
                --bind "$key_refresh:execute-silent(rm -f \"$cache_file\")+reload(bash \"$0\" --fetch-mode \"$mode\" \"$query\")" \
                --bind "$key_download:execute(echo -e '${YELLOW}正在下载...${NC}'; yt-dlp --cookies \"$COOKIE_FILE\" -o \"$DOWNLOAD_DIR/%(title)s.%(ext)s\" 'https://www.bilibili.com/video/{1}'; read -p '按回车键继续...')" \
                --bind "$key_watchlater:execute(echo -e '${YELLOW}正在添加到稍后观看...${NC}'; bash \"$0\" --add-watchlater {1}; read -p '按回车键继续...')" \
                --bind "$key_play:accept" 2>/dev/null)

        if [ -z "$fzf_out" ]; then break; fi

        local key
        local selected
        key=$(echo "$fzf_out" | head -n1)
        selected=$(echo "$fzf_out" | tail -n +2)

        if [ "$key" = "$key_play_all" ]; then
            if [ -s "$cache_file" ]; then
                echo -e "${GREEN}正在准备播放列表...${NC}"
                local playlist_file="$CACHE_DIR/playlist.m3u"
                : >"$playlist_file"

                awk -F'\t' '{print "https://www.bilibili.com/video/" $1}' "$cache_file" >"$playlist_file"

                local count
                count=$(wc -l <"$playlist_file")
                echo -e "${CYAN}已加载 $count 个视频到播放列表${NC}"

                if [ -f "$COOKIE_FILE" ] && [ -s "$COOKIE_FILE" ]; then
                    $VIDEO_PLAYER $PLAYER_ARGS --playlist="$playlist_file" --ytdl-raw-options="cookies=\"$COOKIE_FILE\""
                else
                    $VIDEO_PLAYER $PLAYER_ARGS --playlist="$playlist_file"
                fi
            else
                echo -e "${RED}列表为空${NC}"
                sleep 1
            fi
            continue
        fi

        if [ -n "$selected" ]; then
            local bvid
            bvid=$(echo "$selected" | cut -d$'\t' -f1)
            echo -e "${GREEN}正在启动 $VIDEO_PLAYER 播放: $bvid ${NC}"
            if [ -f "$COOKIE_FILE" ] && [ -s "$COOKIE_FILE" ]; then
                $VIDEO_PLAYER $PLAYER_ARGS --ytdl-raw-options="cookies=\"$COOKIE_FILE\"" "https://www.bilibili.com/video/$bvid" 2>/dev/null
            else
                $VIDEO_PLAYER $PLAYER_ARGS "https://www.bilibili.com/video/$bvid" 2>/dev/null
            fi
        else
            break
        fi
    done
}

run_fzf_up_search() {
    local keyword="$1"

    echo -e "${YELLOW}正在搜索UP主: $keyword${NC}"

    local cache_key
    cache_key="up_search_$(cache_key_hash "$keyword")"
    local cache_file="$CACHE_DIR/$cache_key"

    while true; do
        local out
        if is_cache_valid "$cache_file" "${CACHE_DURATION:-3600}"; then
            out=$(cat "$cache_file")
        else
            out=$(fetch_up_search "$keyword" 2>/dev/null)
            if [ -n "$out" ]; then
                echo "$out" >"$cache_file"
            fi
        fi

        if echo "$out" | grep -q "^ERROR:"; then
            local error_msg
            error_msg=$(echo "$out" | sed 's/^ERROR://')
            echo -e "${RED}搜索失败: $error_msg${NC}"
            read -p "按回车键继续..."
            return 1
        fi

        if [ -z "$out" ]; then
            echo -e "${YELLOW}未找到相关UP主${NC}"
            read -p "按回车键继续..."
            return 1
        fi

        local filtered_out
        filtered_out=$(echo "$out" | awk -F'\t' '{if ($1 != "" && $2 != "") print $0}')

        local fzf_out
        fzf_out=$(echo "$filtered_out" |
            fzf --ansi --style full \
                --color="$FZF_COLOR" \
                --delimiter=$'\t' \
                --with-nth=2 \
                --border \
                --prompt="❯ " \
                --header="BiliTerm - UP主搜索" \
                --layout=reverse \
                --preview "bash \"$0\" --preview up {}" \
                --preview-window="right:${PREVIEW_WIDTH:-40%}:wrap" \
                --bind '?:change-preview-window:hidden|bottom|hidden|right' \
                --bind "ctrl-r:execute-silent(rm -f \"$cache_file\")+reload(bash \"$0\" --fetch-mode up_search \"$keyword\")" \
                --bind "enter:accept" \
                --bind "esc:abort" 2>/dev/null)

        if [ -z "$fzf_out" ]; then break; fi

        local mid
        mid=$(echo "$fzf_out" | cut -d$'\t' -f1)
        local uname
        uname=$(echo "$fzf_out" | cut -d$'\t' -f2)
        local videos
        videos=$(echo "$fzf_out" | cut -d$'\t' -f5)

        if [ -n "$mid" ]; then
            if [ "$videos" = "0" ] || [ -z "$videos" ]; then
                continue
            fi
            run_fzf_video_list "up_videos" "$mid"
        fi
    done
}

# ===========================================
# 区域 12: 菜单界面
# ===========================================

get_login_info() {
    if [ "$LOGIN_STATUS" = "true" ]; then
        echo "✓ 已登录"
        return 0
    fi
    echo "⚠ 未登录 "
    return 1
}

show_menu() {
    local login_info
    login_info=$(get_login_info)

    local menu_options=(
        "$MENU_RECOMMEND"
        "$MENU_POPULAR"
        "$MENU_SEARCH_VIDEO"
        "$MENU_SEARCH_UP"
        "$MENU_HISTORY"
        "$MENU_WATCHLATER"
        "$MENU_SETTINGS"
        "$MENU_LOGIN"
        "$MENU_ABOUT"
        "$MENU_EXIT"
    )

    local choice
    choice=$(
        printf '%s\n' "${menu_options[@]}" |
            fzf --ansi --style full \
                --color="$FZF_COLOR" \
                --border \
                --no-input \
                --prompt="❯ " \
                --pointer='❯' \
                --header="BiliTerm  $login_info" \
                --height=100% \
                --layout=reverse \
                --preview="echo -e '\n${CYAN}快捷键说明${NC}\n\n${YELLOW}主页:${NC}\n• [Enter] 选择功能\n• [Ctrl+R] 刷新状态\n \n${YELLOW}视频列表页:${NC}\n• [${KEY_PLAY:-enter}] 播放单个视频\n• [${KEY_PLAY_ALL:-alt-enter}] 播放当前列表\n• [${KEY_DOWNLOAD:-ctrl-d}] 下载视频\n• [${KEY_WATCHLATER:-ctrl+w}] 添加到稍后观看\n• [${KEY_REFRESH:-ctrl-r}] 刷新列表\n• [Esc] 返回上级\n\n${GREEN}预览窗口显示:${NC}\n• 视频标题/UP主/播放量\n• 点赞/收藏/发布日期\n• 弹幕/投币/视频时长'" \
                --preview-window="right:50%:wrap" \
                --bind '?:change-preview-window:hidden|bottom|hidden|right' \
                --bind "ctrl-r:reload(echo '正在刷新登录状态...'; login_info=\$(get_login_info); printf '%s\n' \"\${menu_options[@]}\")" \
                --bind "esc:abort"
    )

    echo "$choice"
}

search_video() {
    echo -e "${YELLOW}请输入搜索关键词（ESC返回）:${NC}"
    local key
    read -s -n 1 key
    if [[ "$key" == $'\e' ]]; then
        return
    fi
    local keyword="$key"
    read keyword
    if [ -n "$keyword" ]; then
        run_fzf_video_list "search" "$keyword"
    fi
}

search_up() {
    echo -e "${YELLOW}请输入UP主名称（ESC返回）:${NC}"
    local key
    read -s -n 1 key
    if [[ "$key" == $'\e' ]]; then
        return
    fi
    local keyword="$key"
    read keyword
    if [ -n "$keyword" ]; then
        run_fzf_up_search "$keyword"
    fi
}

show_settings() {
    local settings_options=(
        "$SETTINGS_OPEN_DIR"
        "$SETTINGS_EDIT_CONFIG"
        "$SETTINGS_RESET_CONFIG"
        "$SETTINGS_CLEAR_CACHE"
        "$SETTINGS_SYS_INFO"
        "$SETTINGS_BACK"
    )

    while true; do
        local choice
        choice=$(printf '%s\n' "${settings_options[@]}" |
            fzf --ansi --style full \
                --color="$FZF_COLOR" \
                --border \
                --prompt="设置 > " \
                --header="配置管理" \
                --height=100% \
                --layout=reverse \
                --preview="echo -e '\n${CYAN}当前配置信息${NC}\n\n${YELLOW}配置目录:${NC} $CONFIG_DIR\n${GREEN}缓存目录:${NC} $CACHE_BASE_DIR\n${PURPLE}下载目录:${NC} $DOWNLOAD_DIR\n${RED}用户代理:${NC} $USER_AGENT'" \
                --preview-window="down:wrap:40%" \
                --bind "esc:abort" 2>/dev/null)

        case "$choice" in
        *"$SETTINGS_OPEN_DIR"*)
            echo -e "${GREEN}打开配置目录: $CONFIG_DIR${NC}"
            if command -v xdg-open &>/dev/null; then
                xdg-open "$CONFIG_DIR" 2>/dev/null
            elif command -v open &>/dev/null; then
                open "$CONFIG_DIR" 2>/dev/null
            else
                echo -e "目录位置: $CONFIG_DIR"
            fi
            read -p "按回车键继续..."
            ;;
        *"$SETTINGS_EDIT_CONFIG"*)
            echo -e "${GREEN}编辑配置文件: $CONFIG_FILE${NC}"
            ${EDITOR:-vi} "$CONFIG_FILE"
            echo -e "${YELLOW}配置已更新，重启后生效${NC}"
            read -p "按回车键继续..."
            ;;
        *"$SETTINGS_RESET_CONFIG"*)
            echo -e "${RED}确认重置配置文件？(y/N):${NC}"
            read -n 1 confirm
            echo
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                rm -f "$CONFIG_FILE"
                load_config
                echo -e "${GREEN}配置文件已重置${NC}"
            fi
            read -p "按回车键继续..."
            ;;
        *"$SETTINGS_CLEAR_CACHE"*)
            echo -e "${YELLOW}确认清除所有缓存？(y/N):${NC}"
            read -n 1 confirm
            echo
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                rm -rf "${CACHE_BASE_DIR:?}"/*
                echo -e "${GREEN}缓存已清除${NC}"
            fi
            read -p "按回车键继续..."
            ;;
        *"$SETTINGS_SYS_INFO"*)
            echo -e "\n${CYAN}系统信息:${NC}"
            echo -e "${YELLOW}脚本版本:${NC} $BILI_TERM_VERSION"
            echo -e "${GREEN}配置目录:${NC} $CONFIG_DIR"
            echo -e "${BLUE}缓存目录:${NC} $CACHE_BASE_DIR"
            echo -e "${RED}Cookie文件:${NC} $COOKIE_FILE"
            echo -e "\n${CYAN}依赖检查:${NC}"
            for cmd in curl jq fzf chafa mpv yt-dlp; do
                if command -v "$cmd" &>/dev/null; then
                    echo -e "${GREEN}✓${NC} $cmd: $(which $cmd)"
                else
                    echo -e "${RED}✗${NC} $cmd: 未找到"
                fi
            done
            echo ""
            read -p "按回车键继续..."
            ;;
        *"$SETTINGS_BACK"* | "") break ;;
        *)
            echo "无效选择"
            sleep 1
            ;;
        esac
    done
}

show_about() {
    clear
    echo -e "${CYAN}"
    cat <<EOF
╔══════════════════════════════════════════╗
║           $BILI_TERM_NAME $BILI_TERM_VERSION               ║
║      终端中的 Bilibili 客户端            ║
╚══════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}功能特性:${NC}"
    echo -e "  ${GREEN}✓${NC} 视频推荐/热门/搜索"
    echo -e "  ${GREEN}✓${NC} UP主搜索与视频浏览"
    echo -e "  ${GREEN}✓${NC} 历史记录/稍后观看"
    echo -e "  ${GREEN}✓${NC} 扫码登录（支持大会员）"
    echo -e "  ${GREEN}✓${NC} 视频播放与下载"
    echo -e "  ${GREEN}✓${NC} 封面预览与详细信息"
    echo -e "  ${GREEN}✓${NC} XDG 配置规范支持"
    echo ""
    echo -e "${YELLOW}快捷键:${NC}"
    echo -e "  ${CYAN}Enter${NC}    播放选中视频"
    echo -e "  ${CYAN}Alt+Enter${NC} 播放当前列表"
    echo -e "  ${CYAN}Ctrl+D${NC}    下载视频"
    echo -e "  ${CYAN}Ctrl+R${NC}    刷新列表"
    echo -e "  ${CYAN}Esc${NC}       返回上级"
    echo ""
    echo -e "${YELLOW}配置目录:${NC} $CONFIG_DIR"
    echo -e "${YELLOW}缓存目录:${NC} $CACHE_BASE_DIR"
    echo ""
    echo -e "${BLUE}GitHub:${NC} $BILI_TERM_GITHUB"
    echo -e "${BLUE}反馈:${NC} $BILI_TERM_GITHUB/issues"
    echo ""
    read -p "按回车键返回主菜单..."
}

# ===========================================
# 区域 13: 主循环
# ===========================================

run_main_loop() {
    while true; do
        clear

        local choice
        choice=$(show_menu)
        if [ -z "$choice" ]; then
            exit 0
        fi

        case "$choice" in
        *"$MENU_RECOMMEND"*) run_fzf_video_list "rec" ;;
        *"$MENU_POPULAR"*) run_fzf_video_list "popular" ;;
        *"$MENU_SEARCH_VIDEO"*) search_video ;;
        *"$MENU_SEARCH_UP"*) search_up ;;
        *"$MENU_HISTORY"*) run_fzf_video_list "history" ;;
        *"$MENU_WATCHLATER"*) run_fzf_video_list "watchlater" ;;
        *"$MENU_SETTINGS"*) show_settings ;;
        *"$MENU_LOGIN"*)
            do_login
            read -p "按回车键继续..."
            ;;
        *"$MENU_ABOUT"*) show_about ;;
        *"$MENU_EXIT"*)
            exit 0
            ;;
        *)
            echo "无效选择"
            sleep 1
            ;;
        esac
    done
}

# ===========================================
# 区域 14: 启动画面
# ===========================================

startup() {
    printf '\033[?25l'
    local term_width term_height art_width art_height left_padding top_padding padding vpadding
    term_width=$(tput cols)
    term_height=$(tput lines)
    art_width=42
    art_height=17
    left_padding=$(((term_width - art_width) / 2))
    top_padding=$(((term_height - art_height) / 2))

    padding=$(printf "%*s" "$left_padding" "")
    vpadding=$(printf "%*s" "$top_padding" "")

    echo "$vpadding"
    echo -e "${CYAN}"
    cat <<"EOF" | sed "s/^/$padding/"

           ██████╗ ██╗██╗     ██╗
           ██╔══██╗██║██║     ██║
           ██████╔╝██║██║     ██║
           ██╔══██╗██║██║     ██║
           ██████╔╝██║███████╗██║
           ╚═════╝ ╚═╝╚══════╝╚═╝

        ████████╗███████╗██████╗ ███╗   ███╗
        ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
           ██║   █████╗  ██████╔╝██╔████╔██║
           ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
           ██║   ███████╗██║  ██║██║ ╚═╝ ██║
           ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝

             Bilibili Terminal Client
EOF
    echo -e "${NC}"
}

cleanup() {
    if [ -d "$CACHE_DIR" ]; then
        rm -rf "$CACHE_DIR" 2>/dev/null
    fi
}

# ===========================================
# 区域 15: CLI 参数处理
# ===========================================

# 预览/获取数据模式需要提前初始化变量
if [[ "$1" == "--preview" || "$1" == "--fetch-mode" || "$1" == "--fetch-cached" || "$1" == "--add-watchlater" ]]; then
    if [ -n "${HTTP_PROXY:-}" ]; then
        export http_proxy="$HTTP_PROXY"
        export HTTP_PROXY="$HTTP_PROXY"
    fi
    if [ -n "${HTTPS_PROXY:-}" ]; then
        export https_proxy="$HTTPS_PROXY"
        export HTTPS_PROXY="$HTTPS_PROXY"
    fi
    mkdir -p "$CACHE_DIR"
    mkdir -p "$DOWNLOAD_DIR"
    load_config
fi

if [ "${1:-}" = "--fetch-mode" ]; then
    mode="${2:-}"
    query="${3:-}"
    _fetch_data_by_mode "$mode" "$query"
    exit 0
fi

if [ "${1:-}" = "--fetch-cached" ]; then
    cache_key="${2:-}"
    cache_file="$CACHE_DIR/$cache_key"
    mode="${cache_key%%_*}"
    query="${cache_key#*_}"
    if [ "$query" = "$mode" ]; then
        query=""
    fi

    if [ ! -s "$cache_file" ]; then
        _fetch_data_by_mode "$mode" "$query" >"$cache_file" 2>/dev/null
    fi
    cat "$cache_file" 2>/dev/null
    exit 0
fi

if [ "${1:-}" = "--preview" ]; then
    preview_type="${2:-}"
    shift 2
    preview_handler "$*" "$preview_type"
    exit 0
fi

if [ "${1:-}" = "--add-watchlater" ]; then
    bvid="${2:-}"
    add_to_watchlater "$bvid"
    exit 0
fi

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    echo -e "${CYAN}Bili-Term 使用说明${NC}"
    echo ""
    echo "使用方法:"
    echo "  $0                    # 启动交互式界面"
    echo "  $0 --help             # 显示帮助信息"
    echo "  $0 --version          # 显示版本信息"
    echo "  $0 --config           # 显示配置信息"
    echo ""
    echo "配置目录: $CONFIG_DIR"
    echo "缓存目录: $CACHE_BASE_DIR"
    echo ""
    exit 0
fi

if [ "${1:-}" = "--version" ] || [ "${1:-}" = "-v" ]; then
    echo "$BILI_TERM_NAME $BILI_TERM_VERSION"
    exit 0
fi

if [ "${1:-}" = "--config" ]; then
    echo -e "${CYAN}配置信息:${NC}"
    echo "配置文件: $CONFIG_FILE"
    echo "Cookie文件: $COOKIE_FILE"
    echo "下载目录: $DOWNLOAD_DIR"
    echo "用户代理: $USER_AGENT"
    echo "播放器: $VIDEO_PLAYER"
    exit 0
fi

# ===========================================
# 区域 16: 程序入口
# ===========================================

if [ -n "${HTTP_PROXY:-}" ]; then
    export http_proxy="$HTTP_PROXY"
    export HTTP_PROXY="$HTTP_PROXY"
fi
if [ -n "${HTTPS_PROXY:-}" ]; then
    export https_proxy="$HTTPS_PROXY"
    export HTTPS_PROXY="$HTTPS_PROXY"
fi

mkdir -p "$CACHE_DIR"
mkdir -p "$DOWNLOAD_DIR"

trap 'cleanup' EXIT INT TERM

load_config

check_dependency

_init_login_status

clear
startup

sleep 0.3

run_main_loop