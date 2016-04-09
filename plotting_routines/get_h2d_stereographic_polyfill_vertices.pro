FUNCTION GET_H2D_STEREOGRAPHIC_POLYFILL_VERTICES,lons,lats, $
   BINSIZE_LON=binsize_lon, $
   SHIFT_LON=shift_lon, $
   BINSIZE_LAT=binsize_lat, $
   CONVERT_MLT_TO_LON=convert_MLT_to_lon, $
   COUNTERCLOCKWISE=counterclockwise, $
   MOREPOINTS=morePoints, $
   DEBUG=debug

  COMPILE_OPT idl2

  IF KEYWORD_SET(morePoints) THEN BEGIN
     lonBinSplit             = 4.0
  ENDIF ELSE BEGIN
     lonBinSplit             = 2.0
  ENDELSE

  IF KEYWORD_SET(convert_mlt_to_lon) THEN BEGIN
     ;;Need to have the lons wrap here!!! Pick it up, boah!
     lons                    = (lons+shift_lon)*15
     lonFactor               = (INDGEN(FIX(lonBinSplit)-1)+1)*binsize_lon*15/lonBinSplit
  ENDIF ELSE BEGIN
     lonFactor               = binsize_lon/lonBinSplit
  ENDELSE

  nLonFactors                = N_ELEMENTS(lonFactor)/2

  nLats                      = N_ELEMENTS(lats)
  nLons                      = N_ELEMENTS(lons)

  outLonsLats                = MAKE_ARRAY(nLons-1,nLats-1,2,6+(FIX(lonBinSplit)-1)*2)

  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 
        IF KEYWORD_SET(counterclockwise) THEN BEGIN
           ;; tempLats=[lats[nLats-1-j],lats[nLats-1-j]-binsize_lat/2.0,lats[nLats-2-j]]
           ;; tempLons=[lons[i],lons[i],lons[i]] 
           tempLats          = [lats[j+1],lats[j+1]-binsize_lat/2.0,  lats[j]]
           tempLons          = [  lons[i],                  lons[i],  lons[i]] 
        ENDIF ELSE BEGIN
           tempLats          =   [lats[j],  lats[j]+binsize_lat/2.0,lats[j+1]] 
           tempLons          = [  lons[i],                  lons[i],  lons[i]] 
        ENDELSE

        IF KEYWORD_SET(debug) THEN BEGIN
           print,tempLats & print,tempLons
           tempLons          = REBIN(tempLons,4)  
           tempLats          = REBIN(tempLats,4) 
        ENDIF

        IF KEYWORD_SET(counterclockwise) THEN BEGIN
           ;; tempLats=[lats[nLats-1-j],tempLats,lats[nLats-2-j],REVERSE(tempLats)] 
           ;; tempLons=[lons[i]+lonFactor,tempLons,lons[i]+lonFactor,tempLons+lonFactor*2]  
           tempLats          = [        lats[j+1],tempLats,          lats[j],   REVERSE(tempLats)] 
           tempLons          = [lons[i]+lonFactor,tempLons,lons[i]+lonFactor,tempLons+lonFactor*2]  
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(morePoints) THEN BEGIN
              tempLats        = [REPLICATE(lats[j],FIX(lonBinSplit-1)),tempLats,REPLICATE(lats[j+1],FIX(lonBinSplit-1)),REVERSE(tempLats)] 
              tempLons        = [lons[i]+REVERSE(lonFactor),tempLons,lons[i]+lonFactor,tempLons+lonFactor[0]+lonFactor[-1]]
           ENDIF ELSE BEGIN
              tempLats        = [          lats[j],tempLats,        lats[j+1],   REVERSE(tempLats)] 
              tempLons        = [lons[i]+lonFactor,tempLons,lons[i]+lonFactor,tempLons+lonFactor*2]  
           ENDELSE
        ENDELSE

        outLonsLats[i,j,0,*] = tempLons
        outLonsLats[i,j,1,*] = tempLats

     ENDFOR 
  ENDFOR

  RETURN,outLonsLats

END