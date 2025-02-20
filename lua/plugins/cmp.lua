return {
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-path" }, -- Completion engine for path
      { "hrsh7th/cmp-buffer" }, -- Completion engine for buffer
      { "hrsh7th/cmp-cmdline" }, -- Completion engine for CMD
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "saadparwaiz1/cmp_luasnip" },
      {
        "L3MON4D3/LuaSnip",
        build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        config = function(_, opts)
          if opts then
            require("luasnip").config.setup(opts)
          end
          vim.tbl_map(function(type)
            require("luasnip.loaders.from_" .. type).lazy_load()
          end, { "vscode", "snipmate" })
          -- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/Snippets/" }) -- friendly-snippets - enable standardized comments snippets
          require("luasnip").filetype_extend("typescript", { "tsdoc" })
          require("luasnip").filetype_extend("javascript", { "jsdoc" })
          require("luasnip").filetype_extend("lua", { "luadoc" })
          require("luasnip").filetype_extend("python", { "pydoc" })
          require("luasnip").filetype_extend("rust", { "rustdoc" })
          require("luasnip").filetype_extend("cs", { "csharpdoc" })
          require("luasnip").filetype_extend("java", { "javadoc" })
          require("luasnip").filetype_extend("c", { "cdoc" })
          require("luasnip").filetype_extend("cpp", { "cppdoc" })
          require("luasnip").filetype_extend("php", { "phpdoc" })
          require("luasnip").filetype_extend("kotlin", { "kdoc" })
          require("luasnip").filetype_extend("ruby", { "rdoc" })
          require("luasnip").filetype_extend("sh", { "shelldoc" })
        end,
        keys = {
          {
            "<tab>",
            function()
              return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
            end,
            expr = true,
            silent = true,
            mode = "i",
          },
          {
            "<tab>",
            function()
              require("luasnip").jump(1)
            end,
            mode = "s",
          },
          {
            "<s-tab>",
            function()
              require("luasnip").jump(-1)
            end,
            mode = { "i", "s" },
          },
        },
      }, -- Snippets manager
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local Icons = require("arrase.icons")

      local function borderMenu(hl_name)
        return {
          { "", "CmpBorderIconsLT" },
          { "─", hl_name },
          { "▼", "CmpBorderIconsCT" },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      local function borderDoc(hl_name)
        return {
          { "▲", "CmpBorderIconsCT" },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      local function Kinder(item)
        if item == "Function" then
          return "Fnc"
        elseif item == "Text" then
          return "Txt"
        elseif item == "Module" then
          return "Mdl"
        elseif item == "Snippet" then
          return "Snp"
        elseif item == "Variable" then
          return "Var"
        elseif item == "Folder" then
          return "Dir"
        elseif item == "Method" then
          return "Mth"
        elseif item == "Keyword" then
          return "Kwd"
        elseif item == "Constant" then
          return "Cst"
        elseif item == "Property" then
          return "Prp"
        elseif item == "Field" then
          return "Fld"
        else
          return item
        end
      end
      local winhighlightMenu = {
        border = borderMenu("CmpBorder"),
        scrollbar = true,
        scrolloff = 6,
        col_offset = -2,
        side_padding = 0,
        winhighlight = "Normal:CmpNormal,CursorLine:CursorLine",
      }

      local winhighlightDoc = {
        border = borderDoc("CmpBorderDoc"),
        col_offset = -1,
        side_padding = 0,
        scrollbar = false,
        max_width = 45,
        max_height = 15,
        winhighlight = "Normal:CmpNormal,CursorLine:CursorLine",
      }

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),

          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 3000 },
          { name = "luasnip", priority = 1000 },
          { name = "buffer", priority = 500 },
          { name = "codeium", priority = 500 },
          { name = "path", priority = 250 },
          { name = "treesitter", priority = 500 },
          {
            name = "latex_symbols",
            filetype = { "tex", "latex" },
            option = { cache = true, strategy = 2 }, -- avoids reloading each time
            priority = 500,
          },
        }),

        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
          format = function(entry, item)
            item.kind = string.format("%s-{%s}", Icons.kind_icons[item.kind], Kinder(item.kind))
            item.menu = ({
              nvim_lua = "{Lua}",
              nvim_lsp = "{Lsp}",
              luasnip = "{Snip}",
              buffer = "{Buff}",
              path = "{Path}",
              latex_symbols = "{TeX}",
              treesitter = "{TS}",
              codeium = "{AI}",
            })[entry.source.name]
            return item
          end,
        },

        view = {
          entries = { name = "custom" },
          docs = {
            auto_open = true,
          },
          separator = "|",
        },
        duplicates = {
          nvim_lsp = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },

        experimental = {
          ghost_text = { hl_group = "Ghost" },
        },
        window = {
          completion = winhighlightMenu,
          documentation = winhighlightDoc,
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
        },
        view = {
          entries = {
            name = "wildmenu",
            separator = "|",
          },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),

        view = {
          entries = {
            name = "cmdline",
            separator = " | ",
          },
        },
      })
    end,
  },
}
