#!/bin/bash
#generates the list of excluded subunits, mostly island groups.


exclude=( 'HMD' 'PYF' 'ATF' 'ALA' 'CYM' 'FLK' 'GGY' 'NCL' 'NIU' 'NFK' 'BLM' 'SHN' 'MAF' 'SPM' 'SXM' 'SGS' 'TCA' 'UMI' 'VIR' 'WLF' \
  'NSV' 'FRO' 'ECG' 'EUI' 'SFA' 'FSA' 'SGG' 'ATS' 'PAZ' 'PMD' 'ESC' 'FJI' 'NJM' 'WSM' 'TON' 'NZC' 'KIR' 'NZA' 'GUM' 'MNP' 'PLW' 'REU' 'MUS' \
  'BAC' 'CHP' 'ASM' 'SHS' 'SGX' 'FSM' 'SYC' 'ZAI' 'BSI' 'CLP' 'GOI' 'JUI' 'MTQ' 'MYT' 'TEI' \
  'CPV' 'AND' 'DMA' 'COM') #the only sovereign nations excluded are Cabo Verde, Dominica, Andorra and Comoros
query=$(printf "and SU_A3 <> '%s' " "${exclude[@]}")
query=${query:4}

echo $query > exclude.txt
