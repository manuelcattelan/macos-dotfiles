-- Highlight text region after yanking (copying) it.
--   See `:help vim.highlight_on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight text region when yanking (copying)",
  group = vim.api.nvim_create_augroup("highlight-yank", {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Format current buffer on save.
--   See `:help lsp` and `:help vim.lsp.buf.format()`
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Format current buffer on save",
  group = vim.api.nvim_create_augroup("format-on-save", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then return end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end
      })
    end
  end,
})
