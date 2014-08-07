#! /bin/bash

sdcv_lookup()
{
  m=$(sdcv -n --data-dir $1 $2)
  if [[ -n "$3" ]]; then
    if [[ "$3" -eq 0 ]]; then
      m=$(echo $m | tail -1)
    else
      m=$(echo $m | grep -m 1 "^ *$3")
    fi
    echo $m | xclip
  fi
  echo -e $m
}

dic()
{
  sdcv_lookup "/usr/share/stardict/dic" $@
}

# jp (romaji) -> en (romaji)
je()
{
  m=$(sdcv_lookup "/usr/share/stardict/je/" $1)
  if [[ -n "$2" ]]; then
    c="$2,$2p"
    m=$(echo $m | sed '/^$/d' | sed -n $c)
    echo $m | xclip
  else
    m=$(echo $m | nl)
  fi
  echo -e $m
}

# internal use (CJK)
jj()
{
  sdcv_lookup "/usr/share/stardict/jj/" $@ | nl
}

# en -> jp
ej()
{
  m=$(sdcv_lookup "/usr/share/stardict/ej/" $1)
  if [[ -n "$2" ]]; then
    c="$2,$2p"
    m=$(echo $m | sed '/^$/d' | sed -n $c)
    echo $m | xclip
  else
    m=$(echo $m | nl)
  fi
  if [[ "$3" == "je" ]]; then
    m=$(jj $m)
  fi
  if [[ -n "$4" ]]; then
    c=$(($4+1))
    c="$(echo $c),$(echo $c)p"
    m=$(echo $m | sed '/^$/d' | sed -n $c)
    echo $m | xclip
  fi
  echo -e $m
}
