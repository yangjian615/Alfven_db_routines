;;12/11/16
PRO SAVE_PASIS_VARS, $
   FILENAME=fileName, $
   SAVEDIR=dir, $
   NEED_FASTLOC_I=need_fastLoc_i, $
   VERBOSE=verbose

  COMPILE_OPT IDL2

  @common__pasis_lists.pro

  saveDir = KEYWORD_SET(dir)      ? dir      : '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  fName   = KEYWORD_SET(fileName) ? fileName : GET_PASIS_VARS_FNAME(NEED_FASTLOC_I=need_fastLoc_i)

  IF KEYWORD_SET(verbose) THEN BEGIN 
     IF FILE_TEST(saveDir+fName) THEN BEGIN
        thing = 'Overwriting'
        suff  = 'in '
     ENDIF ELSE BEGIN
        thing = 'Saving'
        suff  = 'to '
     ENDELSE

     PRINT,thing + " PASIS vars " + suff + saveDir + fName + ' ...'
  ENDIF

  saveStr = 'SAVE,PASIS__paramString_list,PASIS__paramString,' + $
            'PASIS__alfDB_plot_struct,PASIS__IMF_struct,'      + $
            'PASIS__MIMC_struct,'

  IF KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs) THEN BEGIN
     saveStr += 'PASIS__indices__eSpec_list,'                         + $
                'PASIS__eFlux_eSpec_data,PASIS__eNumFlux_eSpec_data,' + $
                'PASIS__eSpec__MLTs,PASIS__eSpec__ILATs,'
  ENDIF ELSE BEGIN
     saveStr += 'PASIS__plot_i_list,'
  ENDELSE

  IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN
     saveStr += 'PASIS__fastLocInterped_i_list,'
  ENDIF

  IF KEYWORD_SET(ion_junk) THEN BEGIN
     saveStr += 'PASIS__indices__ion_list,'                         + $
                'PASIS__iFlux_eSpec_data,PASIS__iNumFlux_eSpec_data,' + $
                'PASIS__ion__MLTs,PASIS__ion__ILATs,'
  ENDIF

  saveStr    += 'FILENAME=saveDir+fName'

  bro = EXECUTE(saveStr)
  IF ~bro THEN STOP


  ;; SAVE,PASIS__paramString_list       , $
  ;;      PASIS__paramString            , $ 
  ;;      PASIS__plot_i_list            , $ 
  ;;      PASIS__fastLocInterped_i_list , $ 
  ;;      PASIS__indices__eSpec_list    , $ 
  ;;      PASIS__indices__ion_list      , $ 
  ;;      PASIS__eFlux_eSpec_data       , $    
  ;;      PASIS__eNumFlux_eSpec_data    , $ 
  ;;      PASIS__eSpec__MLTs            , $         
  ;;      PASIS__eSpec__ILATs           , $        
  ;;      PASIS__iFlux_eSpec_data       , $    
  ;;      PASIS__iNumFlux_eSpec_data    , $ 
  ;;      PASIS__ion_delta_t            , $ 
  ;;      PASIS__ion__MLTs              , $         
  ;;      PASIS__ion__ILATs             , $ 
  ;;      PASIS__alfDB_plot_struct      , $ 
  ;;      PASIS__IMF_struct             , $ 
  ;;      PASIS__MIMC_struct            , $
  ;;      FILENAME=saveDir+fName

END

