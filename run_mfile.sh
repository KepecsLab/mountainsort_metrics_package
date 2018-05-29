#!/bin/bash

if ( command -v matlab &> /dev/null )
then
  matlab -nosplash -nojvm -r "try, cd(""'"$(dirname $0)"'""), $1, exit(0), catch err, disp(getReport(err,'extended')), exit(-1), end" | tail -n +13 
else
  if ( command -v octave &> /dev/null )
  then
    octave --no-gui --eval "try, cd(""'"$(dirname $0)"'""), $1, exit(0), catch err, disp(getReport(err,'extended')), exit(-1), end"
  else
    printf "\nCould not find Matlab nor Octave.\n\tMake sure at least one is installed and callable.\n\tError at $0\n\tCalled with arguments: $@\n\n"
    exit 1
  fi
fi




