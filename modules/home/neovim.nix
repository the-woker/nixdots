{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };
        opts = {
          tabstop = 4;
          autoindent = true;
        };
        ui.colorizer = {
          enable = true;

          setupOpts = {
            filetypes = {
              "*" = {
                RGB = true;
                RRGGBB = true;
                names = true;
                RRGGBBAA = true;
                css = true;
                css_fn = true;
              };

            };
          };
        };
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy.enable = true;
        };
        autocomplete.blink-cmp.enable = true;
        viAlias = false;
        vimAlias = true;
        lsp.enable = true;
        lsp.formatOnSave = true;
        autopairs.nvim-autopairs.enable = true;
        treesitter.indent.enable = false;
        languages = {
          enableTreesitter = true;
          clang = {
            enable = true;
            lsp.enable = true;
          };
          python = {
            enable = true;
            lsp.enable = true;
          };
          qml = {
            enable = true;
            lsp.enable = true;
          };
          nix = {
            enable = true;
            lsp.enable = true;
          };
        };
        keymaps = [
          {
            key = "<leader>w";
            mode = "n";
            silent = true;
            action = ":w<CR>";
          }

          {
            key = "<leader>q";
            mode = "n";
            silent = true;
            action = ":q<CR>";
          }

          {
            key = "<Tab>";
            mode = "n";
            silent = true;
            action = ">>";
          }

          {
            key = "<S-Tab>";
            mode = "n";
            silent = true;
            action = "<<";
          }
        ];
      };
    };
  };

}
