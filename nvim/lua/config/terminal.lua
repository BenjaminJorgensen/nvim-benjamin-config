local terminal = {
    buf = nil,
    win = nil,
    pid = nil
}

terminal.open = function ()
    -- Create buffer.
    local buf = nil

    if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
        -- If the window is valid, focus it and enter insert mode.
        vim.api.nvim_set_current_win(terminal.win)
        vim.cmd('startinsert')
        return
    end

    if terminal.buf and vim.api.nvim_buf_is_loaded(terminal.buf) then
        buf = terminal.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    -- Create vertical split window.
    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    -- Launch terminal.
    if not terminal.buf then
        terminal.pid = vim.fn.termopen(string.format('%s --login', os.getenv('SHELL')))
    end

    vim.cmd('startinsert')
    vim.cmd("autocmd! TermClose <buffer> lua require('benjamin.terminal').close(true)")

    -- Save current handles.
    terminal.win = win
    terminal.buf = buf
end

terminal.close = function (force)
    if not terminal.win then
        return
    end

    if vim.api.nvim_win_is_valid(terminal.win) then
        vim.api.nvim_win_close(terminal.win, false)
        terminal.win = nil
    end

    -- Force close upon terminal exit.
    if force then
        if vim.api.nvim_buf_is_loaded(terminal.buf) then
            vim.api.nvim_buf_delete(terminal.buf, { force = true })
        end

        vim.fn.jobstop(terminal.pid)

        terminal.buf = nil
        terminal.pid = nil
    end
end

terminal.toggle = function ()
    if not terminal.win then
        terminal.open()
    else
        terminal.close()
    end
end

return terminal
