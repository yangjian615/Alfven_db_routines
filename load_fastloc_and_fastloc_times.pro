;2016/02/13 Added FORCE_LOAD keywords
PRO LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t, $
                                   DBDIR=DBDir, $
                                   DBFILE=DBFile, $
                                   DB_TFILE=DB_tFile, $
                                   FORCE_LOAD_FASTLOC=force_load_fastLoc, $
                                   FORCE_LOAD_TIMES=force_load_times, $
                                   FORCE_LOAD_ALL=force_load_all, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs, $
                                   COORDINATE_SYSTEM=coordinate_system, $
                                   USE_AACGM_COORDS=use_aacgm, $
                                   USE_GEO_COORDS=use_geo, $
                                   USE_MAG_COORDS=use_mag, $
                                   ;; CHECK_DB=check_DB, $
                                   OUT__DO_NOT_LOAD_IN_MEM=do_not_load_in_mem, $
                                   LUN=lun

  ;; COMMON FL_VARS,fastLoc,FASTLOC__times,FASTLOC__delta_t, $
  ;;    FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
  ;;    FASTLOC__dbFile,FASTLOC__dbTimesFile

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1         ;stdout

  IF KEYWORD_SET(force_load_all) THEN BEGIN
     PRINTF,lun,"Forcing load of fastLoc and times..."
     force_load_fastLoc             = 1
     force_load_times               = 1
  ENDIF


  ;; DefDBDir                       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals2/'
  ;; DefDBFile                      = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  ;; DefDBFile                      = 'fastLoc_intervals2--500-16361_all--w_lshell--20151015.sav'
  ;; DefDB_tFile                    = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  ;; DefDBDir                       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals3/'
  ;; DefDBFile                      = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020.sav'
  ;; DefDB_tFile                    = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020--times.sav'

  DefDBDir                          = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
  ;; DefDBFile                      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  ;; DefDB_tFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'
  ;; DefDBFile                      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--sample_t_le_0.01.sav'
  ;; DefDB_tFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times--sample_t_le_0.01.sav'

  ;; DefDBFile                         = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--noDupes--sample_freq_le_0.01.sav'
  DefDBFile                         = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'
  DefDB_tFile                       = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
  ;; DefDBFile                      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  ;; DefDB_tFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'

  ;; DefESpecDBFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes.sav'
  DefESpecDBFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--smaller_datatypes--no_interval_startstop.sav'
  DefESpecDB_tFile                  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'

  defCoordDir                       = defDBDir + 'alternate_coords/'
  ;; AACGM_dir        = '/SPENCEdata/Research/database/FAST/ephemeris/'
  ;; AACGM_file       = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_GEO_and_MAG_coords.sav'
  AACGM_file                        = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_coords.sav'
  GEO_file                          = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--GEO_coords.sav'
  MAG_file                          = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--MAG_coords.sav'


  ;; IF KEYWORD_SET(check_DB) THEN BEGIN
  ;;    out_maximus  = N_ELEMENTS(MAXIMUS__maximus)     GT 0 ? MAXIMUS__maximus     : !NULL
  ;;    out_cdbTime  = N_ELEMENTS(MAXIMUS__times)       GT 0 ? MAXIMUS__times       : !NULL
  ;;    good_i       = N_ELEMENTS(MAXIMUS__good_i)      GT 0 ? MAXIMUS__good_i      : !NULL
  ;;    DBFile       = N_ELEMENTS(MAXIMUS__dbFile)      GT 0 ? MAXIMUS__dbFile      : !NULL
  ;;    DB_tFile     = N_ELEMENTS(MAXIMUS__dbTimesFile) GT 0 ? MAXIMUS__dbTimesFile : !NULL
  ;;    DBDir        = N_ELEMENTS(MAXIMUS__dbDir)       GT 0 ? MAXIMUS__dbDir       : !NULL
  ;;    despunDB     = N_ELEMENTS(MAXIMUS__despun)      GT 0 ? MAXIMUS__despun      : !NULL
  ;;    chastDB      = N_ELEMENTS(MAXIMUS__is_chastDB)  GT 0 ? MAXIMUS__is_chastDB  : !NULL

  ;;    RETURN
  ;; ENDIF

  IF N_ELEMENTS(DBDir) EQ 0 THEN BEGIN
     DBDir                          = DefDBDir
  ENDIF
  IF N_ELEMENTS(DBFile) EQ 0 THEN BEGIN
     IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
        PRINT,'Loading FastLoc for eSpec and ion DBs...'
        DBFile                      = DefESpecDBFile
     ENDIF ELSE BEGIN
        DBFile                      = DefDBFile
     ENDELSE
  ENDIF
  IF N_ELEMENTS(DB_tFile) EQ 0 THEN BEGIN
     IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
        ;; PRINT,'Loading FastLoc times for eSpec and ion DBs...'
        DB_tFile                    = DefESpecDB_tFile
     ENDIF ELSE BEGIN
        DB_tFile                    = DefDB_tFile
     ENDELSE
  ENDIF
  
  IF N_ELEMENTS(fastLoc) EQ 0 OR KEYWORD_SET(force_load_fastLoc) THEN BEGIN
     IF KEYWORD_SET(force_load_fastLoc) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have fastLoc..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF fastLoc EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastLoc!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastLoc struct loaded! Not loading " + DBFile
  ENDELSE

  IF N_ELEMENTS(fastloc_times) EQ 0 OR KEYWORD_SET(force_load_times) THEN BEGIN
     IF KEYWORD_SET(force_load_times) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have times..."
     ENDIF
     IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
     IF fastloc_times EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastloc_times!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastloc_times struct loaded! Not loading " + DB_tFile
  ENDELSE

  IF KEYWORD_SET(coordinate_system) THEN BEGIN
     CASE STRUPCASE(coordinate_system) OF
        'AACGM': BEGIN
           use_aacgm = 1
           use_geo   = 0
           use_mag   = 0
        END
        'GEO'  : BEGIN
           use_aacgm = 0
           use_geo   = 1
           use_mag   = 0
        END
        'MAG'  : BEGIN
           use_aacgm = 0
           use_geo   = 0
           use_mag   = 1
        END
     ENDCASE
  ENDIF

  IF KEYWORD_SET(use_aacgm) THEN BEGIN
     PRINT,'Using AACGM coords ...'

     RESTORE,defCoordDir+AACGM_file

     ALFDB_SWITCH_COORDS,fastLoc,FL_AACGM,'AACGM'

     changedCoords = 1
  ENDIF

  IF KEYWORD_SET(use_GEO) THEN BEGIN
     PRINT,'Using GEO coords ...'

     RESTORE,defCoordDir+GEO_file

     ALFDB_SWITCH_COORDS,fastLoc,FL_GEO,'GEO'

     changedCoords = 1
  ENDIF

  IF KEYWORD_SET(use_MAG) THEN BEGIN
     PRINT,'Using MAG coords ...'

     RESTORE,defCoordDir+MAG_file

     ALFDB_SWITCH_COORDS,fastLoc,FL_MAG,'MAG'

     changedCoords = 1
  ENDIF


  IF KEYWORD_SET(changedCoords) THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,maximus,/CHECK_DB
     IF N_ELEMENTS(maximus) GT 0 THEN BEGIN
        CASE 1 OF
           TAG_EXIST(maximus,'coords'): BEGIN
              IF STRLOWCASE(fastLoc.coords) NE STRLOWCASE(maximus.coords) THEN BEGIN
                 PRINT,'Mismatched coordinate systems!'
                 STOP
              ENDIF 
           END
           ELSE: BEGIN
              PRINT,'Maximus coordinates have not been changed!'
              STOP
           END
        ENDCASE
     ENDIF 
  ENDIF
  

END