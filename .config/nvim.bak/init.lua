
vim.g.mapleader = " "         -- 将 <Space> (空格键) 设置为主键 (Leader key)
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true             -- 显示绝对行号
opt.relativenumber = true     -- 显示相对行号（方便上下跳跃）
opt.cursorline = true         -- 高亮当前光标所在行
opt.termguicolors = true      -- 开启 24 位真彩色支持
opt.signcolumn = "yes"        -- 始终显示标志列（避免后续加插件时屏幕抖动）

opt.tabstop = 4               -- 1 个 Tab 显示为 4 个空格的宽度
opt.shiftwidth = 4            -- 每次缩进 4 个空格
opt.expandtab = true          -- 将 Tab 自动转换为空格
opt.smartindent = true        -- 智能自动缩进

opt.ignorecase = true         -- 搜索时默认忽略大小写
opt.smartcase = true          -- 如果搜索词包含大写字母，则精确匹配大小写
opt.incsearch = true          -- 输入搜索词时实时高亮匹配项

opt.clipboard = "unnamedplus" -- 默认使用系统剪贴板（可以直接 Ctrl+C / Ctrl+V 与外部交互）
opt.wrap = false              -- 禁止长行自动折行
opt.scrolloff = 8             -- 光标上下方始终保留 8 行可见，避免光标贴边
opt.updatetime = 250          -- 降低更新时间，加快响应速度

local map = vim.keymap.set

map("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
map("n", "<leader>q", ":q<CR>", { desc = "退出" })
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "清除搜索高亮" })

map("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "将选中文本向下移动" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "将选中文本向上移动" })

vim.api.nvim_set_hl(0, "StatusLine", {
    fg = "#b4b9b7",   -- 纯白文字
    bg = "#101113",   -- 深海蓝色背景 (你可以换成自己喜欢的十六进制颜色)
    bold = true
})

vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = "#9e9e9e",   -- 灰色文字
    bg = "#303030",   -- 深灰色背景
    bold = false
})


vim.api.nvim_create_autocmd("FileType", {
    callback = function()
     pcall(vim.treesitter.start)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*", -- 针对所有文件类型（如果该文件类型支持 LSP 格式化）
    callback = function()
        vim.lsp.buf.format({
            async = false,
            timeout_ms = 1000
        })
    end,
})

