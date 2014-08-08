#! /bin/bash

sdcv_lookup()
{
  m=$(sdcv -n --data-dir $1 $2)
  m=$(echo "$m" | sed 's/$/:@;\n/' | sed '/-->[jJ]/d')
  echo $m
}

dic()
{
  sdcv_lookup "/usr/share/stardict/dic" $@
}

# jp (romaji) -> en (romaji)
je()
{
  m=$(sdcv_lookup "/usr/share/stardict/je/" $1)
  echo $m
}

# internal use (CJK)
jj()
{
  m=$(sdcv_lookup "/usr/share/stardict/jj/" $1)
  echo $m
}

# en -> jp
ej()
{
  m=$(sdcv_lookup "/usr/share/stardict/ej/" $1)
  echo $m
}

# find key line in damage
dfind()
{
  m=$(grep -A 1 'Number:' ../data/kanjidicks.txt | grep $1)
  c=$(echo "$m" | wc -l)
  if [[ -n "$m" && $c -eq 1 ]]; then
    awk "/$m/{p=1}/Number:/{p=0}p" ../data/kanjidicks.txt
  else
    echo "No matches found: '$1'."
  fi
}
