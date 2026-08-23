-- persist colorscheme choice
local colorscheme_file = vim.fn.stdpath("data") .. "/colorscheme.txt"

local function save_colorscheme(name)
  local f = io.open(colorscheme_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

local function load_colorscheme()
  local f = io.open(colorscheme_file, "r")
  if f then
    local name = f:read("*a")
    f:close()
    if name and name ~= "" and name:find("^bearded") then
      return name
    end
  end
  return "bearded"
end

-- autocmd to save colorscheme when changed (only bearded themes)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function(ev)
    if ev.match:find("^bearded") then
      save_colorscheme(ev.match)
    end
  end,
})

local saved_theme = load_colorscheme()

return {
  -- disable which-key
  { "folke/which-key.nvim", enabled = false },

  -- disable snacks picker (using telescope instead)
  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = false },
    },
  },

  -- disable default LazyVim colorschemes
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },

  -- bearded-nvim
  {
    "Ferouk/bearded-nvim",
    name = "bearded",
    priority = 10000,
    build = function()
      local doc = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "bearded", "doc")
      pcall(vim.cmd, "helptags " .. doc)
    end,
    config = function()
      local flavor = saved_theme:match("^bearded%-(.+)$") or "arc"
      require("bearded").setup({ flavor = flavor })
      vim.cmd.colorscheme(saved_theme)
    end,
  },

  -- tell LazyVim to use saved colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme(saved_theme)
      end,
    },
  },

  -- custom dashboard header
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
          ██      ████████    ██    ██
  ██        ██    ██          ██    ██
  ████      ██  ██            ██  ██
  ██  ██    ██  ████████    ██    ██
  ██  ██    ██  ██          ██    ██
██      ██  ██  ██          ██    ██
██        ████    ████████  ██      ████████
          ]],
        },
      },
    },
  },

  -- grug-far window at bottom, 30 lines height
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      windowCreationCommand = "botright 30split",
    },
  },

  -- neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hidden_files = true,
      },
    },
  },
}
