;2015/08/25
;Tell me when we have data for 
PRO GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1,T2=t2, $
                                        DBSTRUCT=dbStruct,DBTIMES=dbTimes, RESTRICT_W_THESEINDS=in_restrict, $
                                        OUT_INDS=inds, $
                                        UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                        INDS_ORBS=inds_orbs,TRANGES_ORBS=tRanges_orbs, $
                                        TSPANS_ORBS=tSpans_orbs,TSPANTOTAL=tSpanTotal, $
                                        PRINT_DATA_AVAILABILITY=print_data_availability, $
                                        VERBOSE=verbose,DEBUG=debug

  COMPILE_OPT idl2

  IF KEYWORD_SET(verbose) THEN BEGIN
     PRINT,'GET_DATA_AVAILABILITY_FOR_UTC_RANGE'
     print,'UTC Range: ' + TIME_TO_STR(t1) + ' through ' + TIME_TO_STR(t2)
  ENDIF

  IF KEYWORD_SET(in_restrict) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'Restricting with specified inds...'
        PRINT,'(' + STRCOMPRESS(N_ELEMENTS(in_restrict),/REMOVE_ALL) + ' inds provided...)'
     ENDIF
     restrict_i             = in_restrict
     ;; dbStruct=RESIZE_MAXIMUS(dbStruct,CDBTIME=dbTimes,inds=restrict)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'No restriction on inds...'
     ENDIF
     restrict_i             = INDGEN(N_ELEMENTS(dbStruct.time),/L64)
  ENDELSE

  inds_ii = WHERE(dbTimes[restrict_i] GE t1 AND dbTimes[restrict_i] LE t2,nInds)
  IF inds_ii[0] EQ -1 THEN BEGIN

     inds                   = -1

     uniq_orb_inds          = -1
     uniq_orbs              = -1
     nUniq_orbs             = 0

     inds_orbs              = -1
     tRanges_orbs           = -1
     tSpanTotal             = 0
     
  ENDIF ELSE BEGIN

     inds                   = restrict_i[inds_ii]

     uniq_orb_inds_ii       = UNIQ(dbStruct.orbit[inds])
     uniq_orb_inds          = inds[uniq_orb_inds_ii]

     uniq_orbs              = dbStruct.orbit[uniq_orb_inds]
     nUniq_orbs             = N_ELEMENTS(uniq_orb_inds)

     inds_orbs              = MAKE_ARRAY(nUniq_orbs,2,/L64)
     tRanges_orbs           = MAKE_ARRAY(nUniq_orbs,2,/DOUBLE)
     tSpans_orbs            = MAKE_ARRAY(nUniq_orbs,/DOUBLE)
     tSpanTotal             = 0
     
     FOR i=0,nUniq_orbs-1 DO BEGIN
        orb                 = uniq_orbs[i]

        orbInds_ii          = WHERE(dbStruct.orbit[inds] EQ orb)
        orbInds             = inds[orbInds_ii]

        IF KEYWORD_SET(debug) THEN BEGIN
           PRINT,'Checking out orb' + STRCOMPRESS(orb,/REMOVE_ALL) + '  (' + STRCOMPRESS(i+1,/REMOVE_ALL) + ' / ' + STRCOMPRESS(nUniq_orbs,/REMOVE_ALL) + ')'
           nInds = orbInds[0] EQ -1 ? 0 : N_ELEMENTS(orbInds)
           PRINT,'nInds : ' + STRCOMPRESS(nInds,/REMOVE_ALL)
           PRINT,''
        ENDIF

        IF orbInds_ii[0] NE -1 THEN orbMin = MIN(dbTimes[orbInds],orbMin_ii,MAX=orbMax,SUBSCRIPT_MAX=orbMax_ii)
        
        inds_orbs[i,0]      = orbInds[orbMin_ii]
        inds_orbs[i,1]      = orbInds[orbMax_ii]

        tRanges_orbs[i,0]   = orbMin
        tRanges_orbs[i,1]   = orbMax
        
        tSpans_orbs[i]      = orbMax - orbMin
        tSpanTotal         += tSpans_orbs[i]
     ENDFOR
     
     IF KEYWORD_SET(print_data_availability) OR uniq_orb_inds[0] EQ -1 THEN BEGIN
        PRINT_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1,T2=t2, $
                                              UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                              INDS_ORBS=inds_orbs,TRANGES_ORBS=tRanges_orbs, $
                                              TSPANS_ORBS=tSpans_orbs,TSPANTOTAL=tSpanTotal, $
                                              /SUMMARY,DEBUG=debug
     ENDIF
     
  ENDELSE


END