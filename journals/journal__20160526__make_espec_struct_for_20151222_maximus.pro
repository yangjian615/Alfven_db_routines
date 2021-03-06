;;05/26/16
PRO JOURNAL__20160526__MAKE_ESPEC_STRUCT_FOR_20151222_MAXIMUS

  outDir      = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  outFile     = 'alf_eSpec_20151222_db--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  ;;Get cdbTime and the DB directory
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,/JUST_CDBTIME,DBDir=dbDir

  orbFile      = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  alf_eSpecs   = MAKE_ESPEC_DB_FOR_ALFVEN_DB(cdbTime,alfven_orbList, $
                                             OUT_DIFFS=eSpec_magc_diffs, $
                                             OUT_MISSING=eSpec_missing_events)

  SAVE,alf_eSpecs,eSpec_magc_diffs,eSpec_missing_events,FILENAME=outDir+outFile

END
