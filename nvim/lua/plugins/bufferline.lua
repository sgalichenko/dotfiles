local colors = {
    bg=     '#2f343f',
    red=     '#fb3d66',
    green=     '#6d8c63',
    yellow=     '#e4cd7',
    orange=    '#bf946b',
    blue=     '#8b9eb2',
    violet=    '#cdafd9',
    magenta=     '#796e7f',
    darkblue=    '#55648',
    cyan=     '#7b8e93',
    bg_light= "#323b3e",
    bg_alt= "#202325",
    bg_red = '#182332',
    fg=    '#f7f8f8',
    clear= 'None',
}

-- colors for active , inactive uffer tabs
require('bufferline').setup {
    options = {
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 18,
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = false,
        separator_style = "thin",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator_style = '▎',
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        always_show_bufferline = false,
        sort_by = 'id'
    },
    highlights = {
      fill = {
          fg = colors.fg,
          bg = colors.bg
      },
      tab = {
          fg = colors.fg,
          bg = colors.bg
      },
      tab_selected = {
          fg = colors.bg,
          bg = colors.bg
      },
      buffer_selected = {
          fg = colors.fg,
          bg = colors.bg
      },
      buffer_visible = {
          fg = colors.fg,
          bg = colors.bg
      },
      separator_visible = {
          fg = colors.fg,
          bg = colors.bg
      },
      separator_selected = {
          fg = colors.fg,
          bg = colors.bg
      },
      separator = {
          fg = colors.fg,
          bg = colors.bg
      },
      indicator_selected = {
          fg = colors.fg,
          bg = colors.bg
      },
      modified_selected = {
          fg = colors.fg,
          bg = colors.bg
      }
    }
}
