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
  sdcv_lookup "/usr/share/stardict/jj/" $@ | nl
}

# en -> jp
ej()
{
  m=$(sdcv_lookup "/usr/share/stardict/ej/" $1)
  echo $m
}
