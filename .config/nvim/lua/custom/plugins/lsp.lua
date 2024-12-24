return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          {
            path = "${3rd}/luv/library",
            words = { "vim%.uv" }
          },
        },
      },
    }
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    require("lspconfig").lua_ls.setup {
      capabilities = capabilities
    }

    vim.diagnostic.config {
      underline = false,
      float = {
        border = "single"
      },
      severity_sort = true,
    }
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
    })
    require("lspconfig.ui.windows").default_options = {
      border = "single"
    }

    -- Faster diagnostics navigation by specifying the preferred diagnostic
    -- direction and severity to filter the current buffer's diagnostics.
    local goto_diagnostic = function(diagnostic_direction, diagnostic_severity)
      local go = diagnostic_direction == "next" and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
      local severity = diagnostic_severity and vim.diagnostic.severity[diagnostic_severity] or nil

      return function()
        go({ severity = severity })
      end
    end

    -- Open float window that shows the current line's diagnostic error, if present.
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

    -- Navigate current buffer's diagnostics with custom direction and filter options.
    vim.keymap.set("n", "[d", goto_diagnostic("prev"))
    vim.keymap.set("n", "]d", goto_diagnostic("next"))
    vim.keymap.set("n", "[w", goto_diagnostic("prev", "WARN"))
    vim.keymap.set("n", "]w", goto_diagnostic("next", "WARN"))
    vim.keymap.set("n", "[e", goto_diagnostic("prev", "ERROR"))
    vim.keymap.set("n", "]e", goto_diagnostic("next", "ERROR"))
  end
}
