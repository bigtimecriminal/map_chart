#!/bin/bash
#generates the list of excluded subunits, mostly island groups.the only sovereign nation excluded is Cabo Verde.

exclude=( 'ATA' 'HMD' 'PYF' 'ATF' 'ALA' 'CYM' 'FLK' 'GGY' 'NCL' 'NIU' 'NFK' 'BLM' 'SHN' 'MAF' 'SPM' 'SXM' 'SGS' 'TCA' 'UMI' 'VIR' 'WLF' \
  'NSV' 'FRO' 'ECG' 'EUI' 'SFA' 'FSA' 'SGG' 'ATB' 'ATS' 'PAZ' 'PMD' 'ESC' 'FJI' 'NJM' 'WSM' 'TON' 'NZC' 'KIR' 'NZA' 'GUM' 'MNP' 'PLW' 'REU' 'MUS' \
  'BAC' 'CHP' 'ASM' 'SHS' 'SGX' 'FSM' 'SYC' 'ZAI'\
  'CPV' )
query=$(printf "and SU_A3 <> '%s' " "${exclude[@]}")
query=${query:4}

#these will now be deleted on the country level
#query+="and SOV_A3 <> 'US1' and SOV_A3 <> 'CAN'"

echo $query > exclude.txt
