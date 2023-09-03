# Text colors
export TC_BLACK="\033[30m"
export TC_RED="\033[31m"
export TC_GREEN="\033[32m"
export TC_YELLOW="\033[33m"
export TC_BLUE="\033[34m"
export TC_MAGENTA="\033[35m"
export TC_CYAN="\033[36m"
export TC_WHITE="\033[37m"
 
export TC_BRIGHT_BLACK="\033[0;90m"
export TC_BRIGHT_RED="\033[0;91m"
export TC_BRIGHT_GREEN="\033[0;92m"
export TC_BRIGHT_YELLOW="\033[93m"
export TC_BRIGHT_BLUE="\033[94m"
export TC_BRIGHT_MAGENTA="\033[95m"
export TC_BRIGHT_CYAN="\033[96m"
export TC_BRIGHT_WHITE="\033[97m"
 
# Background colors
export BG_BLACK="\033[40m"
export BG_RED="\033[41m"
export BG_GREEN="\033[42m"
export BG_YELLOW="\033[43m"
export BG_BLUE="\033[44m"
export BG_MAGENTA="\033[45m"
export BG_CYAN="\033[46m"
export BG_WHITE="\033[47m"

export BG_BRIGHT_BLACK="\033[100m"
export BG_BRIGHT_RED="\033[101m"
export BG_BRIGHT_GREEN="\033[102m"
export BG_BRIGHT_YELLOW="\033[103m"
export BG_BRIGHT_BLUE="\033[104m"
export BG_BRIGHT_MAGENTA="\033[105m"
export BG_BRIGHT_CYAN="\033[106m"
export BG_BRIGHT_WHITE="\033[107m"

# Font weights (not all terminals support this)
export FW_BOLD="\033[1m"  # Bold or increased intensity
export FW_DIM="\033[2m"   # Dim or decreased intensity
export FW_UNDERLINE="\033[4m"  # Underline text
export FW_BLINK="\033[5m"  # Blink text (not widely supported)
export FW_REVERSE="\033[7m"  # Reverse foreground and background colors
export FW_HIDDEN="\033[8m"  # Hide text (not widely supported)

# Presets
export TC_ERROR="${TC_BRIGHT_RED}${FW_BOLD}"
export TC_WARNING="${TC_BRIGHT_YELLOW}${FW_BOLD}"
export TC_INFO="${TC_BRIGHT_CYAN}${FW_BOLD}"
export TC_SUCCESS="${TC_BRIGHT_GREEN}${FW_BOLD}"

# Reset all formatting
export TC_RESET="\033[0;0m"
