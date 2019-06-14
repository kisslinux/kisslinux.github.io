# KISS

A highly opinionated, ultra minimal, Linux distribution.

## Index

- [Repository](https://github.com/kissx/packages)
- [Package Manager](https://github.com/kissx/kiss)
- [Rationale](#rationale)
- [Status](#status)


## Rationale

A Linux distribution specifically for desktop that aims to be simple, minimal and hackable. KISS is meant for users with prior Linux and programming knowledge and for those who want something simple.

The main repository will contain a minimal and curated package set. However, as a user you can easily create your own repository and package what you like. The tools are made available to you; KISS is just the base.

Packages in KISS employ a new concept. Instead of your typical sourceable shell scripts, multiple plain-text files are used. This new format is easily parseable in any programming language as file data is either separated by spaces or lines.

To showcase this concept, the reference package manager is written in under 200 lines of POSIX `sh`. Nothing stops you from interfacing with the repositories outside of the base package manager. You can easily write your own tools.

## Status

KISS is not yet useable as a distribution, however the package manager and main repository are fully operational. I currently use a few KISS packages on my Void Linux installation.

The remaining work is getting it to a TTY inside a virtual machine and later to a graphical state. This involves creating an installation method, documentation and the last remaining packages.

```
read -r day month year months < <(printf  '%(%e %m %Y)T 0033614625035' -1)

((leap      = year%4?year%100?year%400?0:1:1:1))
((year_code = (${year:2}+(${year:2}/4))%7))
((start     = (year_code+${months:month:1}+6+1-leap)%7%7))

[[ $month == 0[469] || $month == 11 ]] && ((days=30))
[[ $month == 02 ]]                     && ((days=leap?28:29))

printf '      %(%B)T %s\nSu Mo Tu We Th Fr Sa\n' -1 "$year"

for ((;i++<${days:-31};)) {
    ((i==1))   && printf "%$((start*3))s"
    ((i==day)) && printf '\e[7m'

    printf '%2s\e[m ' "$i"

    ((i==days||(i+start)%7)) || printf '\n'
}

printf '\n'
```
