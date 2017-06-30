# gdbinit
add-auto-load-safe-path ./
set max-value-size unlimited

# dashboard
source ~/.gdb-dashboard
alias -a -- db = dashboard
# Black     \e[0;30m # Blue      \e[0;34m # Green     \e[0;32m # Cyan      \e[0;36m
# Red       \e[0;31m # Purple    \e[0;35m # Brown     \e[0;33m # Gray      \e[0;37m
# Dark Gray \e[1;30m # L. Blue   \e[1;34m # L. Green  \e[1;32m # L. Cyan   \e[1;36m
# L. Red    \e[1;31m # L. Purple \e[1;35m # Yellow    \e[1;33m # White     \e[1;37m
db -layout !expressions !memory !assembly !history !registers !stack !threads source
db -style syntax_highlighting 'trac'
db -style style_selected_1 '1;31' # Light Red
db -style style_selected_2 '33'   # Brown
db source -style context 15
db stack -style locals True
db stack -style limit 5
