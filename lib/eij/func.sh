#! /bin/bash

FILE=../data/kanjidicks.txt

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

# find kanjidamage record given a key
dfind()
{
  m=$(grep -A 1 'Number:' $FILE | grep "$1")
  c=$(echo "$m" | wc -l)
  if [[ $c -gt 1 ]]; then
    echo "Disambiguation required:"
    echo "$m" | sed 's/^/   /'
  elif [[ -n $m && $c -eq 1 ]]; then
    f=$(awk "/$m/{p=1}/Number:/{p=0}p" $FILE)
    p=$(awk "/$m/{p=1}/MUTANTS:|ONYOMI:/{p=0}p" $FILE)
    j=$(echo "$f" | awk "/JUKUGO:/{p=1}/USED IN:|LOOKALIKES:/{p=0}p")
    u=$(echo "$f" | sed -n '/USED IN:/,$p')
    echo "$f"
    echo ":;!;"
    echo "$p" | tail -1
    echo ":;!;"
    echo "$j"
    echo ":;!;"
    echo "$u"
  else
    echo "No matches found: '$1'."
  fi
}
