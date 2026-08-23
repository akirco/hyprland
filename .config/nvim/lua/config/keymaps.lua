local map = vim.keymap.set

-- 文件与搜索
map("n", "<C-p>", "<cmd>Telescope find_files cwd=%:p:h<cr>", { desc = "Find Files (cwd)" })
map("n", "<C-S-p>", "<cmd>Telescope find_files<cr>", { desc = "Find Files (root)" })
map("n", "<C-q>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in Buffer" })
map("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Global Search" })
map("n", "<C-S-o>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<C-r>", function()
  local grug = require("grug-far")
  local file = vim.fn.expand("%:p")
  grug.open({
    prefills = {
      paths = file,
    },
  })
end, { desc = "Search and Replace" })

-- 注释
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle Comment" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle Comment" })

-- 删除行
map("n", "<C-S-k>", "<cmd>normal! dd<cr>", { desc = "Delete Line" })

-- 插入空行
map("n", "<C-Enter>", "o<esc>", { desc = "Insert Line Below" })
map("n", "<C-S-Enter>", "O<esc>", { desc = "Insert Line Above" })

-- 删除单词
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Left" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete Word Right" })

-- 多光标
map("n", "<C-d>", "#``cgn", { desc = "Select Next Match" })
map("n", "<C-S-l>", "<cmd>Telescope grep_string<cr>", { desc = "Select All Occurrences" })

-- 缩进
map("v", "<C-[>", "<gv", { desc = "Outdent" })
map("v", "<C-]>", ">gv", { desc = "Indent" })
map("i", "<C-[>", "<C-d>", { desc = "Outdent" })
map("i", "<C-]>", "<C-t>", { desc = "Indent" })

-- 折叠
map("n", "<C-S-[>", "zc", { desc = "Fold" })
map("n", "<C-S-]>", "zo", { desc = "Unfold" })

-- 导航
map("n", "<C-Home>", "gg", { desc = "Go to Top" })
map("n", "<C-End>", "G", { desc = "Go to Bottom" })
map("i", "<C-Home>", "<C-o>gg", { desc = "Go to Top" })
map("i", "<C-End>", "<C-o>G", { desc = "Go to Bottom" })
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })

-- 终端 (toggle)
local function toggle_terminal()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  Snacks.terminal()
end

local function hide_terminal()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
end

map("n", "<C-`>", toggle_terminal, { desc = "Toggle Terminal" })
map("t", "<C-`>", hide_terminal, { desc = "Hide Terminal" })

-- 文件树
map("n", "<C-b>", "<cmd>Neotree toggle dir=%:p:h<cr>", { desc = "Toggle File Explorer" })

-- 新建文件
map("n", "<C-n>", "<cmd>enew | startinsert<cr>", { desc = "New File" })

-- 关闭 buffer
map("n", "<C-w>", "<cmd>BufDelete<cr>", { desc = "Close Buffer" })

-- 全选
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- 主题切换
map("n", "<C-h>", "<cmd>Telescope colorscheme enable_preview=true<cr>", { desc = "Colorscheme" })
