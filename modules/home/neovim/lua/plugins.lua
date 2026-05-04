require("which-key").setup({})
require("gitsigns").setup({})
require("lualine").setup({
  options = {
    theme = "tokyonight",
    globalstatus = true,
  },
})

require("telescope").setup({})

require("blink.cmp").setup({
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  keymap = {
    preset = "default",
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("nil_ls", { capabilities = capabilities })
vim.lsp.enable("nil_ls")

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})
vim.lsp.enable("lua_ls")

vim.g.rustaceanvim = {
  server = {
    capabilities = capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require("nvim-treesitter").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

require("conform").setup({
  formatters_by_ft = {
    rust = { "rustfmt" },
  },
  format_on_save = function(_)
    return { timeout_ms = 1000, lsp_fallback = true }
  end,
})

require("crates").setup({})