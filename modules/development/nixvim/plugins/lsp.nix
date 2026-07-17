# LSP - Language Server Protocol configuration (nvim-lspconfig)
{ config, lib, ... }:
{
  config.programs.nixvim.plugins.lsp = lib.mkIf config.development.nixvim.enable {
    enable = true;
    inlayHints = true;
    autoLoad = true;

    keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };

    servers = {
      # -- System & Configuration --
      nixd = {
        enable = true;
        package = null;
      }; # Nix
      bashls = {
        enable = true;
        package = null;
      }; # Bash/Shell
      taplo = {
        enable = true;
        package = null;
      }; # TOML
      yamlls = {
        enable = true;
        package = null;
      }; # YAML
      jsonls = {
        enable = true;
        package = null;
      }; # JSON
      marksman = {
        enable = true;
        package = null;
      }; # Markdown

      # -- Web Development (HTML/CSS/JS/TS) --
      html = {
        enable = true;
        package = null;
      }; # HTML
      cssls = {
        enable = true;
        package = null;
      }; # CSS/SCSS/LESS
      tailwindcss = {
        enable = true;
        package = null;
      }; # Tailwind CSS
      vtsls = {
        # JS/TS (Modern fast wrapper for tsserver)
        enable = true;
        package = null;
        settings = {
          # Optional but recommended: stops huge generic types from taking over your screen
          vtsls.experimental.maxInlayHintLength = 30;

          # TypeScript type inferences
          typescript.inlayHints = {
            parameterNames.enabled = "all";
            parameterTypes.enabled = true;
            variableTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            functionLikeReturnTypes.enabled = true;
            enumMemberValues.enabled = true;
          };

          # JavaScript type inferences (via JSDoc)
          javascript.inlayHints = {
            parameterNames.enabled = "all";
            parameterTypes.enabled = true;
            variableTypes.enabled = true;
            propertyDeclarationTypes.enabled = true;
            functionLikeReturnTypes.enabled = true;
            enumMemberValues.enabled = true;
          };
        };
      };
      eslint = {
        enable = true;
        package = null;
      }; # ESLint diagnostics/formatting

      # -- Web Frameworks --
      volar = {
        # Vue
        enable = true;
        package = null;
        tslsIntegration = false;
      };
      svelte = {
        enable = true;
        package = null;
      }; # Svelte
      astro = {
        enable = true;
        package = null;
      }; # Astro

      # -- Scripting & High-Level Languages --
      basedpyright = {
        # Python (Modern, faster fork of Pyright)
        enable = true;
        package = null;
        settings.basedpyright.analysis.inlayHints = {
          variableTypes = true;
          callArgumentNames = true;
          functionReturnTypes = true;
          genericTypes = false; # can get noisy, opt-in
        };
      };
      ruff = {
        enable = true;
        package = null;
      }; # Python (Ultra-fast linter/formatter)
      ruby_lsp = {
        enable = true;
        package = null;
      }; # Ruby (Shopify's modern standard)
      lua_ls = {
        # Lua
        enable = true;
        package = null;
        settings.Lua.hint = {
          enable = true;
          arrayIndex = "Auto";
          setType = true;
          paramName = "All";
          paramType = true;
        };
      };
      intelephense = {
        enable = true;
        package = null;
      }; # PHP
      elixirls = {
        enable = true;
        package = null;
      }; # Elixir

      # -- Systems, Compiled, & Enterprise --
      clangd = {
        enable = true;
        package = null;
      }; # C/C++ (inlay hints on by default)
      rust_analyzer = {
        # Rust (inlay hints on by default)
        enable = true;
        package = null;
        installCargo = false;
        installRustc = false;
      };
      gopls = {
        # Go
        enable = true;
        package = null;
        settings.gopls.hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
      zls = {
        enable = true;
        package = null;
      }; # Zig (inlay hints on by default)
      jdtls = {
        # Java
        enable = true;
        package = null;
        settings.java.inlayHints.parameterNames.enabled = "all";
      };
      kotlin_language_server = {
        enable = true;
        package = null;
      }; # Kotlin
      csharp_ls = {
        enable = true;
        package = null;
      }; # C# (.NET) — no inlay hint support
      hls = {
        # Haskell
        enable = true;
        package = null;
        installGhc = false;
        settings.haskell.plugin."inlay-hints".globalOn = true;
      };
      ocamllsp = {
        enable = true;
        package = null;
      }; # OCaml

      # -- Infrastructure & DevOps --
      dockerls = {
        enable = true;
        package = null;
      }; # Dockerfile
      docker_compose_language_service = {
        enable = true;
        package = null;
      }; # Docker Compose
      terraformls = {
        enable = true;
        package = null;
      }; # Terraform/HCL

      # -- Data & APIs --
      sqlls = {
        enable = true;
        package = null;
      }; # SQL
      graphql = {
        enable = true;
        package = null;
      }; # GraphQL
      prismals = {
        enable = true;
        package = null;
      }; # Prisma ORM
    };
  };
}
