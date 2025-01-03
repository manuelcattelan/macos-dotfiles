return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "single",
      },
    },
    config = function(_, opts)
      local mason = require("mason")
      local mason_registry = require("mason-registry")

      mason.setup(opts)
      if mason_registry.refresh then
        mason_registry.refresh()
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      -- Configure diagnostics floating window
      vim.diagnostic.config({
        underline = false,
        float = {
          border = "single",
        },
        severity_sort = true,
        update_in_insert = false,
      })

      local servers = {
        lua_ls = {},
      }

      local handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

          require("lspconfig")[server_name].setup(server)
        end,
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers or {}),
        automatic_installation = false,
        handlers = handlers,
      })
    end,
  },
}
