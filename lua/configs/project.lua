local M = {}

M.find_project_root = function()
    -- Common project root indicators
    local root_patterns = {
        '.git',        -- Git repository
        'init.lua',    -- Neovim config
        '.nvim',       -- Neovim specific
        'lazy-lock.json', -- Lazy package manager
        'stylua.toml', -- Lua formatter config
        'package.json', -- Node.js
        'Cargo.toml',  -- Rust
        'go.mod',      -- Go
        'requirements.txt', -- Python
    }
    -- Start from the current buffer's directory
    local current_dir = vim.fn.expand('%:p:h')
    -- Traverse up the directory tree
    local function find_root(path)
        for _, pattern in ipairs(root_patterns) do
            local pattern_path = path .. '/' .. pattern
            if vim.fn.filereadable(pattern_path) == 1 or vim.fn.isdirectory(pattern_path) == 1 then
                return path
            end
        end
        -- Go up one directory
        local parent = vim.fn.fnamemodify(path, ':h')
        if parent == path then
            return nil
        end
        return find_root(parent)
    end
    local root = find_root(current_dir)
    return root or current_dir -- fallback to current directory if no root found
end
return M;
