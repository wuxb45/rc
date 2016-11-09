source ~/.gdb-dashboard
# Black            \e[0;30m
# Blue             \e[0;34m
# Green            \e[0;32m
# Cyan             \e[0;36m
# Red              \e[0;31m
# Purple           \e[0;35m
# Brown            \e[0;33m
# Gray             \e[0;37m
# Dark Gray        \e[1;30m
# Light Blue       \e[1;34m
# Light Green      \e[1;32m
# Light Cyan       \e[1;36m
# Light Red        \e[1;31m
# Light Purple     \e[1;35m
# Yellow           \e[1;33m
# White            \e[1;37m
dashboard -layout !expressions !memory !assembly !history !registers !stack !threads source

dashboard -style syntax_highlighting 'trac'
dashboard -style style_selected_1 '1;31' # Light Red
dashboard -style style_selected_2 '33'   # Brown

dashboard source -style context 15

dashboard stack -style locals True
dashboard stack -style limit 5

add-auto-load-safe-path ./
