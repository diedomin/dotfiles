spinner() {
    local msg="$1"
    local cmd="$2"
    local logfile="$HOME/Proyectos/Github/dotfiles/setup_$(date +%s%N).log"
    local spins=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local i=0
    local green="\033[0;32m"
    local red="\033[0;31m"
    local reset="\033[0m"

    (eval "$cmd" >"$logfile" 2>&1) &
    local pid=$!

    while kill -0 $pid 2>/dev/null; do
        printf "\r%s %s" "$msg" "${spins[i]}"
        i=$(( (i+1) % ${#spins[@]} ))
        sleep 0.18
    done

    wait $pid
    local exitcode=$?

    if [ $exitcode -eq 0 ]; then
        printf "\r%s ${green}✓${reset}\n" "$msg"
        rm -f "$logfile"
    else
        printf "\r%s ${red}✗ (error)${reset}\n" "$msg"
        echo -e "${red}ERROR:${reset} El comand failed. Last log lines:"
        tail -n 20 "$logfile"
        exit $exitcode
    fi
}
