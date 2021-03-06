PRO JOURNAL__20160503__CRAZY_NIGHTSIDE_DIST_OF_PFLUX__HIGHER_ALTS

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/GET_GOOD_I,GOOD_I=good_i

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  ;;Bounds
  altRange          = [3180,4180]
  minMLT            = [6,18]
  maxMLT            = [18,6]

  ;;Inds
  good_i            = CGSETINTERSECTION(good_i,WHERE(maximus.alt GE altRange[0] AND maximus.alt LE altRange[1]))
  altString         = STRING(FORMAT='("--",I0,"-",I0,"km")',altRange[0],altRange[1])

  day_i             = CGSETINTERSECTION(good_i,WHERE(maximus.mlt GE minMLT[0] AND maximus.mlt LE maxMLT[0]))
  night_i           = CGSETINTERSECTION(good_i,WHERE(maximus.mlt LE maxMLT[1] OR maximus.mlt GE minMLT[1]))

  ;;plotstuff
  plotMin           = -4.5
  plotMax           = 1.
  binsize           = 0.1

  ;;Now plot dayside
  titleDayMLT       = STRING(FORMAT='("(",I0,"-",I0," MLT)")',minMLT[0],maxMLT[0])
  fileDayMLT        = STRING(FORMAT='(I0,"-",I0,"_MLT")',minMLT[0],maxMLT[0])
  CGHISTOPLOT,ALOG10(maximus.pfluxest[day_i]), $
              TITLE="Dayside Log Poynting flux distribution" + titleDayMLT, $
              OUTPUT=plotDir+'pFlux_dist_dayside--'+fileDayMLT+altString+'.png', $
              MAXINPUT=plotMax, $
              MININPUT=plotMin, $
              BINSIZE=binsize

  ;;Now nightside
  titleNightMLT       = STRING(FORMAT='("(",I0,"-",I0," MLT)")',minMLT[1],maxMLT[1])
  fileNightMLT        = STRING(FORMAT='(I0,"-",I0,"_MLT")',minMLT[1],maxMLT[1])
  CGHISTOPLOT,ALOG10(maximus.pfluxest[night_i]), $
              TITLE="Nightside Log Poynting flux distribution" + titleNightMLT, $
              OUTPUT=plotDir+'pFlux_dist_nightside--'+fileNightMLT+altString+'.png', $
              MAXINPUT=plotMax, $
              MININPUT=plotMin, $
              BINSIZE=binsize

END