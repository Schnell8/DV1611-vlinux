#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#



# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"

#
# Message to display for usage and help.
#
function usage
{
    local txt=(
""
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Options available:"
""
"  -h, --help            Display the menu."
"  -v, --version         Display the current version."
"  -c, --count           Display the number of rows returned."
""
"Commands available:"
""
"  url                   Get url to view the server in browser."
"  view                  List all entries."
"  view url <url>        View all entries containing <url>."
"  view ip <ip>          View all entries containing <ip>."
"  use <server>          Set the servername (localhost or server)."
""
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help, -h"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}

#
# Message to display for version.
#
function count
{
    server=$(cat server.txt)

    if [[ "$2" = "view" ]] && [[ "$3" = "" ]]
    then
        json_data=$(curl -s "$server:1338/data")
    elif [[ "$2" = "view" ]] && [[ "$3" = "url" ]]
    then
        json_data=$(curl -s "$server:1338/data/url/$4")
    elif [[ "$2" = "view" ]] && [[ "$3" = "ip" ]]
    then
        json_data=$(curl -s "$server:1338/data/ip/$4")
    fi

    rows=$(echo "$json_data" | jq length)
    echo "$rows"

    printf "%s\\n" "${txt[@]}"
}

#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-url
{
    echo "http://localhost:1338"

    printf "%s\\n" "${txt[@]}"
}

#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-view
{
    server=$(cat server.txt)

    if [[ "$1" = "" ]]
    then
        curl -s "$server":1338/data | jq .
    elif [[ "$1" = "url" ]]
    then
        curl -s "$server:1338/data/url/$2" | jq .
    elif [[ "$1" = "ip" ]]
    then
        curl -s "$server:1338/data/ip/$2" | jq .
    fi

    printf "%s\\n" "${txt[@]}"
    printf "%s\\n" "${txt[@]}"
}

#
# Function for taking care of specific command. Name the function as the
# command is named.
#
function app-use
{
    echo "$1" > server.txt
    server=$(cat server.txt)
    echo "Server is now: $server"

    printf "%s\\n" "${txt[@]}"
}

function main
{
#
# Process options
#
while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        --count | -c)
            count "$@"
            exit 0
        ;;

        url             \
        | view          \
        | use)
            command=$1
            shift
            app-"$command" "$@"
            exit 0
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;

    esac
done

badUsage
exit 1
}

main "$@"
