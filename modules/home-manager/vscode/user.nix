# This file is used to configure the user environment for the VSCode extension.

{ ... }:

{
  programs.vscode.profiles.vue = {
    languageSnippets = {
      scss = {
        "unocss at-apply css variable" = {
          prefix = "at";
          body = "--at-apply: $1;";
          description = "Unocss at-apply css variable style";
          isFileTemplate = false;
        };
      };

      typescript = {
        # #region Vue
        "Vue3 define props" = {
          prefix = "props";
          body = [ "const props = defineProps({" "\t$1" "})" ];
          description = "Vue declare props";
        };
        "Vue3 define props with types" = {
          prefix = "props";
          body = [ "const props = defineProps<{" "\t$1" "}>()" ];
          description = "Vue declare props";
        };
        "Vue3 define emits" = {
          prefix = "emits";
          body = [ "const emit = defineEmits<{" "\t(event: '$1'): void" "}>()" ];
          description = "Vue declare emits";
        };
        "Vue component export" = {
          prefix = "component";
          body = [ "import component from './index.vue'" "" "export default component" ];
          description = "Vue component export";
        };
        # #endregion
      };

      vue = {
        "vue3 sfc basic skeleton" = {
          "prefix" = "!";
          "body" = [
            "<script setup lang=\"ts\">"
            "defineOptions({"
            "\tname: '\${1:\${TM_FILENAME_BASE/(.*)/\${1:/pascalcase}/}}',"
            "})"
            "</script>"
            ""
            "<template>"
            "\t$2"
            "</template>"
            ""
            "<style lang=\"scss\" scoped></style>"
            ""
          ];
          "description" = "Vue3 SFC Basic Skeleton";
          "isFileTemplate" = true;
        };
      };
    };
  };

  programs.vscode.profiles.koishi = {
    languageSnippets = {
      typescript = {
        "Koishi plugin initial snippet" = {
          prefix = [ "!" "koishi" ];
          description = "Koishi plugin initial snippet";
          body = [
            "import { Context, Schema } from 'koishi'"
            ""
            "export interface Config {}"
            "export const Config: Schema<Config> = Schema.object({})"
            ""
            "export const name = '\${1:test}'"
            "export function apply(ctx: Context, config: Config) {"
            "\tctx"
            "\t\t.command('\${1:test}')"
            "\t\t.action(({ session }) => {"
            "\t\t\treturn 'Hello, world!'"
            "\t\t})"
            "}"
          ];
          "isFileTemplate" = true;
        };
      };
    };
  };
}
