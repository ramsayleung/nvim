local M = {}

M.find_project_root = function()
    -- Common project root indicators, ordered by priority
    local root_patterns = {
        -- Workspace/monorepo indicators
        'package.json',    -- Node.js root
        'next.config.mjs', -- Next.js
        'tsconfig.json',   -- TypeScript root
        '.git',            -- Git repository
        'init.lua',        -- Neovim config
        '.nvim',          -- Neovim specific
        'lazy-lock.json', -- Lazy package manager
        'stylua.toml',    -- Lua formatter config
        'Cargo.toml',     -- Rust
        'go.mod',         -- Go
        'requirements.txt' -- Python
    }

    -- Start from the current buffer's directory
    local current_dir = vim.fn.expand('%:p:h')
    local found_roots = {}

    -- Traverse up the directory tree and collect all roots
    local function find_roots(path)
        local found = false
        for _, pattern in ipairs(root_patterns) do
            local pattern_path = path .. '/' .. pattern
            if vim.fn.filereadable(pattern_path) == 1 or vim.fn.isdirectory(pattern_path) == 1 then
                found = true
                table.insert(found_roots, path)
                break -- Found a root indicator in this directory, no need to check others
            end
        end

        -- Go up one directory unless we're at the filesystem root
        local parent = vim.fn.fnamemodify(path, ':h')
        if parent ~= path then
            find_roots(parent)
        end
    end

    find_roots(current_dir)

    -- Return the highest-level (last found) root, or current directory if none found
    return #found_roots > 0 and found_roots[#found_roots] or current_dir
end

return M
