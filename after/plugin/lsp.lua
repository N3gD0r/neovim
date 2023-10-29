local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
        'tsserver',
        'rust_analyzer',
        'bashls',
        'clangd',
        'cmake',
        'csharp_ls',
        'omnisharp',
        'cssls',
        'dockerls',
        'docker_compose_language_service',
        'emmet_ls',
        'jdtls',
        'lua_ls',
        'pylsp',
        'volar',
        'yamlls'
})

lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_action = lsp.cmp_action()

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['S-Tab>'] = cmp_action.select_prev_or_fallback(),
})

cmp.setup({
        preselect = 'item',
        completion = {
                completeopt = 'menu,menuone,noinsert'
        },
})

lsp.setup_nvim_cmp({
        select_behavior = 'insert',
        mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        if client.name == "omnisharp" then
                client.server_capabilities.semanticTokensProvider = {
                        full = vim.empty_dict(),
                        legend = {
                                tokenModifiers = { "static_symbol" },
                                tokenTypes = {
                                        "comment",
                                        "excluded_code",
                                        "identifier",
                                        "keyword",
                                        "keyword_control",
                                        "number",
                                        "operator",
                                        "operator_overloaded",
                                        "preprocessor_keyword",
                                        "string",
                                        "whitespace",
                                        "text",
                                        "static_symbol",
                                        "preprocessor_text",
                                        "punctuation",
                                        "string_verbatim",
                                        "string_escape_character",
                                        "class_name",
                                        "delegate_name",
                                        "enum_name",
                                        "interface_name",
                                        "module_name",
                                        "struct_name",
                                        "type_parameter_name",
                                        "field_name",
                                        "enum_member_name",
                                        "constant_name",
                                        "local_name",
                                        "parameter_name",
                                        "method_name",
                                        "extension_method_name",
                                        "property_name",
                                        "event_name",
                                        "namespace_name",
                                        "label_name",
                                        "xml_doc_comment_attribute_name",
                                        "xml_doc_comment_attribute_quotes",
                                        "xml_doc_comment_attribute_value",
                                        "xml_doc_comment_cdata_section",
                                        "xml_doc_comment_comment",
                                        "xml_doc_comment_delimiter",
                                        "xml_doc_comment_entity_reference",
                                        "xml_doc_comment_name",
                                        "xml_doc_comment_processing_instruction",
                                        "xml_doc_comment_text",
                                        "xml_literal_attribute_name",
                                        "xml_literal_attribute_quotes",
                                        "xml_literal_attribute_value",
                                        "xml_literal_cdata_section",
                                        "xml_literal_comment",
                                        "xml_literal_delimiter",
                                        "xml_literal_embedded_expression",
                                        "xml_literal_entity_reference",
                                        "xml_literal_name",
                                        "xml_literal_processing_instruction",
                                        "xml_literal_text",
                                        "regex_comment",
                                        "regex_character_class",
                                        "regex_anchor",
                                        "regex_quantifier",
                                        "regex_grouping",
                                        "regex_alternation",
                                        "regex_text",
                                        "regex_self_escaped_character",
                                        "regex_other_escape",
                                },
                        },
                        range = true,
                }
        end
end)


require('lspconfig').omnisharp.setup {
        cmd = { "dotnet", "/home/thend/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = true,
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        sdk_include_prereleases = true,
        analyze_open_documents_only = false,
        handlers = {
                ["textDocument/definition"] = require("omnisharp_extended").handler,
        },
}

lsp.skip_server_setup({'jdtls'})

lsp.setup()

vim.diagnostic.config({
        virtual_text = true
})
